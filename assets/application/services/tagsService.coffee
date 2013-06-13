"use strict"
Application.Services.service("tagsService", ["ngResource"]).factory "Tags", ["$resource", ($resource) ->

  # We need to add an update method
  $resource "/tags/:dest/:id", {},
    find:
      method: "GET"
      params:
        dest: "find"
        id: "@id"

    findAll:
      method: "GET"
      params:
        dest: "findAll"
      isArray: true

    get:
      method: "GET"
      params:
        dest: "find"
        id: "@id"

    query:
      method: "GET"
      params:
        dest: ":id"
        id: "@id"
      isArray: true

    save:
      method: "POST"
      params:
        dest: ":id"
        id: "@id"

    remove:
      method: "DELETE"
      params:
        dest: ":id"
        id: "@id"

    delete:
      method: "DELETE"
      params:
        dest: ":id"
        id: "@id"

]

# update: { method: 'POST', params: {dest: ":id", id: "@id"}},
# index: { method: 'GET', params: {dest: "index"}, isArray: true },
# new: { method: 'GET', params: {dest: ":id", id: "@id"}},
# create: { method: 'POST', params: {dest: ":id", id: "@id"}},
# show: { method: 'GET', params: {dest: ":id, id: "@id"}},
# edit: { method: 'GET', params: {dest: ":id", id: "@id"}},
# update: { method: 'PUT', params: {dest: ":id", id: "@id"}},
# destroy: { method: 'DELETE', params: {dest: ":id", id: "@id"}}