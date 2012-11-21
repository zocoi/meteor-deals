
Meteor.publish "deals", () ->
  deals = Deals.find {}, sort: [["votes", "desc"]]

Meteor.publish "users", () ->
  Meteor.users.find {}, 
    fields:
      profile: 1
      username: 1
      email: 1
      services: 1
  
Meteor.publish "events", ()->
  events = Events.find({}, sort: [["createdAt", "desc"]])
  
Meteor.startup ->
  # code to run on server at startup
    