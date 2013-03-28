class Swibat.Routers.Institutions extends Backbone.Router
  routes:
    'institutions/:id': 'show'

  show: (id) ->
    alert "Institution #{id}"