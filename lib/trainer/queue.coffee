###
  queue.coffee
###
define [
  'exports'
  'redis'
], (m, r) ->

    key = 'q:trainer'
    redis = null

    m.init = (ctx) ->
        config = ctx.redis
        redis = r.createClient(config.port, config.host, config.options)

    m.enqueue = (o, callback) ->
        if o
            redis.rpush key, JSON.stringify(o), callback
        else
            callback null, null

    m.dequeue = (callback) ->
        redis.lpop key, (err, val) ->
            if err
                callback err, null
            else
                if val
                    callback null, JSON.parse val
                else
                    callback null, null

    m.size = (callback) ->
        redis.llen key, callback

    m

