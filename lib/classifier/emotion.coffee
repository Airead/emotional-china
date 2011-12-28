###
  emotion.coffee
###
define [
  'exports'
  'asyncblock'
  'cs!../../config/redis'
  'brain'
], (m, a, r, b) ->

    emotions = ['joy', 'surprise', 'fear', 'sadness', 'digest', 'anger', 'slight']

    params =
        backend:
            type: 'Redis'
            options:
                hostname: r.host
                port: r.port
        thresholds:
            unrelated: 1
            modest: 1
            strong: 1
            stronger: 1
            strongest: 1
        def: 'modest'

    createBayes = (name) ->
        params.backend.options.name = name
        new b.BayesianClassifier(params)

    bayeses = {}
    for name in emotions
        bayeses[name] = createBayes(name)

    m.classifyAll = (text, callback) ->
        a (flow) ->
            try
                for type in emotions
                    m.classify type, text, flow.add(type)
                categories = flow.wait()
                callback(null, categories)
            catch err
                callback(err, null)

    m.classify = (type, text, callback) ->
        try
            bayeses[type].classify text, (cat) ->
                callback null, cat
        catch err
            callback err, null

    m
