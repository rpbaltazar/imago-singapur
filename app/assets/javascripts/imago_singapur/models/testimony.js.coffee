class ImagoSingapur.Testimony extends Backbone.Model
  defaults:
    lat: "0.0"
    lon: "0.0"
    story_date: moment()
    memory: "This is a default mem"
    image_url: "https://38.media.tumblr.com/65aac25d02348e0459f26b23727ac154/tumblr_nbqppjPgbO1r9bkpwo1_1280.jpg"
    grid_img: "https://38.media.tumblr.com/65aac25d02348e0459f26b23727ac154/tumblr_nbqppjPgbO1r9bkpwo1_1280.jpg"
    static_map: "http://api.tiles.mapbox.com/v4/{mapid}/{markers}/{lon},{lat},{z}/{width}x{height}.{format}?access_token=<your access token>"
    title: "An Amazing Story"
    headline: "The freedom of the Geronimo, the whale"
    location: "Marina Reservoir"

  initialize: ->

    @.set 'story_date', moment(@.get('story_date'))
    year = @.get('story_date').year()
    keys = Object.keys ImagoSingapur.Lib.Dictionaries.MapIndexes
    keysInt = _.map keys, (k) -> Number k
    closestMapYear = ImagoSingapur.Lib.Numeric.findClosestInteger(year, keysInt, 'negative' )

    if !closestMapYear?
      @.set 'static_map', @getStaticMap()
    else
      options =
        map: "rpbaltazar.singapore-#{closestMapYear}"
      @.set 'static_map', @getStaticMap(options)

    @reverseGeoCodeLocation()

  getStaticMap: (options={}) ->
    lat = @.get('lat')
    lon = @.get('lon')

    options.marker ||= 'pin-s-marker'
    options.width ||= 250
    options.height ||= 250
    options.map ||= 'rpbaltazar.jj789eo9'

    url = "http://api.tiles.mapbox.com/v4/#{options.map}/#{options.marker}+f44(#{lon},#{lat},16)/#{lon},#{lat},14/#{options.width}x#{options.height}.png?access_token=pk.eyJ1IjoicnBiYWx0YXphciIsImEiOiJEQlJyLVVJIn0.yaCOoWv9RzeJ8ZlkfOmoxg"
    url

  reverseGeoCodeLocation: () ->
    self = @
    $.get "http://api.tiles.mapbox.com/v4/geocode/mapbox.places-v1/#{self.get 'lon'},#{self.get 'lat'}.json?access_token=pk.eyJ1IjoicnBiYWx0YXphciIsImEiOiJEQlJyLVVJIn0.yaCOoWv9RzeJ8ZlkfOmoxg", (data) ->
      self.set 'location', data?.features?[0].place_name

