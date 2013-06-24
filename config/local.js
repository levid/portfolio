// Local configuration
//
// Included in the .gitignore by default,
// this is where you include configuration overrides for your local system
// or for a production deployment.
//
// For example, to use port 80 on the local machine, override the `port` config

module.exports.port = process.env.PORT || 1337;
process.env.GMAIL_USER = "i.wooten@gmail.com";
process.env.GMAIL_PASSWORD = "xshgnosnvazhjypm";
process.env.DEFAULT_EMAIL = "i.wooten@gmail.com";
process.env.APPROVED_API_KEY = "$rdc#isaacw";

module.exports.environment = 'production';
// module.exports.adapters.default = 'mongo';