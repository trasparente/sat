# Sort Hexes by `[data-distance]`
$('svg.hexmap1').each ->
  svg = $ @
  # Prepare array
  span = +svg.attr 'data-span'
  levels = []
  levels[l] = [] for l in [0..span]
  # Loop, store and remove hexes
  svg.find('.hex').each ->
    hex = $ @
    levels[+hex.attr 'data-index'].push hex
    hex.remove()
  # Prepend stored hexes
  svg.prepend(h) for h in d for d in levels
  return

# sort_hexes = (a, b) ->
#   ad = $(a).attr 'data-distance'
#   bd = $(b).attr 'data-distance'
#   console.log ad,bd
#   if bd < ad then return 1 else return -1