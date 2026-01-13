/*
 Navicat Premium Data Transfer

 Source Server         : Mydata
 Source Server Type    : MariaDB
 Source Server Version : 101111 (10.11.11-MariaDB)
 Source Host           : localhost:3308
 Source Schema         : productdb

 Target Server Type    : MariaDB
 Target Server Version : 101111 (10.11.11-MariaDB)
 File Encoding         : 65001

 Date: 09/01/2026 10:25:15
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES (14, 'food', 'food');
INSERT INTO `category` VALUES (15, 'drink', 'drink');

-- ----------------------------
-- Table structure for product
-- ----------------------------
DROP TABLE IF EXISTS `product`;
CREATE TABLE `product`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `category_id` bigint(20) NULL DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `price` double NULL DEFAULT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `stock` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_category`(`category_id`) USING BTREE,
  CONSTRAINT `fk_product_category` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of product
-- ----------------------------

-- ----------------------------
-- Table structure for purchase_detail
-- ----------------------------
DROP TABLE IF EXISTS `purchase_detail`;
CREATE TABLE `purchase_detail`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `purchase_id` bigint(20) NOT NULL,
  `stock_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `stock_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `stock_price` decimal(15, 2) NULL DEFAULT NULL,
  `stock_quantity` int(11) NULL DEFAULT NULL,
  `subtotal` decimal(15, 2) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_purchase_id`(`purchase_id`) USING BTREE,
  CONSTRAINT `fk_purchase_detail_header` FOREIGN KEY (`purchase_id`) REFERENCES `purchase_header` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of purchase_detail
-- ----------------------------
INSERT INTO `purchase_detail` VALUES (7, 2, '001', 'INDOMIE GORENG', 5500.00, 1, 5500.00);
INSERT INTO `purchase_detail` VALUES (8, 2, '002', 'INDOMIE KARI AYAM', 4500.00, 1, 4500.00);

-- ----------------------------
-- Table structure for purchase_header
-- ----------------------------
DROP TABLE IF EXISTS `purchase_header`;
CREATE TABLE `purchase_header`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `number_po` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `po_date` datetime(6) NULL DEFAULT NULL,
  `supplier` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `total` decimal(15, 2) NULL DEFAULT NULL,
  `ppn` decimal(15, 2) NULL DEFAULT NULL,
  `grand_total` decimal(15, 2) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_number_po`(`number_po`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of purchase_header
-- ----------------------------
INSERT INTO `purchase_header` VALUES (2, 'P2024080001', '2024-08-17 04:43:36.000000', 'EKO', 100.00, 10.00, 110.00);

-- ----------------------------
-- Table structure for user_roles
-- ----------------------------
DROP TABLE IF EXISTS `user_roles`;
CREATE TABLE `user_roles`  (
  `user_id` bigint(20) NOT NULL,
  `role` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `roles` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`, `role`) USING BTREE,
  CONSTRAINT `user_roles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_roles
-- ----------------------------

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `email` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `password` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  `role` varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE,
  UNIQUE INDEX `email`(`email`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = latin1 COLLATE = latin1_swedish_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (4, 'admin', 'admin@example.com', '$2a$10$K.7/tDZ8seW7/SCafg5ANeOtzEotSWvIqgo/mLo4dlEt0p71ZYqAq', 'ROLE_USER');
INSERT INTO `users` VALUES (5, 'demo', 'demo@gmail.com', '$2a$10$04JniQCnBz7Uhlm0A.nclOO/NennxcPD5NN3CdAbg5cUqaOhT6c4y', 'ROLE_USER');
INSERT INTO `users` VALUES (6, 'michaell', 'michaell@gmail.com', '$2a$10$7uqJ7FDboQvUZXj7.0UZJ.xsxdFHjmavsc.sPXKIaxyTMbP5hX7dW', 'ROLE_USER');
INSERT INTO `users` VALUES (7, 'achan', 'achan@gmail.com', '$2a$10$Mp6AIxYsNTbUIU6SxA0OK.etGIyG.wAiqwZOce99tBtRW5Mvb8Gsu', 'ROLE_USER');

SET FOREIGN_KEY_CHECKS = 1;
