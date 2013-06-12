/*---------------------
	:: Contact
	-> controller
---------------------*/

var ContactController = {
  send: function(req, res, next) {

    var nodemailer  = require("nodemailer");
    var requestBody = req.body.body;

    // create reusable transport method (opens pool of SMTP connections)
    var smtpTransport = nodemailer.createTransport("SMTP",{
      service: "Gmail",
      auth: {
        user: process.env.GMAIL_USER,
        pass: process.env.GMAIL_PASSWORD
      }
    });

    var app = sails.express.app;
    app.set("view options", {layout: false});

    res.render('email.ejs', requestBody, function(err, html) {

      var email       = requestBody.email;
      var name        = requestBody.name;
      var phone       = requestBody.phone;
      var website     = requestBody.website;
      var message     = requestBody.newMessage;
      var subject     = requestBody.subject;

      // setup e-mail data with unicode symbols
      var mailOptions = {
        from: email, // sender address
        to: process.env.DEFAULT_EMAIL, // list of receivers
        subject: subject, // Subject line
        text: message, // plaintext body
        html: html // html body
      }

      // send mail with defined transport object
      smtpTransport.sendMail(mailOptions, function(err, response){

        app.set("view options", {layout: true});

        if (err) {
          return res.send(err, 500);
        }
        return res.json({
          success: true,
          message: 'Thank you. Your email was successfully sent!',
          response: response
        });

        // if you don't want to use this transport object anymore, uncomment following line
        //smtpTransport.close(); // shut down the connection pool, no more messages
      });

    });
  }

};
module.exports = ContactController;


