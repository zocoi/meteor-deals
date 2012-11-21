Events = new Meteor.Collection("events")

Events.allow
  insert: () ->
    false # no cowboy inserts

  remove: (userId, parties) ->
    false

Meteor.methods
  createEvent: (options, userId) ->
    options = options or {}
    for name in ["dealId"]
      throw new Meteor.Error(400, "Required parameter missing: #{name}") unless typeof options[name] is "string" and options[name].length
    throw new Meteor.Error(403, "You must be logged in") unless userId
    console.log Events.insert
      userId: userId
      dealId: options.dealId
      message: options.message
      createdAt: +(new Date)
