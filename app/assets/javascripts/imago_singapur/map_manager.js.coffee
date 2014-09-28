class ImagoSingapur.MapManager
  constructor: (accessToken, id) ->
    L.mapbox.accessToken = accessToken
    @_layers = {
      # TODO: redo the layers exporting with zoom from 12 to 18
      1993: 'rpbaltazar.singapore-1993'
      2000: 'rpbaltazar.singapore-2000'
    }

    @currentLayerYear = 0
    @elId = id
    @currentMarkerLayer
    @constellationLine = []
    @constellation

    @_constellationConfig = {
      opacity: 1,
      color: "#fff",
      weight: 2,
    }

  loadMap: ->
    self = @
    @map = L.mapbox.map(@elId, 'rpbaltazar.jj789eo9').setView(['1.3500', '103.810'], 12)

  toggleConstellation: ->
    if !@map.hasLayer @constellation
      @constellation.addTo(@map)
    else
      @map.removeLayer @constellation


  createLayers: (eventList) ->
    self = @

    mLayer = L.mapbox.featureLayer()
    mLayer.addTo self.map
    @currentMarkerLayer = mLayer

    markersLayerGeoJSON =
      type: 'FeatureCollection',
      features: []

    constellationLine = []

    _.each eventList, (evt) ->
      markersLayerGeoJSON.features.push self._getMarkerFeature(evt)
      constellationLine.push L.latLng evt.lat, evt.lon

    @constellation = L.polyline constellationLine, @_constellationConfig

    mLayer.setGeoJSON markersLayerGeoJSON
    mLayer.on 'click', (e) ->
      $.get e.layer.feature.properties.url
        .success (data) ->
          self.travelInTime(data)
        .error (err) ->
          console.log 'problemo'


  _getMarkerFeature: (evt) ->
    feature = {
      type: 'Feature'
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

    feature

  # createMapMarkersLayer: (eventList) ->
  #   self = @
  #
  #   if @currentMarkerLayer?
  #     @map.removeLayer @currentMarkerLayer
  #
  #   mLayer = L.mapbox.featureLayer()
  #   mLayer.addTo(self.map)
  #   @currentMarkerLayer = mLayer
  #
  #   geojson =
  #     type: 'FeatureCollection'
  #     features: []
  #
  #   _.each eventList, (evt) ->
  #     geojson.features.push(
  #       {
  #         type: 'Feature',
  #         properties:
  #           title: evt.memory,
  #           'marker-color': 'ff00aa',
  #           'marker-size': 'small',
  #           'maker-symbol': 'star',
  #           url: "/api/testimonies/#{evt.id}"
  #         ,
  #         geometry:
  #           type: 'Point',
  #           coordinates: [
  #             evt.lon
  #             evt.lat
  #           ]
  #       }
  #     )
  #
  #   mLayer.setGeoJSON geojson
  #   mLayer.on 'click', (e) ->
  #     $.get e.layer.feature.properties.url
  #       .success (data) ->
  #         self.travelInTime(data)
  #       .error (err) ->
  #         console.log 'problemo'
  #
  travelInTime: (event) ->
    self = @
    year = moment(event.story_date).year()

    @loadYearLayer year
    @zoomAndCenter event

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

  zoomAndCenter: (event) ->
    latlng = L.latLng event.lat, event.lon
    @map.fitBounds L.latLngBounds(latlng, latlng),
      {animate: true,
      maxZoom: 18}

