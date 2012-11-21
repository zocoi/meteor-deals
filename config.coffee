if Meteor.isClient
  console.log "client.config"
  # Accounts.ui.config
  #   requestPermissions:
  #     facebook: ['email', 'user_likes']

if Meteor.isServer
  console.log "server.config"
