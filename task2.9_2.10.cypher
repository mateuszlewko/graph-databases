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