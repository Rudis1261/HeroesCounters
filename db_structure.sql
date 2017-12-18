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
  (4, 'percentile_damage', '% based damage', 50),
  (5, 'blind', 'Blinds', 50),
  (6, 'stasis', '(Stasis, Trapped, Eaten, VP, Temporal Loop, Root)', 50),
  (7, 'protected', 'Protected', 50),
  (8, 'cleanse', 'Cleanse', 50),
  (9, 'iceblock', 'Ice block', 50),
  (9, 'siege', 'Siege damage', 50),
  (10, 'invulnerable', 'Invulnerable', 50),
  (11, 'resets', 'Kill resets', 50),
  (12, 'unstoppable', 'Unstoppable', 50),
  (13, 'insivible', 'Invisible', 50),
  (14, 'reveal', 'Reveals', 50),
  (15, 'shield', 'Shields', 50),
  (16, 'blink', 'Blink', 50),
  (17, 'slow', 'Slows', 50),
  (18, 'stun', 'Stuns', 50),
  (19, 'jungler', 'Jungler', 50),
  (20, 'globe_quest', 'Globe Quest', 50);
  
  
  
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
  -- Ana
  (1, 1, 5),
  (2, 1, 6),
  -- Diablo
  (3, 3, 1),
  (4, 3, 4),
  (5, 3, 18),
  (5, 3, 20);
  
  
CREATE TABLE IF NOT EXISTS `hero_mobility` (
  `id` int(11) unsigned NOT NULL,
  `hero_id` int(11) unsigned NOT NULL,
  `mobility_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id`, `hero_id`, `mobility_id`)
) DEFAULT CHARSET=utf8;
-- hero mobility flat table
INSERT INTO `hero_mobility` (`id`, `hero_id`, `mobility_id`) VALUES
  -- Ana
  (1, 1, 1),
  -- Thrall
  (2, 2, 2),
  -- Diablo
  (3, 3, 3);
  
