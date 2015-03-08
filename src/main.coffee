class GitHubAPIStatus
  @low_rate_limit = false

  window.callback = (json) =>
    @rate_limit = json.data
    @low_rate_limit = @rate_limit.resources.core.remaining < 16
    return

  @update: ->
    unless window.callback.script
      new Element "script", (script) ->
        script.async = true
        script.src = "https://api.github.com/rate_limit?callback=callback"
        window.callback.script = script
        @on "readystatechange", "load", "error", ->
          if !script.readyState or /loaded|complete/.test script.readyState
            script.parentNode.removeChild script
            window.callback.script = null
          return
        head = document.getElementsByTagName("head")[0]
        head.insertBefore script, head.firstChild
        return
    return

  @update()


class Form extends Element
  on: (events..., func) ->
    if events.indexOf("change") >= 0
      callback = (event) =>
        func.call @, event || window.event
      for element in @get().elements
        new Element element
          .on "change", "input", callback
    super

  serialize: ->
    data = {}
    for node in @get().elements when node.name
      switch node.type
        when "radio", "checkbox"
          data[node.name] = node.value if node.checked
        else
          data[node.name] = node.value
    data


class DisabledFrame extends Element
  constructor: ->
    super
    @on "load", ->
      for a in @get().contentWindow.document.getElementsByTagName "a"
        new Element a
          .on "click", (event) ->
            event.preventDefault()
            false
      new Element @get().contentWindow.document.body
        .on "click", =>
          @get().parentNode.click()
          return
      return


class PreviewAnchor extends Element
  constructor: ({href, text, data}, callback) ->
    super "a", (a) ->
      a.className = Config.anchorClass
      a.href = href
      a.appendChild document.createTextNode "#{text}"
      a.setAttribute "data-#{name}", value for name, value of data
      callback a if callback
      return


class PreviewFrame extends Frame
  constructor: (@$) ->
    @on "load", ->
      if callback = @get().contentWindow.callback
        script = callback.script
        if script.readyState
          new Element script
            .on "readystatechange", ->
              @resize() if /loaded|complete/.test script.readyState
              return
        else
          new Element script
            .on "load", "error", ->
              @resize()
              return
      else
        @resize()
      return

  load: (config) ->
    @get().parentNode.style.height = "#{(if config.data.style is "mega" then 28 else 20) + 2}px"
    @get().style.width = "1px"
    @get().style.height = "0"
    @get().src = "buttons.html#{Hash.encode config}"
    @get().contentWindow.document.location.reload()
    return


class Code extends Element
  constructor: ->
    super
    @on "focus", ->
      @get().select()
      return
    @on "click", ->
      @get().select()
      return
    @on "mouseup", (event) ->
      event.preventDefault()
      false


class ButtonForm extends Form
  constructor: (@$, {content, preview: {button, frame, code, warning}, snippet, user_repo}) ->
    snippet.get().value = \
      """
      <!-- Place this tag right after the last button or just before your close body tag. -->
      <script async defer id="github-bjs" src="https://buttons.github.io/buttons.js"></script>
      """

    callback = ({force}) =>
      options = @serialize()

      if options.type
        content.removeClass "hidden"

        for name in ["repo", "standard-icon"]
          @get().elements[name].disabled = options.type is "follow"
        for name in ["show-count"]
          @get().elements[name].disabled = options.type is "download"

        unless (!options.user or /^[a-z0-9][a-z0-9-]*$/i.test options.user) and (options.type is "follow" or !options.repo or (/^[\w.-]+$/.test(options.repo) and not /^\.\.?$/.test(options.repo)))
          user_repo.addClass "has-error"
        else
          user_repo.removeClass "has-error"
          if options.user is "" or (options.type isnt "follow" and options.repo is "")
            user_repo.addClass "has-warning"
          else
            user_repo.removeClass "has-warning"

        if (user_repo.hasClass "has-error") or (user_repo.hasClass "has-warning")
          options.user = "ntkme"
          options.repo = "github-buttons"

        if @cache isnt (cache = Hash.encode options) or force
          @cache = cache
          new PreviewAnchor @parse(options), (a) =>
            code.get().value = \
              """
              <!-- Place this tag where you want the button to render. -->
              #{a.outerHTML}
              """

            button.addClass "hidden"
            if options["show-count"]? and options.type isnt "download"
              GitHubAPIStatus.update()
              if GitHubAPIStatus.low_rate_limit
                button.removeClass "hidden"
                reset = new Date GitHubAPIStatus.rate_limit.resources.core.reset * 1000
                if !@reset or reset > @reset
                  @reset = reset
                  warning.removeClass "hidden"
                if force
                  warning.addClass "hidden"
                else
                  a.removeAttribute "data-count-api"

            frame.load ButtonAnchor.parse a
            a = null
            return
      return

    button.on "click", (event) ->
      event.preventDefault()
      callback force: true
      false
    @on "change", callback

  parse: (options = @serialize()) ->
    {type, user, repo} = options
    config =
      className: "github-button"
      href:
        switch type
          when "follow"
            "https://github.com/#{user}"
          when "watch", "star"
            "https://github.com/#{user}/#{repo}"
          when "fork"
            "https://github.com/#{user}/#{repo}/fork"
          when "issue"
            "https://github.com/#{user}/#{repo}/issues"
          when "download"
            "https://github.com/#{user}/#{repo}/archive/master.zip"
          else
            "https://github.com/"
      text:
        switch type
          when "follow"
            "Follow @#{user}"
          else
            type.charAt(0).toUpperCase() + type[1..].toLowerCase()
      data:
        icon:
          switch type
            when "watch"
              "octicon-eye"
            when "star"
              "octicon-star"
            when "fork"
              "octicon-git-branch"
            when "issue"
              "octicon-issue-opened"
            when "download"
              "octicon-cloud-download"
            else
              "octicon-mark-github"
    if options["large-button"]?
      config.data.style = "mega"
    if options["show-count"]?
      switch type
        when "follow"
          config.data["count-href"] = "/#{user}/followers"
          config.data["count-api"] = "/users/#{user}#followers"
        when "watch"
          config.data["count-href"] = "/#{user}/#{repo}/watchers"
          config.data["count-api"] = "/repos/#{user}/#{repo}#subscribers_count"
        when "star"
          config.data["count-href"] = "/#{user}/#{repo}/stargazers"
          config.data["count-api"] = "/repos/#{user}/#{repo}#stargazers_count"
        when "fork"
          config.data["count-href"] = "/#{user}/#{repo}/network"
          config.data["count-api"] = "/repos/#{user}/#{repo}#forks_count"
        when "issue"
          config.data["count-api"] = "/repos/#{user}/#{repo}#open_issues_count"
    if options["standard-icon"]? or config.data.icon is "octicon-mark-github"
      delete config.data.icon
    config


new DisabledFrame iframe for iframe in document.getElementsByTagName "iframe" when iframe.parentNode.id isnt "preview"

new ButtonForm document.getElementById("button-config"),
  content: new Element document.getElementById "content"
  user_repo: new Element document.getElementById "user-repo"
  preview:
    button: new Element document.getElementById "preview-button"
    frame: new PreviewFrame document.getElementById("preview").getElementsByTagName("iframe")[0]
    code: new Code document.getElementById "code"
    warning: new Element document.getElementById "preview-warning"
  snippet: new Code document.getElementById "snippet"

@onbeforeunload = ->
