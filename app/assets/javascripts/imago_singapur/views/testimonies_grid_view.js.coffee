class ImagoSingapur.TestimonyGridView extends Backbone.View

  id: "testimonies-grid"
  template: JST['imago_singapur/templates/testimonies_grid']

  initialize: ->
    _.bindAll @, 'render', 'add'
    @collection.bind 'reset', @render
    @collection.bind 'add', @add

  render: ->
    self = @
    $(@el).html( @template(collection: self.collection.toJSON()) )
    @

  add: (model) ->
    self = @
    console.log model
    view = new ImagoSingapur.TestimonyGridCellView({model: model})
    $(self.el).append view.render().el

  addNewMemory: ->
    location
