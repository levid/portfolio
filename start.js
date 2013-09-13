require('coffee-script');
var cluster = require('cluster'),
    env = process.env,
    i;

cluster.on('exit', function(worker) {
  if (env.NODE_ENV == 'production') {
    cluster.fork();
  }
});

if (cluster.isMaster) {
  for (i = 0; i < 4; i++) {
    cluster.fork();
  }
} else {
  require('./app.js');
}