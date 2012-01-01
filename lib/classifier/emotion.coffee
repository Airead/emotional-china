###
  emotion.coffee
###
define [
  'exports'
  'asyncblock'
  'cs!../../config/redis'
  'brain'
  'cs!../text/trigram'
], (m, a, r, b, t) ->

    emotions = [
        'joy', 'surprise', 'fear', 'sadness', 'disgust', 'anger', 'scorn',
        'distress', 'anxiety', 'serene', 'sincere', 'wish', 'pity', 'guilt',
        'admire', 'confusion', 'caution', 'fierce', 'trance'
    ]

    params =
        backend:
            type: 'Redis'
            options:
                hostname: r.host
                port: r.port
        thresholds:
            unrelated: 5
            weak: 4
            strong: 3
            stronger: 2
            strongest: 1
        def: 'unrelated'

    createBayes = (name) ->
        params.backend.options.name = name
        new b.BayesianClassifier(params)

    bayeses = {}
    for name in emotions
        bayeses[name] = createBayes(name)

    m.classifyAll = (text, callback) ->
        a (flow) ->
            flow.maxParallel = 1;
            try
                for type in emotions
                    m.classify type, text, flow.add(type)
                categories = flow.wait()
                callback(null, categories)
            catch err
                callback(err, null)

    m.classify = (type, text, callback) ->
        try
            bayeses[type].classify (t.apply text), (cat) ->
                callback null, cat
        catch err
            callback err, null

    m
