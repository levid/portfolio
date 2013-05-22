#### The UI class serving as the base class for the Application
#
# This class can be accessed via ** window.Portfolio.UI **
#
# ** Additional Classes: **
#
# - Portfolio.UI.Audio
# - Portfolio.UI.ImageGrid
# - Portfolio.UI.Nav
# - Portfolio.UI.Sidebar
# - Portfolio.UI.Theme
# - Portfolio.UI.Utils
#
# ** To enable app logging append ?traceToConsole to the query string **
#
class UI extends Portfolio
  opts:
    loadingEl:        undefined
    overlayEl:        undefined
    overlaySpinnerEl: undefined
    loadingSpinnerEl: undefined
    loadingBlockEl:   undefined

  #### The constructor for the UI class
  #
  # @param [Object] options
  # - The options object that is used by the class for configuration purposes (optional)
  #
  constructor: (@options) ->
    # Extend default options to include passed in arguments
    @options          = $.extend({}, this.opts, @options)
    @overlayEl        = @options.overlayEl        or "#overlay"
    @overlaySpinnerEl = @options.overlaySpinnerEl or "#overlay .spinner"
    @loadingSpinnerEl = @options.loadingSpinnerEl or "#loading .spinner"
    @loadingBlockEl   = @options.loadingBlockEl   or "#loading-block"
    @loadingEl        = @options.loadingEl        or "#loading"

    window.$UI = this
    $UI.Constants = {}

    $(document).ready =>
      @showSpinner $(@overlaySpinnerEl),
        lines: 15
        length: 0
        width: 3
        radius: 50
        color: '#000000'
        speed: 1.6
        trail: 45
        shadow: false
        hwaccel: true

    this # allows for method chaining

  # This method is initialized by the parent class and should contain anything that needs to run on every page
  initGlobalUI: (options) ->
    # Methods to enable functionality upon initialization
    $(document).ready =>
      $UI.Constants.sidebar = new $UI.Sidebar(
        sidebarNavEl:    "nav.sidebar-nav"
        sidebarNavLinks: "nav.sidebar-nav ul.nav li a"
      )

      $UI.Constants.sidebarScroller = new $UI.Scroller("[data-behavior='scrollable']")

      $UI.Constants.audio = new $UI.Audio(
        config:
          sidebarNav:
            el:       "nav.sidebar-nav"
            links:    "nav.sidebar-nav ul.nav li a"
            soundId:  "whoosh"
          homeNav:
            el:       "section.content ul.nav"
            links:    "section.content ul.nav li:not(.filter-by) a"
            soundId:  "rollover"
          footerNav:
            el:       ".social-links"
            links:    ".social-links a"
            soundId:  "click"
      )
      $UI.Constants.audio.enableAudio()

      $(window).load =>
        $UI.Constants.theme = new $UI.Theme()
        $UI.Constants.theme.enableThemes()

  showLoadingScreen: () ->
    $(@overlayEl).show()
    @showSpinner $(@overlaySpinnerEl),
      lines: 15
      length: 0
      width: 3
      radius: 50
      color: '#000000'
      speed: 1.6
      trail: 45
      shadow: false
      hwaccel: true

  hideLoadingScreen: () ->
    $(@overlayEl).fadeOut(=>
      @hideSpinner $(@overlaySpinnerEl)
    )

  showLoadingSpinner: (target) ->
    $(@loadingEl).fadeIn()
    @showSpinner $(@overlaySpinnerEl),
      lines: 12
      length: 0
      width: 5
      radius: 30
      color: '#ffffff'
      speed: 1.6
      trail: 45
      shadow: false
      hwaccel: false

  hideLoadingSpinner: () ->
    $(@loadingEl).fadeOut(=>
      @hideSpinner $(@loadingSpinnerEl)
    )

  showSpinner: (target, opts) ->
    opts = opts or
      lines: 12         # The number of lines to draw
      length: 0         # The length of each line
      width: 2          # The line thickness
      radius: 36        # The radius of the inner circle
      color: '#ffffff'  # #rgb or #rrggbb
      speed: 1.6        # Rounds per second
      trail: 45         # Afterglow percentage
      shadow: false     # Whether to render a shadow
      hwaccel: false    # Whether to use hardware acceleration

    $(target).spin(opts)

  hideSpinner: (target) ->
    $(target).spin('stop')

  zoomOut: () ->
    console.log "zoom out"
    $(@loadingBlockEl).css
      top: -150
      left: -150
      width: $(window).width() + 300
      height: $(window).height() + 300

    $(@loadingBlockEl).animate
      width: $(@loadingBlockEl).find(".spinner").width()
      height: $(@loadingBlockEl).find(".spinner").height()
      left: ($(window).width() / 2) - ($(@loadingBlockEl).find(".spinner").width() / 2)
      top: ($(window).height() / 2) - ($(@loadingBlockEl).find(".spinner").height() / 2) - 40
    ,
      duration: 1500
      easing: 'easeOutSine'
      complete: =>
        # console.log "finished"

# Assign this class to the $SC Namespace
window.Portfolio.UI = new UI()