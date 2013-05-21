#### The UI class serving as the base class for the Application
#
# This class can be accessed via ** window.Portfolio.UI **
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
class UI extends Portfolio
  constructor: (@options) ->
    this # allows for method chaining

    window.$UI = this

  # This method is initialized by the parent class and should contain anything that needs to run on every page
  initGlobalUI: (options) ->
    # Methods to enable functionality upon initialization
    # @bindEvents()
    # @bindSharing()
    # @enableTooltips()
    # @enableChosen()
    # @enableModals()
    # @enableCategories()
    # @enableButtons()
    # $SC.UI.initSpinner = @initSpinner
    # $SC.UI.showResultsSpinner = @showResultsSpinner
    # $SC.UI.resultsModalOptions = @resultsModalOption
    # $SC.UI.displayResultsModal = @displayResultsModal
    # @animateColoredBars()


# Assign this class to the $SC Namespace
window.Portfolio.UI = new UI()