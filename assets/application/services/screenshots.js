'use strict'

Application.Services.service("screenshotsService", ["ngResource"]).factory("Screenshots", function ($resource) {
  // We need to add an update method
  return $resource("/screenshots/:dest/:id", {}, {
      find: { method: 'GET', params: {dest: "find", id: "@id"}},
      findAll: { method: 'GET', params: {dest: "findAll"}, isArray: true },
      get: { method: 'GET', params: {dest: "find", id: "@id"}},
      query: {method: 'GET', params: {dest: ":id", id: "@id"}, isArray: true },
      save: {method: 'POST', params: {dest: ":id", id: "@id"}},
      remove: { method: 'DELETE', params: {dest: ":id", id: "@id"}},
      delete: { method: 'DELETE', params: {dest: ":id", id: "@id"}}
      // update: { method: 'POST', params: {dest: "update", id: "@id"}},
      // index: { method: 'GET', params: {dest: "index"}, isArray: true },
      // new: { method: 'GET', params: {dest: "new", id: "@id"}},
      // create: { method: 'POST', params: {dest: "create", id: "@id"}},
      // show: { method: 'GET', params: {dest: "show", id: "@id"}},
      // edit: { method: 'GET', params: {dest: "edit", id: "@id"}},
      // update: { method: 'PUT', params: {dest: "update", id: "@id"}},
      // destroy: { method: 'DELETE', params: {dest: "destroy", id: "@id"}}
    }
  );
});