/*---------------------
	:: Theme
	-> controller
---------------------*/
var ThemesController = {
  findAll: function(req, res) {
    Themes.findAll({
      is_active: "true",
      sort: "name ASC"
    }).done(function(err, themes) {
      if (err) return res.send(err, 500);
      return res.json(themes)
    });
  },

  find: function(req, res) {
    Themes.find({id: req.params.id}).done(function(err, themes) {
      if (err) return res.send(err, 500);
      return res.json(themes);
    });
  }
};
module.exports = ThemesController;