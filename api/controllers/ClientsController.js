/*---------------------
  :: Clients
  -> controller
---------------------*/
var ClientsController = {
  findAll: function(req, res) {
    Clients.findAll().done(function(err, clients) {
      if (err) return res.send(err, 500);
      return res.json(clients)
    });
  },

  find: function(req, res) {
    Clients.find({id: req.params.id}).done(function(err, clients) {
      if (err) return res.send(err, 500);
      return res.json(clients);
    });
  }
};
module.exports = ClientsController;