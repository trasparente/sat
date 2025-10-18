console.log 'jq', $.fn.jquery

# Definitions
win = $ window
doc = $ document
html = $ 'html'
lang = html.attr 'lang'
bottom = $ '#bottom'
login_form = $ '#login-form'
login_popover = $ '#login-popover'
today = +new Date().setHours 0,0,0,0
environment = '{{ site.github.environment }}'
message = 'unlogged'
github_repo_url = '{{ site.github.api_url }}/repos/{{ site.github.repository_nwo }}'

# Slug strings
@slugify = (string) -> 
  return string.toString().toLowerCase().trim()
    .replace /[^\w\s\.—-]/g, '' # Remove every: not word, space, dot, dashes
    .replace /[\s\.—-]+/g, '_' # Replaces space, dot, dashes with underscore
    .replace /^_+|_+$/g, '' # Trim underscore