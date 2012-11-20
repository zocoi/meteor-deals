
if Meteor.isClient
  Meteor.autosubscribe ->
    Meteor.subscribe("deals")
    Meteor.subscribe("users")
  
  # index
  Template.index.deals = ->
    Deals.find({}, sort: [["votes", "desc"]])

  Template.index.events({
    "submit #deal_form": ->
      value = $("#text-input").val()
      obj = {}
      for el in $('#deal_form').serializeArray()
        obj[el.name] = el.value
      console.log obj
      Meteor.call "createDeal", obj, Meteor.userId()
      return false
  })

  # entry  
  Template.entry.events({ 
    "click .btn-vote-up": (event)->
      console.log event
      dealId = $(event.currentTarget).data("id")
      Meteor.call "voteUp", dealId, Meteor.userId()
      return false
  })
  
  Template.entry.truncatedDescription = ()->
    deal = this
    deal.description.truncate(300)

  Template.entry.latestUsers = ()->
    console.log this
    deal = this
    latestUserIds = _.last(deal.userIds, 5)
    if latestUserIds.length > 0
      latestUsers = Meteor.users.find _id: {$in: latestUserIds}, 
        fields:
          profile: 1
          username: 1
          email: 1
          services: 1
      latestUsers.fetch()
    else
      []
      
  Template.entry.avatarUrl = ()->
    user = this
    if user.services?.facebook?.id
      "http://graph.facebook.com/#{user.services.facebook.id}/picture"
    else
      null    

if Meteor.isServer
  Meteor.publish "deals", () ->
    deals = Deals.find {}, sort: [["votes", "desc"]]

  Meteor.publish "users", () ->
    Meteor.users.find {}, 
      fields:
        profile: 1
        username: 1
        email: 1
        services: 1
  
  Meteor.startup ->
    # code to run on server at startup
    