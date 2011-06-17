--- 
layout: post
title: reboot
---
Here's how to generate the archive listing at the bottom:

<pre><code>
&lt;div id="archives">
  {% for m in site.home_section.months %}
    {{ m | strftime: "%Y" | assign_to: 'current_year' }}
    {% if displayed_year != current_year %}
      {% if displayed_year %}
        &lt;/div>
      {% endif %}
      &lt;div class="archive-year">
      &lt;h4>{{ current_year }}&lt;/h4>
    {% endif %}
    &lt;a href="{{ site.home_section | monthly_url: m }}">{{ m | strftime: "%m" }}</a>
    {{ current_year | assign_to: 'displayed_year' }}
  {% endfor %}
  &lt;/div>
&lt;/div>
</code></pre>
