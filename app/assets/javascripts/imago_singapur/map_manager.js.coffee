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
      opacity: 0.7,
      color: "#fff",
      weight: 2,
    }

  loadMap: ->
    self = @
    @map = L.mapbox.map(@elId, 'rpbaltazar.jj789eo9').setView(['1.3500', '103.810'], 12)

    @showBlackLayer false

  toggleConstellation: ->
    if !@map.hasLayer @constellation
      @showBlackLayer true
      @showMarkersLayer false
      @constellation.addTo @map
      @constellationDotsLayer.addTo @map
    else
      @showMarkersLayer true
      @showBlackLayer false
      @map.removeLayer @constellation
      @map.removeLayer @constellationDotsLayer

  showBlackLayer: (visible) ->
    @map.featureLayer.setFilter (fl) ->
      visible or fl.geometry.type != 'Polygon'

  showMarkersLayer: (visible) ->
    if visible
      @currentMarkerLayer.addTo @map
    else
      @map.removeLayer @currentMarkerLayer

  addEventToLayers: (event) ->
    geoJsonMarkers = @currentMarkerLayer.getGeoJSON()
    geoJsonMarkers.features.push @_getMarkerFeature(event)
    @currentMarkerLayer.setGeoJSON geoJsonMarkers

    @rebuildLine geoJsonMarkers.features

    geoJsonData = @constellationDotsLayer.getGeoJSON()
    geoJsonData.features.push @_getConstellationFeature(event)
    geoJsonFinal = L.geoJson(
      geoJsonData,
      {
        pointToLayer: (feature, latlng) ->
          L.circleMarker latlng, {
            radius: 2
            color: '#fff'
            opacity: 1
            fillColor: '#fff'
            fillOpacity: 1
          }
      }
    )
    @constellationDotsLayer.addLayer geoJsonFinal

  rebuildLine: (features) ->
    constellationLine= []
    sorted = _.sortBy features, (f) ->
      moment f.properties?.date?

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
    constellationLayerGeoJSON =
      type: 'FeatureCollection',
      features: []

    constellationLine = []

    _.each sortedEventList, (evt) ->
      markersLayerGeoJSON.features.push self._getMarkerFeature(evt)
      constellationLayerGeoJSON.features.push self._getConstellationFeature(evt)
      constellationLine.push L.latLng evt.lat, evt.lon

    @constellation = L.polyline constellationLine, @_constellationConfig

    geoJson = L.geoJson(
      constellationLayerGeoJSON,
      {
        pointToLayer: (feature, latlng) ->
          console.log feature, latlng
          L.circleMarker latlng, {radius: feature.properties.count}
      }
    )

    @constellationDotsLayer = L.mapbox.featureLayer()
    @constellationDotsLayer.setGeoJSON geoJson.toGeoJSON()

    mLayer.setGeoJSON markersLayerGeoJSON
    mLayer.on 'click', (e) ->
      $.get e.layer.feature.properties.url
        .success (data) ->
          self.travelInTime(data)
        .error (err) ->
          console.log 'problemo'

  _getConstellationFeature: (evt) ->
    feature = {
      type: 'Feature'
      properties:
        count: 10
      geometry:
        type: 'Point',
        coordinates: [
          evt.lon
          evt.lat
        ]
    }
    feature

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
