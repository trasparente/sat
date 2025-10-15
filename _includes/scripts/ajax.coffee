# AJAX PREFILTER
# --------------------------------------
$.ajaxPrefilter (options, ajaxOptions, request) ->
  options.cache = false
  # Check GitHub requests
  if options.url.startsWith '{{ site.github.api_url }}'
    # Proper Accept header
    request.setRequestHeader 'Accept', 'application/vnd.github.v3+json'
    # Add GitHub token
    if storage.get 'token'
      request.setRequestHeader 'Authorization', "token #{storage.get 'token'}"
  return # End Ajax prefilter

# Control html.ajax class
doc.on 'ajaxStart', () -> html.addClass 'ajax'
doc.on 'ajaxStop', () -> setTimeout remove_ajax, 1000
doc.on 'ajaxError', (e,r,x) ->
  message = "#{r.responseJSON?.message || 'error'}"
  url = x.url.replace /https\:\/\/|\?_=\d+|api.github.com\//g, ''
  # regex to delete till the end: string.replace(/[?].*/,'')
  console.log 'ajaxError', r.status, r.statusText, x.url.split('?')[0]
  return
doc.on 'ajaxSuccess', (e,r,x) ->
  console.log r.status, x.url.replace /https\:\/\/|\?_=\d+|api.github.com\//g, ''
  return

remove_ajax = -> html.removeClass('ajax')