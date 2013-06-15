'use strict'

Application.Controllers.controller "AboutController", ["$rootScope", "$scope", "$location", "$socket", "SessionService", "$route", "$routeParams", ($rootScope, $scope, $location, $socket, SessionService, $route, $routeParams) ->

  # AboutController class that is accessible by the window object
  #
  class AboutController

    #### It's always nice to have a constructor to keep things organized
    #
    constructor: () ->
      @initCharts()
      @initPieChart2()

      $scope.user =
        email: "i.wooten@gmail.com"

      if $rootScope.customParams
        if $rootScope.customParams.action == 'index'
          @index($scope, $rootScope.customParams)

      $.subscribe('initAfterViewContentLoaded.Portfolio', @initAfterViewContentLoadedProxy('initAfterViewContentLoaded.Portfolio'))

    initAfterViewContentLoadedProxy: () ->
      # Skip the first argument (event object) but log the other args.
      (_, options) =>
        $UI.hideLoadingScreen()
        if $UI.Constants.sidebarMenuOpen is true then Portfolio.openSidebarMenu() else Portfolio.openSidebar()

    #### The index action
    #
    # @param [Object] $scope
    #
    # - The $scope object must be passed in to the method
    #   since it is a public static method
    #
    index: ($scope, params) ->
      columnTimeout = setTimeout(=>
        $('.programming ul').columnize
          columns: 4
        clearTimeout columnTimeout
      , 700)


    initCharts: () =>
      #-------------------- Animate D3JS Charts --------------------//

      # Create responsibilities graph using D3JS charts
      # width and height, natch
      # arc radius
      # duration, in milliseconds

      # Draw Arc Paths

      # Store current and interpolate to the new angles.
      arcTween = (a) ->
        i = d3.interpolate(@current, a)
        @current = i(0)
        (t) ->
          arc i(t)

      # Update chart
      updateChart = (model) ->
        data = eval(model) # which model?
        arcs.data donut(data.pct) # recompute angles, rebind data
        arcs.transition().ease("cubic-in-out").duration(dur).attrTween "d", arcTween

      # Fire animations on section2
      animateCharts = ->

        # Create toolbox graphs using D3JS charts
        $(".toolbox-item").each (index) ->

          # Grab data length
          datalength = $(this).prev(".toolbox-header").attr("data-length")

          # Append SVG's
          chart = d3.select(this)
            .append("svg")
            .attr("width", 260)
            .attr("height", 2)
            .attr("class", "tool")
            .style("background-color", "rgba(255,255,255, 0.3)")

          # Fill SVG's
          rects = chart.selectAll("rect")
            .data([datalength])
            .enter()
            .append("rect")
            .attr("width", 0)
            .attr("stroke", "none")
            .attr("x", 0)
            .attr("y", 0)
            .attr("height", 2)

          rects.transition()
            .duration(1000)
            .ease("elastic")
            .delay(3000)
            .attr("width", datalength)

          if datalength == "300"
            rects.attr("fill", "#93ccd9")
          else
            rects.attr("fill", "#AAAAAA")

      animateCharts()


    initPieChart2: () ->
      # Store the currently-displayed angles in this._current.
      # Then, interpolate from this._current to the new angles.
      arcTween = (a) ->
        i = d3.interpolate(@current, a)
        @current = i(0)
        (t) ->
          arc i(t)

      # update chart
      updateChart = (model) ->
        data = eval(model) # which model?
        arcs.data donut(data.pct) # recompute angles, rebind data
        arcs.transition()
          .ease("cubic-in-out")
          .duration(dur)
          .attrTween "d", arcTween

        sliceLabel.data donut(data.pct)
        sliceLabel.transition()
          .ease("cubic-in-out")
          .duration(dur).attr("transform", (d) ->
            "translate(" + arc.centroid(d) + ")"
          ).style "fill-opacity", (d) ->
            (if d.value is 0 then 1e-6 else 1)

        pieLabel.text data.legend
      ui =
        legend: "UI"
        labels: ["Web", "Mobile", "Mobile Web", "Games", "Apps", "Flash"]
        pct: [30, 10, 15, 10, 25, 10]

      ux =
        legend: "UX"
        labels: ["Web", "Mobile", "Mobile Web", "Games", "Apps", "Flash"]
        pct: [50, 10, 10, 0, 25, 15]

      frontend =
        legend: "Front End"
        labels: ["Web", "Mobile", "Mobile Web", "Games", "Apps", "Flash"]
        pct: [50, 5, 20, 10, 20, 5]

      backend =
        legend: "Back End"
        labels: ["Web", "Mobile", "Mobile Web", "Games", "Apps", "Flash"]
        pct: [45, 15, 0, 0, 35, 15]

      data = ui
      $('#experience a:first-child').addClass 'active'

      # width and height
      w = 320
      h = 320
      # arc radius
      r = Math.min(w, h) / 2
      # duration, in milliseconds
      that = this
      dur = 750
      color = ["#93ccd9", "#e53517", "#FBC1B0", "#F36E46", "#067FAB", "#f6aa06"]

      donut = d3.layout.pie().sort(null)
      arc = d3.svg.arc()
        .innerRadius(r - 100)
        .outerRadius(r - 30)

      svg = d3.select("#piechart")
        .append("svg:svg")
        .attr("width", w)
        .attr("height", h)

      arc_grp = svg.append("svg:g")
        .attr("class", "arcGrp")
        .attr("transform", "translate(" + (w / 2) + "," + (h / 2) + ")")

      # Group for labels
      label_group = svg.append("svg:g")
        .attr("class", "lblGroup")
        .attr("transform", "translate(" + (w / 2) + "," + (h / 2) + ")")

      # Group for center text
      center_group = svg.append("svg:g")
        .attr("class", "ctrGroup")
        .attr("transform", "translate(" + (w / 2) + "," + (h / 2) + ")")

      # Center label
      pieLabel = center_group.append("svg:text")
        .attr("dy", "10px")
        .attr("class", "chartLabel")
        .attr("text-anchor", "middle")
        .text(data.legend)
        .attr("font-size", "15px")
        .attr("fill", "white")

      # Draw slice labels
      sliceLabel = label_group.selectAll("text")
        .data(donut(data.pct))
        .enter()
        .append("svg:text")
        .attr("class", "arcLabel")
        .attr("class", (d, i) ->
          "arc#{i}"
        )
        .attr("transform", (d) ->
          "translate(" + arc.centroid(d) + ")"
        ).attr("text-anchor", "middle").text (d, i) ->
          data.labels[i]
        .attr("font-family", "sans-serif")
        .attr("font-size", "12px")
        .attr("fill", "white")


      # Draw arc paths
      arcs = arc_grp.selectAll("path")
        .data(donut(data.pct))
        .enter()
        .append("svg:path")
        .attr("fill", (d, i) ->
          color[i]
        )
        .attr("d", arc).each((d) ->
          @current = d
        )
        # .on("mouseover", (d, i) ->
        #   d3.select(this)
        #     .transition()
        #     .ease("cubic-in-out")
        #     .duration(500)
        #     .attr("opacity", "0.5")
        # )
        # .on("mouseout", (d, i) ->
        #   d3.select(this)
        #     .transition()
        #     .ease("cubic-in-out")
        #     .duration(500)
        #     .attr("opacity", "1")
        # )

      # click handler
      $(document).on 'click', "#experience a", (e) ->
        e.preventDefault()
        $(this).parent().find('a.active').removeClass 'active'
        $(this).addClass 'active'
        updateChart @href.slice(@href.indexOf("#") + 1)


    initPieChart: () ->
      data = [
        institution: [5245, 2479, 1697, 2037, 4245]
      ,
        institution: [3245, 88479, 45697, 1037, 77245]
      ]

      titles = [
        title: ['test1', 'test2', 'test3', 'test4', 'test5']
      ,
        title: ['test11', 'test22', 'test33', 'test44', 'test55']
      ]

      width = 250
      height = 250
      radius = Math.min(width, height) / 3
      r = radius
      textOffset = 10
      colours = ["#93ccd9", "#e53517", "#FBC1B0", "#F36E46", "#067FAB"]
      index = 0
      while index < data.length
        pie = d3.layout.pie().sort(null)
        arc = d3.svg.arc()
          .innerRadius(radius - 30)
          .outerRadius(radius - 5)

        svg = d3.select("#piechart")
          .append("svg:svg")
          .attr("width", width)
          .attr("height", height)
          .attr("class", "pie")
          .append("g")
          .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")")

        # Pie data
        piedata = pie(data[index].institution)

        # Tick marks
        ticks = svg.selectAll("line")
          .data(piedata)
          .enter()
          .append("line")

        ticks.attr("x1", 0)
          .attr("x2", 0)
          .attr("y1", -radius + 4)
          .attr("y2", -radius - 2)
          .attr("stroke", "gray")
          .attr "transform", (d) ->
            "rotate(" + (d.startAngle + d.endAngle) / 2 * (180 / Math.PI) + ")"

        # Text labels
        labels = svg.selectAll("text")
          .data(piedata)
          .enter()
          .append("text")
          .attr("font-family", "sans-serif")
          .attr("font-size", "11px")
          .attr("fill", "white")

        labels.attr("class", "value")
          .attr("transform", (d) ->
            dist    = radius + 15
            angle   = (d.startAngle + d.endAngle) / 2
            x       = dist * Math.sin(angle)
            y       = -dist * Math.cos(angle)
            "translate(" + x + "," + y + ")"
          ).attr("dy", "0.35em")
            .attr("text-anchor", "middle")
            .text (d, i) ->
              # d.value
              titles[index].title[i]

        center_group = svg.append("svg:svg")
          .attr("class", "ctrGroup")
          .attr("transform", "translate(" + (width / 2) + "," + (height / 2) + ")");

        pieLabel = center_group.append("svg:text")
          .attr("dy", "0.35em")
          .attr("class", "chartLabel")
          .attr("text-anchor", "middle")
          .text('Design')
          .attr("font-family", "sans-serif")
          .attr("font-size", "11px")
          .attr("fill", "white")

        # Donuts
        path = svg.selectAll("path")
          .data(piedata)
          .enter()
          .append("path")
          .attr("fill", (d, i) ->
            colours[i]
          ).attr("d", arc)

        ++index

  window.AboutController = new AboutController()

]
