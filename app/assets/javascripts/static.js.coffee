# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  return unless $('#imago-singapur-map').length > 0
  ImagoSingapur._mapManager = new ImagoSingapur.MapManager('pk.eyJ1IjoicnBiYWx0YXphciIsImEiOiJEQlJyLVVJIn0.yaCOoWv9RzeJ8ZlkfOmoxg', 'imago-singapur-map')

$.get "people/#{ImagoSingapur._userId}/testimonies", ( data ) ->
  ImagoSingapur._mapManager.createMapMarkers data

$(document).ready(ready)
$(document).on('page:load', ready)

