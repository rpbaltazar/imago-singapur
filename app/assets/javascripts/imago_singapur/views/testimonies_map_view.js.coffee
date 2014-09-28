class ImagoSingapur.TestimonyMapView extends Backbone.View

  id: "testimonies-map"
  template: JST['imago_singapur/templates/testimonies_map']
  mapManager: {}

  initialize: (options) ->
    @collection = options?.collection
    _.bindAll @, 'render', 'add', 'renderMap'
    @collection.bind 'reset', @render
    @collection.bind 'add', @add

  render: ->
    self = @
    $(@el).html( @template(collection: self.collection.toJSON()) )
    @mapManager = new ImagoSingapur.MapManager 'pk.eyJ1IjoicnBiYWx0YXphciIsImEiOiJEQlJyLVVJIn0.yaCOoWv9RzeJ8ZlkfOmoxg', @el
    @

  renderMap: ->
    @mapManager.loadMap()
    @mapManager.createMapMarkersLayer(@collection.toJSON())

  add: (model) ->
    @mapManager.createMapMarkersLayer(@collection.toJSON())

