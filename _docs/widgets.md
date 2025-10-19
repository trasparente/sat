---
order: 1
---
# Widgets
{% include widgets/toc.html %}

List of widgets

{% include widgets/api.html details=1 %}
{% include widgets/api.html details=1 include='widgets/datetime' %}

{% assign now = 'now' | date: "%s" %}
{% assign minute = 60 %}
{% assign hour = minute | times: 60 %}
{% assign day = hour | times: 24 %}
{% assign week = day | times: 7 %}
{% assign month = day | times: 30 %}
{% assign quarter = month | times: 3 %}
{% assign year = week | times: 52 %}
{% assign future_minute = now | plus: minute %}
{% assign future_hour = now | plus: hour %}
{% assign future_day = now | plus: day %}
{% assign future_week = now | plus: week %}
{% assign future_month = now | plus: month %}
{% assign future_quarter = now | plus: quarter %}
{% assign future_year = now | plus: year %}
{% assign future_years = now | plus: year | plus: year %}
{% assign past_minute = now | minus: minute %}
{% assign past_hour = now | minus: hour %}
{% assign past_day = now | minus: day %}
{% assign past_week = now | minus: week %}
{% assign past_month = now | minus: month %}
{% assign past_quarter = now | minus: quarter %}
{% assign past_year = now | minus: year %}
{% assign past_years = now | minus: year | minus: year %}

**Basic**
- Default: {% include widgets/datetime.html %}
- Embed: {% include widgets/datetime.html embed=true %}
- Replace: {% include widgets/datetime.html replace=true %}

**Future**
- Minute: {% include widgets/datetime.html replace=1 datetime=future_minute %}
- Hour: {% include widgets/datetime.html replace=1 datetime=future_hour %}
- Day: {% include widgets/datetime.html replace=1 datetime=future_day %}
- Week: {% include widgets/datetime.html replace=1 datetime=future_week %}
- Month: {% include widgets/datetime.html replace=1 datetime=future_month %}
- Quarter: {% include widgets/datetime.html replace=1 datetime=future_quarter %}
- Year: {% include widgets/datetime.html replace=1 datetime=future_year %}
- Years: {% include widgets/datetime.html replace=1 datetime=future_years %}

**Past**
- Minute: {% include widgets/datetime.html replace=1 datetime=past_minute %}
- Hour: {% include widgets/datetime.html replace=1 datetime=past_hour %}
- Day: {% include widgets/datetime.html replace=1 datetime=past_day %}
- Week: {% include widgets/datetime.html replace=1 datetime=past_week %}
- Month: {% include widgets/datetime.html replace=1 datetime=past_month %}
- Quarter: {% include widgets/datetime.html replace=1 datetime=past_quarter %}
- Year: {% include widgets/datetime.html replace=1 datetime=past_year %}
- Years: {% include widgets/datetime.html replace=1 datetime=past_years %}