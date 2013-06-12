/**
* Allow any authenticated user.
*/
module.exports = function (req,res,next) {

  // User is allowed, proceed to controller

  // FIX THIS
  if (req.session.authenticated) {
  // if (req.isAuthenticated()) {
    // return ok();
    next();
  }

  // User is not allowed
  else {
    res.redirect('/login');
    // return res.send("You are not permitted to perform this action.",403);
  }
};