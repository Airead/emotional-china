###
  subjunctive.coffee
###
define [
  'exports'
  'brain'
  'cs!../../config/redis'
  'cs!../text/segmentor'
], (m, br, rc, sg) ->
    options =
        backend:
            type: 'Redis'
            options:
                hostname: rc.host
                port: rc.port
                name: 'subjunctive'
        thresholds:
            positive: 1
            negative: 3
        def: 'negative'

    m.type = 'subjunctive'
    m.options = ['positive', 'negative']

    bayes = new br.BayesianClassifier(options)
    m.train = (text, category) ->
        sg.seg text, (doc) ->
           bayes.train doc, category

    m
