class ImagoSingapur.Router extends Backbone.Router

  routes:
    "": "renderGridView" #default route
    "testimonies/map": "renderMapView"
    "testimonies/grid": "renderGridView"
    "testimony/:id": 'renderStory'

  renderGridView: ->
    if Backbone.history.location.pathname != "/" and Backbone.history.fragment == ""
      console.log "halting routing", Backbone.history.location.pathname, Backbone.history.fragment
      return

    App.Collections.testimonies = new ImagoSingapur.TestimoniesCollection()
    App.Collections.testimonies.fetch()
    view = new ImagoSingapur.TestimonyGridView(collection: App.Collections.testimonies)
    @_renderMain view
    @_setActive 'profile-nav'


  renderMapView: ->
    App.Collections.testimonies = new ImagoSingapur.TestimoniesCollection()
    App.Collections.testimonies.fetch()

    view = new ImagoSingapur.TestimonyMapView(collection: App.Collections.testimonies)
    @_renderMain view, view.renderMap
    @_setActive 'map-nav'

  renderStory: (id) ->
    # unless App.Collections.testimonies?
    #   App.Collections.testimonies = new ImagoSingapur.TestimoniesCollection()
    #   App.Collections.testimonies.fetch()
    view = new ImagoSingapur.TestimonyShow(model: App.Collections.testimonies.get(id))
    @_renderMain view
    @_setActive ''


  _renderMain: (view, callback) ->
    if @mainView?
      @mainView.remove()

    @mainView = view
    $('#main-view-container').append(view.render().el)

    if callback
      callback()

  _setActive: (newActive) ->
    currActive = $(".current")
    unless currActive.attr('id') == newActive
      currActive.removeClass("current")
      $("#"+newActive).addClass("current")
