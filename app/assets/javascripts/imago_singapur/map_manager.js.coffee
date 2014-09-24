@ImagoSingapur ||= {}

class MapManager
  constructor: (accessToken, id) ->
    L.mapbox.accessToken = accessToken
    @_layers = {
      1993: 'rpbaltazar.singapore-1993'
      2000: 'rpbaltazar.singapore-2000'
    }

    @currentLayerYear = 0
    @elId = id
    @currentMarkers = []

    @loadMap()

  loadMap: ->
    self = @
    @map = L.mapbox.map(@elId, 'rpbaltazar.jj789eo9').setView(['1.3500', '103.810'], 11)

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

  #eventList should follow the format
  #eventList = [
  #  {
  #    date: ...,
  #    location:
  #     {
  #       latitude:
  #       longitude:
  #     },
  #    memory: ...,
  #    tags: ...,
  #    visibility: own/acquitance/others,
  #    image_url: ...,
  #  }
  #]
  createMapMarkers: (eventList) ->
    self = @
    _.each eventList, (evt) ->
      tempMarker =
        L.marker(
          new L.LatLng(evt.location.latitude, evt.location.longitude)
          {
            icon: L.mapbox.marker.icon({'marker-color': 'ff00aa'})
          }
        )
        .bindPopup evt.memory

      self.currentMarkers.push tempMarker
      tempMarker.addTo(self.map)



@ImagoSingapur.MapManager = MapManager
