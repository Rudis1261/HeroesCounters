select * from `trait`;
select * from `mobility`;
select * from `hero`;
select * from `hero_trait`;

SELECT 
  h.*, 
  group_concat(ht.trait_id separator ',') as `traits`,
  (SELECT name FROM mobility WHERE id=m.id)
FROM 
  `hero` h 
LEFT JOIN 
  `hero_trait` ht 
ON 
  h.id=ht.hero_id
LEFT JOIN
  `hero_mobility` m
ON
  h.id=m.hero_id
GROUP by h.id;
