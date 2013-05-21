#### Audio class
#
# @extends UI
#
# - This class extends the Portfolio.UI class
#
class Audio extends Portfolio.UI

  #### The constructor for the Sidebar class
  #
  # @param [Object] options
  # - The options object that is used by the class for configuration purposes (optional)
  #
  constructor: (@options) ->
    # return this to make this class chainable
    this


# Assign this class to the Portfolio Namespace
Portfolio.UI.Audio = new Audio()