# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  L.mapbox.accessToken = 'pk.eyJ1IjoicnBiYWx0YXphciIsImEiOiJEQlJyLVVJIn0.yaCOoWv9RzeJ8ZlkfOmoxg'
  L.mapbox.map('imago-singapur-map', 'rpbaltazar.jj01go9b')

$(document).ready(ready)
$(document).on('page:load', ready)

