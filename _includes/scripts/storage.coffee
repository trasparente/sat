# Storage
@storage =
  nwo: '{{ site.github.repository_nwo }}'
  get: (prop) ->
    obj = storage.getItem()
    if obj and prop then return obj[prop]
    return obj
  set: (prop, value) ->
    obj = storage.getItem {}
    if obj and value
      obj[prop] = value
      storage.setItem obj
    return
  clear: (prop) ->
    obj = storage.getItem {}
    unless prop
      storage.setItem {}
    if obj[prop]
      delete obj[prop]
      storage.setItem obj
    return
  getItem: (def) -> try (JSON.parse atob localStorage.getItem storage.nwo) catch e then def
  setItem: (obj) -> localStorage.setItem storage.nwo, btoa JSON.stringify obj