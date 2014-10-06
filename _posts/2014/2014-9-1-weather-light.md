---
layout: post
title: Weather Lights
---

I recently spoke at the [GitHub Patchwork event in Boulder](https://github.com/blog/1869-patchwork-night-boulder-edition)
last month.  My son Nathan tagged along to get his first taste of the [GitHub
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

Unfortunately, there's one hefty requirement: You need a Philips Hue light kit,
which consists of a Hue bridge and a few lights. Once you have the kit, you'll
have to [use the Hue API](http://developers.meethue.com/gettingstarted.html) to
[create a user](http://developers.meethue.com/4_configurationapi.html) and [figure
out the ID of your light](http://developers.meethue.com/1_lightsapi.html).

Next, you need to setup an account for the [Weather2 API](http://www.myweather2.com/developer/).
There are a lot of services out there, but this one is free, supports JSON
responses, and also gives simple forecasts.  They allow 500 requests a day.  If
you set this script to run every 5 minutes, you'll only use 288 requests.

After you're done, you should have five values.  Write these down somewhere.

* `HUE_API` - The address of your Hue bridge.  Probably something like "http://10.0.0.1"
* `HUE_USER` - The username you setup with the Hue API.
* `HUE_LIGHT` - The ID of the Hue light.  Probably 1-3.
* `WEATHER2_TOKEN` - Your token for the weather2 API.
* `WEATHER2_QUERY` - The latitude and longitude of your house.  For example,
Pikes Peak is at "38.8417832,-105.0438213."

Finally, you need ruby, with the following gems: `faraday` and `dotenv`.
If you're on a version of ruby lower than 1.9, you'll also want the `json` gem.

## Writing the script

I'm going to describe the process I used to write the `weatherhue.rb` script.
Due to the way ruby runs, it's not necessarily in the order that the code
is written.  If you look at the file, you'll see 4 sections:

1. Lines requiring ruby gems.
2. A few defined helper functions.
3. A list of temperatures and their HSL values.
4. Running code that gets the temperature and sets the light.

You'll likely find yourself bouncing around as you write the various sections.

## Step 1: Get the temperature

The first thing the script needs is the temperature.  There are two ways to get
it: through an argument in the script (useful for testing), or a Weather API.
This is a simple script that pulls the current temperature from the API forecast
results.

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

I wanted the color to match color ranges on local news forecasts.

![](https://cloud.githubusercontent.com/assets/21/4112672/12d66b04-3235-11e4-8e38-8d24acfa5152.png)

Our initial attempt required used color math to calculate the color between set
values in 5 degree increments.  This required us to specify 25 colors between
-20 and 100 degrees.  When we did that, we noticed a pattern:

1. The saturation and brightness values didn't change much.
2. The hue value started high and eventually went down to zero.

My son saw this, and suggested that we simply calculate the hue for a
temperature, leaving the saturation and brightness values the same.  So then
I talked him through a simple algorithm based on some math concepts he'd
learned.

First, we set an upper and lower bound that we wanted to track.  We decided to
track from -20 to 100.  The Hue light takes values from 0 to 65535.

```ruby
HUE = {
  -20 => 60_000, # a deep purple
  100 => 0, # bright red
}
```

The `#hue_for_temp` method gets the color range of any of the highest mapped
temperature below the actual temperatur.  It then uses a ratio to get the hue
based on a range of hues.

For example:

```ruby
temp = 50
full_range = 120 # 100 - -20
temp_range = 60 # 40 - -20
temp_perc = temp_range / full_range.to_f

full_hue_range = 60_000 # HUE[-20] - HUE[100]
hue_range = full_hue_range * temp_perc
hue = min_hue - hue_range
```

The `#hue_for_temp` method lets us set hue values for any temperature we want,
too.  While checking the output colors, my son wanted to set 50 to green for
"hoodie weather."  This means that 60 is a really light yellow.  70 is orange,
meaning we can leave off any light jackets.  This is the set of mapped
temperatures that we ended with:

```ruby
HUE = {
  -20 => 60_000,
  50 => 25_500,
  100 => 0,
}
```

## Step 3: Set the light color

Now that we have the HSL values for the temperature, it's time to set the Philip
Hue light.  First, create a state object for the light:

```ruby
state = {
  :on => true,
  :hue => hue_for_temp(temp),
  :sat => 255,
  :bri => 200,
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

1. Update the script to use the forecast for the day, and not the current
temperature.
2. Set a schedule that automatically only keeps the light on in the mornings when
you actually care what the temperature will be.

I hope you enjoyed this little tutorial.  I'd love to hear any experiences from
working with it!  Send me pictures or emails either to the [GitHub issue for
this post](https://github.com/technoweenie/technoweenie.github.com/issues/3),
or my [email address](mailto:technoweenie@gmail.com).
