Deals = new Meteor.Collection("deals")

if Meteor.isServer
  Deals._ensureIndex 'id', {unique: 1, sparse: 1}

Deals.allow
  insert: () ->
    false # no cowboy inserts -- use createDeal method

  update: (userId, deals, fields, modifier) ->
    _.all deals, (deal) ->
      allowed = ["title", "description"]
      return false  if _.difference(fields, allowed).length # tried to write to forbidden field
      
      # A good improvement would be to validate the type of the new
      # value of the field (and if a string, the length.) In the
      # future Meteor will have a schema system to makes that easier.
      true


  remove: (userId, parties) ->
    false

Meteor.methods
  createDeal: (options, userId) ->
    options = options or {}
    console.log "options", options
    for name in ["title", "description", "url", "price", "photoUrl"]
      throw new Meteor.Error(400, "Required parameter missing: #{name}") unless typeof options[name] is "string" and options[name].length
    throw new Meteor.Error(403, "You must be logged in")  unless userId
    Deals.insert
      title: options.title
      description: options.description
      url: options.url
      price: parseInt(options.price)
      fromPrice: parseInt(options.fromPrice)
      photoUrl: options.photoUrl
      userIds: []
      ownerId: null


  # invite: (partyId, userId) ->
  #     party = Parties.findOne(partyId)
  #     throw new Meteor.Error(404, "No such party")  if not party or party.owner isnt @userId
  #     throw new Meteor.Error(400, "That party is public. No need to invite people.")  if party.public
  #     if userId isnt party.owner and not _.contains(party.invited, userId)
  #       Parties.update partyId,
  #         $addToSet:
  #           invited: userId
  # 
  #       from = contactEmail(Meteor.users.findOne(@userId))
  #       to = contactEmail(Meteor.users.findOne(userId))
  #       if Meteor.isServer and to
  #         
  #         # This code only runs on the server. If you didn't want clients
  #         # to be able to see it, you could move it to a separate file.
  #         Email.send
  #           from: "noreply@example.com"
  #           to: to
  #           replyTo: from or `undefined`
  #           subject: "PARTY: " + party.title
  #           text: "Hey, I just invited you to '" + party.title + "' on All Tomorrow's Parties." + "\n\nCome check it out: " + Meteor.absoluteUrl() + "\n"
  

  voteUp: (dealId, userId) ->
    throw new Meteor.Error(403, "You must be logged in to vote up")  unless @userId
    deal = Deals.findOne(dealId)
    throw new Meteor.Error(404, "No such deal") unless deal
    throw new Meteor.Error(400, "You already voted") if deal.userIds.indexOf(userId) != -1
    Deals.update(dealId, {
      $inc: {votes: 1}
      $addToSet: {userIds: userId}
    })