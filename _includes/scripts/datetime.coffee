# Return ISO 8601 date YYYY-MM-DD
date_iso = (date) -> new Date(date || +new Date()).toLocaleDateString 'sv'

seconds =
  seconds: 1
  minutes: 60
  hours: 3600
  days: 3600 * 24
  weeks: 3600 * 24 * 7
  months: 3600 * 24 * (365/12)
  quarters: 3600 * 24 * (365/4)
  years: 3600 * 24 * 365

relative_time = (e) ->
  el = $ e
  datetime = el.attr 'datetime' || new Date()
  date = if datetime instanceof Date then datetime else new Date datetime
  style = el.attr 'data-style' || 'long'
  duration = duration_seconds(el.attr('duration') || 'P')
  secondsElapsed = (date.getTime() - Date.now()) / 1000
  text = ''
  if duration
    while secondsElapsed < 0
      date.setTime date.getTime() + duration * 1000
      secondsElapsed = (date.getTime() - Date.now()) / 1000
  for unit, value of seconds
    if value < Math.abs secondsElapsed
      delta = secondsElapsed / value
      # Check if needs updates
      if unit in ['minutes', 'seconds']
        setTimeout relative_time, seconds[unit] * 30 * 1000, e
      classi = []
      classi.push(if secondsElapsed < 0 then 'past' else 'future')
      if date_iso(date) is date_iso() then classi.push 'today'
      tomorrow = new Date()
      if date_iso(date) is date_iso tomorrow.setTime(tomorrow.getTime()+seconds.days*1000) then classi.push 'tomorrow'
      if date_iso(date) is date_iso new Date().setTime(new Date().getTime()-seconds.days*1000) then classi.push 'yesterday'
      text = format_text delta, unit, style
    else break
  unless el.find('span').length
    el.append $ '<span/>'
  span = el.find 'span'
  span.text text
  el.removeClass 'past future today tomorrow yesterday'
  el.addClass classi.join ' '
  el.attr 'title', date.toLocaleDateString(lang, {
    weekday: "short", day: "numeric", month: "short", year: "numeric"
  }) + " #{date.toLocaleTimeString(lang)} Δ#{Math.abs delta.toFixed 2}"
  return

format_text = (delta, unit, style) ->
  # Language-sensitive relative time formatting
  formatter = new Intl.RelativeTimeFormat lang, {
    style: style
    numeric: 'auto'
  }
  number = Math.round delta
  parts = formatter.formatToParts number, unit
  text = parts.map (e) ->
    return if e.type == 'literal' then e.value.trim() else ''
  return text.filter(Boolean).join ' '

# Convert ISO-8601 duration string in seconds
@duration_seconds = (string) ->
  amount = 0
  d_array = string.match(/^P(\d+Y)?(\d+M)?(\d+W)?(\d+D)?(T(\d+H)?(\d+M)?(\d+S)?)?$/) || []
  ms_array = [null, seconds.years, seconds.months, seconds.weeks, seconds.days, null, seconds.hours, seconds.minutes, seconds.seconds]
  # Loop milliseconds array
  for e, i in ms_array
    # If milliseconds and string match,
    if e and d_array[i] then amount += e * +d_array[i].slice 0, -1
  return amount

# Bootstrap
$('time[datetime]').each -> relative_time @