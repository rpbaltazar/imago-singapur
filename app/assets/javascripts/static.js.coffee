# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class MapManager
  constructor: (accessToken) ->
    L.mapbox.accessToken = accessToken
    @_layers = {
      1993: 'rpbaltazar.jj3on91a'
      2000: 'rpbaltazar.jj3p6ka2'
    }

  loadMap: (id) ->
    self = @
    @map = L.mapbox.map(id).setView(['1.3000', '103.800'], 13)

  loadYearLayer: (year) ->
    self = @
    layer = self._layers[year]
    return unless layer?
    L.mapbox.tileLayer(layer).addTo(self.map)

@ImagoSingapur = {}

ready = ->
  ImagoSingapur._mapManager = new MapManager('pk.eyJ1IjoicnBiYWx0YXphciIsImEiOiJEQlJyLVVJIn0.yaCOoWv9RzeJ8ZlkfOmoxg')
  ImagoSingapur._mapManager.loadMap('imago-singapur-map')
  ImagoSingapur._mapManager.loadYearLayer(1993)


$(document).ready(ready)
$(document).on('page:load', ready)

