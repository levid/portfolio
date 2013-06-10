"use strict"
Application.Services.service("projectsService", ["ngResource"]).factory "Projects", ($resource) ->

  # We need to add an update method
  $resource "/projects/:dest/:slug/:category", {},
    find:
      method: "GET"
      params:
        dest: "find"
        slug: "@slug"

    findAll:
      method: "GET"
      params:
        dest: "findAll"
        category: "@category"
        limit: "@limit"
        skip: "@skip"
      isArray: true

    get:
      method: "GET"
      params:
        dest: "find"
        slug: "@slug"

    query:
      method: "GET"
      params:
        dest: ":id"
        slug: "@slug"
      isArray: true

    save:
      method: "POST"
      params:
        dest: ":id"
        slug: "@slug"

    remove:
      method: "DELETE"
      params:
        dest: ":id"
        slug: "@slug"

    delete:
      method: "DELETE"
      params:
        dest: ":id"
        slug: "@slug"



# update: { method: 'POST', params: {dest: ":id", slug: "@slug"}},
# index: { method: 'GET', params: {dest: "index"}, isArray: true },
# new: { method: 'GET', params: {dest: ":id", slug: "@slug"}},
# create: { method: 'POST', params: {dest: ":id", slug: "@slug"}},
# show: { method: 'GET', params: {dest: ":id, slug: "@slug"}},
# edit: { method: 'GET', params: {dest: ":id", slug: "@slug"}},
# update: { method: 'PUT', params: {dest: ":id", slug: "@slug"}},
# destroy: { method: 'DELETE', params: {dest: ":id", slug: "@slug"}}