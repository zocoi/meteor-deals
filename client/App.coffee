###
Autosubscription
###

Meteor.autosubscribe ->
  Meteor.subscribe("deals")
  Meteor.subscribe("users")
  # Meteor.subscribe("events")
  
  Events.find({}).observe
    added: (event, beforeIndex) ->
      console.log  event
      user = Meteor.users.findOne event.userId
      deal = Deals.findOne event.dealId
      return null unless user and deal
      action = "liked"
      action = "commented" if event.message?
      $.gritter.add
        text: "<strong>#{displayName(user)}</strong> #{action} <a href=\"##{deal._id}\">#{deal.title.truncate(100)}</a>"
        image: avatarUrl(user)
        time: 5000
###
Helper methods
###
displayName = (user) ->
  return user.profile.name if user.profile and user.profile.name
  user.emails[0].address

contactEmail = (user) ->
  return user.emails[0].address  if user.emails and user.emails.length
  return user.services.facebook.email  if user.services and user.services.facebook and user.services.facebook.email
  null

avatarUrl = (user)->
  if user.services?.facebook?.id
    return "http://graph.facebook.com/#{user.services.facebook.id}/picture"
  else if user.services?.twitter?.screenName
    return "http://api.twitter.com/1/users/profile_image?screen_name=#{user.services.twitter.screenName}&size=bigger"
  else
    null

###
Tempates
###

# index
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

Template.index.deals = ->
  Deals.find({}, sort: [["votes", "desc"]])


# entry 
Template.entry.events({ 
  "click .btn-vote-up": (event)->
    console.log event
    dealId = $(event.currentTarget).data("id")
    Meteor.call "voteUp", dealId, Meteor.userId()
    Meteor.call "createEvent", {dealId:dealId}, Meteor.userId()
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
  avatarUrl(this)  