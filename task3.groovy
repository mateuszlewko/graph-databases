// Task 1.
g.V().has('airport','country','PL').outE().inV() \
     .has('country', 'DE').path().by('code').by('dist')

// Task 2.
g.V().has('airport','country','PL').outE().has('dist',gt(400)).inV() \
     .has('country', 'DE').path().by('code').by('dist')

// Task 3.
g.V().has('airport', 'code', 'MUC').inE().outV().has('country', 'PL').as('pl').outE().as('dist').inV().has('country', 'DE').as('de').path().select('pl', 'de', 'dist').by('code').by('code').by('dist')


// Task 6.


// Task 7.
g.V().has('country', 'PL')                       \
     .has('type','airport')                      \
     .as('airport','inCnt', 'outCnt')            \
     .select('airport','inCnt', 'outCnt')        \
     .by('code')                                 \
     .by(inE('route').count())                   \
     .by(outE('route').count())                  


// Task 8.
g.V().has('country', 'PL')                       \
     .has('type','airport')                      \
     .as('airport','countries')                  \
     .select('airport','countries')              \
     .by('code')                                 \
     .by(out().values('country').dedup().fold())