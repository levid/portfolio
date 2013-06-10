/*---------------------
	:: Projects
	-> controller
---------------------*/
var ProjectsController = {

  findAll: function(req, res) {
    limit = req.body.limit || 0;
    skip = req.body.skip || 0;
    var category = req.param('id');
    if(category != undefined){
      // Projects.findAll({
      //   category_string: {
      //     contains: category
      //   }
      // }).done(function(err, projects) {
      //   if (err) return res.send(err, 500);
      //   console.log(projects);
      //   return res.json(projects);
      // });

      Projects.findAll({
        // name: {
        //   contains: 'serv'
        // },
        limit: limit,
        skip: skip
      }).done(function(err, projects) {
        if (err) return res.send(err, 500);
        console.log(projects);
        if (!projects) return res.send("No projects found!", 404);
        return res.json(projects);
      });
    }
    else {
      Projects.findAll().done(function(err, projects) {
        if (err) return res.send(err, 500);
        if (!projects) return res.send("No projects found!", 404);
        return res.json(projects);
      });
    }

    // Projects.find()
    // .where({ category_string: {contains: category}})
    // .limit(100)
    // .exec(function(err, projects) {
    //   if (err) return res.send(err, 500);
    //   if (!projects) return res.send("No projects were found!", 404);
    //   return res.json(projects);
    // });
  },

  find: function(req, res) {
    Projects.find({slug: req.param('id')}).done(function(err, project) {
      if (err) return res.send(err, 500);
      if (!project) return res.send("No project with that id exists!", 404);
      return res.json(project);
    });

    // Projects.findOne()
    // .where({ slug: req.param('id')})
    // .limit(100)
    // .exec(function(err, project) {
    //   if (err) return res.send(err, 500);
    //   if (!project) return res.send("No project with that id exists!", 404);
    //   return res.json(project);
    // });
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