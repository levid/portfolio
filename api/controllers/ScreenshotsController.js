/*---------------------
  :: Screenshot
  -> controller
---------------------*/
var ScreenshotsController = {

  findAll: function(req, res) {
    Screenshots.findAll(function(err, screenshots) {
      if (err) return res.send(err, 500);
      return res.json(screenshots)
    });
  },

  find: function(req, res) {
    Screenshots.find({screenable_id: req.param('id')}).done(function(err, screenshots) {
      if (err) return res.send(err, 500);
      return res.json(screenshots);
    });
  }

};
module.exports = ScreenshotsController;
