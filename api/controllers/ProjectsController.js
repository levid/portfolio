/*---------------------
	:: Projects
	-> controller
---------------------*/
var ProjectsController = {

  findAll: function(req, res) {
    var limit     = req.body.limit || 0;
    var skip      = req.body.skip || 0;
    var category  = req.param('id');

    if(category != undefined && category != 'all'){
      var categoryRegex = new RegExp(category,"g");

      Projects.findAll({
        category_string: categoryRegex, // Had to do this because 'contains:' doesn't seem to work
        limit: limit,
        skip: skip
      }).done(function(err, projects) {
        if (err) return res.send(err, 500);
        if (!projects) return res.send("No projects found!", 404);
        return res.json(projects);
      });
    }
    else {
      Projects.findAll({
        limit: limit,
        skip: skip
      }).done(function(err, projects) {
        if (err) return res.send(err, 500);
        if (!projects) return res.send("No projects found!", 404);
        return res.json(projects);
      });
    }
  },

  find: function(req, res) {
    Projects.find({slug: req.param('id')}).done(function(err, project) {
      if (err) return res.send(err, 500);
      if (!project) return res.send("No project with that id exists!", 404);
      return res.json(project);
    });
  },

  getTotal: function(req, res) {
    var category  = req.param('id');

    var categoryRegex = new RegExp(category,"g");

    Projects.findAll({
      category_string: categoryRegex // Had to do this because 'contains:' doesn't seem to work
    }).done(function(err, projects) {
      if (err) return res.send(err, 500);
      return res.json({
        totalProjects: projects.length
      });
    });
  }
};
module.exports = ProjectsController;

// // Create Method
// create: function(req, res) {
//   console.log(req.isJson);
//   Project.create(req.body, function(err, project) {
//     if (err) return res.send(err, 500);

//     console.log("Project created!", project);
//     res.redirect('/projects');
//   });
// },

// // Show Method
// show: function(req, res) {
//   Project.findById(req.param('id'), function(err, project) {
//     if (err) return res.send(err, 500);

//     res.view({
//       model: project
//     });
//   });
// },

// // Edit Method
// edit: function(req, res) {
//   Project.findById(req.param('id'), function(err, project) {
//     if (err) return res.send(err, 500);

//     res.view({
//       model: project
//     });
//   });
// },

// // Update Method
// update: function(req, res) {
//   Project.update(req.param('id'), req.body, function(err, project) {
//     if (err) return res.send(err, 500);

//     console.log("Project updated!", project);
//     res.redirect('/projects');
//   });
// },

// // Destroy Method
// destroy: function(req, res) {
//   Project.destroy(req.param('id'), function(err) {
//     if (err) return res.send(err, 500);

//     console.log("Project successfully removed.");
//     res.redirect('/projects');
//   });
// }