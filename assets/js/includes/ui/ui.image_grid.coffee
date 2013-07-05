'use strict'
#### ImageGrid class
#
# @extends UI
#
# - This class extends the Portfolio.UI class
#
class ImageGrid extends Portfolio.UI
  opts:
    sidebarNavEl:       undefined
    contentEl:          undefined
    innerContentEl:     undefined
    thumbnailsEl:       undefined
    projectInfoOverlay: undefined
    inView:             undefined
    previousView:       undefined

  #### The constructor for the ImageGrid class
  #
  # @param [Object] options
  # - The options object that is used by the class for configuration purposes (optional)
  #
  constructor: (@options) ->
    # Extend default options to include passed in arguments
    @options            = $.extend({}, this.opts, @options)
    @sidebarNavEl       = @options.sidebarNavEl       or $("nav.sidebar-nav")
    @innerContentEl     = @options.innerContentEl     or $("section.content .innerContent")
    @contentEl          = @options.contentEl          or $("section.content")
    @thumbnailsEl       = @options.thumbnailsEl       or $(".thumbnails")
    @projectInfoOverlay = @options.projectInfoOverlay or $('.project-info-overlay')

    $UI.ImageGrid.buildGrid = (options) => @buildGrid(options)

    $.subscribe('resize.Portfolio', @initResize('resize.Portfolio'))
    $.subscribe('initAfterViewContentLoaded.Portfolio', @initAfterViewContentLoadedProxy('initAfterViewContentLoaded.Portfolio'))
    $.subscribe('renderAfterViewContentLoaded.Portfolio', @renderGrid('renderAfterViewContentLoaded.Portfolio'))

    $(document).on 'click', ".sort-by a", (e) ->
      e.preventDefault()
      $(".sort-by a").removeClass 'active'
      $(this).addClass 'active'
      sortBy = $(e.target).data('option-value')
      $('.thumbnails').isotope
        sortBy: sortBy

    $(document).on 'click', ".thumbnails.show-view .project-details-container", (e) ->
      e.preventDefault()
      imagePath = $(this).parent().find('img').attr('src')
      img = $("#zoom").find('img')
      $(img).attr('src', imagePath)
      $("#zoom").css
        lineHeight: $(window).height() + 'px'
      $("#zoom").fadeIn()

      $(window).resize =>
        $("#zoom").css
          lineHeight: $(window).height() + 'px'

    $(document).on 'click', "#zoom", (e) ->
      e.preventDefault()
      $("#zoom").fadeOut()

    $(document).on 'click', ".close-button", (e) ->
      e.preventDefault()
      $("#zoom").fadeOut()

    # return this to make this class chainable
    return this

  initResize: () ->
    # Skip the first argument (event object) but log the other args.
    (_, options) =>
      log "resize"
      @buildGrid(options)

  initAfterViewContentLoadedProxy: () ->
    # Skip the first argument (event object) but log the other args.
    (_, path) =>
      log "loaded"
      @setupGrid()

  renderGrid: () ->
    # Skip the first argument (event object) but log the other args.
    (_, path) =>

      $('#overlay .logo-preload .text').hide().fadeIn()
      $('.info-container .spinner .text').hide().fadeIn()

      $('.thumbnails').waitForImages
        waitForAll: true
        finished: () =>
          clearTimeout renderTimeout if renderTimeout
          renderTimeout = setTimeout(=>
            @setupGrid((options) =>
              log "rendering"
              @buildGrid(options, =>
                @setInfoWaypoints('.block', '#main')
                $('#overlay .logo-preload .text').fadeOut()
                $('.info-container .spinner .text').fadeOut()
                $UI.hideSpinner $('.info-container .spinner')
                $UI.hideLoadingScreen(=>
                  $('.info-container .spinner .text').text ""
                  $('#overlay .logo-preload .text').text ""
                )
                log "Rendering complete"
                $.publish 'event.Portfolio', message: "Rendering complete"
              )
            )
          , 1000)
        each: (loaded, count, success) =>
          log loaded + " of " + count + " project images has " + ((if success then "loaded" else "failed to load")) + "."
          perc = Math.round((100 / count) * loaded)
          $('#overlay .logo-preload .text').show()
          # $('#overlay .logo-preload .text').text "#{perc} %"
          $('.info-container .spinner .text').show()
          $('.info-container .spinner .text').text "#{perc}"
          $(this).addClass "loaded"

  setInfoWaypoints: (element, context) ->
    self = this
    $(element).waypoint
      context: context
      # offset: 50
      handler: (direction) ->
        self.projectInfoOverlay.fadeOut()

        description       = $(this).find('.description').text()
        self.previousView = self.inView
        self.inView       = description

        # unless self.previousView is self.inView
        if direction is 'down'
          if description.length > 0
            self.projectInfoOverlay.fadeIn()
            projectOverlay = self.projectInfoOverlay.find('p')
            projectOverlay.text description

  setupGrid: (callback) ->
    callback = callback or ->
    @category         = $UI.Constants.category
    @path             = $UI.Constants?.actionPath
    options           = {}
    sidebarMenuOpen   = $UI.Constants.sidebarMenuOpen
    sidebarOpen       = $UI.Constants.sidebarOpen

    log "sidebarOpen: " + $UI.Constants.sidebarOpen
    log "sidebarMenuOpen: " + $UI.Constants.sidebarMenuOpen

    if sidebarOpen is true and sidebarMenuOpen is true
      log "grid: sidebarmenu open"
      containerWidth = ($(window).width() - $("nav.sidebar-nav").width()) - 16
      options.widthDifference = $("nav.sidebar-nav").width() - 70
      options.rightMargin = 80
    else if sidebarOpen is true and sidebarMenuOpen is false
      log "grid: sidebar open"
      containerWidth = $(window).width() - 70
      options.widthDifference = 0
      options.rightMargin = 85
    else if sidebarOpen is false and sidebarMenuOpen is false
      log "grid: sidebar closed"
      containerWidth = $(window).width()
      options.widthDifference = 0
      options.rightMargin = 25
    else
      log "grid: default"
      containerWidth = $(window).width()
      options.widthDifference = 0
      options.rightMargin = 25

    @contentEl.css width: containerWidth
    @innerContentEl.css width: containerWidth
    @thumbnailsEl.css
      width: containerWidth
      height: 'auto'

    callback(options)

  buildGrid: (options, gridCallback) ->
    gridCallback = gridCallback or ->

    calc = () =>
      if Object.keys(options).length is 0
        options.widthDifference = 0
        options.rightMargin = 0

      @containerEl    = $('.thumbnails')
      @thumbContainer = $('.thumb')
      windowWidth     = $(window).width() - options.widthDifference
      windowHeight    = $(window).height()
      containerWidth  = windowWidth - options.rightMargin
      cols1           = containerWidth
      cols2           = containerWidth / 2
      cols3           = containerWidth / 3
      cols4           = containerWidth / 4
      cols5           = containerWidth / 5

      # log "cols1: #{cols1} - cols2: #{cols2} - cols3: #{cols3} - cols4: #{cols4} - cols5: #{cols5}"

      # if cols4 > 600
      #   cols = cols5
      if cols3 > 700
        cols = cols4
      else if cols2 > 600
        cols = cols3
      else if cols2 < 400
        cols = cols1
      else
        cols = cols2

      if @path is 'show' and cols3 > 700 then cols = cols3

      @containerEl.css width: $(window).width()
      if @containerEl.find('.thumb').length is 1
        @thumbContainer.css width: containerWidth - 0.5
        @thumbContainer.find('img').css width: containerWidth - 0.5
      else if @containerEl.find('.thumb').length is 2
        @thumbContainer.css width: (containerWidth / 2)
        @thumbContainer.find('img').css width: (containerWidth / 2)
      else
        @thumbContainer.css width: cols - 0.5
        @thumbContainer.find('img').css width: cols - 0.5

      @containerEl.imagesLoaded =>
        @containerEl.isotope
          itemSelector: '.thumb'
          animationEngine: 'jquery'
          layoutMode: 'masonry'
          resizeContainer: true
          resizable: true
          transformsEnabled: true
          # filter: ".#{@category}" if @category and @category isnt 'all'
          sortBy: 'name'
          # animationOptions:
          #  duration: 300
          #  easing: 'easeOutQuint'
          #  queue: false

          onLayout: =>
            $UI.Constants.viewLoaded = true
            clearTimeout = imageGridTimeout if imageGridTimeout
            imageGridTimeout = setTimeout(=>
              gridCallback()
              gridCallback = -> # clear reference to existing callback to avoid bugs
            , 200)

          getSortData:
            name: ($elem) ->
              return $elem.find('.name').text()
            category: ($elem) ->
              return $elem.attr('data-category')
            tag: ($elem) ->
              return $elem.attr('data-tag')
            year: ($elem) ->
              return $elem.find('.year').text()

      # @containerEl.infinitescroll
      #   behavior: 'local'
      #   binder: '.thumbnails'
      #   navSelector: "#page_nav" # selector for the paged navigation
      #   nextSelector: "#page_nav a" # selector for the NEXT link (to page 2)
      #   itemSelector: '.thumb' # selector for all items you'll retrieve
      #   dataType: 'json'
      #   appendCallback: false
      #   loading:
      #     finishedMsg: "No more pages to load."
      #     img: "http://i.imgur.com/qkKy8.gif"

      # # call Isotope as a callback
      # , (json, opts) =>
      #   page = opts.state.currPage
      #   log page
      #   # @containerEl.isotope "appended", $(newElements)



      # $.extend $.Isotope::,
      #   _customModeReset: ->
      #   _customModeLayout: ($elems) ->
      #   _customModeGetContainerSize: ->
      #   _customModeResizeChanged: ->
      #     log "TEST"
      #     # callback()

    # $('#main').scroll ->
    #   $('.thumbnails').isotope('reLayout')

    $(window).resize ->
      calc()
    calc()

# Assign this class to the Portfolio Namespace
Portfolio.UI.ImageGrid = ImageGrid