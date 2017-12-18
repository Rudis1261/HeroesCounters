CREATE TABLE IF NOT EXISTS `trait` (
  `id` int(11) unsigned NOT NULL,
  `name` varchar(200) NOT NULL,
  `label` varchar(250) NOT NULL,
  `weight` int(4) unsigned NOT NULL,
  PRIMARY KEY (`id`,`name`)
) DEFAULT CHARSET=utf8;
INSERT INTO `trait` (`id`, `name`, `label`, `weight`) VALUES
  (1, 'sustain', 'Sustain', 50),
  (2, 'auto_attack', 'Auto Attack', 50),
  (3, 'spell_damage', 'Spell Damage', 50),
  (4, 'tanky', "High health", 50),
  (5, 'percentile_damage', '% based damage', 50),
  (6, 'blind', 'Blinds', 50),
  (7, 'stasis', '(Stasis, Trapped, Eaten, VP, Temporal Loop, Root)', 50),
  (8, 'protected', 'Protected', 50),
  (9, 'cleanse', 'Cleanse', 50),
  (10, 'iceblock', 'Ice block', 50),
  (11, 'siege', 'Siege damage', 50),
  (12, 'invulnerable', 'Invulnerable', 50),
  (13, 'resets', 'Kill resets', 50),
  (14, 'unstoppable', 'Unstoppable', 50),
  (15, 'insivible', 'Invisible', 50),
  (16, 'reveal', 'Reveals', 50),
  (17, 'shield', 'Shields', 50),
  (18, 'blink', 'Blink', 50),
  (19, 'slow', 'Slows', 50),
  (20, 'stun', 'Stuns', 50),
  (21, 'jungler', 'Jungler', 50),
  (22, 'globe_quest', 'Globe Quest', 50),
  (23, 'ranged', 'Ranged', 50),
  (24, 'melee', 'Melee', 50);
  
  
  
CREATE TABLE IF NOT EXISTS `mobility` (
  `id` int(11) unsigned NOT NULL,
  `name` varchar(200) NOT NULL,
  `title` varchar(200) NOT NULL,
  `weight` int(4) unsigned NOT NULL,
  PRIMARY KEY (`id`,`name`)
) DEFAULT CHARSET=utf8;
INSERT INTO `mobility` (`id`, `name`, `title`, `weight`) VALUES
  (1, 'low', 'Low mobility', 30),
  (2, 'medium', 'Medium mobility', 50),
  (3, 'high', 'High mobility', 70);
  
  
  
CREATE TABLE IF NOT EXISTS `hero` (
  `id` int(11) unsigned NOT NULL,
  `slug` varchar(200) NOT NULL,
  `name` varchar(200) NOT NULL,
  PRIMARY KEY (`id`, `name`)
) DEFAULT CHARSET=utf8;
INSERT INTO `hero` (`id`, `slug`, `name`) VALUES
  (1, 'ana', 'Ana'),
  (2, 'thrall', 'Thrall'),
  (3, 'diablo', 'Diablo');
  
   
   
CREATE TABLE IF NOT EXISTS `hero_trait` (
  `id` int(11) unsigned NOT NULL,
  `hero_id` int(11) unsigned NOT NULL,
  `trait_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`, `hero_id`, `trait_id`)
) DEFAULT CHARSET=utf8;
-- hero trait flat table
INSERT INTO `hero_trait` (`id`, `hero_id`, `trait_id`) VALUES
  (1, 1, 5),
  (2, 1, 6),
  (3, 3, 1),
  (4, 3, 4),
  (5, 3, 18),
  (6, 3, 20),
  (7, 3, 22);
  
  
CREATE TABLE IF NOT EXISTS `hero_mobility` (
  `id` int(11) unsigned NOT NULL,
  `hero_id` int(11) unsigned NOT NULL,
  `mobility_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`, `hero_id`, `mobility_id`)
) DEFAULT CHARSET=utf8;
-- hero mobility flat table
INSERT INTO `hero_mobility` (`id`, `hero_id`, `mobility_id`) VALUES
  (1, 1, 1),
  (2, 2, 2),
  (3, 3, 3);
  
