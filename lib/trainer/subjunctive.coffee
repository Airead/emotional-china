###
  subjunctive.coffee
###
define [
  'exports'
  'cs!../../config/redis'
  'brain'
], (m, r, b) ->
    options =
        backend:
            type: 'Redis'
            options:
                hostname: r.host
                port: r.port
                name: 'subjunctive'
        thresholds:
            positive: 3
            negative: 1
        def: 'negative'

    m.type = 'subjunctive'
    m.options = ['positive', 'negative']

    bayes = new b.BayesianClassifier(options)
    m.train = (text, category) -> bayes.train(text, category)

    m
