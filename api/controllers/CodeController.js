/*---------------------
	:: Code
	-> controller
---------------------*/
var CodeController = {
  getFileContents: function(req, res) {
    // fs = require('fs')
    // fs.readFile(req.param('id').toString(), 'utf8', function (err, data) {
    //   if (err) {
    //     console.log(err)
    //     return res.send(err, 500);
    //   }
    //   return res.send(data)
    // });
    var request = require('request');
    request.get(req.param('id').toString(), function (err, response, body) {
      if (err) {
        console.log(err);
        return res.send(err, 500);
      }
      else {
        if (!err && response.statusCode == 200) {
          return res.json({
            body: body
          });
        }
      }
    });
  }
};
module.exports = CodeController;