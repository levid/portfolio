#### Theme class
#
# @extends UI
#
# - This class extends the Portfolio.UI class
#
class Theme extends Portfolio.UI

  #### The constructor for the Theme class
  #
  # @param [Object] options
  # - The options object that is used by the class for configuration purposes (optional)
  #
  constructor: (@options) ->
    # return this to make this class chainable
    this


# Assign this class to the Portfolio Namespace
Portfolio.UI.Theme = new Theme()