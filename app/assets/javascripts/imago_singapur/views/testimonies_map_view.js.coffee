class ImagoSingapur.TestimonyMapView extends Backbone.View

  template: JST['imago_singapur/templates/testimonies_map']
  $el: $("#main-container")
  mapId: "testimonies-map"
  mapManager: {}

  events:
    'click #constellation-switch' : 'toggleConstellation'

  initialize: (options) ->
    @collection = options?.collection
    _.bindAll @, 'render', 'add', 'renderMap'
    @collection.bind 'reset', @render
    @collection.bind 'add', @add

  render: ->
    self = @
    $(@el).html( @template(collection: self.collection.toJSON()) )
    @mapManager = new ImagoSingapur.MapManager 'pk.eyJ1IjoicnBiYWx0YXphciIsImEiOiJEQlJyLVVJIn0.yaCOoWv9RzeJ8ZlkfOmoxg', @mapId
    @

  renderMap: ->
    @mapManager.loadMap()
    # @mapManager.createMapMarkersLayer(@collection.toJSON())
    @mapManager.createLayers(@collection.toJSON())

  add: (model) ->
    # @mapManager.createMapMarkersLayer(@collection.toJSON())
    @mapManager.createLayers(@collection.toJSON())

  toggleConstellation: ->
    @mapManager.toggleConstellation()

