# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
app = angular.module("swibat", ["ngResource"])
app.config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
  $locationProvider.html5Mode(true)
  #$routeProvider.when('/users/:id', {templateUrl: '/users/:id.json', controller: 'UserCtrl'})
  #$routeProvider.when('/users/:id/videos', {templateUrl: '/users/:id/videos.json', controller: 'UserCtrl'})
]
app.config ['$httpProvider', (provider) ->
  provider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
]

app.factory "User", ["$resource", ($resource) ->
  $resource("/users/:id.json", {id: '@id'}, {
    update: {method: 'PUT'},
    show: {method: 'GET'},
    videos: {method: 'GET'}
    })
]

@UserCtrl = ['$scope', '$route', '$routeParams', '$location', 'User', ($scope, $route, $routeParams, $location, User) ->
  $scope.$route = $route
  $scope.user = User.show(id: 163)
  $scope.videos = User.videos(id: 163)
  $scope.$routeParams = $routeParams
  console.log($scope.user)
  console.log($location)
  console.log($route)
  console.log($routeParams.id)
  console.log($scope.videos)
]


(($) ->
  $.fn.charCount = (options) ->

    # default configuration properties
    calculate = (obj) ->
      count = $(obj).val().length
      available = options.allowed - count
      if available <= options.warning and available >= 0
        $(obj).next().addClass options.cssWarning
      else
        $(obj).next().removeClass options.cssWarning
      if available < 0
        $(obj).next().addClass options.cssExceeded
      else
        $(obj).next().removeClass options.cssExceeded
      $(obj).next().html options.counterText + available
    defaults =
      allowed: 160
      warning: 25
      css: "counter"
      counterElement: "span"
      cssWarning: "warning"
      cssExceeded: "exceeded"
      counterText: "Characters Left: "

    options = $.extend(defaults, options)
    @each ->
      $(this).after "<" + options.counterElement + " class=\"" + options.css + "\">" + options.counterText + "</" + options.counterElement + ">"
      calculate this
      $(this).keyup ->
        calculate this

      $(this).change ->
        calculate this


) jQuery
$(document).ready ->
  $("tr[data-link]").click (e)->
    window.location = this.dataset.link



