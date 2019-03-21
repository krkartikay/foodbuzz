-- ---
-- Globals
-- ---

-- SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
-- SET FOREIGN_KEY_CHECKS=0;

-- ---
-- Table 'users'
-- 
-- ---

DROP TABLE IF EXISTS `users`;
		
CREATE TABLE `users` (
  `uid` INTEGER,
  `email` VARCHAR(50) NOT NULL DEFAULT 'NULL',
  `passwordhash` VARCHAR(100) NOT NULL DEFAULT 'NULL',
  `balance` INTEGER,
  PRIMARY KEY (`uid`)
);

-- ---
-- Table 'vendors'
-- 
-- ---

DROP TABLE IF EXISTS `vendors`;
		
CREATE TABLE `vendors` (
  `vid` INTEGER,
  `name` VARCHAR(50),
  `open` INTEGER NULL DEFAULT 0,
  `contact_no` VARCHAR(50),
  `photoURL` VARCHAR(500),
  `passwordhash` VARCHAR(100),
  PRIMARY KEY (`vid`)
);

-- ---
-- Table 'orders'
-- 
-- ---

DROP TABLE IF EXISTS `orders`;
		
CREATE TABLE `orders` (
  `oid` INTEGER,
  `uid` INTEGER,
  `vid` INTEGER,
  `pid` INTEGER,
  `qty` INTEGER,
  `timestamp` TIMESTAMP,
  `status` INTEGER,
  `totalprice` INTEGER,
  PRIMARY KEY (`oid`,`pid`)
);

-- ---
-- Table 'products'
-- 
-- ---

DROP TABLE IF EXISTS `products`;
		
CREATE TABLE `products` (
  `pid` INTEGER,
  `vid` INTEGER,
  `name` VARCHAR(50),
  `type` VARCHAR(50),
  `description` VARCHAR(500),
  `photoURL` VARCHAR(500),
  `price` INTEGER,
  `est_time` INTEGER,
  `qty_left` INTEGER,
  PRIMARY KEY (`pid`)
);

-- ---
-- Foreign Keys 
-- ---

-- ALTER TABLE `orders` ADD FOREIGN KEY (uid) REFERENCES `users` (`uid`);
-- ALTER TABLE `orders` ADD FOREIGN KEY (vid) REFERENCES `vendors` (`vid`);
-- ALTER TABLE `orders` ADD FOREIGN KEY (pid) REFERENCES `products` (`pid`);
-- ALTER TABLE `products` ADD FOREIGN KEY (vid) REFERENCES `vendors` (`vid`);

-- ---
-- Table Properties
-- ---

-- ALTER TABLE `users` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `vendors` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `orders` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
-- ALTER TABLE `products` ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- ---
-- Test Data
-- ---

-- INSERT INTO `users` (`uid`,`email`,`passwordhash`,`balance`) VALUES
-- ('','','','');
-- INSERT INTO `vendors` (`vid`,`name`,`open`,`contact_no`,`photoURL`,`passwordhash`) VALUES
-- ('','','','','','');
-- INSERT INTO `orders` (`oid`,`uid`,`vid`,`pid`,`qty`,`timestamp`,`status`) VALUES
-- ('','','','','','','');
-- INSERT INTO `products` (`pid`,`vid`,`name`,`description`,`photoURL`,`price`,`est_time`,`qty_left`) VALUES
-- ('','','','','','','','');