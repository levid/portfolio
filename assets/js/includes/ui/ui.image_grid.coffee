'use strict'
#### ImageGrid class
#
# @extends UI
#
# - This class extends the Portfolio.UI class
#
class ImageGrid extends Portfolio.UI
  opts:
    sidebarNavEl:     undefined
    contentEl:        undefined
    innerContentEl:   undefined
    thumbnailsEl:     undefined

  #### The constructor for the ImageGrid class
  #
  # @param [Object] options
  # - The options object that is used by the class for configuration purposes (optional)
  #
  constructor: (@options) ->
    # Extend default options to include passed in arguments
    @options          = $.extend({}, this.opts, @options)
    @sidebarNavEl     = @options.sidebarNavEl or "nav.sidebar-nav"
    @innerContentEl   = @options.innerContentEl   or "section.content .innerContent"
    @contentEl        = @options.contentEl        or "section.content"
    @thumbnailsEl     = @options.thumbnailsEl     or "section.content .innerContent .thumbnails"


    $.subscribe('resize.Portfolio', @initResize('resize.Portfolio'))
    $.subscribe('initAfterViewContentLoaded.Portfolio', @initAfterViewContentLoadedProxy('initAfterViewContentLoaded.Portfolio'))

    $(document).on 'click', ".sort-by a", (e) ->
      e.preventDefault()
      $(".sort-by a").removeClass 'active'
      $(this).addClass 'active'
      # get href attribute, minus the '#'
      sortBy = $(e.target).data('option-value')
      $('.thumbnails').isotope
        sortBy: sortBy

    # return this to make this class chainable
    return this

  initResize: () ->
    # Skip the first argument (event object) but log the other args.
    (_, options) =>
      console.log "resize"
      # resizeTo = setTimeout(=>
      #   @buildGrid options, =>
      #     $('.thumbnails').isotope('reLayout')
      #     clearTimeout resizeTo
      # , 500)

      @buildGrid(options, =>
        $('.thumbnails').isotope('reLayout')
      )

  initAfterViewContentLoadedProxy: () ->
    # Skip the first argument (event object) but log the other args.
    (_, path) =>
      console.log "loaded"
      @category = $UI.Constants.category
      options = {}
      sidebarMenuOpen = $UI.Constants.sidebarMenuOpen
      sidebarOpen     = $UI.Constants.sidebarOpen

      console.log "sidebarOpen: " + $UI.Constants.sidebarOpen
      console.log "sidebarMenuOpen: " + $UI.Constants.sidebarMenuOpen

      if sidebarOpen is true and sidebarMenuOpen is true
        console.log "grid: sidebarmenu open"
        containerWidth = ($(window).width() - $(@sidebarNavEl).width()) - 16
        options.widthDifference = $(@sidebarNavEl).width() - 70
        options.rightMargin = 80
      else if sidebarOpen is true and sidebarMenuOpen is false
        console.log "grid: sidebar open"
        containerWidth = $(window).width() - 70
        options.widthDifference = 0
        options.rightMargin = 85
      else if sidebarOpen is false and sidebarMenuOpen is false
        console.log "grid: sidebar closed"
        containerWidth = $(window).width()
        options.widthDifference = 0
        options.rightMargin = 25
      else
        console.log "grid: default"
        containerWidth = $(window).width()
        options.widthDifference = 0
        options.rightMargin = 25

      $(@contentEl).css width: containerWidth
      $(@innerContentEl).css width: containerWidth
      $(@thumbnailsEl).css width: containerWidth

      # TODO: create dom listener to make sure thumbnails
      # has children before initiating re-layout
      buildIt = setTimeout(=>
        @buildGrid options, =>
          $('.thumbnails').isotope('reLayout')
          clearTimeout buildIt
      , 1000)

  buildGrid: (options, callback) ->
    callback          = callback or ->
    if options
      widthDifference = options.widthDifference
      rightMargin     = options.rightMargin
      path            = $UI.Constants?.actionPath
    else
      widthDifference = 0
      rightMargin     = 70

    calc = () =>
      @containerEl    = $('.thumbnails')
      @thumbContainer = $('.thumb')
      windowWidth     = $(window).width() - widthDifference
      windowHeight    = $(window).height()
      containerWidth  = windowWidth - rightMargin
      cols1           = containerWidth
      cols2           = containerWidth / 2
      cols3           = containerWidth / 3

      console.log "cols1: #{cols1} - cols2: #{cols2} - cols3: #{cols3}"

      if cols2 > 600
        cols = cols3
      else if cols2 < 400
        cols = cols1
      else
        cols = cols2

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

      $('.thumbnails').imagesLoaded =>
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
          #  duration: 500
          #  easing: 'easeInOutQuint'
          #  queue: false

          onLayout: =>
           $UI.Constants.viewLoaded = true

          getSortData:
            name: ($elem) ->
              return $elem.find('.name').text()
            category: ($elem) ->
              return $elem.attr('data-category')
            tag: ($elem) ->
              return $elem.attr('data-tag')
            year: ($elem) ->
              return $elem.find('.year').text()

      @containerEl.infinitescroll
        behavior: 'local'
        binder: @containerEl
        navSelector: "#page_nav" # selector for the paged navigation
        nextSelector: "#page_nav a" # selector for the NEXT link (to page 2)
        itemSelector: '.thumb' # selector for all items you'll retrieve
        dataType: 'json'
        appendCallback: false
        loading:
          finishedMsg: "No more pages to load."
          img: "http://i.imgur.com/qkKy8.gif"

      # call Isotope as a callback
      , (json, opts) =>
        page = opts.state.currPage
        console.log page
        # @containerEl.isotope "appended", $(newElements)



      # $.extend $.Isotope::,
      #   _customModeReset: ->
      #   _customModeLayout: ($elems) ->
      #   _customModeGetContainerSize: ->
      #   _customModeResizeChanged: ->
      #     console.log "TEST"
      #     # callback()

    # $(window).scroll ->
    #   console.log "test"
    #   $('.thumbnails').isotope('reLayout')
    $(window).resize ->
      calc()
    calc()

# Assign this class to the Portfolio Namespace
Portfolio.UI.ImageGrid = ImageGrid