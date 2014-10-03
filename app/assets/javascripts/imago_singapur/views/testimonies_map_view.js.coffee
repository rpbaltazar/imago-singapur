class ImagoSingapur.TestimonyMapView extends Backbone.View

  template: JST['imago_singapur/templates/testimonies_map']
  $el: $("#main-container")
  mapId: "testimonies-map"
  mapManager: {}

  events:
    'updateConstellationViz': 'render'

  initialize: (options) ->
    @collection = options?.collection
    _.bindAll @, 'render', 'add', 'renderMap'

    @model = {constelationViz: false}
    @collection.bind 'reset', @render
    @collection.bind 'add', @add

  render: ->
    self = @
    $(@el).html( @template(collection: self.collection.toJSON(), constellationViz: self.constellationViz) )
    @mapManager = new ImagoSingapur.MapManager 'pk.eyJ1IjoicnBiYWx0YXphciIsImEiOiJEQlJyLVVJIn0.yaCOoWv9RzeJ8ZlkfOmoxg', @mapId
    @

  renderMap: ->
    @mapManager.loadMap()
    @mapManager.createLayers(@collection.toJSON())

  add: (model) ->
    @mapManager.addEventToLayers(model.toJSON())
