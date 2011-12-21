###
  crawler.coffee
###
define [
  'exports'
  'weibo'
], (m, w) ->

    tapi = w.tapi

    m.run = (ctx, callback) ->
        config = ctx.weibo
        tapi.init 'tsina', config.appkey, config.secret, config.oauth_callback_url
        tapi.public_timeline {}, (error, data, response) ->
            callback error, data, response

    m

