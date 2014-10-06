class ImagoSingapur.TestimonyGridCellView extends Backbone.View

  events:
    'click .imago-thumb': 'showStory'
    'mouseenter .imago-thumb': 'showInfo'
    'mouseleave .imago-thumb': 'hideInfo'

  attributes : ->
    {
      id : "testimony-#{@model.get('id')}"
      class: "testimony-cell"
    }

  render: ->
    template = JST['imago_singapur/templates/testimony_grid_cell']( @model.toJSON() )
    $(@el).html(template)
    @

  showStory: (ev) ->
    App.router.navigate "testimony/#{@model.id}", trigger: true

  showInfo: (ev) ->
    $(ev.currentTarget).find(".thumbnail").fadeOut()

  hideInfo: (ev) ->
    $(ev.currentTarget).find(".thumbnail").fadeIn()
