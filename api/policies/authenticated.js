/**
* Allow any authenticated user.
*/
module.exports = function (req, res, ok) {

  // User is allowed, proceed to controller

  console.log(req.param('action'));
  var action = req.param('action');

  res.header('Cache-control', 'public');
  // res.header('Content-Encoding', 'gzip');

  if (action == "index" || action == "find" || action == "findAll" || action == "send" || action == "getTotal" || action == "getFileContents") {
    return ok();
  }
  else {
    // if (req.isAuthenticated()) {
    if (req.session.authenticated) {
      return ok();
    }
    // User is not allowed
    // res.redirect('/login');
    return res.send("You are not permitted to perform this action.",403);
  }
};