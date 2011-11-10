
Backbone = require "backbone"

views = NS "PWB.drawers.views"



class views.Navigation extends Backbone.View

  events:
    "tap .remote": "toggleRemote"
    "tap .next": "navigateToNext"
    "tap .prev": "navigateToPrev"


  constructor: (opts) ->
    super

    {@socket} = opts

    @socket.on "changeSlide", (position) =>
      @navigate parseInt position, 10


  render: ->

    if @model.get "remote"
      @$(".remote").html "Remote is on"
    else
      @$(".remote").html "Remote is off"

    if @model.get("position") <= 1
      @$(".prev").hide()
    else
      @$(".prev").show()


  toggleRemote: ->
    @model.set remote: !@model.get "remote"
    @render()

  navigateToNext: (e) ->
    e.preventDefault()
    @navigate @model.get("position") + 1
    false

  navigateToPrev: (e) ->
    e.preventDefault()
    @navigate @model.get("position") - 1
    false


  navigate: (position) ->
    return if position < 1

    url = "/#{ @model.get "roomName" }/" + position


    if not @model.get "remote"
      window.location = url
    else
      console.log "Emiting change"
      @socket.emit "changeSlide", position, ->
        window.location = url
        console.log "change"

