// 1. List 10 locations that have been mentioned by the largest number of 
//    trolls.

MATCH (t:Troll)-[:POSTED]->(tw:Tweet)-[:MENTIONS]->(node)
WHERE node.location <> ""
RETURN node.location, COUNT(node.location) AS num
ORDER BY num DESC
LIMIT 10

MATCH (t:Troll)-[:POSTED]->(tw:Tweet)-[:CONTAINTS_ENITY]->(loc:Location)
//WHERE node.location <> ""
RETURN loc, COUNT(loc) AS num
ORDER BY num DESC
LIMIT 10

// 2. List 10 trolls that have been mentioned by the largest number of tweets.

MATCH (tw:Tweet)-[:MENTIONS]->(t2:Troll)
// WHERE t2.name <> ""
RETURN t2.screen_name, COUNT(t2) AS num
ORDER BY num DESC
LIMIT 10

// 3. List 10 trolls that have been mentioned by the largest number of users. 

MATCH (u:User)-[:POSTED]->(tw:Tweet)-[:MENTIONS]->(t2:Troll)
RETURN t2.screen_name, COUNT(distinct u) AS num
ORDER BY num DESC
LIMIT 10

// 4. List the number of tweets per month

MATCH (u:User)-[:POSTED]->(tw:Tweet)
WHERE tw.created_str <> ""
RETURN apoc.date.fields(tw.created_str, "yyyy-MM-dd HH:mm:ss").months as month     
     , apoc.date.fields(tw.created_str, "yyyy-MM-dd HH:mm:ss").years as year
     , count(*)
ORDER BY year, month

// 5. List the number of tweers per hour (24 results, one per hour), consider 
//    tweets only by users declaring location in USA, compare with Moscow 
//    business hours.

MATCH (u:User)-[:POSTED]->(tw:Tweet)
WHERE tw.created_str <> "" AND u.location = "USA"
RETURN apoc.date.fields(tw.created_str, "yyyy-MM-dd HH:mm:ss").hours as hour
     , count(*)
ORDER BY hour

// 6. Find the shortest path between the users: 
//    @realdonaldtrump and @hillaryclinton.

MATCH (t:User { user_key: 'realdonaldtrump' })
    , (h:User { user_key: 'hillaryclinton' })
    , p = shortestPath((t)-[*]-(h))
RETURN p

// 7. Extend the database with relationship of type :CITES between trolls: 
//    we say that a troll :CITES another troll if the former retweeted some
//    tweet(s) by the latter.

MATCH (t1:Troll)-[:POSTED]->(tw:Tweet)-[:RETWEETED]-
      (tw2:Tweet)<-[:POSTED]-(t2:Troll)
CREATE (t1)-[:CITES]->(t2)
//RETURN t1.user_key, t2.user_key

// 8. Use algo.labelPropagation algorithm to partition trolls into communities.
CALL apoc.algo.community(25, null,'partition','CITES','OUTGOING','weight',10000)

// 9. Find the most popular hashtags for each of the communities computed in 
//    the previous step

MATCH (t1:Troll)-[:POSTED]->(tw:Tweet)-[:HAS_TAG]->(ht:Hashtag)
WITH t1.partition as part, ht.tag as tg, count(tw) as cnt
WITH part, tg, max(cnt) as mcnt
RETURN part, max({_cnt : mcnt, tag: tg}).tag
ORDER BY part

// 10. Most popular hashtags in tweets (which mention HC) posted by trolls 

MATCH (t1:Troll)-[:POSTED]->(tw:Tweet)-[:HAS_TAG]->(ht:Hashtag)
MATCH (tw)-[:MENTIONS]-(h:User {user_key: "hillaryclinton"})
RETURN ht.tag, count(tw) AS cnt
ORDER BY cnt DESC