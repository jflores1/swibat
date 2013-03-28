window.Swibat =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  initialize: ->
    new Swibat.Routers.Users()
    if !Backbone.history.started
      Backbone.history.start({
        pushState: true,
        hashChange: false
      })
      Backbone.history.started = true

$(document).ready ->
  Swibat.initialize()
