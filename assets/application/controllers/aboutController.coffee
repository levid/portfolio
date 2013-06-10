'use strict'

Application.Controllers.controller "AboutController", ["$rootScope", "$scope", "$location", "$socket", "SessionService", "$route", "$routeParams", ($rootScope, $scope, $location, $socket, SessionService, $route, $routeParams) ->

  # AboutController class that is accessible by the window object
  #
  class AboutController

    #### It's always nice to have a constructor to keep things organized
    #
    constructor: () ->
      @initCharts()
      @initPieChart()

      $scope.user =
        email: "i.wooten@gmail.com"

    initCharts: () =>
      #-------------------- Animate D3JS Charts --------------------//

      # Create responsibilities graph using D3JS charts
      # width and height, natch
      # arc radius
      # duration, in milliseconds

      # Draw Arc Paths

      # Store current and interpolate to the new angles.
      arcTween = (a) ->
        i = d3.interpolate(@_current, a)
        @_current = i(0)
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
            .attr("stroke", "none")
            .attr("fill", "#93ccd9")
            .attr("x", 0)
            .attr("y", 0)
            .attr("height", 2)
            .transition()
            .duration(1000)
            .ease("elastic")
            .delay(100 * index)
            .attr("width", datalength)

      animateCharts()

    initPieChart2: () ->
      # width and height, natch
      # arc radius
      # duration, in milliseconds

      # ---------------------------------------------------------------------

      # GROUP FOR CENTER TEXT

      # CENTER LABEL

      # DRAW ARC PATHS

      # DRAW SLICE LABELS

      # --------- "PAY NO ATTENTION TO THE MAN BEHIND THE CURTAIN" ---------

      # Store the currently-displayed angles in this._current.
      # Then, interpolate from this._current to the new angles.
      arcTween = (a) ->
        i = d3.interpolate(@_current, a)
        @_current = i(0)
        (t) ->
          arc i(t)

      # update chart
      updateChart = (model) ->
        data = eval_(model) # which model?
        arcs.data donut(data.pct) # recompute angles, rebind data
        arcs.transition().ease("elastic").duration(dur).attrTween "d", arcTween
        sliceLabel.data donut(data.pct)
        sliceLabel.transition().ease("elastic").duration(dur).attr("transform", (d) ->
          "translate(" + arc.centroid(d) + ")"
        ).style "fill-opacity", (d) ->
          (if d.value is 0 then 1e-6 else 1)

        pieLabel.text data.label
      agg =
        label: "Design"
        pct: [30, 10, 6, 30, 14, 10]

      bal =
        label: "Development"
        pct: [24, 7, 2, 18, 13, 36]

      mod =
        label: "Moderate"
        pct: [12, 4, 2, 10, 11, 61]

      inc =
        label: "Income"
        pct: [0, 0, 0, 0, 0, 100]

      data = agg
      labels = ["LCAP", "MCAP", "SCAP", "Intl", "Alt", "Fixed"]
      w = 320
      h = 320
      r = Math.min(w, h) / 2
      dur = 750
      color = ["#edc900", "#93ccd9", "#e53517", "#FBC1B0", "#F36E46", "#067FAB"]
      donut = d3.layout.pie().sort(null)
      arc = d3.svg.arc().innerRadius(r - 70).outerRadius(r - 20)
      svg = d3.select("#piechart")
        .append("svg:svg")
        .attr("width", w)
        .attr("height", h)

      arc_grp = svg.append("svg:g")
        .attr("class", "arcGrp")
        .attr("transform", "translate(" + (w / 2) + "," + (h / 2) + ")")

      label_group = svg.append("svg:g")
        .attr("class", "lblGroup")
        .attr("transform", "translate(" + (w / 2) + "," + (h / 2) + ")")

      center_group = svg.append("svg:g")
        .attr("class", "ctrGroup")
        .attr("transform", "translate(" + (w / 2) + "," + (h / 2) + ")")

      pieLabel = center_group.append("svg:text")
        .attr("dy", "10px")
        .attr("class", "chartLabel")
        .attr("text-anchor", "middle")
        .text(data.label)
        .attr("fill", "#ffffff")

      arcs = arc_grp.selectAll("path")
        .data(donut(data.pct))
        .enter()
        .append("svg:path")
        .attr("fill", (d, i) ->
          color[i]
        ).attr("d", arc).each (d) ->
          @_current = d

      sliceLabel = label_group.selectAll("text")
        .data(donut(data.pct))
        .enter()
        .append("svg:text")
        .attr("class", "arcLabel")
        .attr("transform", (d) ->
          "translate(" + arc.centroid(d) + ")"
        ).attr("text-anchor", "middle").text (d, i) ->
          labels[i]
        .attr("fill", "#ffffff")

      # click handler
      $("#objectives a").click ->
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
