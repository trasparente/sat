# .prevent Class .preventDefault()
doc.on 'click', 'a.prevent', (e) -> e.preventDefault()
doc.on 'button', 'button.prevent', (e) -> e.preventDefault()
doc.on 'submit', 'form.prevent', (e) -> e.preventDefault()
# Login button popover
doc.on 'click', '#login-button', -> $('#login-popover')[0].showPopover()
# Dismiss bottom popovers
doc.on 'click', '#bottom .popover', -> $(@).remove()

# ONLINE / OFFLINE
# Called from BODY
@online = -> html.addClass('online').removeClass 'offline'
@offline = -> html.addClass('offline').removeClass 'online'
# Initial call
if navigator.onLine then do online else do offline

# FOCUS / BLUR
# Called from BODY
@focus = -> html.addClass('focus').removeClass 'blur'
@blur = -> html.addClass('blur').removeClass 'focus'
if document.hasFocus() then do focus else do blur

# Hash, fragment identifier change
# Called from BODY
@onhashchange = -> console.log 'onhashchange', window.location.hash

# RESIZE EVENT
# Add class `fullscreen` and `mobile` if the case
# Called from BODY attribute
@resize = ->
  # Fullscreen
  if window.innerHeight is screen.height and window.innerWidth is screen.width and window.innerWidth > 650
    html.addClass('fullscreen not-desktop not-mobile').removeClass 'not-fullscreen desktop mobile'
  else
    html.addClass('not-fullscreen').removeClass 'fullscreen'
    # Mobile screen
    if window.innerWidth <= 650
      html.addClass('mobile not-desktop').removeClass 'desktop not-mobile'
    else html.addClass('desktop not-mobile').removeClass 'mobile not-desktop'

  # Check document SHOTER than window
  if window.innerHeight > document.body.scrollHeight
    html.addClass 'shorter'
  else html.removeClass 'shorter'
  return # End resize

# First run
do resize

# SCROLL Event
# Add `html.scrolled` when scroll > win height
win.scroll () ->
  if win.scrollTop() > win.height() / 5
    html.addClass 'scrolled'
  else html.removeClass 'scrolled'
  # Apply sticky class to main nav
  el = $('header + nav')[0]
  stickyTop = parseInt window.getComputedStyle(el).top
  currentTop = el.getBoundingClientRect().top
  el.classList.toggle "sticky", currentTop == stickyTop
  return