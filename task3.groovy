// Task 8.
g.V().has('country', 'PL')                       \
     .has('type','airport')                      \
     .as('airport','countries')                  \
     .select('airport','countries')              \
     .by('code')                                 \
     .by(out().values('country').dedup().fold())