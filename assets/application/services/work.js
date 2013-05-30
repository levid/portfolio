'use strict'

Application.Services.service("workService", ["ngResource"]).factory("Work", function ($resource) {
  // We need to add an update method
  return $resource(
     "/work/:id", {id: "@id" }, {
        update: {method: 'PUT'}
      }
  );


  // return $resource(
  //    "/user/:id", { id: "@id" }, {
  //       index: { method: 'GET', isArray: true },
  //       new: { method: 'GET' },
  //       create: { method: 'POST' },
  //       show: { method: 'GET' },
  //       edit: { method: 'GET' },
  //       update: { method: 'PUT' },
  //       destroy: { method: 'DELETE' }
  //     }
  // );

});