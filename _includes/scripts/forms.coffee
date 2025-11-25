$('form.input').each ->
  form = $ @

  form.on 'reset', ->
    form.find('#file-url').empty()
    return

  form.on 'submit', ->
    form.addClass 'submit'
    file_url = "#{ github_repo_url }/contents/_data/#{ form.find('.file-url').text() }"
    form.find(':input').blur()
    ext = form.find('#file_extension').val() || form.find('#file_url').val().split('.').pop()
    switch ext.toLowerCase()
      # Json format
      when 'json' then form_to_object form
      # Yaml format
      when 'yaml', 'yml' then jsyaml.dump form_to_object form
      # Csv format
      when 'csv' then get_csv_file form, file_url, form_to_array form
    # CREATE / WRITE: file, file_url
    # console.log file_url, file
    return # End form submit

# HELPERS

#
# GET CSV FILE
#
get_csv_file = (form, file_url, file, header, row) -> $.get
  url: file_url
  # arguments: Object, 'error', 'Not Found'
  error: (request, textStatus , errorThrown) -> if request.status is 404 then save_file form, file_url, file
  success: (data) ->
    # Decode old file and split
    # Boolean remove empty elements
    csv_array = atob data.content
      .split '\n'
      .filter Boolean
    # Update old head
    csv_array[0] = header
    # append row
    csv_array.push row
    new_file = csv_array.join '\n'
    save_file form, file_url, new_file, {sha: data.sha}
    return # End get_csv_file done

save_file = (form, file_url, file, sha) -> $.ajax
  url: file_url
  method: 'PUT'
  data: JSON.stringify $.extend {
    message: "Commit data content #{ file_url }"
    content: btoa file
  }, sha
  success: (data) ->
    bottom.append "<div class='popover'>Committed #{ data.content.path } as #{ data.commit.sha.slice 0, 7 }</div>"
    form.trigger 'reset'
    html.removeClass('updated').addClass 'behind'
    if environment isnt 'development' then do get_builds
    return # End save_file

#
# FORM to File
#
form_to_object = (form) ->
  file = {}
  # Loop normal fields
  form.find('input:not([type=radio],[type=submit],[type=reset],[type=button],[type=hidden]')
    .each ->
      el = $ @
      # tag = el.prop 'tagName'
      file[el.attr 'name'] = switch el.attr 'type'
        # Number type
        when 'number' then Number el.val()
        # String: All others
        else el.val()
      return # End fields loop
  # Loop radio fields
  form.find('input[type=radio]:checked').each ->
    el = $ @
    name = el.attr 'name'
    file[name] = el.val()
    return # End radio loop

  return file

#
# FORM to Array
#
form_to_array = (form, data = {content: B64encode '[]'}) ->
  # Array of objects {name: '...', value: '...'}
  serialized = form.serializeArray().filter (el) ->
    return (el.name not in ['file_url','file_extension','file_name','file_path'])
  header = serialized.map((i) -> i.name).join ','
  row = serialized.map((i) -> i.value).join ','
  return [header, row].join '\n'

# FILE URL
file_url_string = (form) ->
  # Return as [file_path /]file_name.file_extension
  return if form.find('#file_path').val()
    form.find('#file_url')
  else [
    form.find('#file_path').val()
    form.find('#file_name').val()
  ].filter(Boolean).join('/') + '.' + form.find('#file_extension').val()