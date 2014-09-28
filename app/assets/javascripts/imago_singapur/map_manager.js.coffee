class ImagoSingapur.MapManager
  constructor: (accessToken, id) ->
    L.mapbox.accessToken = accessToken
    @_layers = {
      #NOTE: indexmap layers, max zoom 13
      1993: 'rpbaltazar.singapore-1993'
      2000: 'rpbaltazar.singapore-2000'
    }

    @currentLayerYear = 0
    @elId = id
    @currentMarkerLayer

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

  createMapMarkersLayer: (eventList) ->
    self = @

    if @currentMarkerLayer?
      @map.removeLayer @currentMarkerLayer

    mLayer = L.mapbox.featureLayer()
    mLayer.addTo(self.map)
    @currentMarkerLayer = mLayer

    geojson =
      type: 'FeatureCollection'
      features: []

    _.each eventList, (evt) ->
      geojson.features.push(
        {
          type: 'Feature',
          properties:
            title: evt.memory,
            'marker-color': 'ff00aa',
            'marker-size': 'small',
            'maker-symbol': 'star',
            url: "/api/testimonies/#{evt.id}"
          ,
          geometry:
            type: 'Point',
            coordinates: [
              evt.lon
              evt.lat
            ]
        }
      )

    mLayer.setGeoJSON geojson
    mLayer.on 'click', (e) ->
      $(self).trigger 'imago:click', e

  travelInTime: (event) ->
    self = @
    year = moment(event.story_date).year()

    @loadYearLayer year
    @zoomAndCenter event

  zoomAndCenter: (event) ->
    latlng = L.latLng event.lat, event.lon
    @map.fitBounds L.latLngBounds(latlng, latlng),
      {animate: true,
      maxZoom: 17}

