class ImagoSingapur.Router extends Backbone.Router
  routes:
    "": "renderGridView" #default route
    "testimonies/map": "renderMapView"
    "testimonies/grid": "renderGridView"

  renderGridView: ->
    App.Collections.testimonies = new ImagoSingapur.TestimoniesCollection()
    view = new ImagoSingapur.TestimonyGridView(collection: App.Collections.testimonies)
    App.Collections.testimonies.fetch()
    @_renderMain view

  renderMapView: ->
    unless App.Collections.testimonies?.length
      App.Collections.testimonies = new ImagoSingapur.TestimoniesCollection()
      App.Collections.testimonies.fetch()

    view = new ImagoSingapur.TestimonyMapView(collection: App.Collections.testimonies)
    @_renderMain view, view.renderMap

  _renderMain: (view, callback) ->
    if @mainView?
      @mainView.remove()

    @mainView = view
    $('#main-container').append(view.render().el)

    if callback
      callback()
