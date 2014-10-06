class ImagoSingapur.MapManager
  constructor: (accessToken, id) ->
    L.mapbox.accessToken = accessToken
    @_layers = {
      # TODO: redo the layers exporting with zoom from 12 to 18
      # current: L.mapbox.tileLayer 'rpbaltazar.jj789eo9'
      1969: L.mapbox.tileLayer 'rpbaltazar.singapore-1969'
      1975: L.mapbox.tileLayer 'rpbaltazar.singapore-1975'
      1993: L.mapbox.tileLayer 'rpbaltazar.singapore-1993'
      2000: L.mapbox.tileLayer 'rpbaltazar.singapore-2000'
    }

    @currentLayerYear = 0
    @elId = id
    @currentMarkerLayer
    @constellation

    @_constellationConfig = {
      opacity: 0.7,
      color: "#fff",
      weight: 2,
    }

    @_mapOptions = {
      attributionControl: false
      zoomControl: false
      minZoom: 12
    }
    @_mapCenter = [1.332315524375544, 103.82526397705078]

    @nearbyMarkersLayer = L.mapbox.featureLayer()
    @nearbyMarkersLayer.on 'layeradd', (e) ->
      marker = e.layer
      feature = marker.feature
      if feature.properties.visible
        icon = L.divIcon(
          html:"<div class='map-marker'> <img src='#{feature.properties.image}'></div>",
          iconSize: new L.Point(50, 50)
        )
      else
        icon = L.divIcon(
          html:"<div class='map-marker'> <p> Start a chat </p> </div>",
          iconSize: new L.Point(60, 60)
        )

      marker.setIcon(icon)

  loadMap: ->
    self = @
    @map = L.mapbox.map(@elId, 'rpbaltazar.jj789eo9', @_mapOptions).setView(@_mapCenter, 12)
    @showBlackLayer false
    @constellationLine = []
    @_setupEvents()
    @_setMapBounds()

  _setMapBounds: (options) ->

    if !options?
      mapBounds = @map.getBounds()
    else
      console.log 'todo'

    @map.setMaxBounds mapBounds

  _setupEvents: ->
    self = @
    @map.getContainer().querySelector('#constellation').onclick = ->
      if self._toggleConstellation()
        @className = 'active'
        @innerHTML = 'Constellation ON'
      else
        @className = ''
        @innerHTML = 'Constellation OFF'

      return false

  _toggleConstellation: ->
    if !@map.hasLayer @constellation
      @showBlackLayer true
      @showMarkersLayer false
      @constellation.addTo @map
      @constellationDotsLayer.addTo @map
      return true
    else
      @showMarkersLayer true
      @showBlackLayer false
      @map.removeLayer @constellation
      @map.removeLayer @constellationDotsLayer
      return false

  showBlackLayer: (visible) ->
    #NOTE: the featureLayers have names
    #fl.properties.title
    #that can be set either in mapbox or
    #tilemille
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

    constellationLayerGeoJSON =
      type: 'FeatureCollection',
      features: []

    unless @constellationDotsLayer
      geoJson = L.geoJson(
        constellationLayerGeoJSON,
        {
          pointToLayer: (feature, latlng) ->
            L.circleMarker latlng, {radius: feature.properties.count}
        }
      )

      @constellationDotsLayer = L.mapbox.featureLayer()
      @constellationDotsLayer.setGeoJSON geoJson.toGeoJSON()

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
    self = @
    self.constellationLine= []
    sorted = _.sortBy features, (f) ->
      moment f.properties?.date?

    _.each sorted, (f) ->
      self.constellationLine.push (L.latLng f.geometry.coordinates[1], f.geometry.coordinates[0])

    @constellation = L.polyline self.constellationLine, @_constellationConfig

  createLayers: (eventList) ->
    self = @
    @currentMarkerLayer = L.mapbox.featureLayer()

    @currentMarkerLayer.on 'layeradd', (e) ->
      marker = e.layer
      feature = marker.feature
      # if feature.properties.visible
      marker.setIcon(L.icon(feature.properties.icon))

    @currentMarkerLayer.on 'click', (e) ->
      e.originalEvent.preventDefault()
      $.get e.layer.feature.properties.url
        .success (data) ->
          currTestimony = data['testimony']
          surroundingTestimonies = data['nearby']
          self.travelInTime currTestimony
          self._populateNearby surroundingTestimonies

        .error (err) ->
          console.log 'problemo'

    markersLayerGeoJSON =
    constellationLayerGeoJSON =
      type: 'FeatureCollection',
      features: []
    @currentMarkerLayer.setGeoJSON markersLayerGeoJSON
    @currentMarkerLayer.addTo @map

    sortedEventList = _.sortBy eventList, (evt) ->
      moment evt.story_date

    _.each sortedEventList, (evt) ->
      self.addEventToLayers evt

  _populateNearby: (testimoniesList) ->
    self = @

    unless @nearbyMarkersLayer
      @nearbyMarkersLayer = L.mapbox.featureLayer()

    if @map.hasLayer @nearbyMarkersLayer
      @map.removeLayer @nearbyMarkersLayer

    geoJSON =
      type: 'FeatureCollection',
      features: []

    _.each testimoniesList, (evt) ->
      geoJSON.features.push self._getMarkerFeature evt

    @nearbyMarkersLayer.setGeoJSON geoJSON
    @nearbyMarkersLayer.addTo @map


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
        icon: {
          iconSize: [50, 50],
          iconAnchor: [25, 56],
          className: 'map-marker'
        }
        url: "/api/testimonies/#{evt.id}"
        image: "#{evt.grid_img}"
        date: "#{evt.story_date}"
        visible: evt.visible
      ,
      geometry:
        type: 'Point',
        coordinates: [
          evt.lon
          evt.lat
        ]
    }

    console.log 'visible: ?', evt.visible

    if evt.visible
      feature.properties.icon.iconUrl = "#{evt.grid_img}"

    feature

  travelInTime: (event) ->
    self = @
    year = moment(event.story_date).year()

    @loadYearLayer year
    @zoomAndCenter event

  loadYearLayer: (year) ->
    self = @

    keys = Object.keys @_layers
    keysInt = _.map keys, (k) -> Number k
    closestMapYear = ImagoSingapur.Lib.Numeric.findClosestInteger(year, keysInt, 'negative' )
    return if self.currentLayerYear == closestMapYear

    console.log 'event year: ', year
    console.log 'closestMapYear: ', closestMapYear
    layer = self._layers[closestMapYear]
    currentLayer = self._layers[self.currentLayerYear]
    if self.map.hasLayer currentLayer
      self.map.removeLayer currentLayer

    layer.addTo self.map
    self.currentLayerYear = closestMapYear

  zoomAndCenter: (event) ->
    latlng = L.latLng event.lat, event.lon
    @map.fitBounds L.latLngBounds(latlng, latlng),
      {animate: true,
      maxZoom: 18}
