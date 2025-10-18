@bootstrap = (token) ->
  # html.addClass 'unlogged'
  t = token || storage.get 'token'
  if t
    get_auth(t).done (user) ->
      # use Bootstrap token for first login
      get_repo(user, token).done (repo) ->
        $('#auth-message').text message
        # If admin check builds
        if repo.permissions.admin then get_builds().done (builds) ->
          if repo.fork and builds[0].status is 'built'
            get_parent_commits builds, repo
          else do get_forks
        return
      return
  else do logout
  return

get_repo = (user, token) -> $.get
  url: github_repo_url
  success: (repo) ->
    storage.set 'branch', repo.default_branch
    storage.set 'parent', repo.parent?.full_name || ''
    # Store role
    role = if repo.permissions.admin then 'admin' else 'guest'
    html.removeClass('unlogged').addClass "logged #{role}"
    storage.set 'role', role
    # Alert for login
    message = "#{ user.login } logged as #{ role }"
    if token
      bottom.append "<div class='popover'>#{ message }</div>"
    return # End get_repo done

get_builds = -> $.get
  url: github_repo_url + '/pages/builds'
  success: (builds) ->
    status = $ '#status .behind'
    if builds[0].status is 'built' or environment is 'development'
      # UPDATED from BEHIND
      if html.hasClass 'behind'
        # Was behind
        updated_url = [
          window.location.origin
          window.location.pathname
          '?update_to='
          builds[0].updated_at
        ].join ''
        history.pushState null, '', updated_url
        # Activate button
        status.addClass 'blink pointer'
        status.on 'click', () -> window.location.href = updated_url
      # UPDATED
      else html.addClass 'updated'
    else
      # BEHIND
      html.removeClass 'updated'
        .addClass 'behind'
      # Check again in 30 secs
      setTimeout get_builds, 1000 * {{ site.check | default: 30 }}
    return # End get_builds done

# Get parent repo last commit
get_parent_commits = (builds, repo) -> $.get
  url: "{{ site.github.api_url }}/repos/#{ repo.parent?.full_name }/commits"
  success: (commits) ->
    # Compare parent last commit time with this forked site last build time
    commit_after_build = +new Date(commits[0].commit.author.date) / 1000 > {{ site.time | date: "%s" }}
    if commit_after_build then sync_upstream().done -> do get_builds
    return # End get_parent_commits done

# Get Forks recursively
get_forks = (pg = 1, forks = []) -> $.get
  url: github_repo_url + '/forks'
  per_page: 100
  page: pg
  success: (data, status, request) ->
    output = forks.concat data
    links = request.getResponseHeader 'links'
    if links && links.includes 'rel="next"'
      get_forks pg+1, output
    else console.log "#{fork.name} #{fork.updated_at} #{fork.id}" for fork in output
    return # End get_forks

# Sync with upstream
# https://docs.github.com/en/rest/branches/branches#sync-a-fork-branch-with-the-upstream-repository
sync_upstream = -> $.ajax
  url: github_repo_url + '/merge-upstream'
  method: 'POST'
  data: JSON.stringify { "branch": localStorage.getItem 'branch' }
  success: (response) -> spy response.message