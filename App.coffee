
if Meteor.isClient
  Meteor.autosubscribe ->
    Meteor.subscribe("deals")
    Meteor.subscribe("users")
  
  # index
  Template.index.deals = ->
    Deals.find({}, {sort: {name: 1}})

  Template.index.events({
    "submit #form": ->
      value = $("#text-input").val()
      $("#text-holder").append(value)
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


emptyDeals = () ->
	Deals.remove({})

seed = ()->
  # Uncomment if you need dummy data in development
  # if Deals.find().count() == 0
  #   deals = [
  #     {
  #         title: "Almaden Valley Window Washing – Redeem from Home",
  #         url: "http://www.groupon.com/deals/dc-gxa-almaden-valley-window-washing?c=all&p=0"
  #         price: 60,
  #         fromPrice: 120,
  #         description: "Holiday light-installation services from window-washing specialists adept at scaling ladders and homes"
  #         photoUrl: "http://s3.grouponcdn.com/images/site_images/2726/7965/RackMultipart20121105-30181-jz4cln_grid_6.jpg"
  #         userIds: []
  #         ownerId: null
  #       },
  #     {
  #         title: "Bambeco – Online Deal",
  #         url: "http://www.groupon.com/deals/dc-gxa-bambeco-san-francisco"
  #         price: 25,
  #         fromPrice: 50,
  #         description: "Eco-Friendly Home Decor, Accessories, and Gifts (Half Off). Two Options Available."
  #         photoUrl: "http://s3.grouponcdn.com/images/site_images/2713/6650/RackMultipart20121101-13802-15qfhoj_grid_6.jpg"
  #         userIds: []
  #         ownerId: null
  #       }
  #   ]
  #   Deals.insert(deal) for deal in deals
	return

getExternalDeals = ()->
  Meteor.http.get "http://api.yipit.com/v1/deals/?key=xUSQEaDNfYTkqp9q&division=san-francisco", {}, (error, result)->
    console.log result.data
    deals = result.data.response.deals
    for deal in deals
      obj =
        title: deal.title
        url: deal.url
        price: deal.price.raw,
        fromPrice: deal.value.raw,
        description: deal.description
        photoUrl: deal.images.image_big
        division: deal.division
        userIds: []
      Deals.insert(obj)
    

if Meteor.isServer
  Meteor.publish "deals", () ->
    deals = Deals.find {}
    deals

  Meteor.publish "users", () ->
    Meteor.users.find {}, 
      fields:
        profile: 1
        username: 1
        email: 1
        services: 1
  
  Meteor.startup ->
    seed()
    getExternalDeals()
    # code to run on server at startup
    