---
---
# Index

{% for p in site.posts %}- [{{ p.title }}]({{ p.url }}) <time datetime='{{ p.date }}'>{{ p.date | date: date_format }}</time>
{% endfor %}

{% include widgets/api.html %}