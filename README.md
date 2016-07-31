# karma_c
KarmaSync to mysql for Database_c

DLC for Database_c https://github.com/habobababo/database_c
CREATE TABLE IF NOT EXISTS `karma` (
`id` smallint(5) unsigned NOT NULL,
  `steamid` bigint(20) unsigned NOT NULL,
  `karma` smallint(5) unsigned NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=latin1;

ALTER TABLE `karma`
 ADD PRIMARY KEY (`id`);
