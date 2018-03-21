// 1. List 10 locations that have been mentioned by the largest number of 
//    trolls.

MATCH (t:Troll)-[:POSTED]->(tw:Tweet)-[:MENTIONS]->(node)
WHERE node.location <> ""
RETURN node.location, COUNT(node.location) AS num
ORDER BY num DESC
LIMIT 10

// 2. List 10 trolls that have been mentioned by the largest number of tweets.

MATCH (tw:Tweet)-[:MENTIONS]->(t2:Troll)
WHERE t2.name <> ""
RETURN t2.name, COUNT(t2) AS num
ORDER BY num DESC
LIMIT 10

// 3. List 10 trolls that have been mentioned by the largest number of users. 

// ??
MATCH (u:User)-[:POSTED]->(tw:Tweet)-[:MENTIONS]->(t2:Troll)
WHERE t2.name <> ""
RETURN t2.name, COUNT(t2) AS num
ORDER BY num DESC
LIMIT 10

// 4. List the number of tweets per month

MATCH (u:User)-[:POSTED]->(tw:Tweet)
WHERE tw.created_str <> ""
RETURN apoc.date.fields(tw.created_str, "yyyy-MM-dd HH:mm:ss").months as month     
     , apoc.date.fields(tw.created_str, "yyyy-MM-dd HH:mm:ss").years as year
     , count(*)
ORDER BY year, month