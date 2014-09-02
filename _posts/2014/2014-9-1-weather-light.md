---
layout: post
title: Weather Lights
---

I recently attended, and even spoke at, the [GitHub Patchwork event in Boulder](https://github.com/blog/1869-patchwork-night-boulder-edition)
last month.  My son, Nathan, attended to get his first taste of the [GitHub
Flow](https://guides.github.com/introduction/flow/index.html).  I don't
necessarily want him to be a programmer, but I do push him to learn a little to
augment his interest in meteorology and astronomy.  

The night was a success.  He made it through the tutorial with only one complaint:
the [Patchwork credit](http://jlord.github.io/patchwork/) went to my wife, who
had created a GitHub login that night.

Since then, I've been looking for a project to continue his progress.  I settled
on a weather light, which consists of a ruby script that changes the color of a
[Philips Hue](http://meethue.com) bulb.  If you're already an experienced coder,
jump straight to the source at [github.com/technoweenie/weatherhue](https://github.com/technoweenie/weatherhue).

![](https://cloud.githubusercontent.com/assets/21/4112562/ccd554cc-322e-11e4-97a0-ab6b7b7bc65e.jpg)

## Requirements

Unfortunately, there's one hefty requirement: You need a Philips Hue light kit.
This means you need one Hue bridge, and one light.  Once you have the kit, you'll
have to [use the API](http://developers.meethue.com/gettingstarted.html) to
[create a user](http://developers.meethue.com/4_configurationapi.html) and [figure
out the ID of your light](http://developers.meethue.com/1_lightsapi.html).

Next, you need to setup an account for the [Weather2 API](http://www.myweather2.com/developer/).
There are a lot of services out there, but this one is free, supports JSON
responses, and also gives simple forecasts.  They allow 500 requests a day.  If
you set this script to run every 5 minutes, you'll only use 480 requests.

After you're done, you should have five values:

* `HUE_API` - The address of your Hue bridge.  Probably something like "http://10.0.0.1"
* `HUE_USER` - The username you setup with the Hue API.
* `HUE_LIGHT` - The ID of the Hue light.  Probably 1-3.
* `WEATHER2_TOKEN` - Your token for the weather2 API.
* `WEATHER2_QUERY` - The latitude and longitude of your house.  For example,
Pikes Peak is at "38.8417832,-105.0438213."

Finally, you need ruby, with the following gems: `faraday`, `color`, and `dotenv`.
If you're on a version of ruby lower than 1.9, you'll also want the `json` gem.

## Writing the script

I'm going to describe the process I used to write the `weatherhue.rb` script.
Due to the way ruby runs, it's not necessarily in the order that the code
is written.  If you look at the file, you'll see 4 sections:

1. Lines requiring ruby gems.
2. A few defined helper functions.
3. A list of temperatures and their HSL values.
4. Running code that gets the temperature and sets the light.

## Step 1: Get the temperature

The first thing the script needs to do, is get the temperature.  There are two
ways: either through an argument in the script (useful for testing), or the
Weather API.  This is a simple script that pulls the current temperature from
the API forecast results.

```ruby
if temp = ARGV[0]
  # Get the temperature from the first argument.
  temp = temp.to_i
else
  # Get the temperature from the weather2 api
  url = "http://www.myweather2.com/developer/forecast.ashx?uac=#{ENV["WEATHER2_TOKEN"]}&temp_unit=f&output=json&query=#{ENV["WEATHER2_QUERY"]}"
  res = Faraday.get(url)
  if res.status != 200
    puts res.status
    puts res.body
    exit
  end

  data = JSON.parse(res.body)
  temp = data["weather"]["curren_weather"][0]["temp"].to_i
end
```

## Step 2: Choose a color based on the temperature

I wanted the color to match the color range on local news forecasts.

![](https://cloud.githubusercontent.com/assets/21/4112672/12d66b04-3235-11e4-8e38-8d24acfa5152.png)

I actually went through the tedious process of making a list of HSL values at 5
degree increments.  The eye dropper app I used gave me RGB values from 0-255,
which had to be converted to the HSL values that the Hue lights take.  Here's
how I did it in ruby with the `color` gem:

```ruby
rgb = [250, 179, 250]

# convert the values 0-255 to a decimal between 0 and 1.
rgb_color = Color::RGB.from_fraction 250/255.0, 179/255.0, 255/255.0
hsl_color = rgb_color.to_hsl

# convert hsl decimals to the Philips Hue values
hsl = [
  # hue
  (hsl_color.h * 65535).to_i,
  # saturation
  (hsl_color.s * 255).to_i,
  # light (brightness)
  (hsl_color.l * 255).to_i,
]
```

I simply wrote the result out in the HSL hash:

```ruby
HSL = {
  -20=>[53884, 255, 217],
  -15=>[53988, 198, 187],
  -10=>[53726, 161, 167],
  # ...
```

After I had converted everything, I noticed a couple things.  First, the
saturation and brightness values don't change that much, especially for the
hotter temperatures.  Second, the hue values range from 53884 to 1492.  I probably
didn't need to convert all those RGB values by hand :)

Now that we have HSL colors for temperatures in 5 degree increments, we need a
way to convert any temperature to a color.

```ruby
def color_for_temp(temp)
  remainder = temp % 5
  if remainder == 0
    return HSL[temp]
  end

  # get the lower and upper bound around a temp
  lower = temp - remainder
  upper = lower + 5

  # convert the HSL values to Color::HSL objects
  lower_color = hsl_to_color(HSL[lower])
  upper_color = hsl_to_color(HSL[upper])

  # use Color::HSL#mix_with to get a color between two colors
  color = lower_color.mix_with(upper_color, remainder / 5.0)

  color_to_hsl color
end
```

## Step 3: Set the light color

Now that we have the HSL values for the temperature, it's time to set the Philip
Hue light.  First, create a state object for the light:

```ruby
# temp_color is an array of HSL colors: [53884, 255, 217]
state = {
  :on => true,
  :hue => temp_color[0],
  :sat => temp_color[1],
  :bri => temp_color[2],
  # performs a smooth transition to the new color for 1 second
  :transitiontime => 10,
}
```

A simple HTTP PUT call will change the color.

```ruby
hueapi = Faraday.new ENV["HUE_API"]
hueapi.put "/api/#{ENV["HUE_USER"]}/lights/#{ENV["HUE_LIGHT"]}/state", state.to_json
```

## Step 4: Schedule the script

If you don't want to set the environment variables each time, you can create a
`.env` file in the root of the application.

```
WEATHER2_TOKEN=MONKEY
WEATHER2_QUERY=38.8417832,-105.0438213
HUE_API=http://192.168.1.50
HUE_USER=technoweenie
HUE_LIGHT=1
```

You can then run the script with dotenv:

    $ dotenv ruby weatherhue.rb 75

A crontab can be used to run this every 5 minutes.  Run `crontab -e` to add
a new entry:

    # note: put tabs between the `*` values
    */5 * * * * cd /path/to/script; dotenv ruby weatherhue.rb

Confirm the crontab with `crontab -l`.

## Bonus Round

1. Can we simplify the function to get the HSL values for a temperature?  Instead
of looking up by temperature, use a percentage to get a hue range from 55,000 to
1500.
2. Can we do something interesting with the saturation and brightness values?  
Maybe tweak them based on the time of day.
