'use strict'

Application.Controllers.controller "ProjectsController", ["$rootScope", "$scope", "$location", "$socket", "configuration", "User", "Projects", "Images", "Screenshots", "Technologies", "flickrPhotos", "Categories", "Tags", "SessionService", "$route", "$routeParams", ($rootScope, $scope, $location, $socket, configuration, User, Projects, Images, Screenshots, Technologies, flickrPhotos, Categories, Tags, SessionService, $route, $routeParams) ->

  # ProjectsController class that is accessible by the window object
  #
  # @todo add a notifications handler
  # @todo add a proper error handler
  #
  class ProjectsController
    opts:
      projectInfoOverlay: undefined
      inView:             undefined
      previousView:       undefined

    #### It's always nice to have a constructor to keep things organized
    #
    constructor: () ->
      @initScopedMethods()

      @projectInfoOverlay = $('.project-info-overlay')

      if $rootScope.customParams
        if $rootScope.customParams.action == 'index'
          @index($scope, $rootScope.customParams)
        else if $rootScope.customParams.action == 'show'
          @show($scope, $rootScope.customParams)

      $scope.s3_path = configuration.s3_path
      $scope.category = $rootScope.customParams.category

      # $.subscribe('resize.Portfolio', @initAfterViewContentLoadedProxy('resize.Portfolio'))

      $.subscribe('initAfterViewContentLoaded.Portfolio', @initAfterViewContentLoadedProxy('initAfterViewContentLoaded.Portfolio'))

      # return this to make this class chainable
      this

    initAfterViewContentLoadedProxy: () ->
      # Skip the first argument (event object) but log the other args.
      (_, options) =>
        screenshotTimeout = setTimeout(=>
          $('.thumbnails-show-view').waitForImages (=>
            @setWaypoints('.block', '#main')
            $UI.hideSpinner $('.info-container').find('.spinner')

            if $UI.Constants.sidebarMenuOpen is true
              Portfolio.openSidebarMenu()
            else
              Portfolio.openSidebar()

            # setWidth = (options) =>
            #   $('.thumbnails-show-view').css
            #     width: ($(window).width()) - 70
            #     left: -40

            # $(window).resize =>
            #   setWidth(options)
            # setWidth(options)

            console.log "All screenshots have loaded."

          ),((loaded, count, success) ->
            console.log loaded + " of " + count + " images has " + ((if success then "loaded" else "failed to load")) + "."
            $(this).addClass "loaded"
          ), true
          clearTimeout screenshotTimeout
        , 1000)

    setWaypoints: (element, context) ->
      self = this
      $(element).waypoint
        context: context
        # offset: 50
        handler: (direction) ->
          self.projectInfoOverlay.fadeOut()

          description       = $(this).find('.description').text()
          self.previousView = self.inView
          self.inView       = description

          # unless self.previousView is self.inView
          if direction is 'down'
            if description.length > 0
              self.projectInfoOverlay.fadeIn()
              projectOverlay = self.projectInfoOverlay.find('p')
              projectOverlay.text description

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
      $UI.Constants.category   = $rootScope.customParams.category

      $scope.limit = $routeParams.limit or 0
      $scope.skip = $routeParams.skip or 0

      @loadProducts($scope.limit, $scope.skip, params.category)

      # @loadImages = setTimeout(=>
      #   $("#wrapper").waitForImages (=>
      #     console.log "All design images have loaded."

      #   ),((loaded, count, success) ->
      #     console.log loaded + " of " + count + " images has " + ((if success then "loaded" else "failed to load")) + "."
      #   ), waitForAll: true
      #   clearTimeout @loadImages
      # , 500)

      # $scope.photos = flickrPhotos.load({ tags: '1680x1050' })

    loadProducts: (limit, skip, category) ->
      projectsArr = [{}]
      preview_images = []
      projects = Projects.findAll(
        category: category
        limit: limit
        skip: skip
      , (project) ->
        $.each project, (k, v) =>
          tags = []
          categories = []
          images = []
          technologies = []
          $.each v.image_ids, (key, val) =>
            if val isnt ''
              Images.find({id: val}, (image) ->
                v.preview_image =
                  id: image.id
                  path: image.preview_image
                images.push(image)
              )
              v.image_paths = images
          $.each v.tag_ids, (key, val) =>
            if val isnt ''
              Tags.find({id: val}, (tag) ->
                tags.push(tag.name)
              )
              v.tags = tags
          $.each v.category_ids, (key, val) =>
            if val isnt ''
              Categories.find({id: val}, (category) ->
                categories.push(category.name)
              )
              v.categories = categories
          $.each v.technology_ids, (key, val) ->
            if val isnt ''
              Technologies.find({id: val}, (technology) ->
                technologies.push(technology.name)
              )
              v.technologies = technologies
        $.extend(projectsArr, project, projectsArr)

      , (error) ->
        console.log error
      )

      $scope.preview_images = preview_images
      $scope.projects = projectsArr
      $scope.predicate = 'name'

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

      $UI.hideLoadingScreen()

      $UI.Constants.actionPath = $rootScope.customParams.action



      if $routeParams.slug
        projectsArr = [{}]
        projects = Projects.find(
          slug: $routeParams.slug
        , (project) ->
          tags = []
          categories = []
          images = []
          technologies = []

          screenshotsArr = []
          Screenshots.findAll((screenshots) ->
            screenshotsArr = screenshots
          )

          $.each project.image_ids, (k, v) =>
            if v isnt ''
              Images.find({id: v}, (image) ->
                $.each screenshotsArr, (key, val) =>
                  if val.screenable_id is v
                    images.push(val)
                images.push(image)
              )
              project.image_paths = images

          $.each project.tag_ids, (key, val) =>
            if val isnt ''
              Tags.find({id: val}, (tag) ->
                tags.push(tag.name)
              )
              project.tags = tags
          $.each project.category_ids, (key, val) =>
            if val isnt ''
              Categories.find({id: val}, (category) ->
                categories.push(category.name)
              )
              project.categories = categories
          $.each project.technology_ids, (key, val) ->
            if val isnt ''
              Technologies.find({id: val}, (technology) ->
                technologies.push(technology.name)
              )
              project.technologies = technologies

          $.extend(projectsArr, project, projectsArr)

          columnTimeout = setTimeout(=>
            $('.project-info li').each ->
              title = $(this).attr('rel')
              # $(this).attr('data-content', "#{title}")
            $('.project-info').columnize
              columns: 2

            # $('.thumbnails-show-view').waypoint
            #   context: '#main'
            #   offset: 30
            #   handler: (direction) ->
            #     $('.info-container').toggleClass 'sticky'

            clearTimeout columnTimeout
          , 700)

          $UI.showSpinner $('.info-container').find('.spinner'),
            lines: 12
            length: 0
            width: 3
            radius: 10
            color: '#ffffff'
            speed: 1.6
            trail: 45
            shadow: false
            hwaccel: false

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

      $scope.getCategoryString = (categories) ->
        categories = categories.join(' ')
        categories = categories.toLowerCase()
        return categories

      $scope.getTagString = (tags) ->
        tags = tags.join(' ')
        tags = tags.toLowerCase()
        return tags

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

      $scope.getPreviewImagePath = (project) ->
        image_id = project.preview_image?.id
        image_path = project.preview_image?.path
        if image_id
          image = "#{$scope.s3_path}/image/portfolio_image/#{image_id}/#{image_path}"
          return image
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

      $scope.nextPage = (limit, skip) ->
        $scope.limit = limit + 3
        $scope.skip = skip + 1
        console.log limit
        console.log skip

      $scope.addProject = ->
        user = new Project
          name: $scope.inputData.name if $scope.inputData.name.length

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

  window.ProjectsController = new ProjectsController()

]