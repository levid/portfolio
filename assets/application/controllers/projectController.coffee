'use strict'

Application.Controllers.controller "ProjectController", ["$rootScope", "$scope", "$location", "$socket", "configuration", "User", "Projects", "Images", "Screenshots", "flickrPhotos", "Categories", "Tags", "SessionService", "$route", "$routeParams", ($rootScope, $scope, $location, $socket, configuration, User, Projects, Images, Screenshots, flickrPhotos, Categories, Tags, SessionService, $route, $routeParams) ->

  # ProjectController class that is accessible by the window object
  #
  # @todo add a notifications handler
  # @todo add a proper error handler
  #
  class ProjectController

    #### It's always nice to have a constructor to keep things organized
    #
    constructor: () ->
      @initScopedMethods()

      if $rootScope.customParams
        if $rootScope.customParams.action == 'index'
          @index($scope, $rootScope.customParams)
        else if $rootScope.customParams.action == 'show'
          @show($scope, $rootScope.customParams)

      $scope.s3_path = configuration.s3_path

      # $.subscribe('resize.Portfolio', @initAfterViewContentLoadedProxy('resize.Portfolio'))

      # return this to make this class chainable
      this

    initAfterViewContentLoadedProxy: () ->
      # Skip the first argument (event object) but log the other args.
      (_, options) =>
        setWidth = (options) =>
          $('.thumbnails-show-view').css width: ($(window).width() - options.widthDifference) - options.rightMargin
        $(window).resize =>
          setWidth(options)
        setWidth(options)



    #### The index action
    #
    # @param [Object] $scope
    #
    # - The $scope object must be passed in to the method
    #   since it is a public static method
    #
    index: ($scope, params) ->
      console.log "#{$rootScope.customParams.action} action called"
      $UI.Constants.actionPath = $rootScope.customParams.action
      category = params.category

      projectsArr = [{}]
      projects = Projects.findAll(
        category: category
      , (project) ->
        $.each project, (k, v) =>
          tags = []
          categories = []
          images = []
          $.each v.image_ids, (k1, v1) =>
            if v1 isnt ''
              Images.find({id: v1}, (image) ->
                # delete image.id
                # delete image.project_id
                # delete image.work_id
                # delete image.name
                # delete image.format
                 images.push(image)
              )
              v.image_paths = images
          $.each v.tag_ids, (k2, v2) =>
            if v2 isnt ''
              Tags.find({id: v2}, (tag) ->
                delete tag.id
                delete tag.project_id
                delete tag.work_id
                delete tag.slug
                tags.push(tag.name)
              )
              v.tags = tags
          $.each v.category_ids, (k3, v3) =>
            if v3 isnt ''
              Categories.find({id: v3}, (category) ->
                delete category.id
                delete category.category_group_id
                delete category.project_id
                delete category.work_id
                delete category.slug
                categories.push(category.name)
              )
              v.categories = categories
        $.extend(projectsArr, project, projectsArr)
      , (error) ->
        console.log error
      )

      $scope.projects = projectsArr
      # $scope.photos = flickrPhotos.load({ tags: '1680x1050' })
      console.log $scope.projects

    #### The new action
    #
    # @param [Object] $scope
    #
    # - The $scope object must be passed in to the method
    #   since it is a public static method
    #
    new: ($scope) ->
      console.log "#{$rootScope.customParams.action} action called"
      # $scope.user = Project.get(
      #   action: "new"
      # , (resource) ->
      #   console.log resource
      # , (response) ->
      #   console.log response
      # )


    #### The edit action
    #
    # @param [Object] $scope
    #
    # - The $scope object must be passed in to the method
    #   since it is a public static method
    #
    edit: ($scope) ->
      console.log "#{$rootScope.customParams.action} action called"
      if $routeParams.id
        $scope.project = Project.get(
          id: $routeParams.id
          action: "edit"
        , (success) ->
          console.log success
        , (error) ->
          console.log error
        )

    #### The show action
    #
    # @param [Object] $scope
    #
    # - The $scope object must be passed in to the method
    #   since it is a public static method
    #
    show: ($scope, params) ->
      console.log "#{$rootScope.customParams.action} action called"

      $UI.Constants.actionPath = $rootScope.customParams.action

      console.log $routeParams
      if $routeParams.slug
        projectsArr = [{}]
        projects = Projects.find(
          slug: $routeParams.slug
        , (project) ->
          images = []
          screenshotsArr = []
          Screenshots.findAll((screenshots) ->
            screenshotsArr = screenshots
          )

          $.each project.image_ids, (k, v) =>
            if v isnt ''
              Images.find({id: v}, (image) ->
                $.each screenshotsArr, (k2,v2) =>
                  if v2.screenable_id is v
                    images.push(v2)
                images.push(image)
              )
              project.image_paths = images

          $.extend(projectsArr, project, projectsArr)

          console.log projectsArr
        , (error) ->
          console.log error
        )
        $scope.project = projectsArr

    #### Get current scope
    #
    # This method acts as a public static method to grab the
    # current $scope outside of this class.
    # (ex: socket.coffee)
    #
    getScope: () ->
      return $scope

    #### Scoped methods
    #
    # These are helper methods accessible to the angular user views
    #
    initScopedMethods: () ->
      $scope.reverse = (array) ->
        copy = [].concat(array)
        return copy.reverse()

      $scope.go = (path) ->
        $location.path(path)

      $scope.showMessage = ->
        $scope.message && $scope.message.length

      $scope.getProject = (project) ->
        project = Project.get project
        project

      $scope.setOrder = (orderby) ->
        if orderby is $scope.orderby
          $scope.reverse = !$scope.reverse
        $scope.orderby = orderby

      $scope.sortBy = (arr) ->
        arr.category

      $scope.goBack = () ->
        $location.path(history.back())

      $scope.getImages = (data) ->
        images = []
        if data and data isnt undefined
          images.push(data)
          $scope.images = images
        false

      $scope.getLargeImages = (data) ->
        images = []
        if data
          images = $.parseJSON(data)
          return images.large
        false

      $scope.getTags = (data) ->
        tags = []
        if data
          tags = $.parseJSON(data)
          return tags
        false

      $scope.notSorted = (obj) ->
        if !obj
          return []
        return Object.keys(obj)

      $scope.addProject = ->
        user = new Project
          name:     $scope.inputData.name     if $scope.inputData.name.length

        Project.save(project,
          success = (data, status, headers, config) ->
            $scope.message  = "New project added!"
            $scope.status   = 200
            $socket.emit "addProject", data # Broadcast to connected subscribers that a project has been added
            $location.path('/projects') # Redirect to projects index
          , error = (data, status, headers, config) ->
            $scope.message  = data.errors
            $scope.status   = status
        )

      $scope.updateProject = (project) ->
        project = {
          id:       $scope.project.id
          name:     $scope.project.name
          # add additional fields from model
        }

        Project.update($scope.project,
          success = (data, status, headers, config) ->
            $scope.message  = "Project updated!"
            $scope.status   = 200
            $socket.emit "updateProject", data # Broadcast to connected subscribers that a project has been updated
            $location.path('/projects') # Redirect to projects index
            $rootScope.project = data

          , error = (data, status, headers, config) ->
            $scope.message  = data.errors
            $scope.status   = status
        )

      $scope.deleteProject = (project) ->
        r = confirm("Are you sure?");
        if r is true
          Project.delete(
            id: project.id
          , (success) ->
            console.log success
            $scope.projects = _.difference($scope.projects, project)
            $socket.emit "deleteProject", project # Broadcast to connected subscribers that a project has been deleted
          , (error) ->
            console.log error
          )
        false

  window.ProjectController = new ProjectController()

]