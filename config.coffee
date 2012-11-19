if Meteor.isClient
  Accounts.ui.config
    requestPermissions:
      facebook: ['email', 'user_likes']

if Meteor.isServer
  console.log "server"
  # Override publishing service from accounts-base
  # Meteor.publish "meteor.currentUser", ()->
  #   if @userId
  #     Meteor.users.find {_id: @userId},
  #       fields:
  #         profile: 1
  #         username: 1
  #         email: 1
  #         service: 1
  #   else
  #     @complete()
  #     null

  # If autopublish is on, also publish everyone else's user record.
  # Meteor.default_server.onAutopublish ()->
  #   handler = ->
  #     Meteor.users.find {},
  #       fields:
  #         profile: 1
  #         username: 1
  #         email: 1
  #         service: 1
  # 
  #   Meteor.default_server.publish null, handler, is_auto: true