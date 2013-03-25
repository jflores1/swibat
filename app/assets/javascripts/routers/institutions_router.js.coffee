class Swibat.Routers.Institutions extends Backbone.Router
  routes:
    'institutions/:id': 'show'
    'institutions/:id/faculty': 'faculty'

  show: (id) ->
    alert "Institution #{id}"

  faculty: (id) ->
    alert "Faculty for School #{id}!"