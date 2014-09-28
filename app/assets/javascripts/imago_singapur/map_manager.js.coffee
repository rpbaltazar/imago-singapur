class ImagoSingapur.MapManager
  constructor: (accessToken, id) ->
    L.mapbox.accessToken = accessToken
    @_layers = {
      # TODO: redo the layers exporting with zoom from 12 to 18
      # current: L.mapbox.tileLayer 'rpbaltazar.jj789eo9'
      1993: L.mapbox.tileLayer 'rpbaltazar.singapore-1993'
      2000: L.mapbox.tileLayer 'rpbaltazar.singapore-2000'
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

    @blackOverlay

  loadMap: ->
    self = @
    @map = L.mapbox.map(@elId, 'rpbaltazar.jj789eo9').setView(['1.3500', '103.810'], 12)

    # @_layers["current"].addTo @map
    # L.control.layers(@_layers).addTo @map
    @showBlackLayer false

  toggleConstellation: ->
    if !@map.hasLayer @constellation
      @showBlackLayer true
      @constellation.addTo(@map)
    else
      @showBlackLayer false
      @map.removeLayer @constellation

  showBlackLayer: (visible) ->
    @map.featureLayer.setFilter (fl) ->
      visible or fl.geometry.type != 'Polygon'

  addEventToLayers: (event) ->
    geoJson = @currentMarkerLayer.getGeoJSON()
    geoJson.features.push @_getMarkerFeature(event)
    @currentMarkerLayer.setGeoJSON geoJson

    @rebuildLine geoJson.features

  rebuildLine: (features) ->
    constellationLine= []
    console.log features

    sorted = _.sortBy features, (f) ->
      moment f.properties?.date?

    console.log sorted

    _.each sorted, (f) ->
      constellationLine.push (L.latLng f.geometry.coordinates[1], f.geometry.coordinates[0])

    @constellation = L.polyline constellationLine, @_constellationConfig

  createLayers: (eventList) ->
    self = @

    sortedEventList = _.sortBy eventList, (evt) ->
      moment evt.story_date

    mLayer = L.mapbox.featureLayer()
    mLayer.addTo self.map
    @currentMarkerLayer = mLayer

    markersLayerGeoJSON =
      type: 'FeatureCollection',
      features: []

    constellationLine = []

    _.each sortedEventList, (evt) ->
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
        date: "#{evt.story_date}"
      ,
      geometry:
        type: 'Point',
        coordinates: [
          evt.lon
          evt.lat
        ]
    }

    feature

  travelInTime: (event) ->
    self = @
    year = moment(event.story_date).year()

    @loadYearLayer year
    @zoomAndCenter event

  loadYearLayer: (year) ->
    self = @
    return if self.currentLayerYear == year
    layer = self._layers[year]
    return unless layerId?
    currentLayer = self._layers[self.currentLayerYear]
    if self.map.hasLayer currentLayer
      self.map.removeLayer currentLayer

    layer.addTo self.map
    self.currentLayerYear = year

  zoomAndCenter: (event) ->
    latlng = L.latLng event.lat, event.lon
    @map.fitBounds L.latLngBounds(latlng, latlng),
      {animate: true,
      maxZoom: 18}
