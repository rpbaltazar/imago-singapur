# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class MapManager
  constructor: (accessToken, id) ->
    L.mapbox.accessToken = accessToken
    @_layers = {
      1993: 'rpbaltazar.singapore-1993'
      2000: 'rpbaltazar.singapore-2000'
    }

    @currentLayerYear = 0
    @elId = id

    @loadMap()

  loadMap: ->
    self = @
    @map = L.mapbox.map(@elId, 'rpbaltazar.jj789eo9').setView(['1.3000', '103.860'], 11)

  loadYearLayer: (year) ->
    self = @
    return if self.currentLayerYear == year
    layerId = self._layers[year]
    return unless layerId?
    currentLayer = L.mapbox.tileLayer self._layers[self.currentLayerYear]
    if self.map.hasLayer currentLayer
      self.map.removeLayer currentLayer

    L.mapbox.tileLayer(layerId).addTo(self.map)
    self.currentLayerYear = year

@ImagoSingapur = {}

ready = ->
  ImagoSingapur._mapManager = new MapManager('pk.eyJ1IjoicnBiYWx0YXphciIsImEiOiJEQlJyLVVJIn0.yaCOoWv9RzeJ8ZlkfOmoxg', 'imago-singapur-map')


$(document).ready(ready)
$(document).on('page:load', ready)

