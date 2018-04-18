// Task 1.
g.V().has('airport','country','PL').outE().inV() \
     .has('country', 'DE').path().by('code').by('dist')

// Task 2.
g.V().has('airport','country','PL').outE().has('dist',gt(400)).inV() \
     .has('country', 'DE').path().by('code').by('dist')

// Task 3.
g.V().has('airport', 'code', 'MUC').inE().outV().has('country', 'PL') \
     .as('pl').outE().as('dist').inV().has('country', 'DE').as('de')  \
     .path().select('pl', 'de', 'dist').by('code').by('code').by('dist')

// Task 4.
g.V().has('code', 'WRO').repeat(out()).emit(has('airport', 'country', 'UK')) \
     .times(3).out().has('airport', 'country', 'UK').path().by('code')

// Task 5.
g.V().has('code', 'WRO').repeat(out().has('airport', 'country', 'UK')).emit() \
     .times(4).path().by('code')

// Task 6. Not finished

g.V().has('code', 'WRO').repeat(out().simplePath()).emit(has('airport', 'country', 'UK')).until(out().has('airport', 'country', 'UK')).out().has('airport', 'country', 'UK').as('out').select('out').by('code').dedup().fold()

g.V().has('code', 'WRO').repeat(out()).emit().times(3).out().has('airport', 'country', 'UK').as('out').select('out').by('code').dedup().fold().toList()
// g.V().has('code', 'WRO').repeat(out()).emit().times(3).out().has('airport', 'country', 'UK').path().by('code')

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

// Task 9.
g.V().has('continent','code','EU').out().has('type', 'airport') \
      .order().by(outE('route').count(), decr).limit(10)        \
      .project('code','city','cnt').by('code').by('city').by(outE('route').count())