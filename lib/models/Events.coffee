Events = new Meteor.Collection("events")

Events.allow
  insert: () ->
    false # no cowboy inserts

  remove: (userId, parties) ->
    false

Meteor.methods
  createEvent: (options, userId) ->
    options = options or {}
    throw new Meteor.Error(400, "Required parameter missing") unless typeof options.dealId or userId
    throw new Meteor.Error(403, "You must be logged in") unless userId
    Events.insert
      userId: userId
      dealId: options.dealId
      message: options.message
      createdAt: +(new Date)
