ImagoSingapur.Lib ||= {}
ImagoSingapur.Lib.Numeric ||= {}

_.extend ImagoSingapur.Lib.Numeric,

  findClosestInteger: (start, list, direction) ->
    closest = null

    if direction == "positive"
      closer = (s, e, c) ->
        e >= s and (e < c or !c?)
    else if direction == "negative"
      closer = (s, e, c) ->
        e <= s and (e > c or !c?)
    else
      closer = (s, e, c) ->
        Math.abs(e-s) < Math.abs(c-s) || !c?

    _.each list, (elm) ->
      if closer(start, elm, closest)
        closest = elm

    closest
