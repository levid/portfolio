/*---------------------
	:: Project
	-> controller
---------------------*/
var ProjectsController = {

  findAll: function(req, res) {
    Projects.findAll(function(err, projects) {
      if (err) return res.send(err, 500);
      return res.json(projects)
    });

    // console.log(projectsArr);
  },

  find: function(req, res) {
    Projects.find({slug: req.params.id},function(err, projects) {
      if (err) return res.send(err, 500);
      return res.json(projects);
    });

    // console.log(projectsArr);
  }

  // // // New Method
  // // new: function(req, res) {
  // //   res.view();
  // // },

  // // Create Method
  // create: function(req, res) {
  //   console.log(req.isJson);
  //   Projects.create(req.body, function(err, project) {
  //     if (err) return res.send(err, 500);

  //     return res.json(project);
  //   });
  // },

  // // Show Method
  // show: function(req, res) {
  //   Projects.findById(req.param('id'), function(err, project) {
  //     if (err) return res.send(err, 500);

  //     return res.json(project);
  //   });
  // },

  // // Edit Method
  // edit: function(req, res) {
  //   Projects.findById(req.param('id'), function(err, project) {
  //     if (err) return res.send(err, 500);

  //     return res.json(project);
  //   });
  // },

  // // Update Method
  // update: function(req, res) {
  //   Projects.update(req.param('id'), req.body, function(err, project) {
  //     if (err) return res.send(err, 500);

  //     return res.json(project);
  //   });
  // },

  // // Destroy Method
  // destroy: function(req, res) {
  //   Projects.destroy(req.param('id'), function(err) {
  //     if (err) return res.send(err, 500);

  //     return res.json('success');
  //   });
  // }

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