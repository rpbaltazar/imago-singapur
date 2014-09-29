class ImagoSingapur.TestimonyGridCellView extends Backbone.View

  attributes : ->
    {
      id : "testimony-#{@model.get('id')}"
      class: "testimony-cell"
    }

  render: ->
    template = JST['imago_singapur/templates/testimony_grid_cell']( @model.toJSON() )
    $(@el).html(template)
    @
