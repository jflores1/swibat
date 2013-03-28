class Swibat.Views.UsersIndex extends Backbone.View

  template: JST['users/index']

  render: ->
    $(@el).html(@template(teachers: @collection))
    this
