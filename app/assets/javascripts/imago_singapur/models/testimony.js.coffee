class ImagoSingapur.Testimony extends Backbone.Model
  defaults:
    lat: "0.0"
    lon: "0.0"
    story_date: moment()
    memory: "This is a default mem"
    image_url: "https://38.media.tumblr.com/65aac25d02348e0459f26b23727ac154/tumblr_nbqppjPgbO1r9bkpwo1_1280.jpg"
    grid_img: "https://38.media.tumblr.com/65aac25d02348e0459f26b23727ac154/tumblr_nbqppjPgbO1r9bkpwo1_1280.jpg"
    static_map: "http://api.tiles.mapbox.com/v4/{mapid}/{markers}/{lon},{lat},{z}/{width}x{height}.{format}?access_token=<your access token>"

  initialize: ->

    @.set 'story_date', moment(@.get('story_date'))
    year = @.get('story_date').year()
    keys = Object.keys ImagoSingapur.Lib.Dictionaries.MapIndexes
    keysInt = _.map keys, (k) -> Number k
    closestMapYear = ImagoSingapur.Lib.Numeric.findClosestInteger(year, keysInt, 'negative' )
    lat = @.get('lat')
    lon = @.get('lon')

    if !closestMapYear?
      @.set 'static_map', "http://api.tiles.mapbox.com/v4/rpbaltazar.jj789eo9/pin-s-marker+f44(#{lon},#{lat},16)/#{lon},#{lat},14/250x250.png?access_token=pk.eyJ1IjoicnBiYWx0YXphciIsImEiOiJEQlJyLVVJIn0.yaCOoWv9RzeJ8ZlkfOmoxg"
    else
      @.set 'static_map', "http://api.tiles.mapbox.com/v4/rpbaltazar.singapore-#{closestMapYear}/pin-s-marker+f44(#{lon},#{lat},16)/#{lon},#{lat},14/250x250.png?access_token=pk.eyJ1IjoicnBiYWx0YXphciIsImEiOiJEQlJyLVVJIn0.yaCOoWv9RzeJ8ZlkfOmoxg"
