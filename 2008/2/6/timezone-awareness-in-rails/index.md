--- 
layout: post
title: Timezone awareness in Rails
---
I just committed "another piece of the puzzle":http://dev.rubyonrails.org/changeset/8806 to "Rails' new time zone support":http://ryandaigle.com/articles/2008/1/25/what-s-new-in-edge-rails-easier-timezones, coming in Rails 2.1.  This takes a different approach than my "previous attempt":http://svn.rubyonrails.org/rails/plugins/tztime/ at timezone-aware activerecord attributes. The whole idea behind this approach, is that times appear in the local time zone while you work with them, but are persisted to the database in UTC.

<pre><code>
>> Time.zone = "Pacific Time (US & Canada)"
>> @status = Status.find :first
>> @status.created_at
=> Tue, 29 Jan 2008 15:30:09 PST -08:00
</code></pre>

If you set the time, it makes any necessary conversions to your current time zone.

<pre><code>
>> @status.created_at = Time.utc 2008, 1, 1
>> @status.created_at
=> Mon, 31 Dec 2007 16:00:00 PST -08:00
</code></pre>

Multiparameter attributes (say, from a time select box) are changed to the current time zone properly.

<pre><code>
>> @status.attributes = {
?>   "created_at(1i)" => "2008", "created_at(2i)" => "1", "created_at(3i)" => "1", 
?>   "created_at(4i)" => "0", "created_at(5i)" => "0", "created_at(6i)" => "0" }
>> @status.created_at
=> Tue, 01 Jan 2008 00:00:00 PST -08:00
</code></pre>

Now in our particular app, it's very important that each user sets up their own timezone.  The easiest way, we've found, is to take the offset from the browser.  This way, the user can move around, hop on a business flight, or play with their system clock, and our app will still function correctly.  First, we set a cookie with the timezone offset:

<pre><code>
Cookie.set({tzoffset: (new Date()).getTimezoneOffset()});
</code></pre>

Then, I wrote a before filter to process this automatically and set the Time.zone value appropriately.

<pre><code>
  # The browsers give the # of minutes that a local time needs to add to
  # make it UTC, while TimeZone expects offsets in seconds to add to 
  # a UTC to make it local.
  def browser_timezone
    return nil if cookies[:tzoffset].blank?
    @browser_timezone ||= begin
      min = cookies[:tzoffset].to_i
      TimeZone[-min.minutes]
    end
  end

  def set_timezone
    if logged_in? && browser_timezone \
        && browser_timezone.name != current_user.time_zone
      current_user.update_attribute(:time_zone, browser_timezone.name)
    end
    Time.zone = logged_in? ? current_user.time_zone : browser_timezone
  end
</code></pre>

Keep in mind, this does only set the current offset.  The offset doesn't account for things like DST(Daylight Savings Time).  However, since this will update on each request, it'll correct itself once the DST status changes.

Huge thanks to "Geoff Buesing":http://mad.ly, the mastermind behind this new TimeWithZone implementation.  
