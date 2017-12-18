-- http://sqlfiddle.com/#!9/8a1aa7/5/0
select * from `trait`;
select * from `mobility`;
select * from `hero`;
select * from `hero_trait`;

SELECT 
  h.*, 
  group_concat(ht.trait_id separator ',') as `traits`,
  sum(t.weight),
  (SELECT name FROM mobility WHERE id=m.id) as mobility
FROM 
  `hero` h 
LEFT JOIN 
  `hero_trait` ht 
ON 
  h.id=ht.hero_id
INNER JOIN
  `trait` t
ON
  ht.trait_id=t.id
INNER JOIN
  `hero_mobility` m
ON
  h.id=m.hero_id
GROUP by h.id
ORDER by h.name ASC
