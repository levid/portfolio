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

    // console.log(projectsArr);
  },

  find: function(req, res) {
    console.log(req.params);
    Screenshots.find({screenable_id: req.params.id}).done(function(err, screenshots) {
      console.log(err);
      console.log(screenshots);
      if (err) return res.send(err, 500);
      return res.json(screenshots);
    });

    // console.log(projectsArr);
  }


};
module.exports = ScreenshotsController;
