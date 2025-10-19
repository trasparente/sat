---
permalink: /site/info/
---
# Info

{% include widgets/api.html include='page/init' %}

<fieldset markdown=1><legend>Repository</legend>
- [{{ site.github.repository_nwo }}]({{ site.github.repository_url }})
- Owner type `{{ repo.owner.type }}`
- Owner name `{{ site.github.owner_name }}`
- Page type `{% if site.github.is_user_page %}User{% endif %}{% if site.github.is_project_page %}Project{% endif %}`
- Fork `{{ repo.fork | inspect }}`
- Release `{{ site.github.releases | first | map: 'tag_name' | default: '-' }}` `{{ site.github.releases | first | map: 'name' | default: '-' }}`
- Created <code>{% include widgets/datetime.html datetime=repo.created_at %}</code>
- Modified <code>{% include widgets/datetime.html datetime=repo.modified_at %}</code>
- Site build <code>{% include widgets/datetime.html datetime=site.time %}</code>
</fieldset>

<fieldset markdown=1><legend>Pages</legend>
{% for item in sorted_html_pages %}- `{{ item[sort_by] | inspect }}` {{ item.title | default: item.name }}
{% endfor %}
</fieldset>

<fieldset markdown=1><legend>Collections</legend>
{% for collection in sorted_collections %}- `{{ collection.order | inspect }}` {{ collection.title | default: collection.label }} ({{ collection.docs.size }} documents){% assign collection_docs = collection.docs | sort: sort_by %}{% for p in collection_docs %}
  - `{{ p[sort_by] | inspect }}` {{ p.title | default: p.path }}{% endfor %}
{% endfor %}
</fieldset>

<fieldset markdown=1><legend>Static files</legend>
{% assign folder_assets = site.static_files | group_by_exp: "item", "item.path | replace: item.name, ''" %}
<ul>{% for folder in folder_assets %}
  <li>Folder <code>{{ folder.name }}</code></li>
  <ul>{% for file in folder.items %}
    <li><code>{{ file.name }}</code></li>
  {% endfor %}</ul>
{% endfor %}</ul>
</fieldset>