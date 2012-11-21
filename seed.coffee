# Uncomment if you need dummy data in development
#
# seed = ()->
#   
#   if Deals.find().count() == 0
#     deals = [
#       {
#           title: "Almaden Valley Window Washing – Redeem from Home",
#           url: "http://www.groupon.com/deals/dc-gxa-almaden-valley-window-washing?c=all&p=0"
#           price: 60,
#           fromPrice: 120,
#           description: "Holiday light-installation services from window-washing specialists adept at scaling ladders and homes"
#           photoUrl: "http://s3.grouponcdn.com/images/site_images/2726/7965/RackMultipart20121105-30181-jz4cln_grid_6.jpg"
#           userIds: []
#           ownerId: null
#         },
#       {
#           title: "Bambeco – Online Deal",
#           url: "http://www.groupon.com/deals/dc-gxa-bambeco-san-francisco"
#           price: 25,
#           fromPrice: 50,
#           description: "Eco-Friendly Home Decor, Accessories, and Gifts (Half Off). Two Options Available."
#           photoUrl: "http://s3.grouponcdn.com/images/site_images/2713/6650/RackMultipart20121101-13802-15qfhoj_grid_6.jpg"
#           userIds: []
#           ownerId: null
#         }
#     ]
#     Deals.insert(deal) for deal in deals
#   return
# 
# getExternalDeals = ()->
#   Meteor.http.get "http://api.yipit.com/v1/deals/?key=xUSQEaDNfYTkqp9q&division=san-francisco", {}, (error, result)->
#     console.log result.data
#     deals = result.data.response.deals
#     for deal in deals
#       obj =
#         title: deal.title
#         url: deal.url
#         price: deal.price.raw,
#         fromPrice: deal.value.raw,
#         description: deal.description
#         photoUrl: deal.images.image_big
#         division: deal.division
#         votes: 0
#         userIds: []
#       Deals.insert(obj)
getGrouponGoodsDeals = ()->
  Meteor.http.get "http://api.groupon.com/v2/deals?client_id=05c5a7da5a462284c60eb8c091a2eaec16abb1a1&channel_id=goods", {}, (error, result)->
    deals = result.data.deals
    console.log deals.length
    for deal in deals
      if deal.status == "open" and not Deals.findOne(deal.id)
        console.log deal.options
        obj =
          id: deal.id
          title: deal.title
          url: deal.dealUrl
          price: deal.options[0].price.amount / 100 if deal.options[0]?.price?.amount
          fromPrice: deal.options[0].value.amount /100 if deal.options[0]?.value?.amount
          description: deal.highlightsHtml.stripTags()
          photoUrl: deal.largeImageUrl
          division: deal.division
          votes: 0
          userIds: []
        Deals.insert(obj)

# emptyTables = () ->
#   Deals.remove({})
#   Events.remove({})

if Meteor.isServer
  Meteor.startup ->
    # seed()
    # getGrouponGoodsDeals()
    # code to run on server at startup
