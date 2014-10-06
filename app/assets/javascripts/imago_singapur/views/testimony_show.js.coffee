class ImagoSingapur.TestimonyShow extends Backbone.View

  template: JST['imago_singapur/templates/testimony_show']
  $el: $("#main-container")

  render: ->
    @$el.html(@template(@model.toJSON()))
    @
