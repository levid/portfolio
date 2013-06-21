#### The HappyPlace class serving as the base class for the Application
#
# This class can be accessed via ** window.HappyPlace **
#
# ** Additional Classes: **
#
# - HappyPlace.Layer
# - HappyPlace.Move
# - HappyPlace.Preload
# - HappyPlace.Share
# - HappyPlace.Slide
# - HappyPlace.Sprite
# - HappyPlace.Utils
#
# ** To enable app logging append ?traceToConsole to the query string **
#
class HappyPlace

  #### Define Application Variables
  #
  opts:
    # - container vars
    wrapper:          undefined # [Object] Wrapper container element (#wrapper)
    app:              undefined # [Object] App container element (#app)
    hotSpots:         undefined # [Object] HotSpot element container (#hotspots)
    clouds:           undefined # [Object] for animation demo (#clouds)
    flashDialog:      undefined # [Object] Display a flash overlay with an optional message (#flashDialog)
    landScapeMessage: undefined # [Object] Landscape Message element container (#landscape-message)

    # - misc vars
    shake:            undefined # [Boolean] Determine if a device shake has been detected
    manifest:         undefined # [Array] List of files to be pre-loaded before the app is displayed
    displayScale:     undefined # [Integer] Device pixel ratio
    audioTrack:       undefined # [Array] Soundtrack filenames (mp3, ogg)
    paused:           undefined # [String] Keep track if the app is currently in focus
    allowAnimation:   undefined # [Boolean] Determine if animation is allowed or not[]

    # - speed vars
    shakeSpeed:       undefined # [Integer] How fast the layers animate when a shake event is detected
    swipeSpeed:       undefined # [Integer] How fast the layers animate when a swipe event is detected
    dragSpeed:        undefined # [Integer] How fast the layers animate when a drag event is detected
    introSpeed:       undefined # [Integer] How fast the layers animate during the intro (sliding only)

    # - intro vars
    startIntro:       undefined # [Boolean] Keep track if the intro has started (sliding only)
    introType:        undefined # [String] Type of intro 'static, sliding or none'
    introContainer:   undefined # [Object] Intro container element

    # - path vars
    imgPath:          undefined # [String] Path where the images are stored
    arrowIcon:        undefined # [String] Path to the arrow icon that is displayed when dragging
    thumbnailPath:    undefined # [String] Path to the sharing thumbnails (facebook only)
    spritePath:       undefined # [String] Path to where the sprite sheets are stored
    audioPath:        undefined # [String] Path to where the audio files are stored

    # - dimension vars
    appWidth:         undefined # [Integer] Width of the app
    appHeight:        undefined # [Integer] Height of the app
    swipeIconWidth:   undefined # [Integer] Width of the swipe icon
    swipeIconHeight:  undefined # [Integer] Height of the swipe icon
    wrapperWidth:     undefined # [Integer] Width of the wrapper
    wrapperHeight:    undefined # [Integer] Height of the wrapper

    # - class vars
    layerClass:       undefined # [Object] HappyPlace.Layer class instance
    slideClass:       undefined # [Object] HappyPlace.Slide class instance
    preloaderClass:   undefined # [Object] HappyPlace.Preload class instance
    movementClass:    undefined # [Object] HappyPlace.Move class instance (not currently used)
    audioClass:       undefined # [Object] HappyPlace.Audio class instance

    # - movement vars
    startTime:        undefined # [Integer] Value used to keep track of how quickly a user drags
    endTime:          undefined # [Integer] Value used to keep track of how quickly a user drags
    startX:           undefined # [Integer] Value used to keep track of how far a user drags
    endX:             undefined # [Integer] Value used to keep track of how far a user drags
    distance:         undefined # [Integer] endX - startX
    duration:         undefined # [Integer] endTime - startTime

    # - cursor vars
    cursorDown:       undefined # [Boolean] Keeps track of when a user is interacting with the app (touch or click)
    cursorX:          undefined # [Integer] X Value of the cursor
    pcursorX:         undefined # [Integer] Stored value of the cursor used to track history
    cursorXVelocity:  undefined # [Integer] cursorX - pcursorX (tracks how fast the user is dragging)

    # - sound vars
    allowAudio:       undefined # [String] true or false value that controls if audio is allowed to play

    # - sharing vars
    fbAppId:          undefined # [String] Facebook App Id

    # - slide vars
    slideIds:         undefined # [Array] List of slide Ids
    totalSlides:      undefined # [Integer] Total number of slides (3 is the minimum for the wrapping technique to work)
    totalWidth:       undefined # [Integer] Total width of the app * number of slides
    visibleSlide:     undefined # [Array] List of the currently visible slides for each layer
    slideHeight:      undefined # [Integer] Height of an individual slide
    slideArray:       undefined # [Array] Constantly updated array of the current slide order (ex: [0,3,1,2])
    startPointArray:  undefined # [Array] This controls which slides appear first on page load (ex: ?startAt=3-3-3-3)

    # - layer vars
    layerIds:         undefined # [Array] List of layer Ids
    totalLayers:      undefined # [Integer] Total number of layers (1 is the minimum allowed)

  #### The constructor for the HappyPlace class
  #
  # @param [Object] options
  #
  # - The options object that is used by the class for configuration purposes (optional)
  #
  constructor: (@options) ->
    # Extend default options to include passed in arguments
    @options = $.extend({}, this.opts, @options)

    log "---Instantiating App---"

    # Set default vars
    @slideIds         = @getQueryStringParam('slideIds') or @options.slideIds or []
    @layerIds         = @getQueryStringParam('layerIds') or @options.layerIds or []
    @slideHeight      = @getQueryStringParam('slideHeight') or @options.slideHeight or 712
    @shakeSpeed       = @getQueryStringParam('shakeSpeed') or @options.shakeSpeed or 1500
    @swipeSpeed       = @getQueryStringParam('swipeSpeed') or @options.swipeSpeed or 333
    @dragSpeed        = @getQueryStringParam('dragSpeed') or @options.dragSpeed or 999
    @introSpeed       = @getQueryStringParam('introSpeed') or @options.introSpeed or 1500
    @introType        = @getQueryStringParam('introType') or @options.introType or 'static'
    @swipeIconHeight  = @getQueryStringParam('swipeIconHeight') or @options.swipeIconHeight or 86
    @swipeIconWidth   = @getQueryStringParam('swipeIconWidth') or @options.swipeIconWidth or 193
    @imgPath          = @getQueryStringParam('imgPath') or @options.imgPath or "img"
    @thumbnailPath    = @getQueryStringParam('thumbnailPath') or @options.thumbnailPath or "thumbs"
    @spritePath       = @getQueryStringParam('spritePath') or @options.spritePath or "spritesheets"
    @allowAudio       = @getQueryStringParam('allowAudio') or @options.allowAudio or 'false'
    @allowAnimation   = @getQueryStringParam('allowAnimation') or @options.allowAnimation or 'true'
    @fbAppId          = @getQueryStringParam('fbAppId') or @options.fbAppId or ''
    @manifest         = @getQueryStringParam('manifest') or @options.manifest or []
    @audioTrack       = @getQueryStringParam('audioTrack') or @options.audioTrack or ''
    @audioPath        = @getQueryStringParam('audioPath') or @options.audioPath or 'audio'
    @cacheBust        = @getQueryStringParam('cacheBust') or @options.cacheBust or 'false'
    @totalSlides      = @slideIds.length
    @totalLayers      = @layerIds.length
    @visibleSlide     = new Array()
    @slideArray       = new Array()
    @startPointArray  = new Array()

    # Constructor definitions like these are the ONLY approach available if public methods require access to function arguments or closure state.
    # see: http://www.gridlinked.info/oop-with-coffeescript-javascript/
    #
    # Create public static method instances (accessed via: HappyPlace.methodName())
    HappyPlace.getSlideArray          = => @slideArray
    HappyPlace.isCacheBustingEnabled  = => @cacheBust
    HappyPlace.pauseAnimations        = => @pauseAnimations
    HappyPlace.resumeAnimations       = => @resumeAnimations
    HappyPlace.isAnimationAllowed     = => @allowAnimation

    @setUpDOM() # Configure the necessary DOM elements to make the app display correctly
    @initPreloader() # Initialize the Preloader
    @handleMobile() if isMobile.any() # Check if a mobile device is being used and handle accordingly

    # public static method that returns a function object
    HappyPlace.methods = {
      getQueryStringParam: => @getQueryStringParam(name)
      setUpDOM: => @setUpDOM()
    }

    this # return this to make the class chainable if necessary

  #### Get Query String Param
  #
  # This method searches for a specific parameter in the query string and returns it's value
  #
  getQueryStringParam: (name) ->
    params = $.deparam.querystring()
    params[name]

  #### Configure the DOM
  #
  # This method sets up the DOM with the necessary
  # objects to make the app function
  #
  setUpDOM: () ->
    log "---Configuring the DOM---"
    @displayScale     = window.devicePixelRatio or 1
    @appWidth         = $(window).width()*@displayScale  #I have these set elsewhere
    @appHeight        = $(window).height()*@displayScale #but here for convenience below
    @wrapper          = $("#wrapper") # page wrapper - might hold global nav etc.
    @app              = $("<div id=\"app\" />") # the app display container
    @wrapperWidth     = @wrapper.width() # Set the wrapper width
    @totalWidth       = @wrapperWidth * @totalSlides # Set the total width of the app & slides
    @arrowIcon        = "#{@imgPath}/arrow2.svg" # Define the arrow icon path

    @wrapper.append @app # Append it to the DOM
    @wrapper.css  transform: "translateZ(0)" # activate hardware rendering
    @app.css      transform: "translateZ(0)" # activate hardware rendering

    @app.animate opacity: 1, 700 # Fade in the app

    @animateSlides = false

  #### Initialize Preloader
  #
  # This method configures the Preload class
  #
  # @param [Function] callback
  #
  # - The callback method (optional)
  #
  initPreloader: () ->
    @preloaderClass = new HappyPlace.Preload(
      manifest: @manifest
      callback: =>
        @initApp()
        @handleIntro(=>
          @setupSharingButtons()
        )
    )

  #### Set up the Sharing Buttons
  #
  # This method handles the creation of the sharing buttons
  #
  # - Twitter
  # - Facebook
  #
  setupSharingButtons: () =>
    # Initialize Facebook via their sharing API
    FB.init
      appId: @fbAppId
      status: true
      cookie: true

    # Set up the twitter share button
    twitter = new HappyPlace.Share(
      appendTo: @wrapper
      imgPath: @imgPath
      id: "twitter-button"
      type: 'twitter'
      url: "https://twitter.com/intent/tweet"
      width: 400
      height: 300
      buttonTitle: 'Share Twitter'
      properties:
        url: ''
        text: $("meta[name='twitter:title']").attr("content")
        image: "#{$("meta[name='twitter:url']").attr("content")}#{@imgPath}/#{@thumbnailPath}/Coke_ImageMatrix" # Image number is dynamically appended in Share class
    )

    # Set up the facebook share button
    facebook = new HappyPlace.Share(
      appendTo: @wrapper
      imgPath: @imgPath
      id: "facebook-button"
      type: 'facebook'
      url: "http://www.facebook.com/sharer.php"
      mobile_url: 'http://m.facebook.com/sharer.php'
      width: 400
      height: 300
      buttonTitle: 'Share Facebook'
      properties:
        url: $("meta[property='og:url']").attr("content") + "?startAt="
        title: $("meta[property='og:title']").attr("content")
        caption: $("meta[property='og:caption']").attr("content")
        description: $("meta[property='og:description']").attr("content")
        image: "#{$("meta[property='og:url']").attr("content")}#{@imgPath}/#{@thumbnailPath}/Coke_ImageMatrix" # Image number is dynamically appended in Share class
    )

  #### Initialize The App
  #
  # This method initalizes the app after preloading is complete
  #
  initApp: () ->
    log "---Initializing App---"
    @setupHotSpots() # Create the hotspots that are necessary for dragging to work
    @setupLayers() # Set up and configure the layers
    @setupSlides() # Set up and configure the slides for each layer
    @setupCokeBottle() # Dispaly the Coke bottle graphic
    @setupBlurFocus()
    @adjustAppSize() # Adjust the app size to fit the device

    @wrapIt $(".slide") # do the first wrapping on load

  #### Set up Audio
  #
  # This method sets up the audio in the application
  #
  setupAudio: () ->
    @audioClass = new HappyPlace.Audio(
      audioTrack: @audioTrack
      audioPath: @audioPath
    )

  #### Initalize the Static Intro
  #
  # This method initalizes the static intro screen
  #
  initStaticIntro: () ->
    if @isAnimationEnabled()
      @introContainer.delay(500).fadeIn()
    else
      @introContainer.delay(500).fadeIn()
      introScreenTimer = setInterval(=>
        @introContainer.find('.intro-slide:eq(1)').fadeToggle(400)
      , 2000)

    @introContainer.find('a').on 'click', (e) =>
      e.preventDefault()

      if @isAudioEnabled()
        @audioClass.createMuteButton() # Display the mute button
        @audioClass.playAudio()

      @introContainer.fadeOut()
      clearInterval introScreenTimer if introScreenTimer

  #### Set up Blur Focus
  #
  # This method listens for changes in the window blur and focus.
  #
  # If someone clicks off the window it will pause the audio and animations
  # and then resume if they click back on the window.
  #
  setupBlurFocus: () ->
    $(window).blur(=>
      @pauseApp()
    ).focus =>
      @resumeApp()

  #### Pause App
  #
  # This method pauses the animations and audio in the app
  #
  pauseApp: () ->
    @paused = true
    @pauseAnimations()
    @audioClass.pauseAudio() if @audioClass?.audioReady is true

  #### Resume App
  #
  # This method resumes the animations and audio in the app
  #
  resumeApp: () ->
    @paused = false
    @resumeAnimations()
    @audioClass.resumeAudio() if @audioClass?.audioReady is true

  #### Pause Animations
  #
  # This method pauses the animations currently running in a specific layer or all layers.
  #
  # @param [Object] el
  #
  # - The layer element object used as a starting point (optional)
  #
  pauseAnimations: (el) ->
    if el
      $(el).find('div').addClass 'paused'
      $(el).find('.paused').pause()
    else
      $('div').addClass 'paused'
      $('.paused').pause()

  #### Resume Animations
  #
  # This method resumes the animations which are paused in a specific layer or all layers.
  #
  # @param [Object] el
  #
  # - The layer element object used as a starting point (optional)
  #
  resumeAnimations: (el) ->
    if el
      $(el).find('.paused').resume()
      $(el).find('div').removeClass 'paused'
    else
      $('.paused').resume()
      $('div').removeClass 'paused'

  #### Set Up the Static Intro Slide
  #
  # This method creates the DOM element for the static intro slide
  #
  setupStaticIntroSlide: () ->
    # Configure the DOM
    @introContainer = $("<div id=\"static-intro-slide\" />")
    @introContainer.append "<a href=\"#\"></a>"

    if @isAnimationEnabled()
      @introContainer.append "<div class=\"intro-slide\"></div>"
      @introContainer.find(".intro-slide").append "<div class=\"instructions\"></div>"
      @introContainer.find(".intro-slide").append "<object data=\"#{@imgPath}/intro-slide.svg\" type=\"image/svg+xml\" width=\"100%\" height=\"100%\" />"
    else
      @introContainer.append "<div class=\"intro-slide\"><object data=\"#{@imgPath}/intro-slide-fallback1.svg\" type=\"image/svg+xml\" width=\"100%\" height=\"100%\" /></div>"
      @introContainer.append "<div class=\"intro-slide\"><object data=\"#{@imgPath}/intro-slide-fallback2.svg\" type=\"image/svg+xml\" width=\"100%\" height=\"100%\" /></div>"

    # Check for mobile device and load correct intro slide
    if isMobile.any() then @introContainer.addClass 'mobile'

    # Append slide to DOM
    @wrapper.prepend @introContainer

  #### Is Audio Enabled
  #
  # This getter method determines if audio is enabled or not.
  #
  isAudioEnabled: () ->
    if @allowAudio isnt 'false' && @detectIphoneVersion() isnt 4 then true else false

  #### Is Animation Enabled
  #
  # This getter method determines if animation is enabled or not.
  #
  isAnimationEnabled: () ->
    if HappyPlace.Utils.hasProperty('cssanimations') and isMobile.any() is null and HappyPlace.isAnimationAllowed() is 'true' then true else false

  #### Handle Intro
  #
  # This method handles the displaying of the intro (if set)
  #
  # @param [Function] callback
  #
  # - The callback method (optional)
  #
  handleIntro: (callback) ->
    _handleIntroCallback = callback or =>

    if @introType == 'sliding'
      @startPointArray = HappyPlace.Utils.parseQueryString()
      @loadSlideArray(@assignIntroPoints(@startPointArray))

      # @showFlashDialog('When the sliding stops, click and drag to swap layers...', 3500)
      @initSlidingIntro(=>
        @addEventListeners()
        # @showFlashDialog('Start by dragging a layer now...', 500, =>)
      )
    else if @introType == 'static'
      # Create the intro container
      @setupStaticIntroSlide()
      @setupAudio() if @isAudioEnabled()
      @initStaticIntro()
      @startPointArray = HappyPlace.Utils.parseQueryString()
      @loadSlideArray(@startPointArray)
      @addEventListeners()
    else
      @startPointArray = HappyPlace.Utils.parseQueryString()
      @loadSlideArray(@startPointArray)
      @addEventListeners()

    _handleIntroCallback() # execute callback method


  #### Initialize the Sliding Intro
  #
  # This method controls the sliding intro screen
  #
  # @param [Function] callback
  #
  # - The callback method (optional)
  #
  initSlidingIntro: (callback) ->
    _slidingIntroCallback = callback or =>

    # Handle the arrow swiping
    swipeArrow = (count, callback) =>
      _swipeArrowCallback = callback or =>
      arrow = $("<div id=\"arrow\"></div>")
      arrow.append "<object data=\"#{@arrowIcon}\" type=\"image/svg+xml\" width=\"193\" height=\"86\" />"
      @wrapper.append arrow

      $(arrow).css
        width: 193
        height: 86
        left: 100
        top: @hotSpots.find(".#{@layerIds[count]}").position().top + (@hotSpots.find(".#{@layerIds[count]}").height() * .5) - (@swipeIconHeight * .5)

      $(arrow).fadeIn('slow').animate
        left: (@wrapper.width() / 2) + (@wrapper.width() * .2)
      ,
        duration: @introSpeed
        easing: 'easeOutExpo'
        complete: =>
          $(arrow).fadeOut(=>
            _swipeArrowCallback()
          )

      slideEl = $("##{@layerIds[count]}").find('.slide')
      slideEl.delay(600).animate
        left: "+=" + ((@wrapper.width()) - (@wrapper.width() * .4))
      ,
        duration: @introSpeed
        easing: 'easeOutExpo'


    # Configure the hot spots
    @hotSpots.find("li").animate opacity: 1, duration: 10
    @hotSpots.find("li").css borderBottom:
      '2px dotted rgba(255,255,255, 0.5)'

    # Set up the slide demo
    @startIntro = true
    count       = 0
    introTimer  = setInterval(=>
      @hotSpots.find("li").css backgroundColor: "transparent"
      @hotSpots.find("li:eq(#{count})").animate backgroundColor: "rgba(255,255,255,0.25)"

      $("#arrow").remove()
      swipeArrow(count, =>
        @hotSpots.find("li").css backgroundColor: "transparent"
        @snapIt($("##{@layerIds[count]}").find('.slide'), =>
          log "layer: #{count} = " + @slideIds[parseInt(@startPointArray[count])]
        , parseInt(@startPointArray[count]))

        if count is @startPointArray.length-1
          @startIntro = false
          setTimeout(=>
            @hotSpots.find("li").css borderBottom: "none"
            $("#arrow").remove()
            _slidingIntroCallback()
          , 700)
          clearTimeout introTimer
        else count++
      )
    , 3500)


  #### Create the Hot Spots for dragging
  #
  # This method creates the necessary hot spots
  # to control dragging of the various layers
  #
  setupHotSpots: () ->
    @hotSpots = $("<div id=\"hotspots\" />")
    @hotSpots.append "<ul></ul>"
    $.each @layerIds,(index, val) => @hotSpots.find("ul").append "<li class=\"#{val}\">&nbsp;</li>"
    @hotSpots.find("ul").append "<li class=\"#{@layerIds[0]}\">&nbsp;</li>"
    @app.append @hotSpots

  #### Create the App Layers
  #
  # This method creates the various presentation layers
  #
  # - background
  # - bg-elements
  # - mg-elements
  # - fg-elements
  #
  setupLayers: () ->
    @layerClass = new HappyPlace.Layer(
      layerIds:     @layerIds
      totalLayers:  @totalLayers
    )

    @app.append @layerClass.getLayers()

  #### Create the App Slides
  #
  # This method creates the various slides
  # containing the SVG images for each layer
  #
  setupSlides: (id) ->
    @slideClass = new HappyPlace.Slide(
      layerIds:     @layerIds
      slideIds:     @slideIds
      slideHeight:  @slideHeight
      spritePath:   @spritePath
      totalSlides:  @totalSlides
      wrapperWidth: @wrapperWidth
    )

    @visibleSlide['backgrounds'] = $('#backgrounds .slide').first()
    @visibleSlide['mg-elements'] = $('#mg-elements .slide').first()
    @visibleSlide['bg-elements'] = $('#bg-elements .slide').first()
    @visibleSlide['fg-elements'] = $('#fg-elements .slide').first()


  # Not currently in use
  showClouds: () ->
    @clouds = $("<div id=\"clouds\" />")
    for i in [1...3] by 1
      # the line below is for using pure css, check the #cloud1 etc. id's in animate.css
      $cloud = $('<div  id="cloud'+i+'" class="cloud"><img src="' + @imgPath + '/cloud'+i+'.svg" type="image/svg+xml" width="100%" height="100%" /></div>')

      # this works better for fluid layout though, as it's adaptive to the window size
      cloud    = $("<div  class=\"cloud\"><img src=\"" + @imgPath + "/bg-elements3-cloud" + i + ".svg\" type=\"image/svg+xml\" width=\"100%\" height=\"100%\" /></div>")
      timeScale = ($(window).width() / 1200) # 1200 is arbitrary.. makes animation speed relative to width
      speed     = timeScale * (i * 33 + 44) # offset the speed of each cloud
      $cloud.css "animation", "cloudFloat " + speed + "s infinite" # set the animation name speed and loops - jquery automagically adds browser prefixes
      @clouds.append cloud # inject into the DOM

    # Old way
    @visibleSlide['backgrounds'].append(@clouds)

    animating cloud
    @clouds = $("<div id=\"clouds\" />")
    @clouds.append "<div class=\"cloud\"><img src=\"#{@imgPath}/bg-elements3-cloud1.svg\" type=\"image/svg+xml\" width=\"100%\" height=\"100%\" /></div>"
    @clouds.append "<div class=\"cloud\"><img src=\"#{@imgPath}/bg-elements3-cloud2.svg\" type=\"image/svg+xml\" width=\"100%\" height=\"100%\" /></div>"
    @clouds.append "<div class=\"cloud\"><img src=\"#{@imgPath}/bg-elements3-cloud3.svg\" type=\"image/svg+xml\" width=\"100%\" height=\"100%\" /></div>"
    @visibleSlide['backgrounds'].append(@clouds)

    leopard = $("<div class=\"leopard\" />")
    $("#fg-elements").find(".slide").first().append leopard

    leopard.css
      top: "13%"
      backgroundSize: @wrapper.height() * .4

    @animateClouds()

  # Not currently in use
  animateClouds: () =>
    $.each @clouds.find(".cloud"), (k ,v) =>
      $(v).fadeIn()

      @movementClass = HappyPlace.Movement.animateIt($(v), options =
        startX:   -@wrapperWidth
        endX:     @wrapperWidth
        easing:   'linear'
        minSpeed: 50000
        maxSpeed: 100000
        repeat:   'infinite'
      )

  #### Create the Coke Bottle
  #
  # This method creates the coke bottle and
  # sizes it correctly to fit the window dimensions
  #
  setupCokeBottle: () ->
    scale  = @getScaleValue(@slideHeight)
    bottle = $("<div id=\"bottle\" />")
    bottle.append "<object data=\"#{@imgPath}/CokeBottle.svg\" type=\"image/svg+xml\" width=\"100%\" height=\"100%\" \>"
    bottle.show()
    # bottle.css
    #   top: "20%"

    # bottle.find('img').css
    #   height: @wrapper.height() / 2

    @app.append bottle
    # $("#bottle").css("transform", "scale("+scale+", "+scale+")")

  #### Get Scale Value
  #
  # This getter method calculates the current scale value of the window.
  # Used to scale the sprite sheets containers for each layer.
  #
  # @param [Integer] height
  #
  # - The height of the sprite sheets container (default is 712)
  #
  getScaleValue: (height) ->
    scale = $(window).height() / height
    scale

  #### Create the infinite swipe effect
  #
  # This method controls the "wrapping" of the slides
  # so that no matter what direction the user drags or swipes
  # something will always appear
  #
  # @param [Object] el
  #
  # - The element to wrap (ie: a single slide or multiple slides across various layers)
  # - $('.slide') for all slides in all layers
  #
  wrapIt: (el, callback) ->
    _wrapItCallback   = callback or ->
    rightMostX        = 0
    rightMostScreen   = undefined
    leftMostX         = 0
    leftMostScreen    = undefined

    $(el).each (el) ->
      slide = $(this)
      x     = slide.position().left

      if x >= rightMostX
        rightMostX      = x
        rightMostScreen = slide
      if x <= leftMostX
        leftMostX       = x
        leftMostScreen  = slide

    rightMostScreen.css "left", "-=" + @totalWidth if leftMostX >= 0
    leftMostScreen.css "left", "+=" + @totalWidth if leftMostX <= (@wrapperWidth - @totalWidth)

    _wrapItCallback()

  #### Create the "snapping" effect
  #
  # This method controls the "snapping" of slides to the visible window area
  #
  # @param [Object] el
  #
  # - The element to snap (ie: a single slide or multiple slides across various layers)
  # - $(.slide) for all slides in all layers
  #
  snapIt: (el, callback, startAt) ->
    _snapItCallback = callback or ->
    layerEl         = el
    layerId         = $(layerEl).parent().attr('id') # determine which layer is active
    layers          = $(el).length # store the number of layers
    speed           = @dragSpeed
    startAt         = parseInt(startAt) if startAt?

    $.each layerEl, (k, v) =>
      slide = $(v)
      index = @visibleSlide[layerId].index() # find the index of the visible slide on the active layer

      unless slide.data("id") is @visibleSlide[layerId].data("id") # don't test visible screen
        x         = slide.position().left
        rightEdge = x + @wrapperWidth

        # determine if the action was a swipe or not
        if @duration < 1000
          speed = @swipeSpeed
          if @distance > 0 # swipe right
            @visibleSlide[layerId] = if index == 0 then $(layerEl).eq(layers-1) else $(layerEl).eq(index - 1)
            false
          else if @distance < 0 # swipe left
            @visibleSlide[layerId] = if index == (layers-1) then $(layerEl).eq(0) else $(layerEl).eq(index + 1)
            false
        # if swipe movement wasn't detected then calculate the drag margins relative to the current slide
        else
          speed = @dragSpeed
          if (rightEdge > @wrapperWidth * .2) and (x < @wrapperWidth * .8) # if true set this screen to be the "visible" one
            @visibleSlide[layerId] = slide
            false
          else if @shake == true
            speed = @shakeSpeed
            @visibleSlide[layerId] = $(layerEl).eq(HappyPlace.Utils.getRandomNumberBetween(0, 5))
            false
          else if startAt?
            if @startIntro?
              speed = @introSpeed
            else
              speed = @swipeSpeed
            @visibleSlide[layerId] = $(layerEl).eq(startAt)
            false

    distance = @visibleSlide[layerId].position().left * -1 # calculate the new distance to snap to
    @updateSlideArray() # Make sure we are keeping track of the current slides (for sharing URL)

    # if Modernizr.csstransforms and Modernizr.csstransitions
    #   # vendor prefixes omitted here for brevity
    #   $(el).css
    #     transition: "all .2s linear"
    #     transform: "translate3d(#{distance}px, 0, 0)"
    # else
    # if an older browser, fall back to jQuery animate

    $(el).animate # wrap on complete
      left: "+=" + distance
      opacity: 1
    ,
      duration: speed
      easing: 'easeOutExpo'
      complete: =>
        @pauseHiddenLayers() unless @paused is true
        @wrapIt($(el))
        # if @visibleSlide[layerId].data('id') == 'backgrounds'
        #   @animateClouds() # start up the cloud if it's the right screen

    @wrapIt($(el))
    _snapItCallback()

  #### Pause Hidden Layers
  #
  # This method controls the pausing of all slide animations except for the active layers
  #
  pauseHiddenLayers: () ->
    if @isAnimationEnabled()
      @resumeAnimations()
      $.each @slideArray, (k, v) =>
        @pauseAnimations($("##{@layerIds[k]}").children().not("##{@layerIds[k]}-#{@slideIds[v]}"))

  #### Update Slide Array
  #
  # This method keeps track of the slide array uses for sharing
  # Stored in an array (ie: [0,0,0,0])
  #
  # Each number represents a layer (see layerIds for the order)
  #
  updateSlideArray: () ->
    tempArr = new Array()
    $.each @layerIds, (k, v) =>
      tempArr.push(@visibleSlide[v].index())
    @slideArray = tempArr

  #### Get Slide String
  #
  # This getter method returns a string value of the current slide order.
  # ex: [1-2-3-4]
  #
  # @param [Array] arr
  #
  # - Specific slide array to be passed in.
  #
  # @param [String] splitBy
  #
  # - The character used to split each array value (default is a '-' dash).
  #
  getSlideString: (arr, splitBy) ->
    arr = arr or @slideArray
    splitBy = splitBy or ''
    str     = ''
    $.each arr, (k, v) =>
      if k == arr.length-1 then str += "#{v}" else str += "#{v}#{splitBy}"
    str

  #### Get Thumbnail Value
  #
  # This method returns the correct thumbnail number value
  # based on the current visible slides.
  #
  getThumbVal: (arr) ->
    numArray = new Array()
    arr = arr or @slideArray or []
    $.each arr, (k, v) ->
      if k == 0 then numArray.push(parseInt(v) * 1331)
      if k == 1 then numArray.push(parseInt(v) * 121)
      if k == 2 then numArray.push(parseInt(v) * 11)
      if k == 3 then numArray.push(parseInt(v) + 1)
    imageNum = numArray.reduce (t, s) -> t + s

    if imageNum.toString().length < 1 then imageNum = "00000#{imageNum}"
    if imageNum.toString().length < 2 then imageNum = "0000#{imageNum}"
    if imageNum.toString().length < 3 then imageNum = "000#{imageNum}"
    if imageNum.toString().length < 4 then imageNum = "00#{imageNum}"
    if imageNum.toString().length < 5 then imageNum = "0#{imageNum}"
    log "image number: #{imageNum}"
    imageNum

  #### Resize End
  #
  # This method is fired if the window is resized or
  # the device orientation changes
  #
  resizeEnd: ->
    @visibleSlide['backgrounds'] = $('#backgrounds .slide').first()
    @visibleSlide['mg-elements'] = $('#mg-elements .slide').first()
    @visibleSlide['bg-elements'] = $('#bg-elements .slide').first()
    @visibleSlide['fg-elements'] = $('#fg-elements .slide').first()

    @loadSlideArray @slideArray, =>
      setTimeout(=>
        HappyPlace.Utils.removeOverlay()
      , 500)

  #### Reset Wrap
  #
  # This method resets the automatic wrapping
  # in order to do "infinite scrolling"
  #
  # @param [Function] callback
  #
  # - The callback method (optional)
  #
  resetWrap: (callback) ->
    _resetWrapCallback = callback or ->
    $.each @layerIds, (k, v) =>
      $.each $("##{v}").find(".slide"), (k, v) =>
        $(v).css left: @wrapperWidth * k
    _resetWrapCallback()

  #### Adjust App Size
  #
  # This method controls the dynamic sizing of
  # the app and the various SVG assets
  #
  adjustAppSize: (mode) ->
    log "---Adjusting App Dimensions---"

    @wrapperWidth  = $(window).width()
    @wrapperHeight = $(window).height()

    if isMobile.iOS()
      if mode is 'landscape'
        @wrapper.css
          width: @wrapperWidth
          height: @wrapperHeight
          marginTop: 0
      else
        @wrapper.css
          width: @wrapperWidth
          height: @wrapperHeight + 60

    @totalWidth = @wrapperWidth * @totalSlides

    log "App Width: #{@wrapperWidth}"
    log "App Height: #{@wrapperHeight}"
    log "Layers: #{$(".layer").length}"
    log "Slides: #{$(".slide").length}"

  #### Show Flash Dialog
  #
  # This method loads an array of slides and snaps each layer into place.
  #
  # @param [Array] arr
  #
  # - The slide array to load
  # - ex: default is [0,0,0,0]
  #
  # @param [Function] callback
  #
  # - The callback method (optional)
  #
  showFlashDialog: (message, delay, callback) ->
    _showFlashCallback = callback or ->
    @flashDialog       = $("<div id=\"flashDialog\" />")
    @flashDialog.text(message)
    @wrapper.append @flashDialog

    $(@flashDialog).css marginLeft: -($(@flashDialog).width()/2)
    $(@flashDialog).delay(500).fadeIn "normal", ->
      $(this).delay(delay).fadeOut(->
        $(this).remove()
        _showFlashCallback()
      )

  #### Load Slide Array
  #
  # This method loads an array of slides and snaps each layer into place.
  #
  # @param [Array] arr
  #
  # - The slide array to load
  # - ex: default is [0,0,0,0]
  #
  # @param [Function] callback
  #
  # - The callback method (optional)
  #
  loadSlideArray: (arr, callback) ->
    _loadSlideCallback = callback or ->
    log "---Active Slides---"
    $.each arr, (k, v) =>
      @snapIt($("##{@layerIds[k]}").find('.slide'), =>
        log "layer: #{k} = " + @slideIds[v]
        _loadSlideCallback()
      , v)

  #### Assign Intro Points
  #
  # This method assigns the correct slide order to display when the "sliding"
  # intro is started. Each layer should stop on the number passed in.
  #
  # @param [Array] arr
  #
  # - The slide array to load
  # - ex: if default is [0,0,0,0] then the start order would be [1,1,1,1]
  #
  assignIntroPoints: (arr) ->
    newArr = new Array()
    $.each arr, (k, v) =>
      val = parseInt(v)
      if val > 0
        newArr.push(val+1)
      else if val < 0
        newArr.push(@totalSlides-1)
      else
        newArr.push(1)
    return newArr

  #### Handle Mobile
  #
  # This method handles the experience on mobile devices
  # Currently it does not allow for landscape mode and displays
  # a message to the user to rotate their device.
  #
  handleMobile: () ->
    # show message on handheld in landscape mode
    @landScapeMessage = $("<div id=\"landscape-message\"></div>")
    @wrapper.append @landScapeMessage

    @showHideLandscapeMessage()
    $(window).on "orientationchange", => @showHideLandscapeMessage()

  #### Show Hide Landscape Message
  #
  # This method handles the device orientation and whether or not to show or hide the landscape message.
  #
  showHideLandscapeMessage: () ->
    log "---Checking Device Orientation---"

    if $(window).width() > $(window).height()
      ahh.embed.showPageNav(false)
      @landScapeMessage.show()
      @adjustAppSize('landscape')
      @pauseAnimations()
      @audioClass.pauseAudio() if @audioClass?.audioReady is true
      HappyPlace.Utils.hideURLBar('landscape') # scroll to hide url bar in iOS
    else
      ahh.embed.showPageNav(true)
      @landScapeMessage.hide()
      @adjustAppSize('portrait')
      @resumeAnimations()
      @audioClass.resumeAudio() if @audioClass?.audioReady is true
      HappyPlace.Utils.hideURLBar('portrait') # scroll to hide url bar in iOS

  #### Detect iPhone Version
  #
  # This method uses window.devicePixelRatio to determine the current iPhone version.
  # - if less than 1 = iPhone 4
  # - if greater than or equal to 2 = iPhone 5
  #
  detectIphoneVersion: () ->
    if isMobile.iOS() && iOSDevice != 'iPad' # make sure this is an iOS device and not an iPad
      if window.devicePixelRatio <= 1
        iphoneVersion = 4
      else if window.devicePixelRatio >= 2
        iphoneVersion = 5
      return iphoneVersion

  #### Handle Resize
  #
  # This method handles when the window is resized. A 'resizeEnd' event is fired when complete.
  #
  handleResize: () ->
    $(window).on "resize", =>
      @adjustAppSize()
      @resetWrap()
      HappyPlace.Utils.attachOverlay("Resizing...") unless isMobile.any() isnt null # only show the resizing overlay if mobile isn't detected

      clearTimeout @resizeTo if @resizeTo
      @resizeTo = setTimeout(->
        $(this).trigger "resizeEnd"
      , 500)

    $(window).on "resizeEnd", =>
      @resizeEnd()

  #### Add Event Listeners
  #
  # This method ensures the App is listening for
  # mouse and touch events
  #
  # - resize
  # - touchstart (mobile only)
  # - touchmove (mobile only)
  # - touchend (mobile only)
  # - shake (mobile only)
  # - mousedown
  # - mousemove
  # - mouseup
  # - mouseout
  #
  addEventListeners: () ->
    log "---Listening For Events---"

    @handleResize() # handle window resizing events

    # bind event listeners to mouse and touch events
    @app.on "touchstart", (e) =>
      e.originalEvent.preventDefault()
      ahh.util.track('Happy Place', 'Happy Place', 'Begin') # Google Analytics Tracking
      $(".slide").stop() # stop if we're down
      @shake      = false
      @cursorDown = true
      touch       = e.originalEvent.touches[0] || e.originalEvent.changedTouches[0] # required for touch events to work on Android
      @cursorX    = touch.pageX
      @startX     = @cursorX
      @startTime  = HappyPlace.Utils.getTime()
      targetClass = $(e.target).attr('class')
      targetIndex = $(e.target).index()

      el = $("##{targetClass}").find('.slide') # Get the current slide being interacted with

      @hotSpots.find("li").animate
        opacity: 1
      ,
        duration: 10

      @hotSpots.find("li:eq(#{targetIndex})").css
        backgroundImage: "url(#{@arrowIcon})"
        backgroundPosition: @cursorX - (@swipeIconWidth / 2)
        backgroundColor: "rgba(255,255,255,0.25)"
        backgroundRepeat: 'no-repeat'
        backgroundSize: '193px 86px'
        borderTop: '2px dotted rgba(255,255,255, 0.5)'
        borderBottom: '2px dotted rgba(255,255,255, 0.5)'

      @wrapIt(el) # avoid clipping bugs by wrapping on touch start

    @app.on "mousedown", (e) =>
      ahh.util.track('Happy Place', 'Happy Place', 'Begin') # Google Analytics Tracking
      $(".slide").stop() # stop if we're down
      @shake      = false
      @cursorDown = true
      @cursorX    = e.pageX
      @startX     = @cursorX
      @startTime  = HappyPlace.Utils.getTime()
      targetClass = $(e.target).attr('class')
      targetIndex = $(e.target).index()

      el = $("##{targetClass}").find('.slide')  # Get the current slide being interacted with

      @hotSpots.find("li").animate
        opacity: 1
      ,
        duration: 10

      @hotSpots.find("li:eq(#{targetIndex})").css
        backgroundImage: "url(#{@arrowIcon})"
        backgroundPosition: @cursorX - (@swipeIconWidth / 2)
        backgroundColor: "rgba(255,255,255,0.25)"
        backgroundRepeat: 'no-repeat'
        backgroundSize: '193px 86px'
        borderTop: '2px dotted rgba(255,255,255, 0.5)'
        borderBottom: '2px dotted rgba(255,255,255, 0.5)'

      @wrapIt(el) # avoid clipping bugs by wrapping on mouse start

    @app.on "touchmove", (e) =>
      e.originalEvent.preventDefault()
      ahh.util.track('Happy Place', 'Happy Place', 'Swipe')
      @shake = false
      if @cursorDown
        @pcursorX         = @cursorX
        touch             = e.originalEvent.touches[0] || e.originalEvent.changedTouches[0] # required for touch events to work on Android
        @cursorX          = touch.pageX
        @cursorXVelocity  = @cursorX - @pcursorX
        targetClass       = $(e.target).attr('class')
        targetIndex       = $(e.target).index()

        el = $("##{targetClass}").find('.slide')  # Get the current slide being interacted with
        el.css
          left: "+="+ @cursorXVelocity

        @hotSpots.find("li").animate
          opacity: 1
        ,
          duration: 10

        @hotSpots.find("li:eq(#{targetIndex})").css
          backgroundImage: "url(#{@arrowIcon})"
          backgroundPosition: @cursorX - (@swipeIconWidth / 2)
          backgroundColor: "rgba(255,255,255,0.25)"
          backgroundRepeat: 'no-repeat'
          backgroundSize: '193px 86px'
          borderTop: '2px dotted rgba(255,255,255, 0.5)'
          borderBottom: '2px dotted rgba(255,255,255, 0.5)'

    @app.on "mousemove", (e) =>
      ahh.util.track('Happy Place', 'Happy Place', 'Swipe')
      @shake = false
      if @cursorDown
        @pcursorX         = @cursorX
        @cursorX          = e.pageX
        @cursorXVelocity  = @cursorX - @pcursorX
        targetClass       = $(e.target).attr('class')
        targetIndex       = $(e.target).index()

        el = $("##{targetClass}").find('.slide')  # Get the current slide being interacted with
        el.css
          left: "+="+ @cursorXVelocity

        @hotSpots.find("li").animate
          opacity: 1
        ,
          duration: 10

        @hotSpots.find("li:eq(#{targetIndex})").css
          backgroundImage: "url(#{@arrowIcon})"
          backgroundPosition: @cursorX - (@swipeIconWidth / 2)
          backgroundColor: "rgba(255,255,255,0.25)"
          backgroundRepeat: 'no-repeat'
          borderTop: '2px dotted rgba(255,255,255, 0.5)'
          borderBottom: '2px dotted rgba(255,255,255, 0.5)'

    @app.on "touchend", (e) =>
      e.originalEvent.preventDefault()
      @cursorDown = false
      touch       = e.originalEvent.touches[0] || e.originalEvent.changedTouches[0] # required for touch events to work on Android
      @endX       = touch.pageX
      @endTime    = HappyPlace.Utils.getTime()
      @duration   = @endTime - @startTime # detect if event type is mouseout and make sure it's not handled as a "swipe"
      @distance   = @endX - @startX
      targetClass = $(e.target).attr('class')
      targetIndex = $(e.target).index()

      el = $("##{targetClass}").find('.slide')  # Get the current slide being interacted with
      @snapIt(el)

      @hotSpots.find("li").animate
        opacity: 0
      ,
        duration: 100
        easing: 'linear'
        complete: =>
          @hotSpots.find("li:eq(#{targetIndex})").css
            backgroundImage: "none"
            backgroundColor: "transparent"
            borderTop: 'none'
            borderBottom: 'none'

    @app.on "mouseup mouseout", (e) =>
      @cursorDown = false
      @endX       = e.pageX
      @endTime    = HappyPlace.Utils.getTime()
      @duration   = if e.type != 'mouseout' then @endTime - @startTime else 1001 # detect if event type is mouseout and make sure it's not handled as a "swipe"
      @distance   = @endX - @startX
      targetClass = $(e.target).attr('class')
      targetIndex = $(e.target).index()

      el = $("##{targetClass}").find('.slide')  # Get the current slide being interacted with
      @snapIt(el)

      @hotSpots.find("li").animate
        opacity: 0
      ,
        duration: 100
        easing: 'linear'
        complete: =>
          @hotSpots.find("li:eq(#{targetIndex})").css
            backgroundImage: "none"
            backgroundColor: "transparent"
            borderTop: 'none'
            borderBottom: 'none'

    # it is also possible to detect specific shake events "shakefrontback shakeleftright shakeupdown"
    $(window).on "shake", (e) =>
      @shake = true
      shakeArr = new Array()
      $.each @layerIds, (k, v) =>
        shakeArr.push(HappyPlace.Utils.getRandomNumberBetween(0,@totalSlides))
      @loadSlideArray shakeArr

window.HappyPlace = HappyPlace or {}
