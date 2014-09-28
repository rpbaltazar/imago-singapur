class ImagoSingapur.TestimonyGridCellView extends Backbone.View

  id: "testimony"
  render: ->
    template = JST['imago_singapur/templates/testimony_grid_cell']( @model.toJSON() )
    $(@el).html(template)
    @
