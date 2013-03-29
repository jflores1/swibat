class Swibat.Routers.Users extends Backbone.Router
  routes: {
    "users":"index"
    "users/:id":"show"
  }

  initialize: ->
    @collection = new Swibat.Collections.Users()
    @collection.fetch()

  index: ->
    view = new Swibat.Views.UsersIndex(collection: @collection)
    $('.span9').html(view.render().el)


  show: (id) ->
    alert "This is the show route for #{id}!"