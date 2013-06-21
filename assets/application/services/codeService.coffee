"use strict"
Application.Services.service("codeService", ["ngResource"]).factory "Code", ["$resource", ($resource) ->
  $resource "/code/:dest/:path", {},
    getFileContents:
      method: "GET"
      params:
        dest: "getFileContents"
        path: "@path"

]