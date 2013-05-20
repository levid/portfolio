/*---------------------
  :: Template
  -> controller
---------------------*/
module.exports = {
  index: function (req,res) {
    var listOfAssetSourcePaths = sails.config.assets.sequence;

    var htmlString = "";
    async.each(listOfAssetSourcePaths, function (path,cb) {
      require('fs').readFile(path,function (err, contents) {
        if (err) return cb(err);
        htmlString += contents;
      });
    }, function (err) {
      if (err) return res.send(err,500);

      res.contentType('text/html');
      res.send(htmlString);
    });
  },

  find: function(req,res) {
    var tpl = req.param('id');
    console.log('looking for template' + tpl);
    require('fs').readFile('assets/templates/views/remote/'+tpl,function (err, contents) {
      if (err){
        console.log(err);
        res.contentType('text/html');
        res.send('');
      }
      else {
        res.contentType('text/html');
        res.send(contents);
      }
    });
  }
};

var port = process.env.PORT || 1336;
var io = require('socket.io').listen(port);

io.configure(function () {
  io.set("transports", ["xhr-polling"]);
  io.set("polling duration", 10);
  io.set("maxListeners", 0);
});

io.sockets.on('connection', function (socket) {
  var numberOfSockets = Object.keys(io.connected).length;
  socket.emit('connectedUsers', { count: numberOfSockets });
  socket.broadcast.emit('connectedUsers', { count: numberOfSockets });

  socket.emit('news', { hello: 'world' });
  socket.emit('init', { data: 'what' });
  socket.on('my other event', function (data) {
    console.log("serverEventData: " + data);
  });

  socket.on('deleteUser', function(user){
    console.log("onUserDeleted broadcasted");
    socket.broadcast.emit('onUserDeleted', user);
  });

  socket.on('addUser', function(user){
    console.log("onUserAdded broadcasted");
    socket.broadcast.emit('onUserAdded', user);
  });

  socket.on('updateUser', function(user){
    console.log("onUserUpdated broadcasted");
    socket.broadcast.emit('onUserUpdated', user);
  });

  socket.on('disconnect', function () {
    socket.emit('connectedUsers', { count: numberOfSockets-1 });
    socket.broadcast.emit('connectedUsers', { count: numberOfSockets-1 });
  });

  socket.removeListener("connect", function(){});
  socket.removeListener("deleteUser", function(){});
  socket.removeListener("addUser", function(){});
});
