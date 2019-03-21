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
  `uid` INTEGER NULL DEFAULT NULL,
  `email` VARCHAR(50) NOT NULL DEFAULT 'NULL',
  `passwordhash` VARCHAR(100) NOT NULL DEFAULT 'NULL',
  `balance` INTEGER NULL DEFAULT NULL,
  PRIMARY KEY (`uid`)
);

-- ---
-- Table 'vendors'
-- 
-- ---

DROP TABLE IF EXISTS `vendors`;
		
CREATE TABLE `vendors` (
  `vid` INTEGER NULL DEFAULT NULL,
  `name` VARCHAR(50) NULL DEFAULT NULL,
  `open` INTEGER NULL DEFAULT 0,
  `contact_no` VARCHAR(50) NULL DEFAULT NULL,
  `photoURL` VARCHAR(500) NULL DEFAULT NULL,
  `passwordhash` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`vid`)
);

-- ---
-- Table 'orders'
-- 
-- ---

DROP TABLE IF EXISTS `orders`;
		
CREATE TABLE `orders` (
  `oid` INTEGER NULL DEFAULT NULL,
  `uid` INTEGER NULL DEFAULT NULL,
  `vid` INTEGER NULL DEFAULT NULL,
  `pid` INTEGER NULL DEFAULT NULL,
  `qty` INTEGER NULL DEFAULT NULL,
  `timestamp` TIMESTAMP NULL DEFAULT NULL,
  `status` INTEGER NULL DEFAULT NULL,
  PRIMARY KEY (`oid`,`pid`)
);

-- ---
-- Table 'products'
-- 
-- ---

DROP TABLE IF EXISTS `products`;
		
CREATE TABLE `products` (
  `pid` INTEGER NULL DEFAULT NULL,
  `vid` INTEGER NULL DEFAULT NULL,
  `name` VARCHAR(50) NULL DEFAULT NULL,
  `type` VARCHAR(50) NULL DEFAULT NULL,
  `description` VARCHAR(500) NULL DEFAULT NULL,
  `photoURL` VARCHAR(500) NULL DEFAULT NULL,
  `price` INTEGER NULL DEFAULT NULL,
  `est_time` INTEGER NULL DEFAULT NULL,
  `qty_left` INTEGER NULL DEFAULT NULL,
  PRIMARY KEY (`pid`)
);

-- ---
-- Foreign Keys 
-- ---

ALTER TABLE `orders` ADD FOREIGN KEY (uid) REFERENCES `users` (`uid`);
ALTER TABLE `orders` ADD FOREIGN KEY (vid) REFERENCES `vendors` (`vid`);
ALTER TABLE `orders` ADD FOREIGN KEY (pid) REFERENCES `products` (`pid`);
ALTER TABLE `products` ADD FOREIGN KEY (vid) REFERENCES `vendors` (`vid`);

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