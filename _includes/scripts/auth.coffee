logout = (token) ->
  html.addClass('unlogged').removeClass 'logged admin guest'
  storage.clear()
  if token
    bottom.append "<div class='popover'>Logged out</div>"
  return

login_form.on 'submit', ->
  form = $ @
  field = form.serializeArray()[0]
  login_popover[0].hidePopover()
  form.trigger 'reset'
  if field['value'] and field['name'] is 'login-token'
    bootstrap field['value']
  return

# Logout button
$('#logout-button').on 'click', -> logout storage.get 'token'

#
# AUTH FUNCTIONS
# --------------
# GitHub auth, personal token as argument
get_auth = (token) -> $.get
  url: '{{ site.github.api_url }}/user'
  headers: { 'Authorization': "token #{ token }" }
  success: (user) ->
    storage.set 'token', token
    storage.set 'user', user.login
    return # End get_auth done
  error: (request) ->
    bottom.append "<div class='popover bg-error'>Auth error</div>"
    do logout
    return