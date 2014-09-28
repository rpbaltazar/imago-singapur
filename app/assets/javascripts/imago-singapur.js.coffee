#this refers to Window
@App =
  Collections: {}


@ImagoSingapur = {}

$(document).ready ->
  App.router = new ImagoSingapur.Router()
  Backbone.history.start()
