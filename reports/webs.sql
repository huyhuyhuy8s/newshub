/*
 Navicat Premium Dump SQL

 Source Server         : local
 Source Server Type    : MySQL
 Source Server Version : 100134 (10.1.34-MariaDB)
 Source Host           : localhost:3306
 Source Schema         : web

 Target Server Type    : MySQL
 Target Server Version : 100134 (10.1.34-MariaDB)
 File Encoding         : 65001

 Date: 25/12/2024 21:25:27
*/
CREATE DATABASE web;
USE web;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for administrator
-- ----------------------------
DROP TABLE IF EXISTS `administrator`;
CREATE TABLE `administrator`  (
  `Id_Administrator` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Id_User` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`Id_Administrator`) USING BTREE,
  UNIQUE INDEX `Id_User`(`Id_User` ASC) USING BTREE,
  CONSTRAINT `administrator_ibfk_1` FOREIGN KEY (`Id_User`) REFERENCES `user` (`Id_User`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of administrator
-- ----------------------------
INSERT INTO `administrator` VALUES ('ADM0001', 'USR0001');

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `Id_Category` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Status` bit(1) NOT NULL,
  PRIMARY KEY (`Id_Category`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES ('CAT0000', 'default', b'0');
INSERT INTO `category` VALUES ('CAT0001', 'Thời sự', b'1');
INSERT INTO `category` VALUES ('CAT0002', 'Kinh doanh', b'1');
INSERT INTO `category` VALUES ('CAT0003', 'Khoa học', b'1');
INSERT INTO `category` VALUES ('CAT0004', 'Thể thao', b'1');
INSERT INTO `category` VALUES ('CAT0005', 'Giáo dục', b'1');
INSERT INTO `category` VALUES ('CAT0006', 'Đời sống', b'1');
INSERT INTO `category` VALUES ('CAT0007', 'Thế giới', b'1');
INSERT INTO `category` VALUES ('CAT0008', 'Bất động sản', b'1');
INSERT INTO `category` VALUES ('CAT0009', 'Giải trí', b'1');
INSERT INTO `category` VALUES ('CAT0010', 'Pháp luật', b'1');
INSERT INTO `category` VALUES ('CAT0011', 'Sức khỏe', b'1');
INSERT INTO `category` VALUES ('CAT0012', 'Du lịch', b'1');

-- ----------------------------
-- Table structure for comment
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment`  (
  `Id_Comment` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Id_User` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Id_News` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Time` datetime NULL DEFAULT NULL,
  `Comment` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  PRIMARY KEY (`Id_Comment`) USING BTREE,
  INDEX `Id_User`(`Id_User` ASC) USING BTREE,
  INDEX `Id_News`(`Id_News` ASC) USING BTREE,
  CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`Id_User`) REFERENCES `user` (`Id_User`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`Id_News`) REFERENCES `news` (`Id_News`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of comment
-- ----------------------------
INSERT INTO `comment` VALUES ('CMT000015', 'USR0003', 'NEWS0008', '2024-12-08 15:23:45', 'Bài viết xuất sắc! Tiếp tục phát huy nhé.');
INSERT INTO `comment` VALUES ('CMT000016', 'USR0004', 'NEWS0008', '2024-12-08 16:12:23', 'Tôi đã học được điều gì đó mới hôm nay.');
INSERT INTO `comment` VALUES ('CMT000017', 'USR0001', 'NEWS0009', '2024-02-07 09:45:56', 'Đây là một bài đọc cần thiết cho mọi người!');
INSERT INTO `comment` VALUES ('CMT000018', 'USR0002', 'NEWS0009', '2024-02-07 10:23:12', 'Tôi đánh giá cao nghiên cứu phía sau bài viết này.');
INSERT INTO `comment` VALUES ('CMT000021', 'USR0005', 'NEWS0010', '2024-02-05 11:23:56', 'Một bài viết rất chi tiết và sâu sắc!');
INSERT INTO `comment` VALUES ('CMT000022', 'USR0006', 'NEWS0011', '2024-02-05 12:45:23', 'Tôi rất thích cách tiếp cận của tác giả về vấn đề này.');
INSERT INTO `comment` VALUES ('CMT000023', 'USR0007', 'NEWS0012', '2024-02-04 16:34:12', 'Thông tin rất bổ ích, giúp tôi hiểu rõ hơn về chủ đề.');
INSERT INTO `comment` VALUES ('CMT000072', 'USR0006', 'NEWS0061', '2024-12-01 10:25:00', 'Tôi hoàn toàn đồng tình với những phân tích.');
INSERT INTO `comment` VALUES ('CMT000073', 'USR0007', 'NEWS0062', '2024-12-01 10:30:00', 'Thông tin này giúp tôi mở rộng tầm nhìn.');
INSERT INTO `comment` VALUES ('CMT000074', 'USR0008', 'NEWS0063', '2024-12-01 10:35:00', 'Rất cảm ơn về những góc nhìn sáng tạo.');
INSERT INTO `comment` VALUES ('CMT000075', 'USR0009', 'NEWS0064', '2024-12-01 10:40:00', 'Một bài viết thực sự đáng để nghiên cứu.');
INSERT INTO `comment` VALUES ('CMT000083', 'USR0007', 'NEWS0008', '2024-12-01 11:20:00', 'Thông tin này giúp tôi hiểu sâu hơn.');
INSERT INTO `comment` VALUES ('CMT000084', 'USR0008', 'NEWS0009', '2024-12-01 11:25:00', 'Rất cảm ơn về những phân tích sâu sắc.');
INSERT INTO `comment` VALUES ('CMT000085', 'USR0009', 'NEWS0010', '2024-12-01 11:30:00', 'Một bài viết thực sự đáng để suy ngẫm.');
INSERT INTO `comment` VALUES ('CMT000086', 'USR0010', 'NEWS0011', '2024-12-01 11:35:00', 'Tôi rất thích cách trình bày khoa học.');
INSERT INTO `comment` VALUES ('CMT000087', 'USR0001', 'NEWS0012', '2024-12-01 11:40:00', 'Thông tin này thực sự rất bổ ích.');
INSERT INTO `comment` VALUES ('CMT000088', 'USR0001', 'NEWS0208', '2024-12-25 21:20:56', 'Bài viết cung cấp nhiều kiến thức bổ ích');
INSERT INTO `comment` VALUES ('CMT000089', 'USR0008', 'NEWS0208', '2024-12-25 21:21:26', 'Bài viết bổ ích');

-- ----------------------------
-- Table structure for editor
-- ----------------------------
DROP TABLE IF EXISTS `editor`;
CREATE TABLE `editor`  (
  `Id_Editor` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Id_User` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Id_Category` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`Id_Editor`) USING BTREE,
  UNIQUE INDEX `Id_User`(`Id_User` ASC) USING BTREE,
  INDEX `Id_Category`(`Id_Category` ASC) USING BTREE,
  CONSTRAINT `editor_ibfk_1` FOREIGN KEY (`Id_User`) REFERENCES `user` (`Id_User`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `editor_ibfk_2` FOREIGN KEY (`Id_Category`) REFERENCES `category` (`Id_Category`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of editor
-- ----------------------------
INSERT INTO `editor` VALUES ('DEFAULT', 'USR0000', 'CAT0000');
INSERT INTO `editor` VALUES ('EDT0001', 'USR0002', 'CAT0001');
INSERT INTO `editor` VALUES ('EDT0002', 'USR0003', 'CAT0002');
INSERT INTO `editor` VALUES ('EDT0003', 'USR0004', 'CAT0003');
INSERT INTO `editor` VALUES ('EDT0004', 'USR0005', 'CAT0004');

-- ----------------------------
-- Table structure for editor_check_news
-- ----------------------------
DROP TABLE IF EXISTS `editor_check_news`;
CREATE TABLE `editor_check_news`  (
  `Id_Editor` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `Id_News` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `Reason` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Date_feedback` date NULL DEFAULT NULL,
  INDEX `Id_Editor`(`Id_Editor` ASC) USING BTREE,
  INDEX `Id_News`(`Id_News` ASC) USING BTREE,
  CONSTRAINT `editor_check_news_ibfk_1` FOREIGN KEY (`Id_Editor`) REFERENCES `editor` (`Id_Editor`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `editor_check_news_ibfk_2` FOREIGN KEY (`Id_News`) REFERENCES `news` (`Id_News`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of editor_check_news
-- ----------------------------

-- ----------------------------
-- Table structure for list_deleted_news
-- ----------------------------
DROP TABLE IF EXISTS `list_deleted_news`;
CREATE TABLE `list_deleted_news`  (
  `Id_SubCategory` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `Id_Writer` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `Id_Status` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Id_News` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Date` datetime NOT NULL,
  `Comments` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `Premium` bit(1) NULL DEFAULT NULL,
  `Views` int NULL DEFAULT NULL,
  `Content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `Image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `Title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Meta_title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Meta_description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`Id_News`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of list_deleted_news
-- ----------------------------

-- ----------------------------
-- Table structure for news
-- ----------------------------
DROP TABLE IF EXISTS `news`;
CREATE TABLE `news`  (
  `Id_SubCategory` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `Id_Writer` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `Id_Status` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Id_News` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Date` datetime NOT NULL,
  `Comments` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `Premium` bit(1) NULL DEFAULT NULL,
  `Views` int NULL DEFAULT NULL,
  `Content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL,
  `Image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `Title` varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Meta_title` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Meta_description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`Id_News`) USING BTREE,
  INDEX `Id_SubCategory`(`Id_SubCategory` ASC) USING BTREE,
  INDEX `Id_Writer`(`Id_Writer` ASC) USING BTREE,
  INDEX `Id_Status`(`Id_Status` ASC) USING BTREE,
  FULLTEXT INDEX `Title`(`Title`, `Content`, `Meta_title`, `Meta_description`),
  CONSTRAINT `news_ibfk_1` FOREIGN KEY (`Id_SubCategory`) REFERENCES `subcategory` (`Id_SubCategory`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `news_ibfk_2` FOREIGN KEY (`Id_Writer`) REFERENCES `writer` (`Id_Writer`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `news_ibfk_3` FOREIGN KEY (`Id_Status`) REFERENCES `status_of_news` (`Id_Status`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of news
-- ----------------------------
INSERT INTO `news` VALUES ('SUB0001', 'WRT0001', 'STS0001', 'NEWS0001', '2024-12-25 20:28:44', 'Bài viết hay!', b'0', 15041069, '<p>Tr&iacute; tuệ nh&acirc;n tạo đang trở th&agrave;nh một phần kh&ocirc;ng thể thiếu trong việc quản l&yacute; quốc gia, hỗ trợ ch&iacute;nh phủ tối ưu h&oacute;a c&aacute;c nguồn lực v&agrave; cải thiện qu&aacute; tr&igrave;nh ra quyết định.</p>', 'filename-1735133324461.png', 'Vai trò của AI trong quản lý quốc gia', 'AI hỗ trợ cải thiện quản trị quốc gia', 'Bài viết phân tích cách AI hỗ trợ chính phủ cải thiện quản trị, từ quản lý nguồn lực đến quy hoạch đô thị thông minh.');
INSERT INTO `news` VALUES ('SUB0001', 'WRT0002', 'STS0001', 'NEWS0002', '2024-12-19 00:00:00', 'Bài viết rất hay!', b'1', 493, 'Trong chính trị hiện đại, trí tuệ nhân tạo đang được sử dụng để phân tích dữ liệu cử tri, dự đoán kết quả bầu cử và xây dựng các chiến lược chính trị hiệu quả hơn.', 'filename-1735047727225.jpg', 'Ứng dụng AI trong chiến lược chính trị hiện đại', 'AI và chiến lược chính trị hiện đại', 'AI đang thay đổi cách các chiến dịch chính trị được lên kế hoạch và thực hiện, mang lại hiệu quả vượt trội.');
INSERT INTO `news` VALUES ('SUB0001', 'WRT0003', 'STS0001', 'NEWS0003', '2024-12-19 00:00:00', 'Bài viết hay và ý nghĩa!', b'0', 450, 'Trong chính trị quốc tế, trí tuệ nhân tạo đang hỗ trợ việc dự đoán khủng hoảng, thúc đẩy đối thoại hòa bình và xây dựng quan hệ ngoại giao bền vững.', 'filename-1735047727225.jpg', 'AI và ngoại giao: Tương lai của đối thoại toàn cầu', 'Vai trò của AI trong ngoại giao quốc tế', 'Khám phá cách trí tuệ nhân tạo đang hỗ trợ các nhà ngoại giao trong việc xây dựng mối quan hệ quốc tế bền vững.');
INSERT INTO `news` VALUES ('SUB0001', 'WRT0004', 'STS0001', 'NEWS0004', '2024-12-20 00:00:00', 'Bài viết rất ý nghĩa!', b'0', 463, 'Chính phủ các nước đang tận dụng trí tuệ nhân tạo để phát hiện và ngăn chặn các mối đe dọa an ninh mạng, bảo vệ dữ liệu và duy trì ổn định quốc gia.', 'filename-1735047727225.jpg', 'Bảo mật quốc gia trong kỷ nguyên AI', 'AI và an ninh mạng quốc gia', 'AI đang trở thành công cụ quan trọng để đảm bảo an ninh quốc gia trước các mối đe dọa ngày càng gia tăng.');
INSERT INTO `news` VALUES ('SUB0001', 'WRT0001', 'STS0001', 'NEWS0005', '2024-12-21 00:00:00', 'Bài viết có nội dung thú vị!', b'1', 473, 'Trí tuệ nhân tạo trong chính trị đang cải thiện tính minh bạch và trách nhiệm giải trình, giúp củng cố các hệ thống dân chủ và nâng cao niềm tin của người dân.', 'filename-1735047727225.jpg', 'AI và dân chủ: Minh bạch và trách nhiệm giải trình', 'Trí tuệ nhân tạo và sự phát triển dân chủ', 'Khám phá vai trò của AI trong việc tăng cường tính minh bạch và trách nhiệm trong các hệ thống chính trị dân chủ.');
INSERT INTO `news` VALUES ('SUB0001', 'WRT0002', 'STS0001', 'NEWS0006', '2024-12-21 00:00:00', 'Cảm ơn tác giả vì bài viết!', b'1', 494, 'Ở các quốc gia đang phát triển, trí tuệ nhân tạo đang hỗ trợ việc phân bổ nguồn lực công bằng và nâng cao chất lượng quản lý nhà nước.', 'filename-1735047727225.jpg', 'Trí tuệ nhân tạo ở các quốc gia đang phát triển', 'Vai trò của AI trong quản lý tài nguyên quốc gia', 'AI đang thay đổi cách các quốc gia đang phát triển quản lý tài nguyên, từ nông nghiệp đến y tế.');
INSERT INTO `news` VALUES ('SUB0001', 'WRT0003', 'STS0001', 'NEWS0007', '2024-12-21 00:00:00', 'Bài viết cung cấp thông tin hữu ích!', b'0', 441, 'Các hệ thống AI đang được áp dụng trong việc giám sát các cuộc xung đột và đưa ra cảnh báo sớm, giúp giảm thiểu thiệt hại.', 'filename-1735047727225.jpg', 'AI và vai trò trong quản lý xung đột', 'Quản lý xung đột bằng trí tuệ nhân tạo', 'AI đang giúp giảm thiểu xung đột toàn cầu thông qua giám sát và cảnh báo sớm.');
INSERT INTO `news` VALUES ('SUB0001', 'WRT0004', 'STS0001', 'NEWS0008', '2024-12-25 00:00:00', 'Great article on politics!', b'0', 431, 'Political dynamics are fascinating.', 'filename-1735047727225.jpg', 'Những biến động chính trị hiện nay', 'Phân tích các yếu tố ảnh hưởng đến chính trị toàn cầu', 'Chính trị toàn cầu đang chứng kiến nhiều biến động lớn. Bài viết này sẽ phân tích các yếu tố đang ảnh hưởng mạnh mẽ đến các chính sách chính trị, từ chiến tranh, căng thẳng quốc tế đến các thay đổi trong chính quyền các quốc gia.');
INSERT INTO `news` VALUES ('SUB0001', 'WRT0001', 'STS0001', 'NEWS0009', '2024-12-29 00:00:00', 'Great article on political advancements!', b'0', 430, 'Political advancements are fascinating.', 'filename-1735047727225.jpg', 'Các tiến bộ trong chính trị toàn cầu', 'Sự thay đổi trong các hệ thống chính trị quốc gia', 'Bài viết này sẽ tìm hiểu về các tiến bộ và cải cách chính trị đang diễn ra tại các quốc gia, bao gồm những thay đổi trong các hệ thống chính trị, cải cách pháp lý và các phong trào chính trị nổi bật.');
INSERT INTO `news` VALUES ('SUB0001', 'WRT0002', 'STS0001', 'NEWS0010', '2025-01-01 00:00:00', 'Great article on political issues!', b'0', 6, 'Political issues are fascinating.', 'filename-1735047727225.jpg', 'Những vấn đề chính trị nổi bật hiện nay', 'Các vấn đề nóng bỏng trong chính trị toàn cầu', 'Bài viết này sẽ phân tích các vấn đề chính trị lớn đang thu hút sự chú ý toàn cầu, bao gồm các cuộc bầu cử, xung đột quốc tế, và các vấn đề về quyền con người.');
INSERT INTO `news` VALUES ('SUB0001', 'WRT0003', 'STS0001', 'NEWS0011', '2025-01-02 00:00:00', 'Great article on political ideologies!', b'0', 421, 'Political ideologies are fascinating.', 'filename-1735047727225.jpg', 'Những tư tưởng chính trị quan trọng', 'Các hệ tư tưởng chính trị ảnh hưởng đến thế giới hiện đại', 'Trong bài viết này, chúng ta sẽ tìm hiểu về những hệ tư tưởng chính trị lớn, từ chủ nghĩa tự do, chủ nghĩa xã hội đến chủ nghĩa bảo thủ, và cách chúng ảnh hưởng đến chính sách quốc gia và quốc tế.');
INSERT INTO `news` VALUES ('SUB0001', 'WRT0004', 'STS0001', 'NEWS0012', '2025-01-02 00:00:00', 'Great article on political trends!', b'0', 4, 'Political trends are fascinating.', 'filename-1735047727225.jpg', 'Các xu hướng chính trị toàn cầu', 'Các xu hướng chính trị nổi bật trên thế giới', 'Chúng ta đang chứng kiến sự thay đổi mạnh mẽ trong các xu hướng chính trị toàn cầu. Bài viết này sẽ phân tích các xu hướng quan trọng, từ phong trào chính trị mới đến sự thay đổi trong các đảng phái và chính sách toàn cầu.');
INSERT INTO `news` VALUES ('SUB0002', 'WRT0001', 'STS0001', 'NEWS0013', '2024-12-19 00:00:00', 'Bài viết tuyệt vời!', b'0', 501, 'Xã hội đang phát triển với những thách thức và cơ hội mới.', 'filename-1735047727225.jpg', 'Vấn đề xã hội', 'Vấn đề xã hội', 'Những thách thức xã hội đang định hình tương lai.');
INSERT INTO `news` VALUES ('SUB0002', 'WRT0002', 'STS0001', 'NEWS0014', '2024-12-20 00:00:00', 'Bài viết tuyệt vời!', b'0', 495, 'Nhận thức xã hội đang gia tăng trên toàn cầu.', 'filename-1735047727225.jpg', 'Nhận thức xã hội', 'Nhận thức xã hội', 'Ảnh hưởng của mạng xã hội đến nhận thức và sự thay đổi trong xã hội.');
INSERT INTO `news` VALUES ('SUB0002', 'WRT0003', 'STS0001', 'NEWS0015', '2024-12-22 00:00:00', 'Bài viết tuyệt vời!', b'0', 501, 'Sức mạnh của các phong trào xã hội trong việc thúc đẩy sự thay đổi.', 'filename-1735047727225.jpg', 'Phong trào xã hội', 'Phong trào xã hội', 'Các phong trào xã hội tiếp tục thúc đẩy công lý xã hội.');
INSERT INTO `news` VALUES ('SUB0002', 'WRT0004', 'STS0001', 'NEWS0016', '2024-12-20 00:00:00', 'Bài viết tuyệt vời!', b'0', 467, 'Vai trò của cộng đồng trong việc xây dựng sự đoàn kết xã hội.', 'filename-1735047727225.jpg', 'Tác động cộng đồng', 'Tác động cộng đồng', 'Nỗ lực cộng đồng là chìa khóa để xây dựng một xã hội vững mạnh hơn.');
INSERT INTO `news` VALUES ('SUB0002', 'WRT0001', 'STS0001', 'NEWS0017', '2024-12-28 00:00:00', 'Bài viết tuyệt vời!', b'0', 470, 'Bất bình đẳng xã hội vẫn tồn tại mặc dù có những nỗ lực giảm thiểu.', 'filename-1735047727225.jpg', 'Bất bình đẳng xã hội', 'Bất bình đẳng xã hội', 'Bất bình đẳng tiếp tục là một thách thức lớn đối với xã hội.');
INSERT INTO `news` VALUES ('SUB0002', 'WRT0002', 'STS0001', 'NEWS0018', '2025-01-02 00:00:00', 'Bài viết tuyệt vời!', b'0', 480, 'Chính sách xã hội cần thay đổi theo thời gian.', 'filename-1735047727225.jpg', 'Chính sách xã hội', 'Chính sách xã hội', 'Cập nhật chính sách xã hội để đáp ứng các nhu cầu xã hội mới.');
INSERT INTO `news` VALUES ('SUB0002', 'WRT0003', 'STS0001', 'NEWS0019', '2025-01-01 00:00:00', 'Bài viết tuyệt vời!', b'0', 440, 'Giới trẻ đang dẫn đầu trong các phong trào xã hội.', 'filename-1735047727225.jpg', 'Phong trào thanh niên', 'Phong trào thanh niên', 'Giới trẻ đang tạo ra một làn sóng mới trong các phong trào xã hội.');
INSERT INTO `news` VALUES ('SUB0002', 'WRT0004', 'STS0001', 'NEWS0020', '2025-01-02 00:00:00', 'Bài viết tuyệt vời!', b'0', 436, 'Vai trò của công nghệ trong việc kết nối xã hội.', 'filename-1735047727225.jpg', 'Mạng xã hội', 'Mạng xã hội', 'Ảnh hưởng của mạng xã hội trong việc hình thành các chuẩn mực xã hội.');
INSERT INTO `news` VALUES ('SUB0002', 'WRT0001', 'STS0001', 'NEWS0021', '2025-01-01 00:00:00', 'Bài viết tuyệt vời!', b'0', 430, 'Vai trò của gia đình và truyền thống trong xã hội hiện đại.', 'filename-1735047727225.jpg', 'Gia đình và Truyền thống', 'Gia đình và Truyền thống', 'Cấu trúc gia đình đang thay đổi trước những thách thức hiện đại.');
INSERT INTO `news` VALUES ('SUB0002', 'WRT0002', 'STS0001', 'NEWS0022', '2024-12-26 00:00:00', 'Bài viết tuyệt vời!', b'0', 8, 'Phát triển xã hội khác nhau giữa các nền văn hóa.', 'filename-1735047727225.jpg', 'Xã hội toàn cầu', 'Xã hội toàn cầu', 'Sự khác biệt văn hóa đóng vai trò quan trọng trong việc hình thành sự phát triển xã hội.');
INSERT INTO `news` VALUES ('SUB0002', 'WRT0003', 'STS0001', 'NEWS0023', '2024-12-26 00:00:00', 'Bài viết tuyệt vời!', b'0', 3, 'Khởi nghiệp xã hội đang thay đổi cách chúng ta nhìn nhận kinh doanh.', 'filename-1735047727225.jpg', 'Khởi nghiệp xã hội', 'Khởi nghiệp xã hội', 'Kinh doanh có thể tạo ra ảnh hưởng lớn đối với xã hội thông qua khởi nghiệp xã hội.');
INSERT INTO `news` VALUES ('SUB0002', 'WRT0004', 'STS0001', 'NEWS0024', '2024-12-27 00:00:00', 'Bài viết tuyệt vời!', b'0', 2, 'Sự thay đổi của các chuẩn mực xã hội trong thời đại số.', 'filename-1735047727225.jpg', 'Xã hội số', 'Xã hội số', 'Cách mà thời đại số đang ảnh hưởng đến hành vi xã hội.');
INSERT INTO `news` VALUES ('SUB0003', 'WRT0001', 'STS0001', 'NEWS0025', '2024-12-26 00:00:00', 'Great article on the economy!', b'0', 499, 'Economic advancements are fascinating.', 'filename-1735047727225.jpg', 'Những tiến bộ kinh tế đáng chú ý', 'Sự phát triển kinh tế trong thời đại mới', 'Kinh tế thế giới đang trải qua những thay đổi mạnh mẽ với những tiến bộ đáng chú ý. Bài viết này phân tích các xu hướng kinh tế nổi bật, từ sự chuyển dịch trong các ngành công nghiệp đến các tác động của công nghệ và toàn cầu hóa.');
INSERT INTO `news` VALUES ('SUB0003', 'WRT0002', 'STS0001', 'NEWS0026', '2025-01-02 00:00:00', 'Great article on economic trends!', b'1', 10, 'Global economy fascinating.', 'filename-1735047727225.jpg', 'Những xu hướng nổi bật trong nền kinh tế toàn cầu', 'Những xu hướng kinh tế ảnh hưởng toàn cầu', 'Sự phát triển của nền kinh tế toàn cầu đang chịu sự ảnh hưởng mạnh mẽ của các yếu tố như công nghệ, biến đổi khí hậu, và các chính sách tài chính quốc gia. Bài viết này sẽ đi sâu vào những xu hướng nổi bật trong nền kinh tế hiện đại.');
INSERT INTO `news` VALUES ('SUB0003', 'WRT0003', 'STS0001', 'NEWS0027', '2024-12-24 00:00:00', 'Great article on economic challenges!', b'0', 250, 'Economic growth challenges.', 'filename-1735047727225.jpg', 'Những thách thức đối với sự tăng trưởng kinh tế toàn cầu', 'Những khó khăn trong việc duy trì tăng trưởng kinh tế', 'Trong bối cảnh nền kinh tế toàn cầu có sự biến động mạnh mẽ, việc duy trì tăng trưởng là một thách thức lớn. Bài viết này sẽ thảo luận về những vấn đề chính như lạm phát, suy thoái và các cuộc khủng hoảng tài chính toàn cầu.');
INSERT INTO `news` VALUES ('SUB0003', 'WRT0004', 'STS0001', 'NEWS0028', '2024-12-24 00:00:00', 'Great article on economic shifts!', b'1', 160, 'Economic shifts fascinating.', 'filename-1735047727225.jpg', 'Những sự chuyển biến lớn trong nền kinh tế toàn cầu', 'Tác động của các thay đổi lớn trong nền kinh tế', 'Nền kinh tế toàn cầu đang chứng kiến những chuyển biến lớn do sự thay đổi trong chính sách tài chính, công nghệ, và các yếu tố môi trường. Bài viết sẽ phân tích các sự thay đổi này và ảnh hưởng của chúng đối với nền kinh tế quốc gia và khu vực.');
INSERT INTO `news` VALUES ('SUB0003', 'WRT0001', 'STS0001', 'NEWS0029', '2024-12-28 00:00:00', 'Great article on economic growth!', b'0', 88, 'Economic advancements are fascinating.', 'filename-1735047727225.jpg', 'Những bước tiến trong phát triển kinh tế', 'Những thành tựu đáng chú ý trong phát triển kinh tế', 'Bài viết này điểm qua các bước tiến lớn trong phát triển kinh tế, từ các sáng kiến trong công nghiệp đến các chính sách kích thích tăng trưởng. Cùng nhìn lại những thành tựu quan trọng trong nền kinh tế thế giới và cách thức chúng góp phần thay đổi cuộc sống.');
INSERT INTO `news` VALUES ('SUB0003', 'WRT0002', 'STS0001', 'NEWS0030', '2024-12-21 00:00:00', 'Great article on economic policies!', b'1', 109, 'AI fascinating.', 'filename-1735047727225.jpg', 'Các chính sách kinh tế quan trọng hiện nay', 'Chính sách và chiến lược kinh tế đột phá', 'Bài viết này tập trung vào những chính sách kinh tế quan trọng và các chiến lược phát triển bền vững của các quốc gia trong việc điều tiết nền kinh tế toàn cầu, bao gồm các biện pháp chống lại khủng hoảng và thúc đẩy đầu tư.');
INSERT INTO `news` VALUES ('SUB0003', 'WRT0003', 'STS0001', 'NEWS0031', '2024-12-24 00:00:00', 'Great article on economic sustainability!', b'0', 45, 'Sustainable economy fascinating.', 'filename-1735047727225.jpg', 'Tính bền vững trong nền kinh tế toàn cầu', 'Bảo vệ môi trường và tăng trưởng kinh tế bền vững', 'Sự kết hợp giữa bảo vệ môi trường và tăng trưởng kinh tế là yếu tố quan trọng để phát triển một nền kinh tế bền vững. Bài viết này sẽ khám phá các sáng kiến và chính sách nhằm đạt được sự cân bằng giữa phát triển kinh tế và bảo vệ môi trường.');
INSERT INTO `news` VALUES ('SUB0003', 'WRT0004', 'STS0001', 'NEWS0032', '2024-12-27 00:00:00', 'Great article on economic crises!', b'1', 460, 'Economic crises fascinating.', 'filename-1735047727225.jpg', 'Những cuộc khủng hoảng kinh tế lớn trong lịch sử', 'Phân tích các cuộc khủng hoảng kinh tế và bài học rút ra', 'Khủng hoảng kinh tế đã và đang gây ảnh hưởng đến mọi quốc gia. Bài viết này sẽ tìm hiểu các cuộc khủng hoảng kinh tế lớn trong lịch sử và những bài học kinh nghiệm từ những cuộc khủng hoảng đó.');
INSERT INTO `news` VALUES ('SUB0003', 'WRT0001', 'STS0001', 'NEWS0033', '2024-12-27 00:00:00', 'Great article on financial markets!', b'0', 8, 'Financial markets fascinating.', 'filename-1735047727225.jpg', 'Những thay đổi trong thị trường tài chính toàn cầu', 'Phân tích các xu hướng mới trong thị trường tài chính quốc tế', 'Bài viết này sẽ tập trung vào các thay đổi trong thị trường tài chính toàn cầu, từ sự xuất hiện của các công nghệ mới đến những tác động của chính sách tài chính quốc gia.');
INSERT INTO `news` VALUES ('SUB0003', 'WRT0002', 'STS0001', 'NEWS0034', '2024-12-29 00:00:00', 'Great article on global economy!', b'1', 9, 'Global economy fascinating.', 'filename-1735047727225.jpg', 'Tác động của nền kinh tế toàn cầu', 'Những ảnh hưởng của nền kinh tế toàn cầu đối với các quốc gia', 'Sự phụ thuộc lẫn nhau giữa các quốc gia trong nền kinh tế toàn cầu khiến các quốc gia phải đối mặt với nhiều vấn đề chung. Bài viết này sẽ phân tích tác động của nền kinh tế toàn cầu đối với các quốc gia và các yếu tố thúc đẩy sự thay đổi.');
INSERT INTO `news` VALUES ('SUB0003', 'WRT0003', 'STS0001', 'NEWS0035', '2025-01-02 00:00:00', 'Great article on future economy!', b'0', 107, 'Future economy fascinating.', 'filename-1735047727225.jpg', 'Tương lai của nền kinh tế toàn cầu', 'Dự báo và xu hướng phát triển nền kinh tế tương lai', 'Bài viết này sẽ đưa ra những dự báo về tương lai của nền kinh tế toàn cầu, bao gồm những thay đổi trong công nghệ, biến đổi khí hậu và sự thay đổi trong các chính sách tài chính quốc gia.');
INSERT INTO `news` VALUES ('SUB0003', 'WRT0004', 'STS0001', 'NEWS0036', '2025-01-01 00:00:00', 'Great article on economic development!', b'0', 111, 'Economic development fascinating.', 'filename-1735047727225.jpg', 'Phát triển kinh tế ở các quốc gia đang phát triển', 'Thúc đẩy phát triển kinh tế tại các quốc gia đang phát triển', 'Bài viết này sẽ thảo luận về các chiến lược phát triển kinh tế tại các quốc gia đang phát triển, tập trung vào các biện pháp cần thiết để thúc đẩy nền kinh tế và giảm thiểu sự chênh lệch phát triển.');
INSERT INTO `news` VALUES ('SUB0004', 'WRT0001', 'STS0001', 'NEWS0037', '2024-12-25 00:00:00', 'Bài viết tuyệt vời!', b'0', 490, 'Các tiến bộ về AI đang tạo ra những ảnh hưởng mạnh mẽ trong mọi lĩnh vực, bao gồm cả nghệ thuật và văn hóa.', 'filename-1735047727225.jpg', 'AI và sự phát triển văn hóa', 'AI và sự phát triển văn hóa', 'AI đang thay đổi cách chúng ta tương tác và sáng tạo trong lĩnh vực nghệ thuật và văn hóa.');
INSERT INTO `news` VALUES ('SUB0004', 'WRT0002', 'STS0001', 'NEWS0038', '2024-12-25 21:01:45', 'Bài viết tuyệt vời!', b'1', 100011, '<p>Văn h&oacute;a nghệ thuật đang ph&aacute;t triển với sự kết hợp của truyền thống v&agrave; đổi mới.</p>', 'filename-1735135305125.jpg', 'Nghệ thuật truyền thống và hiện đại', 'Nghệ thuật truyền thống và hiện đại', 'Văn hóa truyền thống và nghệ thuật hiện đại đang có sự giao thoa mạnh mẽ trong thế giới đương đại.');
INSERT INTO `news` VALUES ('SUB0004', 'WRT0003', 'STS0001', 'NEWS0039', '2024-12-25 20:45:22', 'Bài viết rất thú vị!', b'0', 11576, '<p>Nghệ thuật hiện đại đang thử nghiệm với c&aacute;c h&igrave;nh thức s&aacute;ng tạo mới.</p>', 'filename-1735134322077.jpg', 'Tác phẩm nghệ thuật đương đại', 'Tác phẩm nghệ thuật đương đại', 'Nghệ thuật đương đại không chỉ là sự sáng tạo mà còn là phản ánh của xã hội và công nghệ.');
INSERT INTO `news` VALUES ('SUB0004', 'WRT0004', 'STS0001', 'NEWS0040', '2024-12-22 00:00:00', 'Bài viết xuất sắc!', b'0', 99, 'Các phương pháp sáng tạo trong nghệ thuật đương đại đang thay đổi nhanh chóng.', 'filename-1735047727225.jpg', 'Phương pháp sáng tạo trong nghệ thuật đương đại', 'Phương pháp sáng tạo trong nghệ thuật đương đại', 'Những phương pháp sáng tạo trong nghệ thuật đương đại đang thay đổi cách chúng ta nhìn nhận về nghệ thuật và sáng tạo.');
INSERT INTO `news` VALUES ('SUB0004', 'WRT0001', 'STS0001', 'NEWS0041', '2024-12-23 00:00:00', 'Bài viết tuyệt vời!', b'1', 70, 'Văn hóa nghệ thuật đang trải qua sự thay đổi mạnh mẽ từ ảnh hưởng của công nghệ.', 'filename-1735047727225.jpg', 'Văn hóa và công nghệ', 'Văn hóa và công nghệ', 'Công nghệ đang thay đổi không chỉ cách chúng ta sống mà còn cách chúng ta sáng tạo và thưởng thức nghệ thuật.');
INSERT INTO `news` VALUES ('SUB0004', 'WRT0002', 'STS0001', 'NEWS0042', '2024-12-29 00:00:00', 'Bài viết rất thú vị!', b'0', 80, 'Văn hóa truyền thống và hiện đại có thể tồn tại song song và phát triển mạnh mẽ.', 'filename-1735047727225.jpg', 'Giao thoa giữa văn hóa truyền thống và hiện đại', 'Giao thoa giữa văn hóa truyền thống và hiện đại', 'Nghệ thuật và văn hóa truyền thống đang hòa quyện với những yếu tố hiện đại để tạo nên những tác phẩm độc đáo và đầy sáng tạo.');
INSERT INTO `news` VALUES ('SUB0004', 'WRT0003', 'STS0001', 'NEWS0043', '2024-12-30 00:00:00', 'Bài viết hấp dẫn!', b'0', 40, 'Nghệ thuật và văn hóa đang trải qua những thay đổi mạnh mẽ dưới tác động của công nghệ.', 'filename-1735047727225.jpg', 'Ứng dụng AI trong nghệ thuật và văn hóa', 'Ứng dụng AI trong nghệ thuật và văn hóa', 'AI đang giúp các nghệ sĩ và các nhà văn hóa phát triển những tác phẩm nghệ thuật thông qua công nghệ mới.');
INSERT INTO `news` VALUES ('SUB0004', 'WRT0004', 'STS0001', 'NEWS0044', '2024-12-31 00:00:00', 'Bài viết xuất sắc!', b'1', 36, 'Nghệ thuật đương đại đang thay đổi cách chúng ta nhìn nhận về nghệ thuật.', 'filename-1735047727225.jpg', 'Nghệ thuật đương đại', 'Nghệ thuật đương đại', 'Nghệ thuật đương đại đang không ngừng sáng tạo và thử nghiệm những hình thức mới, giúp thay đổi cách chúng ta cảm nhận về nghệ thuật.');
INSERT INTO `news` VALUES ('SUB0004', 'WRT0001', 'STS0001', 'NEWS0045', '2025-01-02 00:00:00', 'Bài viết rất hay!', b'0', 30, 'Văn hóa nghệ thuật đang thay đổi mạnh mẽ nhờ vào sự sáng tạo và thử nghiệm.', 'filename-1735047727225.jpg', 'Nghệ thuật và sự sáng tạo', 'Nghệ thuật và sự sáng tạo', 'Nghệ thuật là nơi các nghệ sĩ có thể thể hiện bản sắc văn hóa và sự sáng tạo không giới hạn.');
INSERT INTO `news` VALUES ('SUB0004', 'WRT0002', 'STS0001', 'NEWS0046', '2025-01-01 00:00:00', 'Bài viết rất hay!', b'0', 32, 'Sự giao thoa giữa văn hóa truyền thống và hiện đại trong nghệ thuật.', 'filename-1735047727225.jpg', 'Giao thoa văn hóa trong nghệ thuật', 'Giao thoa văn hóa trong nghệ thuật', 'Nghệ thuật hiện đại đang có sự kết hợp thú vị với các yếu tố văn hóa truyền thống, tạo ra những tác phẩm đầy ý nghĩa.');
INSERT INTO `news` VALUES ('SUB0004', 'WRT0003', 'STS0001', 'NEWS0047', '2025-01-02 00:00:00', 'Bài viết thú vị!', b'0', 11, 'Văn hóa nghệ thuật đang phát triển mạnh mẽ với sự kết hợp giữa truyền thống và hiện đại.', 'filename-1735047727225.jpg', 'Văn hóa và nghệ thuật đương đại', 'Văn hóa và nghệ thuật đương đại', 'Văn hóa nghệ thuật đương đại đang phát triển mạnh mẽ và phản ánh xã hội hiện đại.');
INSERT INTO `news` VALUES ('SUB0004', 'WRT0004', 'STS0001', 'NEWS0048', '2025-01-01 00:00:00', 'Bài viết xuất sắc!', b'1', 4000, 'Nghệ thuật đương đại đang mở rộng và thay đổi hình thức sáng tạo.', 'filename-1735047727225.jpg', 'Nghệ thuật đương đại và sự đổi mới', 'Nghệ thuật đương đại và sự đổi mới', 'Các tác phẩm nghệ thuật đương đại đang phản ánh sự sáng tạo không giới hạn của các nghệ sĩ trong một thế giới công nghệ mới.');
INSERT INTO `news` VALUES ('SUB0005', 'WRT0005', 'STS0001', 'NEWS0049', '2024-12-29 00:00:00', 'Bài viết về sự phát triển doanh nghiệp!', b'0', 100, 'Các doanh nghiệp đang ứng dụng AI để nâng cao hiệu quả công việc và cải thiện dịch vụ khách hàng.', 'filename-1735047727225.jpg', 'Doanh nghiệp và công nghệ AI', 'Doanh nghiệp áp dụng công nghệ AI để cải thiện dịch vụ', 'AI đang trở thành công cụ quan trọng trong việc nâng cao trải nghiệm khách hàng và tối ưu hóa quy trình doanh nghiệp.');
INSERT INTO `news` VALUES ('SUB0005', 'WRT0005', 'STS0001', 'NEWS0050', '2024-12-27 00:00:00', 'Bài viết về xu hướng công nghệ trong doanh nghiệp!', b'1', 9900008, 'Công nghệ AI đang giúp các doanh nghiệp cải thiện quy trình và tối ưu hóa chi phí.', 'filename-1735047727225.jpg', 'AI trong cải tiến doanh nghiệp', 'Doanh nghiệp áp dụng AI để cải tiến quy trình', 'Công nghệ AI giúp các doanh nghiệp giảm thiểu chi phí và nâng cao hiệu suất làm việc, là xu hướng không thể thiếu trong thời đại số hóa.');
INSERT INTO `news` VALUES ('SUB0005', 'WRT0005', 'STS0001', 'NEWS0051', '2024-12-29 00:00:00', 'Bài viết về hiệu quả của AI đối với các chiến lược doanh nghiệp!', b'1', 102, 'AI giúp doanh nghiệp nắm bắt cơ hội mới và cải thiện chiến lược kinh doanh.', 'filename-1735047727225.jpg', 'AI và chiến lược kinh doanh', 'AI hỗ trợ chiến lược kinh doanh của doanh nghiệp', 'AI giúp doanh nghiệp nâng cao chiến lược tiếp thị, từ việc phân tích dữ liệu đến tối ưu hóa các chiến lược sản phẩm và dịch vụ.');
INSERT INTO `news` VALUES ('SUB0005', 'WRT0005', 'STS0001', 'NEWS0052', '2024-12-26 00:00:00', 'Bài viết về AI trong lĩnh vực quản lý doanh nghiệp!', b'1', 99, 'AI đang giúp các nhà quản lý doanh nghiệp đưa ra các quyết định thông minh hơn.', 'filename-1735047727225.jpg', 'AI trong quản lý doanh nghiệp', 'Doanh nghiệp sử dụng AI trong quản lý', 'AI giúp các nhà quản lý doanh nghiệp đưa ra quyết định nhanh chóng và chính xác, tăng cường khả năng ra quyết định và lập kế hoạch dài hạn.');
INSERT INTO `news` VALUES ('SUB0005', 'WRT0005', 'STS0001', 'NEWS0053', '2025-01-01 00:00:00', 'Bài viết về chuyển đổi số trong doanh nghiệp!', b'1', 70, 'Chuyển đổi số giúp các doanh nghiệp đổi mới và nâng cao sức cạnh tranh.', 'filename-1735047727225.jpg', 'Chuyển đổi số trong doanh nghiệp', 'Chuyển đổi số giúp doanh nghiệp phát triển', 'Chuyển đổi số là yếu tố quyết định giúp doanh nghiệp phát triển trong thời đại công nghệ 4.0, mang lại lợi ích lớn trong việc tối ưu hóa quy trình và quản lý khách hàng.');
INSERT INTO `news` VALUES ('SUB0005', 'WRT0005', 'STS0001', 'NEWS0054', '2024-12-25 20:48:42', 'Bài viết về ứng dụng AI trong quản lý dữ liệu doanh nghiệp!', b'1', 7900002, '<p>AI hỗ trợ doanh nghiệp trong việc ph&acirc;n t&iacute;ch v&agrave; sử dụng dữ liệu hiệu quả hơn.</p>', 'filename-1735134522530.png', 'AI và dữ liệu doanh nghiệp', 'Doanh nghiệp áp dụng AI vào phân tích dữ liệu', 'AI giúp doanh nghiệp phân tích dữ liệu lớn, dự báo xu hướng và ra quyết định dựa trên thông tin chính xác và nhanh chóng.');
INSERT INTO `news` VALUES ('SUB0005', 'WRT0005', 'STS0001', 'NEWS0055', '2024-12-27 00:00:00', 'Bài viết về các xu hướng công nghệ mới trong doanh nghiệp!', b'1', 40, 'AI sẽ tiếp tục thay đổi ngành công nghiệp trong thời gian tới.', 'filename-1735047727225.jpg', 'Công nghệ mới trong doanh nghiệp', 'Các xu hướng công nghệ mới trong doanh nghiệp', 'Doanh nghiệp cần theo kịp xu hướng công nghệ mới để duy trì lợi thế cạnh tranh và phát triển bền vững trong tương lai.');
INSERT INTO `news` VALUES ('SUB0005', 'WRT0005', 'STS0001', 'NEWS0056', '2024-12-27 00:00:00', 'Bài viết về tầm quan trọng của đổi mới trong doanh nghiệp!', b'0', 306, 'Đổi mới giúp doanh nghiệp duy trì sự cạnh tranh và phát triển bền vững.', 'filename-1735047727225.jpg', 'Đổi mới trong doanh nghiệp', 'Doanh nghiệp phát triển nhờ đổi mới', 'Đổi mới là yếu tố then chốt giúp doanh nghiệp vượt qua thách thức và duy trì sức mạnh trên thị trường toàn cầu.');
INSERT INTO `news` VALUES ('SUB0005', 'WRT0005', 'STS0001', 'NEWS0057', '2024-12-28 00:00:00', 'Bài viết về các chiến lược phát triển doanh nghiệp!', b'0', 301, 'Chiến lược kinh doanh thông minh giúp doanh nghiệp tăng trưởng nhanh chóng.', 'filename-1735047727225.jpg', 'Chiến lược phát triển doanh nghiệp', 'Các chiến lược giúp doanh nghiệp tăng trưởng', 'Các chiến lược phát triển doanh nghiệp thông minh kết hợp với công nghệ giúp tăng trưởng nhanh chóng và tối đa hóa lợi nhuận.');
INSERT INTO `news` VALUES ('SUB0005', 'WRT0005', 'STS0001', 'NEWS0058', '2024-12-28 00:00:00', 'Bài viết về phát triển bền vững trong doanh nghiệp!', b'0', 33, 'Doanh nghiệp cần chú trọng phát triển bền vững để tạo ra giá trị lâu dài.', 'filename-1735047727225.jpg', 'Phát triển bền vững trong doanh nghiệp', 'Doanh nghiệp phát triển bền vững', 'Doanh nghiệp phải kết hợp giữa phát triển bền vững và chiến lược tăng trưởng để tạo ra giá trị lâu dài và nâng cao sức mạnh cạnh tranh.');
INSERT INTO `news` VALUES ('SUB0005', 'WRT0005', 'STS0001', 'NEWS0059', '2025-01-02 00:00:00', 'Bài viết về quản lý doanh nghiệp thông minh!', b'0', 119, 'Quản lý thông minh giúp doanh nghiệp tối ưu hóa quy trình.', 'filename-1735047727225.jpg', 'Quản lý thông minh trong doanh nghiệp', 'Quản lý doanh nghiệp thông minh', 'Quản lý thông minh giúp doanh nghiệp nâng cao hiệu quả công việc và giảm thiểu rủi ro, đồng thời cải thiện trải nghiệm khách hàng.');
INSERT INTO `news` VALUES ('SUB0005', 'WRT0005', 'STS0001', 'NEWS0060', '2025-01-01 00:00:00', 'Bài viết về tương lai của doanh nghiệp!', b'1', 409, 'Tương lai doanh nghiệp sẽ được định hình bởi công nghệ và đổi mới.', 'filename-1735047727225.jpg', 'Tương lai của doanh nghiệp', 'Tương lai doanh nghiệp trong kỷ nguyên công nghệ', 'Công nghệ và đổi mới sẽ là yếu tố chủ chốt giúp doanh nghiệp phát triển và tồn tại lâu dài trong kỷ nguyên số.');
INSERT INTO `news` VALUES ('SUB0006', 'WRT0005', 'STS0001', 'NEWS0065', '2024-12-19 00:00:00', 'Lập kế hoạch tài chính cho tương lai vững chắc.', b'0', 150, 'Sống một cuộc sống tài chính vững chắc là điều cần thiết để có sự ổn định lâu dài.', 'filename-1735047727225.jpg', 'Lập kế hoạch tài chính và đầu tư', 'Tầm quan trọng của lập kế hoạch tài chính', 'Lập kế hoạch tài chính là yếu tố quan trọng để đạt được sự ổn định tài chính lâu dài và thành công.');
INSERT INTO `news` VALUES ('SUB0006', 'WRT0005', 'STS0001', 'NEWS0066', '2024-12-21 00:00:00', 'Hiểu về rủi ro tài chính.', b'0', 200, 'Quản lý rủi ro tài chính là yếu tố quan trọng giúp doanh nghiệp thành công.', 'filename-1735047727225.jpg', 'Quản lý rủi ro tài chính', 'Giảm thiểu rủi ro tài chính trong kinh doanh', 'Quản lý rủi ro tài chính hiệu quả là điều cần thiết để doanh nghiệp phát triển trong một thị trường cạnh tranh.');
INSERT INTO `news` VALUES ('SUB0006', 'WRT0005', 'STS0001', 'NEWS0067', '2024-12-12 00:00:00', 'Chiến lược đầu tư cho người mới bắt đầu.', b'0', 250, 'Đầu tư thông minh là yếu tố quan trọng trong việc xây dựng tài sản.', 'filename-1735047727225.jpg', 'Chiến lược đầu tư cho người mới bắt đầu', 'Làm thế nào để bắt đầu đầu tư một cách khôn ngoan', 'Đầu tư khôn ngoan là một trong những cách hiệu quả nhất để xây dựng tài sản theo thời gian. Bắt đầu sớm và đa dạng hóa danh mục đầu tư là những bước quan trọng để đạt được thành công tài chính.');
INSERT INTO `news` VALUES ('SUB0007', 'WRT0005', 'STS0001', 'NEWS0068', '2024-12-24 00:00:00', 'Thị trường chính trị toàn cầu hiện nay.', b'0', 300, 'Chính trị trên thế giới đang có những thay đổi quan trọng.', 'filename-1735047727225.jpg', 'Thị trường chính trị toàn cầu', 'Những thay đổi trong thị trường chính trị toàn cầu', 'Chính trị toàn cầu đang trải qua nhiều biến động và có ảnh hưởng lớn đến thị trường quốc tế. Các quyết định chính trị hiện nay sẽ tác động đến sự phát triển và ổn định của các quốc gia và nền kinh tế.');
INSERT INTO `news` VALUES ('SUB0007', 'WRT0005', 'STS0001', 'NEWS0069', '2024-12-25 00:00:00', 'Quan hệ quốc tế và tác động đến thị trường.', b'0', 350, 'Quan hệ giữa các quốc gia đóng vai trò quan trọng trong việc thúc đẩy sự phát triển của các thị trường toàn cầu.', 'filename-1735047727225.jpg', 'Quan hệ quốc tế và tác động đến thị trường', 'Tầm quan trọng của quan hệ quốc tế trong thị trường toàn cầu', 'Quan hệ quốc tế có ảnh hưởng sâu rộng đến các quyết định kinh tế và chiến lược của các quốc gia, qua đó tác động đến sự phát triển của các thị trường và các ngành công nghiệp trên thế giới.');
INSERT INTO `news` VALUES ('SUB0007', 'WRT0005', 'STS0001', 'NEWS0070', '2024-12-30 00:00:00', 'Trao đổi văn hóa và sự ảnh hưởng đối với thị trường toàn cầu.', b'0', 400, 'Trao đổi văn hóa đóng vai trò quan trọng trong việc kết nối và thúc đẩy thị trường toàn cầu.', 'filename-1735047727225.jpg', 'Trao đổi văn hóa và tác động đến thị trường', 'Tầm quan trọng của trao đổi văn hóa trong phát triển thị trường toàn cầu', 'Trao đổi văn hóa giữa các quốc gia không chỉ thúc đẩy sự hiểu biết mà còn tạo ra các cơ hội kinh doanh và hợp tác giữa các doanh nghiệp quốc tế, ảnh hưởng đến các thị trường và ngành công nghiệp toàn cầu.');
INSERT INTO `news` VALUES ('SUB0007', 'WRT0005', 'STS0001', 'NEWS0071', '2025-01-01 00:00:00', 'Xu hướng kinh tế toàn cầu hiện nay.', b'1', 450, 'Kinh tế toàn cầu đang thay đổi nhanh chóng và tạo ra những cơ hội và thách thức mới.', 'filename-1735047727225.jpg', 'Xu hướng kinh tế toàn cầu', 'Phân tích xu hướng kinh tế toàn cầu và tác động đến thị trường', 'Kinh tế toàn cầu đang trải qua những thay đổi lớn, đặc biệt là trong bối cảnh phát triển công nghệ và toàn cầu hóa. Các xu hướng này không chỉ ảnh hưởng đến các quốc gia mà còn tác động đến các chiến lược kinh doanh và thị trường');
INSERT INTO `news` VALUES ('SUB0008', 'WRT0005', 'STS0001', 'NEWS0072', '2024-12-28 00:00:00', 'Xu hướng thị trường bất động sản hiện nay.', b'1', 500, 'Thị trường bất động sản đang thay đổi nhanh chóng.', 'filename-1735047727225.jpg', 'Thị trường bất động sản', 'Những xu hướng mới trong thị trường bất động sản', 'Thị trường bất động sản hiện nay đang trải qua những thay đổi lớn, với nhiều xu hướng mới như phát triển các khu đô thị thông minh và sự gia tăng nhu cầu nhà ở xanh và bền vững.');
INSERT INTO `news` VALUES ('SUB0008', 'WRT0005', 'STS0001', 'NEWS0073', '2024-12-30 00:00:00', 'Mua nhà hay thuê nhà?', b'0', 550, 'Mua nhà hay thuê nhà - đâu là lựa chọn tốt nhất?', 'filename-1735047727225.jpg', 'Mua nhà hay thuê nhà?', 'So sánh giữa việc mua nhà và thuê nhà', 'Việc quyết định giữa mua hay thuê nhà là một trong những vấn đề quan trọng đối với người tiêu dùng và nhà đầu tư bất động sản. Mỗi lựa chọn đều có những ưu nhược điểm riêng, và quyết định này sẽ ảnh hưởng lâu dài đến tài chính cá nhân và sự ổn định trong cuộc sống.');
INSERT INTO `news` VALUES ('SUB0008', 'WRT0005', 'STS0001', 'NEWS0074', '2025-01-01 00:00:00', 'Cơ hội đầu tư bất động sản.', b'1', 600, 'Đầu tư vào bất động sản là một chiến lược tài chính hiệu quả.', 'filename-1735047727225.jpg', 'Cơ hội đầu tư bất động sản', 'Lời khuyên về đầu tư bất động sản', 'Đầu tư bất động sản luôn là một lựa chọn hấp dẫn trong dài hạn. Tuy nhiên, để thành công, các nhà đầu tư cần phải nghiên cứu kỹ lưỡng thị trường, lựa chọn loại hình bất động sản phù hợp và hiểu rõ các yếu tố pháp lý liên quan.');
INSERT INTO `news` VALUES ('SUB0008', 'WRT0005', 'STS0001', 'NEWS0075', '2024-12-21 00:00:00', 'Mẹo cải thiện giá trị bất động sản.', b'0', 650, 'Tăng giá trị tài sản bất động sản của bạn.', 'filename-1735047727225.jpg', 'Mẹo cải thiện giá trị bất động sản', 'Các chiến lược cải thiện giá trị bất động sản', 'Cải thiện giá trị bất động sản là một chiến lược quan trọng đối với các nhà đầu tư và người sở hữu tài sản. Bằng cách nâng cấp các tiện ích, cải tạo không gian sống và lựa chọn các vật liệu xây dựng chất lượng, bạn có thể nâng cao giá trị của bất động sản và gia tăng tiềm năng lợi nhuận. ');
INSERT INTO `news` VALUES ('SUB0009', 'WRT0006', 'STS0001', 'NEWS0076', '2024-12-22 00:00:00', 'Những công nghệ mới bạn không thể bỏ qua.', b'0', 701, 'Công nghệ đột phá trong năm nay.', 'filename-1735047727225.jpg', 'Công nghệ mới', 'Những công nghệ tiên tiến thay đổi cuộc sống', 'Các công nghệ mới nhất đang thay đổi nhanh chóng cách chúng ta sống và làm việc, bao gồm trí tuệ nhân tạo, blockchain, và các giải pháp điện toán đám mây. Những đổi mới này không chỉ cải thiện hiệu suất công việc mà còn mở ra những cơ hội mới cho các doanh nghiệp.');
INSERT INTO `news` VALUES ('SUB0009', 'WRT0006', 'STS0001', 'NEWS0077', '2024-12-28 00:00:00', 'Top xu hướng công nghệ hiện nay.', b'0', 750, 'Công nghệ tiên tiến đang thay đổi thế giới.', 'filename-1735047727225.jpg', 'Xu hướng công nghệ', 'Những xu hướng công nghệ hot nhất 2024', 'Công nghệ luôn là yếu tố quan trọng trong sự phát triển của xã hội. Năm 2024 chứng kiến sự bùng nổ của công nghệ 5G, công nghệ AI và các giải pháp tự động hóa, giúp doanh nghiệp tối ưu hóa quy trình và mang lại những sản phẩm và dịch vụ thông minh hơn.');
INSERT INTO `news` VALUES ('SUB0009', 'WRT0006', 'STS0001', 'NEWS0078', '2024-12-30 00:00:00', 'Các ứng dụng công nghệ trong doanh nghiệp.', b'0', 800, 'Ứng dụng công nghệ trong môi trường kinh doanh.', 'filename-1735047727225.jpg', 'Ứng dụng công nghệ trong doanh nghiệp', 'Công nghệ và sự đổi mới trong kinh doanh', 'Ứng dụng công nghệ vào doanh nghiệp không chỉ giúp cải thiện quy trình mà còn tạo ra các cơ hội cạnh tranh. Những công nghệ như phần mềm ERP, công nghệ blockchain, và AI đang ngày càng trở nên thiết yếu trong việc thúc đẩy sự đổi mới và tối ưu hóa hoạt động kinh doanh.');
INSERT INTO `news` VALUES ('SUB0009', 'WRT0006', 'STS0001', 'NEWS0079', '2025-01-02 00:00:00', 'Công nghệ trong ngành game.', b'1', 850, 'Các xu hướng công nghệ trong ngành công nghiệp game.', 'filename-1735047727225.jpg', 'Công nghệ trong game', 'Công nghệ mới trong ngành game', 'Công nghệ đóng vai trò quan trọng trong sự phát triển của ngành công nghiệp game. Từ công nghệ VR, AR đến game đám mây và AI, ngành công nghiệp game đang không ngừng thay đổi để mang đến cho người chơi những trải nghiệm thú vị và tương tác hơn bao giờ hết.');
INSERT INTO `news` VALUES ('SUB0010', 'WRT0006', 'STS0001', 'NEWS0080', '2024-12-21 00:00:00', 'Hiểu về luật vũ trụ.', b'0', 900, 'Khám phá các quy luật của vũ trụ.', 'filename-1735047727225.jpg', 'Khám phá vũ trụ', 'Các quy luật và khám phá vũ trụ', 'Vũ trụ là một không gian rộng lớn với các hiện tượng bí ẩn. Việc hiểu về các quy luật trong vũ trụ sẽ giúp chúng ta có cái nhìn sâu sắc hơn về sự tồn tại và sự vận hành của vũ trụ này.');
INSERT INTO `news` VALUES ('SUB0010', 'WRT0006', 'STS0001', 'NEWS0081', '2024-12-26 00:00:00', 'Các thiên thể trong vũ trụ.', b'0', 950, 'Khám phá các thiên thể trong vũ trụ.', 'filename-1735047727225.jpg', 'Thiên thể vũ trụ', 'Các thiên thể và hệ mặt trời', 'Các thiên thể như sao, hành tinh, và các dải ngân hà tạo nên vũ trụ bao la. Việc nghiên cứu những thiên thể này không chỉ giúp chúng ta hiểu rõ hơn về nguồn gốc của vũ trụ mà còn khám phá những khả năng tồn tại sự sống ở nơi khác ngoài Trái đất.');
INSERT INTO `news` VALUES ('SUB0010', 'WRT0006', 'STS0001', 'NEWS0082', '2024-12-30 00:00:00', 'Khám phá không gian vũ trụ.', b'1', 1000, 'Khám phá không gian bên ngoài Trái đất.', 'filename-1735047727225.jpg', 'Khám phá không gian', 'Sự phát triển của khám phá không gian', 'Khám phá không gian không chỉ là việc tìm hiểu những vùng không gian ngoài Trái đất mà còn là cuộc hành trình đầy thú vị để tìm ra sự sống, nghiên cứu các hiện tượng thiên văn học và các phép thử công nghệ mới.');
INSERT INTO `news` VALUES ('SUB0010', 'WRT0006', 'STS0001', 'NEWS0083', '2025-01-01 00:00:00', 'Kỹ thuật không gian hiện đại.', b'0', 1050, 'Công nghệ trong nghiên cứu không gian.', 'filename-1735047727225.jpg', 'Công nghệ không gian', 'Công nghệ trong ngành nghiên cứu vũ trụ', 'Các tiến bộ trong công nghệ không gian, từ tàu vũ trụ tự động đến các chương trình khám phá sao Hỏa, đang thay đổi cách chúng ta nghiên cứu và hiểu về vũ trụ.');
INSERT INTO `news` VALUES ('SUB0011', 'WRT0006', 'STS0001', 'NEWS0084', '2025-01-02 00:00:00', 'Chế độ dinh dưỡng cho sức khỏe.', b'0', 1100, 'Dinh dưỡng là yếu tố quan trọng cho sức khỏe.', 'filename-1735047727225.jpg', 'Chế độ dinh dưỡng', 'Lời khuyên về dinh dưỡng cho sức khỏe', 'Dinh dưỡng là một yếu tố quan trọng không thể thiếu trong việc duy trì sức khỏe. Một chế độ ăn uống lành mạnh, cân bằng có thể giúp cải thiện sức khỏe thể chất và tinh thần.');
INSERT INTO `news` VALUES ('SUB0011', 'WRT0006', 'STS0001', 'NEWS0085', '2024-12-21 00:00:00', 'Hiểu về các bệnh lý thông thường.', b'0', 1150, 'Các bệnh lý phổ biến và cách phòng tránh.', 'filename-1735047727225.jpg', 'Bệnh lý phổ biến', 'Những bệnh lý thường gặp và biện pháp phòng tránh', 'Các bệnh lý phổ biến như cảm cúm, bệnh tim mạch và tiểu đường đều có thể được phòng ngừa và điều trị sớm nếu chúng ta có kiến thức cơ bản về chúng.');
INSERT INTO `news` VALUES ('SUB0011', 'WRT0006', 'STS0001', 'NEWS0086', '2025-01-01 00:00:00', 'Tập thể dục cho sức khỏe.', b'1', 1200, 'Tầm quan trọng của việc tập thể dục.', 'filename-1735047727225.jpg', 'Tập thể dục', 'Tập thể dục cho sức khỏe thể chất', 'Tập thể dục đều đặn không chỉ giúp cơ thể khỏe mạnh mà còn giúp cải thiện tinh thần. Việc luyện tập hàng ngày là một yếu tố quan trọng để duy trì sức khỏe lâu dài.');
INSERT INTO `news` VALUES ('SUB0011', 'WRT0006', 'STS0001', 'NEWS0087', '2024-12-28 00:00:00', 'Nhận thức về sức khỏe tâm thần.', b'0', 1250, 'Tầm quan trọng của sức khỏe tâm thần.', 'filename-1735047727225.jpg', 'Sức khỏe tâm thần', 'Sức khỏe tâm thần và các vấn đề liên quan', 'Sức khỏe tâm thần là yếu tố không thể thiếu để duy trì sự cân bằng trong cuộc sống. Nhận thức về các vấn đề sức khỏe tâm thần sẽ giúp chúng ta cải thiện chất lượng cuộc sống và giảm thiểu stress.');
INSERT INTO `news` VALUES ('SUB0012', 'WRT0006', 'STS0001', 'NEWS0088', '2024-12-23 00:00:00', 'Du lịch trong nước.', b'0', 1300, 'Kinh nghiệm du lịch trong nước.', 'filename-1735047727225.jpg', 'Du lịch trong nước', 'Các địa điểm du lịch nổi bật trong nước', 'Du lịch trong nước mang đến nhiều trải nghiệm tuyệt vời về cảnh quan thiên nhiên và văn hóa địa phương. Việc bảo vệ môi trường trong quá trình du lịch là yếu tố rất quan trọng để bảo tồn những giá trị thiên nhiên này.');
INSERT INTO `news` VALUES ('SUB0012', 'WRT0006', 'STS0001', 'NEWS0089', '2024-12-25 00:00:00', 'Du lịch quốc tế', b'1', 1350, 'Kinh nghiệm du lịch quốc tế.', 'filename-1735047727225.jpg', 'Du lịch quốc tế', 'Những địa điểm du lịch quốc tế thú vị', 'Du lịch quốc tế không chỉ mang lại những trải nghiệm mới lạ mà còn giúp chúng ta hiểu rõ hơn về các nền văn hóa và môi trường sống khác nhau trên thế giới.');
INSERT INTO `news` VALUES ('SUB0012', 'WRT0006', 'STS0001', 'NEWS0090', '2024-12-29 00:00:00', 'Trải nghiệm ẩm thực du lịch.', b'0', 1400, 'Trải nghiệm ẩm thực trong các chuyến du lịch.', 'filename-1735047727225.jpg', 'Trải nghiệm ẩm thực', 'Các món ăn nổi bật khi du lịch', 'Ẩm thực là một phần không thể thiếu trong những chuyến du lịch. Việc khám phá ẩm thực của các quốc gia và vùng miền khác nhau sẽ giúp chúng ta hiểu hơn về văn hóa và con người nơi đó.');
INSERT INTO `news` VALUES ('SUB0012', 'WRT0006', 'STS0001', 'NEWS0091', '2025-01-02 00:00:00', 'Trải nghiệm văn hóa khi du lịch.', b'0', 1450, 'Các trải nghiệm văn hóa đặc sắc khi du lịch.', 'filename-1735047727225.jpg', 'Trải nghiệm văn hóa', 'Khám phá văn hóa qua các chuyến du lịch', 'Du lịch không chỉ là việc tham quan các danh lam thắng cảnh mà còn là cơ hội để tìm hiểu sâu về lịch sử, nghệ thuật và phong tục của các quốc gia và dân tộc khác nhau.');
INSERT INTO `news` VALUES ('SUB0013', 'WRT0007', 'STS0001', 'NEWS0092', '2024-12-27 00:00:00', 'Các trận bóng đá tuần này.', b'1', 1500, 'Những trận bóng đá thú vị sắp tới.', 'filename-1735047727225.jpg', 'Các trận đấu hấp dẫn trong tuần này', 'Tổng quan các trận bóng đá thú vị sắp diễn ra', 'Tổng quan các trận bóng đá sắp diễn ra trong tuần này, bao gồm những đội bóng mạnh, các trận đấu đáng chú ý và những dự đoán hấp dẫn.');
INSERT INTO `news` VALUES ('SUB0013', 'WRT0007', 'STS0001', 'NEWS0093', '2024-12-28 00:00:00', 'Giải vô địch bóng chuyền.', b'1', 1550, 'Giải vô địch bóng chuyền đang nóng lên.', 'filename-1735047727225.jpg', 'Giải vô địch bóng đá sắp tới', 'Giải vô địch bóng đá toàn cầu đang nóng lên', 'Tổng quan về các giải vô địch bóng đá sắp tới, những đội bóng nổi bật và các trận đấu quan trọng sẽ diễn ra trong thời gian tới.');
INSERT INTO `news` VALUES ('SUB0013', 'WRT0007', 'STS0001', 'NEWS0094', '2024-12-25 00:00:00', 'Các sự kiện điền kinh tháng này.', b'1', 1600, 'Các sự kiện bóng đá đáng chú ý.', 'filename-1735047727225.jpg', 'Các sự kiện bóng đá nổi bật trong tháng này', 'Tổng quan về các sự kiện bóng đá lớn trong tháng này', 'Tổng quan về các sự kiện bóng đá quan trọng sẽ diễn ra trong tháng này, từ các giải đấu lớn đến các trận đấu quốc tế đáng chú ý.');
INSERT INTO `news` VALUES ('SUB0013', 'WRT0007', 'STS0001', 'NEWS0095', '2025-01-01 00:00:00', 'Giải cầu lông sắp tới.', b'0', 1650, 'Các giải bóng đá sắp diễn ra.', 'filename-1735047727225.jpg', 'Các giải bóng đá quốc tế sắp tới', 'Các giải bóng đá lớn sắp diễn ra', 'Tổng quan về các giải đấu bóng đá sắp tới, bao gồm những đội tuyển mạnh, các trận đấu mở màn và dự đoán về các nhà vô địch.');
INSERT INTO `news` VALUES ('SUB0014', 'WRT0007', 'STS0001', 'NEWS0096', '2024-12-19 00:00:00', 'Mẹo tập luyện bóng chuyền.', b'1', 1700, 'Mẹo để cải thiện kỹ năng bóng chuyền của bạn.', 'filename-1735047727225.jpg', 'Mẹo tập luyện hiệu quả', 'Những mẹo giúp cải thiện kỹ năng chơi bóng chuyền', 'Tổng quan về các mẹo tập luyện bóng chuyền để giúp người chơi cải thiện kỹ năng, từ việc tăng cường thể lực đến kỹ thuật chuyền bóng.');
INSERT INTO `news` VALUES ('SUB0014', 'WRT0007', 'STS0001', 'NEWS0097', '2024-12-22 00:00:00', 'Những cầu thủ bóng chuyền xuất sắc của năm.', b'0', 1750, 'Highlight các cầu thủ xuất sắc.', 'filename-1735047727225.jpg', 'Những cầu thủ xuất sắc của năm', 'Đánh giá các cầu thủ bóng chuyền xuất sắc năm nay', 'Đánh giá những cầu thủ bóng chuyền nổi bật trong năm qua, những thành tựu họ đạt được và sự đóng góp của họ cho các đội tuyển.');
INSERT INTO `news` VALUES ('SUB0014', 'WRT0007', 'STS0001', 'NEWS0098', '2024-12-30 00:00:00', 'Highlight các trận đấu bóng chuyền.', b'0', 1800, 'Những điểm nổi bật từ các trận đấu gần đây.', 'filename-1735047727225.jpg', 'Tổng hợp các trận đấu hấp dẫn', 'Tổng kết các trận đấu bóng chuyền gần đây', 'Tổng hợp các trận đấu bóng chuyền đã diễn ra, những điểm nổi bật và kết quả bất ngờ.');
INSERT INTO `news` VALUES ('SUB0014', 'WRT0007', 'STS0001', 'NEWS0099', '2025-01-01 00:00:00', 'Các sự kiện bóng chuyền sắp tới.', b'0', 1850, 'Các sự kiện đáng chú ý sắp diễn ra.', 'filename-1735047727225.jpg', 'Các sự kiện bóng chuyền sắp diễn ra', 'Tổng quan về các sự kiện bóng chuyền sắp tới', 'Tổng quan về các giải đấu và sự kiện bóng chuyền sắp diễn ra trong thời gian tới, với sự tham gia của các đội tuyển hàng đầu.');
INSERT INTO `news` VALUES ('SUB0015', 'WRT0007', 'STS0001', 'NEWS0100', '2024-12-25 00:00:00', 'Các chương trình huấn luyện điền kinh.', b'0', 1900, 'Những chương trình huấn luyện tốt nhất cho vận động viên.', 'filename-1735047727225.jpg', 'Các chương trình huấn luyện hiệu quả', 'Tổng quan về các chương trình huấn luyện điền kinh', 'Tổng quan về các chương trình huấn luyện điền kinh, các kỹ thuật giúp nâng cao thành tích và xây dựng nền tảng thể lực vững chắc.');
INSERT INTO `news` VALUES ('SUB0015', 'WRT0007', 'STS0001', 'NEWS0101', '2024-12-30 00:00:00', 'Những vận động viên điền kinh nổi bật.', b'1', 1950, 'Những vận động viên đáng chú ý trong làng điền kinh.', 'filename-1735047727225.jpg', 'Các vận động viên nổi bật', 'Đánh giá các vận động viên điền kinh xuất sắc', 'Đánh giá các vận động viên điền kinh nổi bật, những thành tựu và thành công mà họ đã đạt được trong các cuộc thi quốc tế.');
INSERT INTO `news` VALUES ('SUB0015', 'WRT0007', 'STS0001', 'NEWS0102', '2024-12-31 00:00:00', 'Tổng kết các sự kiện điền kinh.', b'0', 2000, 'Tổng kết các sự kiện điền kinh gần đây.', 'filename-1735047727225.jpg', 'Tổng kết các sự kiện điền kinh', 'Tổng kết các sự kiện điền kinh gần đây', 'Tổng kết các sự kiện điền kinh đã diễn ra, những kỷ lục mới và các vận động viên xuất sắc.');
INSERT INTO `news` VALUES ('SUB0015', 'WRT0007', 'STS0001', 'NEWS0103', '2025-01-02 00:00:00', 'Các cuộc thi điền kinh sắp tới.', b'0', 2050, 'Các cuộc thi điền kinh đáng mong đợi.', 'filename-1735047727225.jpg', 'Các cuộc thi điền kinh sắp tới', 'Các cuộc thi điền kinh lớn sắp diễn ra', 'Tổng quan các cuộc thi điền kinh sắp diễn ra, dự đoán kết quả và những vận động viên đáng chú ý sẽ tham gia.');
INSERT INTO `news` VALUES ('SUB0016', 'WRT0007', 'STS0001', 'NEWS0104', '2024-12-29 00:00:00', 'Kỹ thuật huấn luyện cầu lông.', b'1', 2100, 'Các kỹ thuật để cải thiện trò chơi của bạn.', 'filename-1735047727225.jpg', 'Các kỹ thuật huấn luyện hiệu quả', 'Tổng quan về các kỹ thuật huấn luyện cầu lông', 'Tổng quan về các kỹ thuật huấn luyện cầu lông, từ cách nâng cao sức mạnh, tốc độ đến cải thiện kỹ năng di chuyển trên sân.');
INSERT INTO `news` VALUES ('SUB0016', 'WRT0007', 'STS0001', 'NEWS0105', '2024-12-20 00:00:00', 'Các cầu thủ cầu lông xuất sắc nhất.', b'1', 2150, 'Highlight các cầu thủ xuất sắc trong làng cầu lông.', 'filename-1735047727225.jpg', 'Các cầu thủ xuất sắc trong năm qua', 'Đánh giá các cầu thủ cầu lông xuất sắc nhất', 'Đánh giá các cầu thủ cầu lông nổi bật trong năm qua, những thành tích họ đạt được và vai trò của họ trong các giải đấu quốc tế.');
INSERT INTO `news` VALUES ('SUB0016', 'WRT0007', 'STS0001', 'NEWS0106', '2024-12-27 00:00:00', 'Highlight các trận đấu cầu lông.', b'1', 2200, 'Những điểm nổi bật từ các trận đấu cầu lông gần đây.', 'filename-1735047727225.jpg', 'Tổng kết các trận đấu cầu lông', 'Tổng kết các trận đấu cầu lông gần đây', 'Tổng kết các trận đấu cầu lông đáng chú ý đã diễn ra, điểm nhấn trong từng trận đấu và kết quả bất ngờ.');
INSERT INTO `news` VALUES ('SUB0016', 'WRT0007', 'STS0001', 'NEWS0107', '2024-12-23 00:00:00', 'Các giải cầu lông sắp tới.', b'1', 2250, 'Các giải đấu cầu lông đáng chú ý sắp diễn ra.', 'filename-1735047727225.jpg', 'Các giải cầu lông sắp diễn ra', 'Tổng quan về giải đấu cầu lông sắp tới', 'Tổng quan các giải cầu lông sắp tới, những đội tuyển và tay vợt đáng chú ý sẽ tham gia.');
INSERT INTO `news` VALUES ('SUB0017', 'WRT0008', 'STS0001', 'NEWS0108', '2024-12-21 00:00:00', 'Cơ hội học bổng quốc tế.', b'0', 2300, 'Các cơ hội học bổng quốc tế dành cho sinh viên.', 'filename-1735047727225.jpg', 'Cơ hội học bổng quốc tế', 'Những cơ hội học bổng quốc tế dành cho sinh viên', 'Giới thiệu các cơ hội học bổng quốc tế dành cho sinh viên, từ học bổng toàn phần đến các học bổng bán phần tại các trường đại học uy tín.');
INSERT INTO `news` VALUES ('SUB0017', 'WRT0008', 'STS0001', 'NEWS0109', '2024-12-22 00:00:00', 'Cách chuẩn bị hồ sơ học bổng.', b'1', 2350, 'Lời khuyên về hồ sơ xin học bổng.', 'filename-1735047727225.jpg', 'Cách chuẩn bị hồ sơ học bổng thành công', 'Lời khuyên về việc chuẩn bị hồ sơ học bổng', 'Những bí quyết để chuẩn bị hồ sơ học bổng thành công, từ việc viết thư động lực cho đến việc tạo dựng ấn tượng mạnh mẽ với ban tuyển chọn.');
INSERT INTO `news` VALUES ('SUB0017', 'WRT0008', 'STS0001', 'NEWS0110', '2024-12-25 00:00:00', 'Các học bổng du học hàng đầu.', b'1', 2400, 'Top các học bổng du học đáng chú ý.', 'filename-1735047727225.jpg', 'Các học bổng du học hàng đầu', 'Những học bổng du học đáng chú ý', 'Giới thiệu các học bổng du học nổi bật, từ các học bổng tại Mỹ, Anh, Úc đến các học bổng tại các quốc gia châu Âu.');
INSERT INTO `news` VALUES ('SUB0017', 'WRT0008', 'STS0001', 'NEWS0111', '2024-12-28 00:00:00', 'Các học bổng dành cho sinh viên Việt Nam.', b'1', 2450, 'Học bổng dành riêng cho sinh viên Việt Nam.', 'filename-1735047727225.jpg', 'Các học bổng dành cho sinh viên Việt Nam', 'Các cơ hội học bổng dành cho sinh viên Việt Nam', 'Giới thiệu các học bổng đặc biệt dành cho sinh viên Việt Nam, các cơ hội học bổng tại các trường đại học quốc tế và các chương trình học bổng nổi bật.');
INSERT INTO `news` VALUES ('SUB0018', 'WRT0008', 'STS0001', 'NEWS0112', '2024-12-27 00:00:00', 'Quy trình đăng ký vào đại học.', b'1', 2500, 'Hướng dẫn từng bước về quy trình đăng ký.', 'filename-1735047727225.jpg', 'Quy trình đăng ký', 'Hướng dẫn quy trình đăng ký đại học', 'Bài viết này cung cấp hướng dẫn chi tiết từng bước về quy trình đăng ký vào đại học, liệt kê các bước cần thực hiện, tài liệu và mẹo cho các sinh viên tiềm năng.');
INSERT INTO `news` VALUES ('SUB0018', 'WRT0008', 'STS0001', 'NEWS0113', '2024-12-21 00:00:00', 'Các ngày quan trọng trong quy trình đăng ký.', b'0', 2551, 'Các ngày quan trọng cần nhớ.', 'filename-1735047727225.jpg', 'Các ngày quan trọng trong đăng ký', 'Các ngày đăng ký không thể bỏ lỡ', 'Bài viết này nêu rõ các ngày quan trọng trong quy trình đăng ký mà mỗi sinh viên cần phải chú ý, giúp họ không bỏ lỡ bất kỳ thời hạn nào trong quá trình đăng ký.');
INSERT INTO `news` VALUES ('SUB0018', 'WRT0008', 'STS0001', 'NEWS0114', '2025-01-02 00:00:00', 'Mẹo để đăng ký thành công.', b'0', 2601, 'Cách đảm bảo quy trình đăng ký diễn ra suôn sẻ.', 'filename-1735047727225.jpg', 'Hoàn thành quy trình đăng ký một cách suôn sẻ cho sinh viên', 'Tổng hợp các mẹo hữu ích giúp sinh viên tránh những sai lầm cơ bản khi lần đầu đăng ký quy trình', 'Bài viết này chia sẻ các mẹo và thực hành tốt giúp sinh viên hoàn thành quy trình đăng ký một cách suôn sẻ, tránh được các sai lầm phổ biến và đảm bảo đăng ký thành công.');
INSERT INTO `news` VALUES ('SUB0018', 'WRT0008', 'STS0001', 'NEWS0115', '2024-12-30 00:00:00', 'Những sai lầm thường gặp trong đăng ký.', b'1', 2650, 'Tránh những sai lầm phổ biến này.', 'filename-1735047727225.jpg', 'Sai lầm trong đăng ký', 'Những sai lầm cần tránh trong đăng ký', 'Bài viết này liệt kê những sai lầm phổ biến mà sinh viên hay mắc phải trong quy trình đăng ký và cách tránh chúng, giúp đảm bảo một trải nghiệm đăng ký không gặp trở ngại.');
INSERT INTO `news` VALUES ('SUB0019', 'WRT0008', 'STS0001', 'NEWS0116', '2024-12-31 00:00:00', 'Các chương trình đào tạo cho chuyên gia.', b'0', 2700, 'Khám phá các lựa chọn đào tạo khác nhau.', 'filename-1735047727225.jpg', 'Các chương trình đào tạo', 'Tổng quan về chương trình đào tạo chuyên gia', 'Bài viết này giới thiệu tổng quan về các chương trình đào tạo dành cho các chuyên gia, giúp họ nâng cao kỹ năng và phát triển sự nghiệp.');
INSERT INTO `news` VALUES ('SUB0019', 'WRT0008', 'STS0001', 'NEWS0117', '2024-12-21 00:00:00', 'Cách chọn chương trình đào tạo phù hợp.', b'1', 2752, 'Mẹo để lựa chọn chương trình tốt nhất.', 'filename-1735047727225.jpg', 'Chọn chương trình đào tạo phù hợp', 'Hướng dẫn chọn chương trình đào tạo hiệu quả', 'Bài viết này cung cấp các mẹo và hướng dẫn để chọn được chương trình đào tạo phù hợp với mục tiêu và nhu cầu của từng cá nhân.');
INSERT INTO `news` VALUES ('SUB0019', 'WRT0008', 'STS0001', 'NEWS0118', '2025-01-02 00:00:00', 'Câu chuyện thành công từ các học viên.', b'0', 2800, 'Những câu chuyện truyền cảm hứng từ học viên.', 'filename-1735047727225.jpg', 'Câu chuyện thành công', 'Những câu chuyện truyền cảm hứng từ đào tạo', 'Bài viết này chia sẻ các câu chuyện thành công từ các học viên đã tham gia chương trình đào tạo, mang lại động lực và bài học thực tế cho người đọc.');
INSERT INTO `news` VALUES ('SUB0019', 'WRT0008', 'STS0001', 'NEWS0119', '2024-12-23 00:00:00', 'Những sai lầm phổ biến trong đào tạo.', b'0', 2850, 'Tránh những sai lầm thường gặp này.', 'filename-1735047727225.jpg', 'Sai lầm phổ biến', 'Những sai lầm thường gặp trong đào tạo', 'Bài viết này liệt kê các sai lầm phổ biến mà học viên và tổ chức thường gặp phải trong quá trình đào tạo, kèm theo các cách tránh để tối ưu hóa hiệu quả.');
INSERT INTO `news` VALUES ('SUB0020', 'WRT0008', 'STS0001', 'NEWS0120', '2024-12-24 00:00:00', 'Cơ hội nghiên cứu cho sinh viên.', b'1', 2900, 'Khám phá các cơ hội nghiên cứu đa dạng.', 'filename-1735047727225.jpg', 'Cơ hội nghiên cứu', 'Cơ hội nghiên cứu cho sinh viên', 'Bài viết giới thiệu các cơ hội nghiên cứu dành cho sinh viên, từ chương trình học bổng đến dự án nghiên cứu thực tế.');
INSERT INTO `news` VALUES ('SUB0020', 'WRT0008', 'STS0001', 'NEWS0121', '2024-12-25 00:00:00', 'Làm thế nào để nghiên cứu hiệu quả.', b'0', 2950, 'Các mẹo để thực hiện nghiên cứu.', 'filename-1735047727225.jpg', 'Nghiên cứu hiệu quả', 'Mẹo nghiên cứu hiệu quả', 'Hướng dẫn cách thực hiện nghiên cứu một cách hiệu quả, bao gồm quản lý thời gian, thu thập dữ liệu và phân tích.');
INSERT INTO `news` VALUES ('SUB0020', 'WRT0008', 'STS0001', 'NEWS0122', '2024-12-29 00:00:00', 'Những câu chuyện thành công từ nghiên cứu.', b'0', 3000, 'Câu chuyện truyền cảm hứng từ các nhà nghiên cứu.', 'filename-1735047727225.jpg', 'Câu chuyện nghiên cứu thành công', 'Câu chuyện thành công nghiên cứu', 'Các câu chuyện thành công của những người đã áp dụng nghiên cứu để đạt được mục tiêu cá nhân và chuyên môn.');
INSERT INTO `news` VALUES ('SUB0020', 'WRT0008', 'STS0001', 'NEWS0123', '2024-12-30 00:00:00', 'Những sai lầm thường gặp trong nghiên cứu.', b'0', 3050, 'Tránh những sai lầm phổ biến.', 'filename-1735047727225.jpg', 'Sai lầm nghiên cứu', 'Sai lầm phổ biến trong nghiên cứu', 'Danh sách những sai lầm thường gặp khi thực hiện nghiên cứu và cách tránh chúng để đạt hiệu quả cao hơn.');
INSERT INTO `news` VALUES ('SUB0021', 'WRT0009', 'STS0001', 'NEWS0124', '2024-12-28 00:00:00', 'Hoạt động gắn kết gia đình.', b'1', 3100, 'Các hoạt động để tăng cường tình cảm gia đình.', 'filename-1735047727225.jpg', 'Hoạt động gia đình', 'Hoạt động gắn kết gia đình', 'Gợi ý các hoạt động giúp các thành viên trong gia đình gần gũi và hiểu nhau hơn.');
INSERT INTO `news` VALUES ('SUB0021', 'WRT0009', 'STS0001', 'NEWS0125', '2024-12-29 00:00:00', 'Bí quyết để có một gia đình hạnh phúc.', b'0', 3150, 'Lời khuyên để duy trì hạnh phúc gia đình.', 'filename-1735047727225.jpg', 'Bí quyết gia đình hạnh phúc', 'Hạnh phúc gia đình', 'Những lời khuyên thực tế để giữ gìn sự hòa thuận và hạnh phúc trong gia đình.');
INSERT INTO `news` VALUES ('SUB0021', 'WRT0009', 'STS0001', 'NEWS0126', '2024-12-30 00:00:00', 'Quản lý tài chính gia đình.', b'0', 3200, 'Mẹo tài chính cho gia đình.', 'filename-1735047727225.jpg', 'Tài chính gia đình', 'Quản lý tài chính gia đình', 'Cách lập kế hoạch và quản lý tài chính thông minh cho các gia đình.');
INSERT INTO `news` VALUES ('SUB0021', 'WRT0009', 'STS0001', 'NEWS0127', '2024-12-31 00:00:00', 'Sức khỏe và hạnh phúc gia đình.', b'0', 3250, 'Lời khuyên sức khỏe cho cả gia đình.', 'filename-1735047727225.jpg', 'Sức khỏe gia đình', 'Sức khỏe và hạnh phúc gia đình', 'Những mẹo chăm sóc sức khỏe toàn diện cho mọi thành viên trong gia đình.');
INSERT INTO `news` VALUES ('SUB0022', 'WRT0009', 'STS0001', 'NEWS0128', '2024-12-22 00:00:00', 'Thói quen ăn uống lành mạnh.', b'1', 3300, 'Mẹo để có chế độ ăn cân bằng.', 'filename-1735047727225.jpg', 'Thói quen ăn uống lành mạnh', 'Chế độ ăn uống lành mạnh', 'Hướng dẫn xây dựng thói quen ăn uống lành mạnh và duy trì sức khỏe tốt.');
INSERT INTO `news` VALUES ('SUB0022', 'WRT0009', 'STS0001', 'NEWS0129', '2024-12-25 00:00:00', 'Các bài tập cho gia đình.', b'0', 3350, 'Các bài tập thú vị dành cho gia đình.', 'filename-1735047727225.jpg', 'Bài tập gia đình', 'Bài tập thể dục gia đình', 'Danh sách các bài tập thể dục vui nhộn và phù hợp cho mọi lứa tuổi trong gia đình.');
INSERT INTO `news` VALUES ('SUB0022', 'WRT0009', 'STS0001', 'NEWS0130', '2024-12-31 00:00:00', 'Nhận thức về sức khỏe tâm thần.', b'0', 3400, 'Tầm quan trọng của sức khỏe tâm thần.', 'filename-1735047727225.jpg', 'Sức khỏe tâm thần', 'Nhận thức về sức khỏe tâm thần', 'Lý do cần quan tâm đến sức khỏe tâm thần và cách cải thiện tâm lý.');
INSERT INTO `news` VALUES ('SUB0022', 'WRT0009', 'STS0001', 'NEWS0131', '2025-01-02 00:00:00', 'Mẹo chăm sóc sức khỏe phòng ngừa.', b'1', 3450, 'Cách giữ sức khỏe.', 'filename-1735047727225.jpg', 'Chăm sóc sức khỏe', 'Mẹo phòng ngừa sức khỏe', 'Những lời khuyên hữu ích để phòng ngừa bệnh tật và duy trì sức khỏe tốt.');
INSERT INTO `news` VALUES ('SUB0023', 'WRT0009', 'STS0001', 'NEWS0132', '2024-12-26 00:00:00', 'Quy trình chăm sóc da cho mọi lứa tuổi.', b'1', 3500, 'Mẹo để có làn da khỏe mạnh.', 'filename-1735047727225.jpg', 'Chăm sóc da', 'Quy trình chăm sóc da', 'Hướng dẫn chi tiết cách chăm sóc da phù hợp với từng độ tuổi và loại da.');
INSERT INTO `news` VALUES ('SUB0023', 'WRT0009', 'STS0001', 'NEWS0133', '2024-12-24 00:00:00', 'Mẹo trang điểm cho người mới bắt đầu.', b'0', 3550, 'Các kỹ thuật trang điểm đơn giản.', 'filename-1735047727225.jpg', 'Trang điểm cơ bản', 'Hướng dẫn trang điểm cơ bản', 'Những mẹo trang điểm đơn giản và hiệu quả dành cho người mới bắt đầu.');
INSERT INTO `news` VALUES ('SUB0023', 'WRT0009', 'STS0001', 'NEWS0134', '2024-12-29 00:00:00', 'Mẹo chăm sóc tóc.', b'0', 3600, 'Cách giữ mái tóc khỏe mạnh.', 'filename-1735047727225.jpg', 'Chăm sóc tóc', 'Hướng dẫn chăm sóc tóc', 'Các bí quyết giúp giữ cho mái tóc luôn bóng mượt và khỏe mạnh.');
INSERT INTO `news` VALUES ('SUB0023', 'WRT0009', 'STS0001', 'NEWS0135', '2024-12-31 00:00:00', 'Chăm sóc móng và thiết kế nail.', b'1', 3650, 'Xu hướng nail đẹp và mẹo chăm sóc.', 'filename-1735047727225.jpg', 'Nail đẹp', 'Chăm sóc móng tay', 'Những ý tưởng thiết kế nail mới nhất và cách chăm sóc móng tại nhà.');
INSERT INTO `news` VALUES ('SUB0024', 'WRT0009', 'STS0001', 'NEWS0136', '2025-01-01 00:00:00', 'Chia sẻ kinh nghiệm cá nhân.', b'0', 3700, 'Tầm quan trọng của việc chia sẻ.', 'filename-1735047727225.jpg', 'Kinh nghiệm cá nhân', 'Chia sẻ kinh nghiệm cá nhân', 'Tại sao việc chia sẻ kinh nghiệm lại quan trọng và cách tạo không gian thoải mái để tâm sự.');
INSERT INTO `news` VALUES ('SUB0024', 'WRT0009', 'STS0001', 'NEWS0137', '2025-01-01 00:00:00', 'Cách đối mặt với căng thẳng.', b'1', 3750, 'Mẹo để giảm căng thẳng.', 'filename-1735047727225.jpg', 'Đối mặt căng thẳng', 'Giảm căng thẳng hiệu quả', 'Hướng dẫn các phương pháp đơn giản để giảm căng thẳng trong cuộc sống hàng ngày.');
INSERT INTO `news` VALUES ('SUB0024', 'WRT0009', 'STS0001', 'NEWS0138', '2024-12-29 00:00:00', 'Xây dựng sự tự tin.', b'1', 3800, 'Cách để tự tin hơn.', 'filename-1735047727225.jpg', 'Tự tin trong cuộc sống', 'Phát triển sự tự tin', 'Những cách hiệu quả để nâng cao sự tự tin và đạt được mục tiêu cá nhân.');
INSERT INTO `news` VALUES ('SUB0024', 'WRT0009', 'STS0001', 'NEWS0139', '2024-12-23 00:00:00', 'Tìm sự cân bằng trong cuộc sống.', b'0', 3850, 'Lời khuyên để cân bằng cuộc sống.', 'filename-1735047727225.jpg', 'Cân bằng cuộc sống', 'Tìm cân bằng cuộc sống', 'Làm thế nào để cân bằng giữa công việc, gia đình và sở thích cá nhân một cách hiệu quả.');
INSERT INTO `news` VALUES ('SUB0025', 'WRT0010', 'STS0001', 'NEWS0140', '2024-12-23 00:00:00', 'Đa dạng văn hóa ở châu Á.', b'0', 3900, 'Khám phá những nền văn hóa phong phú ở châu Á.', 'filename-1735047727225.jpg', 'Đa dạng văn hóa ở châu Á', 'Tổng quan về đa dạng văn hóa ở châu Á', 'Tổng quan về sự đa dạng văn hóa của châu Á.');
INSERT INTO `news` VALUES ('SUB0025', 'WRT0010', 'STS0001', 'NEWS0141', '2024-12-25 00:00:00', 'Điểm đến du lịch ở châu Á.', b'1', 3950, 'Những địa điểm du lịch hàng đầu ở châu Á.', 'filename-1735047727225.jpg', 'Điểm đến du lịch ở châu Á', 'Những địa điểm du lịch nổi bật ở châu Á', 'Khám phá những điểm du lịch nổi bật ở châu Á.');
INSERT INTO `news` VALUES ('SUB0025', 'WRT0010', 'STS0001', 'NEWS0142', '2024-12-29 00:00:00', 'Những món ăn đặc trưng của châu Á.', b'0', 4000, 'Khám phá ẩm thực đặc sắc của châu Á.', 'filename-1735047727225.jpg', 'Những món ăn đặc trưng của châu Á', 'Khám phá ẩm thực châu Á', 'Khám phá những món ăn ngon và đặc trưng của châu Á.');
INSERT INTO `news` VALUES ('SUB0025', 'WRT0010', 'STS0001', 'NEWS0143', '2025-01-02 00:00:00', 'Lễ hội ở châu Á.', b'1', 4050, 'Những lễ hội đặc sắc ở châu Á.', 'filename-1735047727225.jpg', 'Lễ hội ở châu Á', 'Các lễ hội lớn ở châu Á', 'Khám phá những lễ hội nổi bật ở châu Á, thể hiện văn hóa truyền thống.');
INSERT INTO `news` VALUES ('SUB0026', 'WRT0010', 'STS0001', 'NEWS0144', '2024-12-27 00:00:00', 'Những địa danh lịch sử ở châu Âu.', b'0', 4100, 'Khám phá những di tích lịch sử nổi bật của châu Âu.', 'filename-1735047727225.jpg', 'Những địa danh lịch sử ở châu Âu', 'Những địa danh lịch sử quan trọng ở châu Âu', 'Tổng quan về những di tích lịch sử quan trọng ở châu Âu.');
INSERT INTO `news` VALUES ('SUB0026', 'WRT0010', 'STS0001', 'NEWS0145', '2024-12-28 00:00:00', 'Nghệ thuật và kiến trúc châu Âu.', b'1', 4150, 'Khám phá di sản nghệ thuật của châu Âu.', 'filename-1735047727225.jpg', 'Nghệ thuật và kiến trúc châu Âu', 'Di sản nghệ thuật và kiến trúc của châu Âu', 'Khám phá các phong trào nghệ thuật và các công trình kiến trúc vĩ đại của châu Âu.');
INSERT INTO `news` VALUES ('SUB0026', 'WRT0010', 'STS0001', 'NEWS0146', '2024-12-31 00:00:00', 'Ẩm thực châu Âu.', b'0', 4200, 'Khám phá những món ăn ngon của châu Âu.', 'filename-1735047727225.jpg', 'Ẩm thực châu Âu', 'Khám phá ẩm thực châu Âu', 'Hướng dẫn về những món ăn đặc trưng của châu Âu.');
INSERT INTO `news` VALUES ('SUB0026', 'WRT0010', 'STS0001', 'NEWS0147', '2024-12-20 00:00:00', 'Truyền thống và phong tục châu Âu.', b'0', 4250, 'Khám phá các phong tục văn hóa ở châu Âu.', 'filename-1735047727225.jpg', 'Truyền thống và phong tục châu Âu', 'Các phong tục và truyền thống độc đáo của châu Âu', 'Khám phá các truyền thống và phong tục đặc biệt ở châu Âu.');
INSERT INTO `news` VALUES ('SUB0027', 'WRT0010', 'STS0001', 'NEWS0148', '2025-01-02 00:00:00', 'Những kỳ quan thiên nhiên của châu Mỹ.', b'0', 4300, 'Khám phá những phong cảnh tuyệt đẹp của châu Mỹ.', 'filename-1735047727225.jpg', 'Những kỳ quan thiên nhiên của châu Mỹ', 'Những kỳ quan thiên nhiên nổi bật ở châu Mỹ', 'Khám phá những cảnh quan thiên nhiên tuyệt vời ở Bắc và Nam Mỹ.');
INSERT INTO `news` VALUES ('SUB0027', 'WRT0010', 'STS0001', 'NEWS0149', '2024-12-22 00:00:00', 'Lễ hội văn hóa ở châu Mỹ.', b'1', 4350, 'Các lễ hội văn hóa thể hiện sự đa dạng của châu Mỹ.', 'filename-1735047727225.jpg', 'Lễ hội văn hóa ở châu Mỹ', 'Các lễ hội văn hóa nổi bật ở châu Mỹ', 'Khám phá các lễ hội văn hóa đặc sắc ở châu Mỹ.');
INSERT INTO `news` VALUES ('SUB0027', 'WRT0010', 'STS0001', 'NEWS0150', '2024-12-23 00:00:00', 'Đặc sản ẩm thực Mỹ.', b'0', 4400, 'Khám phá những món ăn đặc trưng của Mỹ.', 'filename-1735047727225.jpg', 'Đặc sản ẩm thực Mỹ', 'Những món ăn đặc sắc của Mỹ', 'Khám phá những món ăn đặc trưng và nổi tiếng của ẩm thực Mỹ.');
INSERT INTO `news` VALUES ('SUB0027', 'WRT0010', 'STS0001', 'NEWS0151', '2024-12-26 00:00:00', 'Các di tích lịch sử ở Mỹ.', b'0', 4450, 'Khám phá những di tích lịch sử quan trọng của Mỹ.', 'filename-1735047727225.jpg', 'Các di tích lịch sử ở Mỹ', 'Những di tích lịch sử nổi tiếng ở Mỹ', 'Khám phá các di tích lịch sử nổi tiếng ở Hoa Kỳ.');
INSERT INTO `news` VALUES ('SUB0028', 'WRT0010', 'STS0001', 'NEWS0152', '2024-12-31 00:00:00', 'Động vật hoang dã và thiên nhiên ở châu Phi.', b'0', 4502, 'Khám phá sự đa dạng sinh học phong phú của châu Phi.', 'filename-1735047727225.jpg', 'Động vật hoang dã và thiên nhiên ở châu Phi', 'Động vật hoang dã và thiên nhiên ở châu Phi', 'Khám phá các loài động vật hoang dã và thiên nhiên tuyệt vời ở châu Phi.');
INSERT INTO `news` VALUES ('SUB0028', 'WRT0010', 'STS0001', 'NEWS0153', '2024-12-21 00:00:00', 'Di sản văn hóa của châu Phi.', b'1', 4550, 'Khám phá sự đa dạng văn hóa của châu Phi.', 'filename-1735047727225.jpg', 'Di sản văn hóa của châu Phi', 'Di sản văn hóa phong phú của châu Phi', 'Khám phá di sản văn hóa đa dạng và phong phú của châu Phi.');
INSERT INTO `news` VALUES ('SUB0028', 'WRT0010', 'STS0001', 'NEWS0154', '2024-12-25 00:00:00', 'Ẩm thực châu Phi.', b'0', 4600, 'Khám phá những món ăn độc đáo của châu Phi.', 'filename-1735047727225.jpg', 'Ẩm thực châu Phi', 'Những món ăn đặc sắc của châu Phi', 'Khám phá ẩm thực đặc sắc của các vùng đất nước Châu Phi xinh đẹp');
INSERT INTO `news` VALUES ('SUB0028', 'WRT0010', 'STS0001', 'NEWS0155', '2024-12-30 00:00:00', 'Tôi thấy lai động nước ngoài hiện xâm nhập nước mình rất nhiều, một số làm kĩ sư cho các công ty, một số thì dạy ngoại ngữ và lao đông chân tay. Nhưng đa phần người nước ngoài rất coi thường luật lệ giao thông ở việt nam, đi xe máy lạng lách tạt đầu và nhất là không đội mũ bảo hiểm. Sau đó là tệ nạn về đêm nhiều khu vực tôi sống nhất các phòng trọ và chung cư có người nước ngoài ở rất phức tạp mong các cơ quan quản lý vấn đề này chặt chẽ hơn.', b'1', 4651, 'Tài vừa tốt nghiệp Thạc sĩ và được một tập đoàn công nghệ lớn tại Pháp nhận vào làm việc. Anh có chút sốt ruột trong khi chờ hoàn thiện thủ tục cư trú dành cho lao động người nước ngoài.', 'filename-1735047727225.jpg', 'Nhập khẩu lao động châu Phi', 'Nhập khẩu lao động châu Phi', 'Lao động nhập cư bất hợp pháp là một vấn đề lớn đối với nhiều quốc gia, thậm chí trở thành chủ đề chính của các chiến dịch vận động tranh cử lãnh đạo đất nước. Việt Nam chưa trở thành \"miền đất hứa\" cũng như không có vị trí địa lý thuận lợi cho dòng người di cư từ châu Phi, nhưng vẫn bắt đầu manh nha hình thành những khu vực hấp dẫn với người nhập cư bất hợp pháp. Chuyện không hẳn vui, cũng chẳng phải buồn, nhưng đáng quan tâm và lo ngại. Nếu không kiểm soát tốt, tình trạng này có thể gây mất an toàn trật tự xã hội, ảnh hưởng đến an sinh, thậm chí an ninh quốc gia nếu dòng lao động bất hợp pháp tiếp tục phình to ra, hoặc đến từ những khu vực có điều kiện địa lý thuận lợi');
INSERT INTO `news` VALUES ('SUB0029', 'WRT0011', 'STS0001', 'NEWS0156', '2024-12-23 00:00:00', 'Mua nhà lần đầu.', b'1', 4700, 'Lời khuyên cho người mua nhà lần đầu.', 'filename-1735047727225.jpg', 'Mua nhà lần đầu', 'Mua nhà lần đầu', 'Tổng quan về việc mua nhà lần đầu.');
INSERT INTO `news` VALUES ('SUB0029', 'WRT0011', 'STS0001', 'NEWS0157', '2024-12-25 00:00:00', 'Lời khuyên bảo trì nhà cửa.', b'0', 4750, 'Cách giữ cho ngôi nhà của bạn luôn trong tình trạng tốt.', 'filename-1735047727225.jpg', 'Lời khuyên bảo trì nhà cửa', 'Bảo trì nhà cửa', 'Tổng quan về bảo trì nhà cửa.');
INSERT INTO `news` VALUES ('SUB0029', 'WRT0011', 'STS0001', 'NEWS0158', '2024-12-27 00:00:00', 'Ý tưởng thiết kế nội thất.', b'1', 4800, 'Cách sáng tạo để trang trí ngôi nhà của bạn.', 'filename-1735047727225.jpg', 'Ý tưởng thiết kế nội thất', 'Thiết kế nội thất', 'Tổng quan về ý tưởng thiết kế nội thất.');
INSERT INTO `news` VALUES ('SUB0029', 'WRT0011', 'STS0001', 'NEWS0159', '2024-12-29 00:00:00', 'Lời khuyên về an ninh nhà cửa.', b'0', 4850, 'Cách giữ cho ngôi nhà của bạn an toàn.', 'filename-1735047727225.jpg', 'Lời khuyên về an ninh nhà cửa', 'An ninh nhà cửa', 'Tổng quan về an ninh nhà cửa.');
INSERT INTO `news` VALUES ('SUB0030', 'WRT0011', 'STS0001', 'NEWS0160', '2024-12-19 00:00:00', 'Thiết lập văn phòng tại nhà.', b'0', 4900, 'Lời khuyên về việc tạo ra không gian làm việc hiệu quả.', 'filename-1735047727225.jpg', 'Thiết lập văn phòng tại nhà', 'Thiết lập văn phòng tại nhà', 'Tổng quan về thiết lập văn phòng tại nhà.');
INSERT INTO `news` VALUES ('SUB0030', 'WRT0011', 'STS0001', 'NEWS0161', '2024-12-20 00:00:00', 'Lời khuyên về tổ chức văn phòng.', b'0', 4950, 'Cách giữ cho văn phòng của bạn luôn gọn gàng.', 'filename-1735047727225.jpg', 'Lời khuyên về tổ chức văn phòng', 'Tổ chức văn phòng', 'Tổng quan về cách tổ chức văn phòng.');
INSERT INTO `news` VALUES ('SUB0030', 'WRT0011', 'STS0001', 'NEWS0162', '2024-12-27 00:00:00', 'Chọn thiết bị văn phòng phù hợp.', b'1', 5000, 'Các công cụ thiết yếu cho văn phòng của bạn.', 'filename-1735047727225.jpg', 'Chọn thiết bị văn phòng phù hợp', 'Thiết bị văn phòng', 'Tổng quan về việc chọn thiết bị văn phòng.');
INSERT INTO `news` VALUES ('SUB0030', 'WRT0011', 'STS0001', 'NEWS0163', '2025-01-01 00:00:00', 'Cân bằng công việc và cuộc sống trong văn phòng.', b'0', 5050, 'Duy trì sự cân bằng khi làm việc.', 'filename-1735047727225.jpg', 'Cân bằng công việc và cuộc sống trong văn phòng', 'Cân bằng công việc và cuộc sống', 'Tổng quan về cân bằng công việc và cuộc sống trong văn phòng.');
INSERT INTO `news` VALUES ('SUB0031', 'WRT0011', 'STS0001', 'NEWS0164', '2024-12-19 00:00:00', 'Chiến lược đầu tư cho người mới bắt đầu.', b'0', 5100, 'Cách bắt đầu đầu tư một cách khôn ngoan.', 'filename-1735047727225.jpg', 'Chiến lược đầu tư cho người mới bắt đầu', 'Chiến lược đầu tư', 'Tổng quan về các chiến lược đầu tư cho người mới bắt đầu.');
INSERT INTO `news` VALUES ('SUB0031', 'WRT0011', 'STS0001', 'NEWS0165', '2024-12-24 00:00:00', 'Hiểu biết về cổ phiếu và trái phiếu.', b'1', 5150, 'Kiến thức cơ bản về đầu tư cổ phiếu và trái phiếu.', 'filename-1735047727225.jpg', 'Hiểu biết về cổ phiếu và trái phiếu', 'Cổ phiếu và trái phiếu', 'Tổng quan về cổ phiếu và trái phiếu.');
INSERT INTO `news` VALUES ('SUB0031', 'WRT0011', 'STS0001', 'NEWS0166', '2024-12-27 00:00:00', 'Lời khuyên về đầu tư bất động sản.', b'0', 5200, 'Cách đầu tư vào bất động sản.', 'filename-1735047727225.jpg', 'Lời khuyên về đầu tư bất động sản', 'Đầu tư bất động sản', 'Tổng quan về đầu tư bất động sản.');
INSERT INTO `news` VALUES ('SUB0031', 'WRT0011', 'STS0001', 'NEWS0167', '2024-12-30 00:00:00', 'Đa dạng hóa danh mục đầu tư của bạn.', b'1', 5250, 'Tầm quan trọng của việc đa dạng hóa đầu tư.', 'filename-1735047727225.jpg', 'Đa dạng hóa danh mục đầu tư', 'Đa dạng hóa danh mục đầu tư', 'Tổng quan về việc đa dạng hóa danh mục đầu tư.');
INSERT INTO `news` VALUES ('SUB0032', 'WRT0011', 'STS0001', 'NEWS0168', '2024-12-21 00:00:00', 'Hiểu biết về hợp đồng pháp lý.', b'0', 5300, 'Kiến thức cơ bản về hợp đồng và thỏa thuận.', 'filename-1735047727225.jpg', 'Hiểu biết về hợp đồng pháp lý', 'Hợp đồng pháp lý', 'Tổng quan về hợp đồng pháp lý.');
INSERT INTO `news` VALUES ('SUB0032', 'WRT0011', 'STS0001', 'NEWS0169', '2024-12-23 00:00:00', 'Quyền và nghĩa vụ pháp lý.', b'0', 5350, 'Biết quyền lợi và nghĩa vụ của bạn.', 'filename-1735047727225.jpg', 'Quyền và nghĩa vụ pháp lý', 'Quyền lợi và nghĩa vụ pháp lý', 'Tổng quan về quyền và nghĩa vụ pháp lý.');
INSERT INTO `news` VALUES ('SUB0032', 'WRT0011', 'STS0001', 'NEWS0170', '2024-12-30 00:00:00', 'Cách giải quyết tranh chấp pháp lý.', b'0', 5400, 'Các bước giải quyết tranh chấp hợp pháp.', 'filename-1735047727225.jpg', 'Cách giải quyết tranh chấp pháp lý', 'Giải quyết tranh chấp pháp lý', 'Tổng quan về giải quyết tranh chấp pháp lý.');
INSERT INTO `news` VALUES ('SUB0032', 'WRT0011', 'STS0001', 'NEWS0171', '2025-01-02 00:00:00', 'Tìm kiếm luật sư tốt.', b'1', 5450, 'Lời khuyên để chọn đại diện pháp lý phù hợp.', 'filename-1735047727225.jpg', 'Tìm kiếm luật sư tốt', 'Tìm luật sư tốt', 'Tổng quan về việc tìm kiếm luật sư tốt.');
INSERT INTO `news` VALUES ('SUB0033', 'WRT0012', 'STS0001', 'NEWS0172', '2024-12-19 00:00:00', 'Các bộ phim sắp ra mắt.', b'0', 5500, 'Những bộ phim đáng xem trong những tháng tới.', 'filename-1735047727225.jpg', 'Các bộ phim sắp ra mắt', 'Các bộ phim sắp ra mắt', 'Tổng quan về các bộ phim sắp ra mắt.');
INSERT INTO `news` VALUES ('SUB0033', 'WRT0012', 'STS0001', 'NEWS0173', '2024-12-22 00:00:00', 'Những bộ phim hay nhất trong năm.', b'0', 5550, 'Nhìn lại những bộ phim xuất sắc nhất trong năm nay.', 'filename-1735047727225.jpg', 'Những bộ phim hay nhất trong năm', 'Những bộ phim hay nhất trong năm', 'Tổng quan về những bộ phim hay nhất trong năm.');
INSERT INTO `news` VALUES ('SUB0033', 'WRT0012', 'STS0001', 'NEWS0174', '2024-12-27 00:00:00', 'Đánh giá và phê bình phim.', b'0', 5600, 'Đánh giá chi tiết các bộ phim nổi bật.', 'filename-1735047727225.jpg', 'Đánh giá và phê bình phim', 'Đánh giá phim', 'Tổng quan về các đánh giá phim.');
INSERT INTO `news` VALUES ('SUB0033', 'WRT0012', 'STS0001', 'NEWS0175', '2024-12-31 00:00:00', 'Hậu trường sản xuất phim.', b'0', 5650, 'Cái nhìn sâu sắc về quy trình làm phim.', 'filename-1735047727225.jpg', 'Hậu trường sản xuất phim', 'Hậu trường làm phim', 'Tổng quan về hậu trường làm phim.');
INSERT INTO `news` VALUES ('SUB0034', 'WRT0012', 'STS0001', 'NEWS0176', '2024-12-21 00:00:00', 'Những sản phẩm âm nhạc mới nhất.', b'0', 5700, 'Những gì mới trong thế giới âm nhạc.', 'filename-1735047727225.jpg', 'Những sản phẩm âm nhạc mới nhất', 'Âm nhạc mới nhất', 'Tổng quan về các sản phẩm âm nhạc mới nhất.');
INSERT INTO `news` VALUES ('SUB0034', 'WRT0012', 'STS0001', 'NEWS0177', '2024-12-22 00:00:00', 'Bảng xếp hạng âm nhạc hàng đầu.', b'0', 5750, 'Những bài hát phổ biến hiện nay.', 'filename-1735047727225.jpg', 'Bảng xếp hạng âm nhạc', 'Bảng xếp hạng âm nhạc', 'Tổng quan về bảng xếp hạng âm nhạc.');
INSERT INTO `news` VALUES ('SUB0034', 'WRT0012', 'STS0001', 'NEWS0178', '2024-12-26 00:00:00', 'Các buổi hòa nhạc và biểu diễn trực tiếp.', b'0', 5800, 'Những buổi hòa nhạc sắp tới bạn nên tham dự.', 'filename-1735047727225.jpg', 'Các buổi hòa nhạc và biểu diễn trực tiếp', 'Hòa nhạc và biểu diễn', 'Tổng quan về các buổi hòa nhạc và biểu diễn.');
INSERT INTO `news` VALUES ('SUB0034', 'WRT0012', 'STS0001', 'NEWS0179', '2024-12-31 00:00:00', 'Phỏng vấn với các nghệ sĩ.', b'0', 5850, 'Phỏng vấn độc quyền với các nhạc sĩ và ca sĩ.', 'filename-1735047727225.jpg', 'Phỏng vấn với các nghệ sĩ', 'Phỏng vấn nghệ sĩ', 'Tổng quan về các phỏng vấn với nghệ sĩ.');
INSERT INTO `news` VALUES ('SUB0035', 'WRT0012', 'STS0001', 'NEWS0180', '2024-12-23 00:00:00', 'Các gameshow phổ biến trên TV.', b'0', 5900, 'Những gameshow đáng xem trên màn hình của bạn.', 'filename-1735047727225.jpg', 'Các gameshow phổ biến trên TV', 'Các gameshow trên TV', 'Tổng quan về các gameshow phổ biến trên TV.');
INSERT INTO `news` VALUES ('SUB0035', 'WRT0012', 'STS0001', 'NEWS0181', '2024-12-24 00:00:00', 'Hậu trường các gameshow.', b'0', 5950, 'Cách các gameshow được sản xuất.', 'filename-1735047727225.jpg', 'Hậu trường các gameshow', 'Hậu trường gameshow', 'Tổng quan về hậu trường các gameshow.');
INSERT INTO `news` VALUES ('SUB0035', 'WRT0012', 'STS0001', 'NEWS0182', '2024-12-29 00:00:00', 'Phỏng vấn với người dẫn chương trình gameshow.', b'0', 6000, 'Những chia sẻ từ những người dẫn chương trình yêu thích của bạn.', 'filename-1735047727225.jpg', 'Phỏng vấn với người dẫn chương trình gameshow', 'Phỏng vấn người dẫn chương trình', 'Tổng quan về phỏng vấn người dẫn chương trình gameshow.');
INSERT INTO `news` VALUES ('SUB0035', 'WRT0012', 'STS0001', 'NEWS0183', '2025-01-02 00:00:00', 'Trí thức và sự thật thú vị về gameshow.', b'0', 6050, 'Những sự thật thú vị về các gameshow.', 'filename-1735047727225.jpg', 'Trí thức và sự thật thú vị về gameshow', 'Sự thật gameshow', 'Tổng quan về sự thật thú vị về các gameshow.');
INSERT INTO `news` VALUES ('SUB0036', 'WRT0012', 'STS0001', 'NEWS0184', '2024-12-23 00:00:00', 'Các vở kịch sắp tới.', b'0', 1504, 'Những vở kịch sẽ được trình diễn trong mùa này.', 'filename-1735047727225.jpg', 'Các vở kịch sắp tới', 'Các vở kịch sắp tới', 'Tổng quan về các vở kịch sắp tới.');
INSERT INTO `news` VALUES ('SUB0036', 'WRT0012', 'STS0001', 'NEWS0185', '2024-12-25 00:00:00', 'Đánh giá các buổi biểu diễn gần đây.', b'0', 6150, 'Những phê bình về các buổi biểu diễn mới đây.', 'filename-1735047727225.jpg', 'Đánh giá các buổi biểu diễn gần đây', 'Đánh giá buổi biểu diễn', 'Tổng quan về các buổi biểu diễn sân khấu gần đây.');
INSERT INTO `news` VALUES ('SUB0036', 'WRT0012', 'STS0001', 'NEWS0186', '2024-12-29 00:00:00', 'Phỏng vấn với các diễn viên sân khấu.', b'0', 6200, 'Những chia sẻ từ các diễn viên sân khấu.', 'filename-1735047727225.jpg', 'Phỏng vấn với các diễn viên sân khấu', 'Phỏng vấn diễn viên sân khấu', 'Tổng quan về các phỏng vấn diễn viên sân khấu.');
INSERT INTO `news` VALUES ('SUB0036', 'WRT0012', 'STS0001', 'NEWS0187', '2025-01-01 00:00:00', 'Lịch sử và sự phát triển của sân khấu.', b'0', 6250, 'Khám phá lịch sử sân khấu và sự phát triển của nó.', 'filename-1735047727225.jpg', 'Lịch sử và sự phát triển của sân khấu', 'Lịch sử sân khấu', 'Tổng quan về lịch sử và sự phát triển của sân khấu.');
INSERT INTO `news` VALUES ('SUB0037', 'WRT0013', 'STS0001', 'NEWS0188', '2024-12-24 00:00:00', 'Những vụ án hình sự mới nhất trong tin tức.', b'0', 6300, 'Tổng quan về các vụ án hình sự gần đây.', 'filename-1735047727225.jpg', 'Những vụ án hình sự mới nhất trong tin tức', 'Tin tức vụ án hình sự', 'Tổng quan về các vụ án hình sự gần đây.');
INSERT INTO `news` VALUES ('SUB0037', 'WRT0013', 'STS0001', 'NEWS0189', '2024-12-29 00:00:00', 'Hiểu biết về luật hình sự.', b'0', 6350, 'Giải thích về các khái niệm cơ bản của luật hình sự.', 'filename-1735047727225.jpg', 'Hiểu biết về luật hình sự', 'Khái niệm luật hình sự', 'Tổng quan về luật hình sự.');
INSERT INTO `news` VALUES ('SUB0037', 'WRT0013', 'STS0001', 'NEWS0190', '2024-12-30 00:00:00', 'Phỏng vấn với lực lượng thực thi pháp luật.', b'0', 6400, 'Những thông tin từ các sĩ quan cảnh sát.', 'filename-1735047727225.jpg', 'Phỏng vấn với lực lượng thực thi pháp luật', 'Phỏng vấn lực lượng thực thi pháp luật', 'Phỏng vấn với lực lượng thực thi pháp luật.');
INSERT INTO `news` VALUES ('SUB0037', 'WRT0013', 'STS0001', 'NEWS0191', '2025-01-01 00:00:00', 'Mẹo phòng chống tội phạm.', b'1', 6450, 'Cách giữ an toàn và ngăn ngừa tội phạm.', 'filename-1735047727225.jpg', 'Mẹo phòng chống tội phạm', 'Ngăn ngừa tội phạm', 'Mẹo phòng chống tội phạm.');
INSERT INTO `news` VALUES ('SUB0038', 'WRT0013', 'STS0001', 'NEWS0192', '2024-12-25 00:00:00', 'Cơ bản về luật dân sự.', b'1', 6500, 'Hiểu về luật dân sự và các ứng dụng của nó.', 'filename-1735047727225.jpg', 'Cơ bản về luật dân sự', 'Giới thiệu về luật dân sự', 'Tổng quan về luật dân sự.');
INSERT INTO `news` VALUES ('SUB0038', 'WRT0013', 'STS0001', 'NEWS0193', '2024-12-28 00:00:00', 'Các tranh chấp dân sự phổ biến.', b'0', 6550, 'Tổng quan về các tranh chấp dân sự điển hình.', 'filename-1735047727225.jpg', 'Các tranh chấp dân sự phổ biến', 'Tranh chấp dân sự phổ biến', 'Các tranh chấp dân sự phổ biến.');
INSERT INTO `news` VALUES ('SUB0038', 'WRT0013', 'STS0001', 'NEWS0194', '2024-12-30 00:00:00', 'Cách giải quyết tranh chấp dân sự.', b'0', 6600, 'Các phương pháp giải quyết tranh chấp dân sự.', 'filename-1735047727225.jpg', 'Cách giải quyết tranh chấp dân sự', 'Giải quyết tranh chấp dân sự', 'Giải quyết tranh chấp dân sự.');
INSERT INTO `news` VALUES ('SUB0038', 'WRT0013', 'STS0001', 'NEWS0195', '2025-01-02 00:00:00', 'Quyền lợi pháp lý trong các vấn đề dân sự.', b'0', 6650, 'Hiểu về quyền lợi của bạn trong các vấn đề dân sự.', 'filename-1735047727225.jpg', 'Quyền lợi pháp lý trong các vấn đề dân sự', 'Quyền lợi dân sự', 'Quyền lợi pháp lý trong các vấn đề dân sự.');
INSERT INTO `news` VALUES ('SUB0039', 'WRT0013', 'STS0001', 'NEWS0196', '2024-12-19 00:00:00', 'Luật lao động và quy định.', b'1', 6700, 'Tổng quan về các luật lao động.', 'filename-1735047727225.jpg', 'Luật lao động và quy định', 'Luật lao động', 'Tổng quan về luật lao động.');
INSERT INTO `news` VALUES ('SUB0039', 'WRT0013', 'STS0001', 'NEWS0197', '2024-12-25 00:00:00', 'Quyền lợi và bảo vệ người lao động.', b'0', 6750, 'Hiểu về quyền lợi của người lao động.', 'filename-1735047727225.jpg', 'Quyền lợi và bảo vệ người lao động', 'Quyền lợi lao động', 'Quyền lợi và bảo vệ người lao động.');
INSERT INTO `news` VALUES ('SUB0039', 'WRT0013', 'STS0001', 'NEWS0198', '2024-12-29 00:00:00', 'Quy định về an toàn lao động.', b'0', 6800, 'Đảm bảo an toàn tại nơi làm việc.', 'filename-1735047727225.jpg', 'Quy định về an toàn lao động', 'An toàn lao động', 'Quy định về an toàn lao động.');
INSERT INTO `news` VALUES ('SUB0039', 'WRT0013', 'STS0001', 'NEWS0199', '2024-12-30 00:00:00', 'Cách xử lý tranh chấp lao động.', b'1', 6850, 'Giải quyết các mâu thuẫn trong công việc.', 'filename-1735047727225.jpg', 'Cách xử lý tranh chấp lao động', 'Xử lý tranh chấp lao động', 'Cách xử lý tranh chấp lao động.');
INSERT INTO `news` VALUES ('SUB0040', 'WRT0013', 'STS0001', 'NEWS0200', '2024-12-23 00:00:00', 'Các xu hướng kinh tế hiện tại.', b'0', 6900, 'Tổng quan về nền kinh tế hiện nay.', 'filename-1735047727225.jpg', 'Các xu hướng kinh tế hiện tại', 'Xu hướng kinh tế hiện tại', 'Tổng quan về các xu hướng kinh tế hiện tại.');
INSERT INTO `news` VALUES ('SUB0040', 'WRT0013', 'STS0001', 'NEWS0201', '2024-12-27 00:00:00', 'Hiểu về lạm phát.', b'0', 6950, 'Lạm phát là gì và những tác động của nó.', 'filename-1735047727225.jpg', 'Hiểu về lạm phát', 'Lạm phát và tác động', 'Hiểu về lạm phát.');
INSERT INTO `news` VALUES ('SUB0040', 'WRT0013', 'STS0001', 'NEWS0202', '2024-12-31 00:00:00', 'Cơ hội đầu tư trong nền kinh tế.', b'1', 7000, 'Những nơi đầu tư trong thị trường hiện tại.', 'filename-1735047727225.jpg', 'Cơ hội đầu tư trong nền kinh tế', 'Cơ hội đầu tư', 'Cơ hội đầu tư trong nền kinh tế.');
INSERT INTO `news` VALUES ('SUB0040', 'WRT0013', 'STS0001', 'NEWS0203', '2025-01-01 00:00:00', 'Các chính sách kinh tế và ảnh hưởng của chúng.', b'0', 7050, 'Cách các chính sách tác động đến nền kinh tế.', 'filename-1735047727225.jpg', 'Các chính sách kinh tế và ảnh hưởng của chúng', 'Chính sách kinh tế và ảnh hưởng', 'Các chính sách kinh tế và ảnh hưởng của chúng.');
INSERT INTO `news` VALUES ('SUB0041', 'WRT0014', 'STS0001', 'NEWS0204', '2024-12-23 00:00:00', 'Latest nutrition trends.', b'0', 7100, 'What’s new in nutrition.', 'filename-1735047727225.jpg', 'Khám phá xu hướng dinh dưỡng mới nhất cho năm 2024', 'Các xu hướng dinh dưỡng nổi bật trong năm 2024 và ảnh hưởng của chúng đến sức khỏe', 'Dinh dưỡng luôn là một yếu tố quan trọng trong việc duy trì sức khỏe. Trong năm 2024, một số xu hướng dinh dưỡng mới đang nổi lên và có thể ảnh hưởng đến lựa chọn thực phẩm của chúng ta. Những xu hướng này không chỉ tập trung vào việc cải thiện vóc dáng mà còn là cách giúp cơ thể khỏe mạnh hơn từ bên trong. Cùng tìm hiểu về những thay đổi này và cách chúng ta có thể áp dụng vào chế độ ăn hàng ngày.');
INSERT INTO `news` VALUES ('SUB0041', 'WRT0014', 'STS0001', 'NEWS0205', '2024-12-29 00:00:00', 'Innovations in nutrition science.', b'1', 7150, 'Exploring new nutrition science advancements.', 'filename-1735047727225.jpg', 'Những cải tiến mới trong khoa học dinh dưỡng', 'Các công nghệ mới trong nghiên cứu dinh dưỡng có thể thay đổi cuộc sống của bạn', 'Khoa học dinh dưỡng không ngừng phát triển với những công nghệ và nghiên cứu mới đang thay đổi cách chúng ta hiểu về chế độ ăn uống. Các nghiên cứu gần đây cho thấy tầm quan trọng của các vi chất dinh dưỡng và cách thức bổ sung chúng sao cho hiệu quả. Hãy cùng khám phá những cải tiến mới trong khoa học dinh dưỡng và những phát hiện có thể giúp bạn cải thiện sức khỏe toàn diện.');
INSERT INTO `news` VALUES ('SUB0041', 'WRT0014', 'STS0001', 'NEWS0206', '2024-12-30 00:00:00', 'Impact of nutrition on health.', b'0', 7200, 'How nutrition shapes our well-being.', 'filename-1735047727225.jpg', 'Dinh dưỡng và ảnh hưởng đến sức khỏe tổng thể', 'Dinh dưỡng có thể cải thiện sức khỏe tinh thần và thể chất như thế nào', 'Dinh dưỡng không chỉ là nguồn năng lượng cho cơ thể mà còn ảnh hưởng trực tiếp đến sức khỏe tinh thần và thể chất. Chế độ ăn uống hợp lý có thể giúp cải thiện tâm trạng, giảm căng thẳng và nâng cao hiệu suất làm việc. Hãy tìm hiểu cách thức dinh dưỡng có thể giúp bạn duy trì sức khỏe lâu dài.');
INSERT INTO `news` VALUES ('SUB0041', 'WRT0014', 'STS0001', 'NEWS0207', '2025-01-01 00:00:00', 'Future of nutrition science.', b'1', 7250, 'What to expect in the future of nutrition.', 'filename-1735047727225.jpg', 'Tương lai của khoa học dinh dưỡng', 'Những xu hướng và nghiên cứu dinh dưỡng sẽ định hình tương lai của ngành công nghiệp sức khỏe', 'Với sự tiến bộ của công nghệ và nghiên cứu y học, khoa học dinh dưỡng đang đi đến những bước tiến vượt bậc. Chúng ta có thể mong đợi những cải tiến lớn trong việc cá nhân hóa chế độ ăn uống và sử dụng công nghệ mới để tối ưu hóa sức khỏe. Bài viết này sẽ giúp bạn hình dung rõ ràng hơn về tương lai của dinh dưỡng và cách thức áp dụng chúng vào cuộc sống hàng ngày.');
INSERT INTO `news` VALUES ('SUB0042', 'WRT0014', 'STS0001', 'NEWS0208', '2024-12-25 21:19:49', 'Trends in healthcare diseases.', b'0', 999999314, '<p>&nbsp;</p>\r\n<article class=\"fck_detail \">\r\n<p class=\"Normal\">Tiếp đo&agrave;n l&atilde;nh đạo quận T&acirc;n B&igrave;nh ng&agrave;y 25/12, PGS.TS.BS L&ecirc; Đ&igrave;nh Thanh, Gi&aacute;m đốc Bệnh viện Thống Nhất, cho biết nhiều bệnh nh&acirc;n trong số n&agrave;y kh&ocirc;ng c&oacute; thẻ bảo hiểm hoặc thẻ bảo hiểm hết hạn. Do đ&oacute;, bệnh viện hỗ trợ viện ph&iacute; cho tất cả để phần n&agrave;o chia sẻ những kh&oacute; khăn, tổn thất của mọi người trong sự cố kh&ocirc;ng may.</p>\r\n<p class=\"Normal\">3 bệnh nh&acirc;n nặng nhất, gồm ch&agrave;ng trai 23 tuổi, hai c&ocirc; g&aacute;i 23 v&agrave; 24 tuổi, đ&atilde; được chuyển từ Khoa Hồi sức T&iacute;ch cực Chống độc sang khoa Nội h&ocirc; hấp nhờ sức khỏe tiến triển tốt. Cả ba đều suy h&ocirc; hấp do ngạt kh&iacute;, trong đ&oacute; hai trường hợp ngộ độc kh&iacute; CO, từng phải điều trị thở m&aacute;y.</p>\r\n<p class=\"Normal\">Theo PGS Thanh, bệnh viện đ&atilde; huy động nh&acirc;n lực v&agrave; trang thiết bị, ph&acirc;n luồng di chuyển tiếp nhận bệnh nh&acirc;n một c&aacute;ch nhanh nhất. Phần lớn nạn nh&acirc;n đều bị hoảng loạn, sợ h&atilde;i, lo lắng về chi ph&iacute;, n&ecirc;n ngo&agrave;i điều trị chuy&ecirc;n m&ocirc;n, b&aacute;c sĩ c&ograve;n phải trấn an về tinh thần.</p>\r\n<p class=\"Normal\"><img src=\"https://drive.tiny.cloud/1/c7ncx5x4bdo5yb9klw2gzs1kx687tmkt0zt4da7tppggll7v/a7ee4edb-358f-4a5f-bf5c-9629f3954b45\" alt=\"\" width=\"800\" height=\"533\"></p>\r\n<p class=\"Normal\">3 bệnh nh&acirc;n nặng nhất, gồm ch&agrave;ng trai 23 tuổi, hai c&ocirc; g&aacute;i 23 v&agrave; 24 tuổi, đ&atilde; được chuyển từ Khoa Hồi sức T&iacute;ch cực Chống độc sang khoa Nội h&ocirc; hấp nhờ sức khỏe tiến triển tốt. Cả ba đều suy h&ocirc; hấp do ngạt kh&iacute;, trong đ&oacute; hai trường hợp ngộ độc kh&iacute; CO, từng phải điều trị thở m&aacute;y.</p>\r\n<p class=\"Normal\">Theo PGS Thanh, bệnh viện đ&atilde; huy động nh&acirc;n lực v&agrave; trang thiết bị, ph&acirc;n luồng di chuyển tiếp nhận bệnh nh&acirc;n một c&aacute;ch nhanh nhất. Phần lớn nạn nh&acirc;n đều bị hoảng loạn, sợ h&atilde;i, lo lắng về chi ph&iacute;, n&ecirc;n ngo&agrave;i điều trị chuy&ecirc;n m&ocirc;n, b&aacute;c sĩ c&ograve;n phải trấn an về tinh thần.</p>\r\n<p class=\"Normal\">3 bệnh nh&acirc;n nặng nhất, gồm ch&agrave;ng trai 23 tuổi, hai c&ocirc; g&aacute;i 23 v&agrave; 24 tuổi, đ&atilde; được chuyển từ Khoa Hồi sức T&iacute;ch cực Chống độc sang khoa Nội h&ocirc; hấp nhờ sức khỏe tiến triển tốt. Cả ba đều suy h&ocirc; hấp do ngạt kh&iacute;, trong đ&oacute; hai trường hợp ngộ độc kh&iacute; CO, từng phải điều trị thở m&aacute;y.</p>\r\n<p class=\"Normal\">Theo PGS Thanh, bệnh viện đ&atilde; huy động nh&acirc;n lực v&agrave; trang thiết bị, ph&acirc;n luồng di chuyển tiếp nhận bệnh nh&acirc;n một c&aacute;ch nhanh nhất. Phần lớn nạn nh&acirc;n đều bị hoảng loạn, sợ h&atilde;i, lo lắng về chi ph&iacute;, n&ecirc;n ngo&agrave;i điều trị chuy&ecirc;n m&ocirc;n, b&aacute;c sĩ c&ograve;n phải trấn an về tinh thần.</p>\r\n<p class=\"Normal\">3 bệnh nh&acirc;n nặng nhất, gồm ch&agrave;ng trai 23 tuổi, hai c&ocirc; g&aacute;i 23 v&agrave; 24 tuổi, đ&atilde; được chuyển từ Khoa Hồi sức T&iacute;ch cực Chống độc sang khoa Nội h&ocirc; hấp nhờ sức khỏe tiến triển tốt. Cả ba đều suy h&ocirc; hấp do ngạt kh&iacute;, trong đ&oacute; hai trường hợp ngộ độc kh&iacute; CO, từng phải điều trị thở m&aacute;y.</p>\r\n<p class=\"Normal\">Theo PGS Thanh, bệnh viện đ&atilde; huy động nh&acirc;n lực v&agrave; trang thiết bị, ph&acirc;n luồng di chuyển tiếp nhận bệnh nh&acirc;n một c&aacute;ch nhanh nhất. Phần lớn nạn nh&acirc;n đều bị hoảng loạn, sợ h&atilde;i, lo lắng về chi ph&iacute;, n&ecirc;n ngo&agrave;i điều trị chuy&ecirc;n m&ocirc;n, b&aacute;c sĩ c&ograve;n phải trấn an về tinh thần.</p>\r\n<p class=\"Normal\"><img src=\"https://drive.tiny.cloud/1/c7ncx5x4bdo5yb9klw2gzs1kx687tmkt0zt4da7tppggll7v/f630fe85-38e4-49ee-890d-ac63a1bc0fc8\" alt=\"\" width=\"640\" height=\"480\"></p>\r\n<p class=\"Normal\">3 bệnh nh&acirc;n nặng nhất, gồm ch&agrave;ng trai 23 tuổi, hai c&ocirc; g&aacute;i 23 v&agrave; 24 tuổi, đ&atilde; được chuyển từ Khoa Hồi sức T&iacute;ch cực Chống độc sang khoa Nội h&ocirc; hấp nhờ sức khỏe tiến triển tốt. Cả ba đều suy h&ocirc; hấp do ngạt kh&iacute;, trong đ&oacute; hai trường hợp ngộ độc kh&iacute; CO, từng phải điều trị thở m&aacute;y.</p>\r\n<p class=\"Normal\">Theo PGS Thanh, bệnh viện đ&atilde; huy động nh&acirc;n lực v&agrave; trang thiết bị, ph&acirc;n luồng di chuyển tiếp nhận bệnh nh&acirc;n một c&aacute;ch nhanh nhất. Phần lớn nạn nh&acirc;n đều bị hoảng loạn, sợ h&atilde;i, lo lắng về chi ph&iacute;, n&ecirc;n ngo&agrave;i điều trị chuy&ecirc;n m&ocirc;n, b&aacute;c sĩ c&ograve;n phải trấn an về tinh thần.</p>\r\n<p class=\"Normal\">&nbsp;</p>\r\n<p class=\"Normal\">&nbsp;</p>\r\n<p class=\"Normal\">&nbsp;</p>\r\n</article>', 'filename-1735133766088.jpg', 'Các xu hướng bệnh lý trong chăm sóc sức khỏe hiện nay', 'Các bệnh lý đang nổi lên và tác động đến chăm sóc sức khỏe năm 2024', 'Bệnh lý luôn là vấn đề quan trọng trong chăm sóc sức khỏe cộng đồng. Các xu hướng bệnh lý mới đang ngày càng được phát hiện và có tác động mạnh mẽ đến việc điều trị và phòng ngừa. Năm 2024, các nghiên cứu về bệnh lý lây nhiễm và không lây nhiễm tiếp tục phát triển. Hãy cùng khám phá những bệnh lý nổi bật và cách chúng thay đổi quy trình chăm sóc sức khỏe.');
INSERT INTO `news` VALUES ('SUB0042', 'WRT0014', 'STS0001', 'NEWS0209', '2024-12-24 00:00:00', 'Chronic diseases and their management.', b'0', 7350, 'Managing chronic diseases effectively.', 'filename-1735047727225.jpg', 'Quản lý các bệnh lý mãn tính hiệu quả', 'Những cách quản lý bệnh lý mãn tính để sống khỏe mạnh', 'Bệnh lý mãn tính như tiểu đường, huyết áp cao, và bệnh tim mạch đang gia tăng và đe dọa đến sức khỏe của người dân. Quản lý bệnh lý mãn tính là một yếu tố quan trọng để duy trì sức khỏe lâu dài. Hãy tìm hiểu cách thức quản lý bệnh lý mãn tính thông qua chế độ ăn uống, tập thể dục, và thuốc men.');
INSERT INTO `news` VALUES ('SUB0042', 'WRT0014', 'STS0001', 'NEWS0210', '2024-12-29 00:00:00', 'Cancer treatment advancements.', b'0', 7400, 'How cancer treatments are evolving.', 'filename-1735047727225.jpg', 'Những tiến bộ trong điều trị ung thư', 'Những đột phá trong công nghệ điều trị ung thư và hy vọng cho bệnh nhân', 'Ung thư vẫn là một trong những căn bệnh gây tử vong cao nhất thế giới. Tuy nhiên, với những tiến bộ vượt bậc trong nghiên cứu và điều trị ung thư, khả năng chữa khỏi bệnh ngày càng tăng. Các phương pháp mới như liệu pháp gen và liệu pháp miễn dịch đang mở ra hy vọng lớn cho bệnh nhân. Cùng khám phá những tiến bộ này và cách chúng thay đổi tương lai của điều trị ung thư.');
INSERT INTO `news` VALUES ('SUB0042', 'WRT0014', 'STS0001', 'NEWS0211', '2024-12-31 00:00:00', 'Mental health diseases.', b'0', 7450, 'Understanding mental health diseases.', 'filename-1735047727225.jpg', 'Những bệnh lý liên quan đến sức khỏe tâm thần', 'Tìm hiểu về các bệnh lý sức khỏe tâm thần và ảnh hưởng đến cộng đồng', 'Sức khỏe tâm thần là một yếu tố quan trọng trong tổng thể sức khỏe con người. Các bệnh lý tâm thần như trầm cảm, lo âu, và rối loạn tâm thần đang trở thành vấn đề cấp bách cần được giải quyết. Hiểu về những bệnh lý này và cách điều trị chúng sẽ giúp giảm bớt gánh nặng sức khỏe tâm thần trong xã hội.');
INSERT INTO `news` VALUES ('SUB0043', 'WRT0014', 'STS0001', 'NEWS0212', '2024-12-09 00:00:00', 'Understanding exercise science.', b'1', 7500, 'Basics of exercise science awareness.', 'filename-1735047727225.jpg', 'Khám phá khoa học về tập luyện và lợi ích của việc tập thể dục', 'Những lợi ích của việc tập thể dục đối với sức khỏe thể chất và tinh thần', 'Tập luyện không chỉ giúp cải thiện sức khỏe thể chất mà còn có tác động tích cực đến tâm lý. Việc duy trì thói quen tập thể dục thường xuyên có thể giúp cải thiện sức khỏe tim mạch, xương khớp, và giảm nguy cơ mắc các bệnh mãn tính. Bài viết này sẽ giải thích rõ hơn về khoa học đằng sau việc tập luyện và cách thức giúp bạn đạt được hiệu quả cao nhất.');
INSERT INTO `news` VALUES ('SUB0043', 'WRT0014', 'STS0001', 'NEWS0213', '2024-12-20 00:00:00', 'Strength training benefits.', b'1', 7551, 'How strength training helps the body.', 'filename-1735047727225.jpg', 'Lợi ích của tập luyện sức mạnh đối với cơ thể', 'Tập luyện sức mạnh giúp tăng cơ bắp và duy trì sự dẻo dai', 'Tập luyện sức mạnh là một phương pháp tập luyện hiệu quả để tăng cường sức khỏe cơ bắp và xương khớp. Không chỉ giúp bạn có cơ bắp săn chắc mà còn cải thiện khả năng vận động và duy trì sự linh hoạt. Cùng khám phá những lợi ích của tập luyện sức mạnh và cách xây dựng chương trình tập luyện phù hợp.');
INSERT INTO `news` VALUES ('SUB0043', 'WRT0014', 'STS0001', 'NEWS0214', '2024-12-25 21:05:06', 'Cardio exercises and heart health.', b'1', 7601, '<p>Why cardio exercises are essential for heart health.</p>', 'filename-1735135506316.jpg', 'Lợi ích của tập luyện cardio đối với sức khỏe tim mạch', 'Các bài tập cardio giúp duy trì sức khỏe tim mạch và cải thiện tuần hoàn máu', 'Tập luyện cardio có vai trò quan trọng trong việc tăng cường sức khỏe tim mạch, giảm nguy cơ mắc bệnh tim và đột quỵ. Các bài tập như chạy bộ, đạp xe, bơi lội không chỉ giúp giảm cân mà còn cải thiện sức khỏe tổng thể. Cùng tìm hiểu các bài tập cardio và cách áp dụng chúng vào thói quen tập luyện hàng ngày.');
INSERT INTO `news` VALUES ('SUB0043', 'WRT0014', 'STS0001', 'NEWS0215', '2024-12-31 00:00:00', 'Stretching and flexibility exercises.', b'1', 7650, 'Why stretching is important for flexibility and injury prevention.', 'filename-1735047727225.jpg', 'Tầm quan trọng của việc kéo dãn cơ thể và phòng ngừa chấn thương', 'Tăng cường sự linh hoạt và phòng ngừa chấn thương với các bài tập kéo dãn', 'Kéo dãn cơ thể là một phần quan trọng trong quá trình tập luyện, giúp cải thiện sự linh hoạt và giảm nguy cơ chấn thương. Việc kéo dãn cơ thể trước và sau khi tập thể dục có thể giúp bạn giảm căng thẳng cơ bắp và duy trì sự dẻo dai. Hãy tìm hiểu về các bài tập kéo dãn cơ thể và lợi ích của chúng đối với sức khỏe.');
INSERT INTO `news` VALUES ('SUB0044', 'WRT0014', 'STS0001', 'NEWS0216', '2025-01-02 00:00:00', 'Latest psychology research.', b'1', 7701, 'What’s happening in the world of psychology.', 'filename-1735047727225.jpg', 'Các nghiên cứu tâm lý mới nhất và ứng dụng vào cuộc sống', 'Khám phá các nghiên cứu và xu hướng tâm lý mới trong năm 2024', 'Tâm lý học không chỉ giúp chúng ta hiểu về bản thân mà còn giúp cải thiện mối quan hệ với người khác và nâng cao sức khỏe tinh thần. Các nghiên cứu mới nhất trong lĩnh vực này tập trung vào việc tìm hiểu các yếu tố ảnh hưởng đến hành vi và cảm xúc của con người. Cùng tìm hiểu các xu hướng tâm lý và ứng dụng của chúng vào cuộc sống thực tế.');
INSERT INTO `news` VALUES ('SUB0044', 'WRT0014', 'STS0001', 'NEWS0217', '2024-12-29 00:00:00', 'Mental health strategies.', b'1', 7750, 'How to improve mental health with practical strategies.', 'filename-1735047727225.jpg', 'Các chiến lược cải thiện sức khỏe tâm lý hiệu quả', 'Hướng dẫn các chiến lược giảm căng thẳng và lo âu', 'Sức khỏe tâm lý là một yếu tố quan trọng trong việc duy trì chất lượng cuộc sống. Những chiến lược như thiền, tập thể dục, và các kỹ thuật giảm căng thẳng có thể giúp bạn cải thiện sức khỏe tinh thần và vượt qua những lo âu trong cuộc sống. Hãy tìm hiểu các chiến lược cải thiện sức khỏe tâm lý giúp bạn cảm thấy thư giãn và cân bằng hơn.');
INSERT INTO `news` VALUES ('SUB0044', 'WRT0014', 'STS0001', 'NEWS0218', '2024-12-27 00:00:00', 'Cognitive behavioral therapy (CBT).', b'1', 7800, 'How CBT can help mental health.', 'filename-1735047727225.jpg', 'Liệu pháp hành vi nhận thức (CBT) và ứng dụng trong điều trị tâm lý', 'Khám phá lợi ích của liệu pháp hành vi nhận thức trong điều trị các rối loạn tâm lý', 'Liệu pháp hành vi nhận thức (CBT) là một phương pháp điều trị hiệu quả cho các vấn đề tâm lý như trầm cảm, lo âu và các rối loạn tâm lý khác. Bằng cách thay đổi cách suy nghĩ và hành vi, CBT giúp bệnh nhân vượt qua những suy nghĩ tiêu cực và xây dựng những thói quen tích cực. Cùng tìm hiểu về CBT và cách ứng dụng phương pháp này trong điều trị các vấn đề tâm lý.');
INSERT INTO `news` VALUES ('SUB0044', 'WRT0014', 'STS0001', 'NEWS0219', '2024-12-26 00:00:00', 'Psychological effects of social media.', b'1', 7850, 'How social media impacts mental health.', 'filename-1735047727225.jpg', 'Tác động của mạng xã hội đối với sức khỏe tâm lý', 'Mạng xã hội ảnh hưởng như thế nào đến tâm lý và cảm xúc của người sử dụng', 'Mạng xã hội đã trở thành một phần không thể thiếu trong cuộc sống hiện đại, nhưng nó cũng mang đến những tác động tiêu cực đối với sức khỏe tâm lý của người dùng. Các nghiên cứu cho thấy việc sử dụng mạng xã hội quá mức có thể dẫn đến cảm giác cô đơn, lo âu và trầm cảm. Hãy cùng tìm hiểu về tác động của mạng xã hội và cách giảm thiểu những ảnh hưởng tiêu cực này đối với sức khỏe tâm lý.');
INSERT INTO `news` VALUES ('SUB0045', 'WRT0015', 'STS0001', 'NEWS0220', '2024-12-20 00:00:00', 'Top travel destinations in Vietnam for 2024.', b'1', 700, 'Explore the best places to visit in Vietnam this year.', 'filename-1735047727225.jpg', 'Những điểm đến du lịch hàng đầu tại Việt Nam trong năm 2024', 'Các điểm đến nổi bật tại Việt Nam trong năm 2024', 'Du lịch Việt Nam luôn có sức hút mạnh mẽ đối với du khách trong và ngoài nước. Những điểm đến du lịch đẹp và độc đáo như Hà Nội, Hội An, Phú Quốc, và Đà Nẵng đang thu hút hàng triệu lượt khách mỗi năm. Bài viết này sẽ giới thiệu những điểm đến nổi bật của Việt Nam trong năm 2024 và lý do tại sao bạn không nên bỏ lỡ cơ hội ghé thăm chúng.');
INSERT INTO `news` VALUES ('SUB0045', 'WRT0015', 'STS0001', 'NEWS0221', '2024-12-27 00:00:00', 'Travel tips for budget travelers in Vietnam.', b'1', 750, 'How to travel affordably in Vietnam.', 'filename-1735047727225.jpg', 'Những mẹo du lịch tiết kiệm tại Việt Nam', 'Cách du lịch tiết kiệm ở Việt Nam mà không làm giảm trải nghiệm', 'Du lịch Việt Nam không nhất thiết phải tốn kém. Với những mẹo du lịch tiết kiệm, bạn vẫn có thể trải nghiệm những điều tuyệt vời mà không phải chi quá nhiều tiền. Cùng khám phá những cách thức giúp bạn tiết kiệm chi phí khi du lịch trong nước, từ việc tìm kiếm chỗ ở giá rẻ đến việc lựa chọn các phương tiện giao thông tiết kiệm.');
INSERT INTO `news` VALUES ('SUB0045', 'WRT0015', 'STS0001', 'NEWS0222', '2024-12-29 00:00:00', 'Cultural experiences in Vietnam.', b'1', 800, 'Immerse yourself in local Vietnamese cultures.', 'filename-1735047727225.jpg', 'Trải nghiệm văn hóa tại các địa phương Việt Nam', 'Tìm hiểu về những trải nghiệm văn hóa đặc sắc tại các địa phương Việt Nam', 'Việt Nam là một đất nước đa dạng về văn hóa và truyền thống. Mỗi vùng miền đều có những nét văn hóa riêng biệt từ ẩm thực, phong tục tập quán đến các lễ hội đặc sắc. Hãy cùng khám phá các trải nghiệm văn hóa phong phú này và những điều đặc biệt mà du khách có thể trải nghiệm khi đến thăm các vùng đất nổi tiếng như Hà Giang, Huế, và Sài Gòn.');
INSERT INTO `news` VALUES ('SUB0045', 'WRT0015', 'STS0001', 'NEWS0223', '2025-01-01 00:00:00', 'Travel safety tips in Vietnam.', b'1', 8050, 'How to stay safe while traveling in Vietnam.', 'filename-1735047727225.jpg', 'Lời khuyên về an toàn khi du lịch tại Việt Nam', 'Các mẹo giữ an toàn khi du lịch ở Việt Nam', 'Du lịch ở Việt Nam rất an toàn, nhưng như bất kỳ điểm đến nào khác, bạn vẫn cần tuân thủ một số lưu ý để bảo vệ bản thân. Bài viết này sẽ cung cấp những lời khuyên hữu ích giúp bạn giữ an toàn khi tham quan các thành phố lớn như Hà Nội, TP.HCM, hay các khu vực nông thôn, đặc biệt là về giao thông và những vấn đề y tế cần chú ý.');
INSERT INTO `news` VALUES ('SUB0046', 'WRT0015', 'STS0001', 'NEWS0224', '2024-12-22 00:00:00', 'Top international travel destinations for 2024.', b'1', 8100, 'Explore the best global destinations to visit this year.', 'filename-1735047727225.jpg', 'Những điểm đến du lịch quốc tế hàng đầu trong năm 2024', 'Các điểm đến du lịch quốc tế nổi bật năm 2024', 'Du lịch quốc tế luôn mang đến những trải nghiệm tuyệt vời, từ những thành phố hiện đại như New York, Paris, Tokyo đến những thiên đường nhiệt đới như Maldives và Bali. Cùng khám phá các điểm đến du lịch quốc tế nổi bật trong năm 2024 và lý do tại sao chúng lại thu hút hàng triệu du khách mỗi năm.');
INSERT INTO `news` VALUES ('SUB0046', 'WRT0015', 'STS0001', 'NEWS0225', '2024-12-27 00:00:00', 'Travel tips for international travelers.', b'1', 8150, 'How to plan and travel internationally on a budget.', 'filename-1735047727225.jpg', 'Những mẹo du lịch quốc tế tiết kiệm', 'Cách du lịch quốc tế với ngân sách hợp lý', 'Du lịch quốc tế có thể là một trải nghiệm tuyệt vời, nhưng chi phí có thể là một vấn đề. Tuy nhiên, với những mẹo du lịch thông minh, bạn vẫn có thể khám phá những điểm đến yêu thích mà không phải tốn quá nhiều tiền. Bài viết này sẽ cung cấp cho bạn những gợi ý về cách lên kế hoạch du lịch quốc tế tiết kiệm mà vẫn có thể trải nghiệm trọn vẹn chuyến đi.');
INSERT INTO `news` VALUES ('SUB0046', 'WRT0015', 'STS0001', 'NEWS0226', '2024-12-30 00:00:00', 'Top cultural experiences worldwide.', b'1', 8200, 'Explore cultural experiences across the globe.', 'filename-1735047727225.jpg', 'Những trải nghiệm văn hóa độc đáo trên toàn cầu', 'Những trải nghiệm văn hóa thú vị tại các quốc gia trên thế giới', 'Khám phá những nền văn hóa độc đáo và phong phú trên khắp thế giới là một trong những lý do khiến du lịch quốc tế trở thành một hành trình không thể bỏ qua. Từ việc tham gia lễ hội truyền thống ở Ấn Độ, đến việc tìm hiểu nghệ thuật ẩm thực Pháp, bài viết này sẽ đưa bạn đến với những trải nghiệm văn hóa tuyệt vời ở nhiều quốc gia khác nhau.');
INSERT INTO `news` VALUES ('SUB0046', 'WRT0015', 'STS0001', 'NEWS0227', '2025-01-02 00:00:00', 'How to stay safe while traveling internationally.', b'1', 8250, 'Safety tips for international travel.', 'filename-1735047727225.jpg', 'Những mẹo an toàn khi du lịch quốc tế', 'Lời khuyên để bảo vệ bản thân khi du lịch quốc tế', 'Mặc dù du lịch quốc tế có thể rất hấp dẫn, nhưng cũng có những nguy cơ tiềm ẩn. Để chuyến đi của bạn trở nên suôn sẻ và an toàn, hãy tìm hiểu những mẹo về an toàn khi di chuyển ở nước ngoài, từ việc bảo vệ tài sản cá nhân đến những lưu ý về sức khỏe và giao thông quốc tế.');
INSERT INTO `news` VALUES ('SUB0047', 'WRT0015', 'STS0001', 'NEWS0228', '2024-12-19 00:00:00', 'Top food trends for 2024.', b'1', 8300, 'What’s trending in the culinary world this year.', 'filename-1735047727225.jpg', 'Những xu hướng ẩm thực nổi bật trong năm 2024', 'Những món ăn và phong cách ẩm thực đáng chú ý trong năm 2024', 'Trong năm 2024, ẩm thực toàn cầu sẽ chứng kiến nhiều xu hướng mới mẻ và sáng tạo. Những món ăn mới từ các nền văn hóa khác nhau sẽ được giới thiệu, từ các món ăn lành mạnh đến các thực phẩm độc đáo với nguyên liệu tự nhiên. Bài viết này sẽ cập nhật những xu hướng ẩm thực nổi bật và lý do tại sao chúng lại thu hút sự chú ý của những người yêu thích ẩm thực khắp nơi.');
INSERT INTO `news` VALUES ('SUB0047', 'WRT0015', 'STS0001', 'NEWS0229', '2024-12-25 20:55:52', 'Best street foods around the world.', b'0', 8352, '<p>Explore the most famous street food from different countries.</p>', 'filename-1735134952638.jpg', 'Những món ăn đường phố nổi tiếng thế giới', 'Những món ăn đường phố đặc sắc từ các quốc gia khác nhau', 'Ẩm thực đường phố luôn là một phần không thể thiếu trong văn hóa ẩm thực của mỗi quốc gia. Từ những món ăn đậm đà hương vị ở Thái Lan, đến những món ăn hấp dẫn ở Mexico, mỗi món ăn đường phố đều mang đến những trải nghiệm độc đáo. Bài viết này sẽ giới thiệu những món ăn đường phố nổi bật mà bạn không thể bỏ qua khi đi du lịch quốc tế.');
INSERT INTO `news` VALUES ('SUB0047', 'WRT0015', 'STS0001', 'NEWS0230', '2024-12-29 00:00:00', 'Traditional Vietnamese dishes you must try.', b'0', 8400, 'Discover the must-try dishes from Vietnam.', 'filename-1735047727225.jpg', 'Những món ăn truyền thống của Việt Nam bạn nhất định phải thử', 'Những món ăn đặc sản của Việt Nam mà du khách không thể bỏ lỡ', 'Ẩm thực Việt Nam nổi tiếng với sự đa dạng và hương vị đặc trưng. Từ phở, bún chả đến bánh mì, mỗi món ăn đều mang đậm dấu ấn văn hóa và sự sáng tạo của người dân nơi đây. Cùng tìm hiểu về những món ăn đặc sắc mà bạn không thể bỏ qua khi đến thăm Việt Nam.');
INSERT INTO `news` VALUES ('SUB0047', 'WRT0015', 'STS0001', 'NEWS0231', '2025-01-02 00:00:00', 'Vegan and vegetarian cuisine in Vietnam.', b'0', 8450, 'Explore the vegetarian and vegan food scene in Vietnam.', 'filename-1735047727225.jpg', 'Ẩm thực chay và thuần chay tại Việt Nam', 'Các món ăn thuần chay và chay nổi bật tại Việt Nam', 'Việt Nam là một điểm đến tuyệt vời cho những ai yêu thích ẩm thực chay và thuần chay. Các món ăn như bún riêu chay, cơm chay, hay gỏi cuốn chay đều là những lựa chọn hoàn hảo cho du khách tìm kiếm thực phẩm lành mạnh và ngon miệng. Bài viết này sẽ giới thiệu những món ăn chay và thuần chay phổ biến và dễ tìm thấy tại các thành phố lớn và các khu du lịch nổi tiếng.');
INSERT INTO `news` VALUES ('SUB0048', 'WRT0015', 'STS0001', 'NEWS0232', '2024-12-21 00:00:00', 'Top cultural festivals worldwide.', b'1', 8500, 'Discover the world’s top cultural festivals in 2024.', 'filename-1735047727225.jpg', 'Những lễ hội văn hóa hàng đầu thế giới trong năm 2024', 'Các lễ hội văn hóa nổi bật trên toàn cầu trong năm 2024', 'Lễ hội văn hóa luôn là dịp để chúng ta khám phá sự đa dạng và phong phú của các nền văn hóa trên thế giới. Từ lễ hội âm nhạc ở Amsterdam, lễ hội ánh sáng ở New Delhi đến lễ hội truyền thống tại Peru, những lễ hội này sẽ mang đến cho bạn những trải nghiệm khó quên về nghệ thuật và văn hóa đặc sắc của mỗi quốc gia.');
INSERT INTO `news` VALUES ('SUB0048', 'WRT0015', 'STS0001', 'NEWS0233', '2024-12-25 20:52:08', 'The role of traditional art forms in modern society.', b'0', 8550, '<p>Exploring the place of traditional art in today&rsquo;s world.</p>', 'filename-1735134728322.jpg', 'Vai trò của nghệ thuật truyền thống trong xã hội hiện đại', 'Sự phát triển của nghệ thuật truyền thống trong thế giới đương đại', 'Nghệ thuật truyền thống vẫn giữ một vai trò quan trọng trong xã hội hiện đại, dù đã có sự thay đổi lớn với sự phát triển của công nghệ và các xu hướng nghệ thuật mới. Bài viết này sẽ khám phá cách các hình thức nghệ thuật truyền thống như múa rối nước, ca trù, hay tranh Đông Hồ vẫn tồn tại và phát triển trong bối cảnh thế giới hiện đại.');
INSERT INTO `news` VALUES ('SUB0048', 'WRT0015', 'STS0001', 'NEWS0234', '2024-12-27 00:00:00', 'The impact of global cultures on local traditions.', b'1', 8600, 'How global culture is influencing local customs and traditions.', 'filename-1735047727225.jpg', 'Tác động của văn hóa toàn cầu đến các truyền thống địa phương', 'Sự thay đổi của các truyền thống văn hóa dưới ảnh hưởng toàn cầu', 'Trong thời đại toàn cầu hóa, các nền văn hóa lớn có ảnh hưởng mạnh mẽ đến các truyền thống địa phương. Từ các món ăn quốc tế đến lối sống hiện đại, bài viết này sẽ tìm hiểu về tác động của văn hóa toàn cầu đối với các truyền thống và phong tục ở những quốc gia như Việt Nam, Ấn Độ, và Mexico.');
INSERT INTO `news` VALUES ('SUB0048', 'WRT0015', 'STS0001', 'NEWS0235', '2024-12-30 00:00:00', 'The preservation of cultural heritage in the modern world.', b'1', 8650, 'How to protect cultural heritage in a fast-changing world.', 'filename-1735047727225.jpg', 'Bảo tồn di sản văn hóa trong thế giới hiện đại', 'Những phương pháp bảo vệ di sản văn hóa trong bối cảnh hiện đại', 'Việc bảo tồn di sản văn hóa trong bối cảnh hiện đại là một vấn đề quan trọng đối với nhiều quốc gia. Bài viết này sẽ đi sâu vào các phương pháp và sáng kiến bảo vệ di sản văn hóa, từ việc bảo vệ các di tích lịch sử cho đến việc gìn giữ những truyền thống và phong tục của cộng đồng trong môi trường thay đổi nhanh chóng.');

-- ----------------------------
-- Table structure for news_tag
-- ----------------------------
DROP TABLE IF EXISTS `news_tag`;
CREATE TABLE `news_tag`  (
  `Id_News` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Id_Tag` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  INDEX `Id_News`(`Id_News` ASC) USING BTREE,
  INDEX `Id_Tag`(`Id_Tag` ASC) USING BTREE,
  CONSTRAINT `news_tag_ibfk_1` FOREIGN KEY (`Id_News`) REFERENCES `news` (`Id_News`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `news_tag_ibfk_2` FOREIGN KEY (`Id_Tag`) REFERENCES `tag` (`Id_Tag`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of news_tag
-- ----------------------------
INSERT INTO `news_tag` VALUES ('NEWS0008', 'TAG0010');
INSERT INTO `news_tag` VALUES ('NEWS0008', 'TAG0020');
INSERT INTO `news_tag` VALUES ('NEWS0008', 'TAG0021');
INSERT INTO `news_tag` VALUES ('NEWS0008', 'TAG0022');
INSERT INTO `news_tag` VALUES ('NEWS0008', 'TAG0023');
INSERT INTO `news_tag` VALUES ('NEWS0008', 'TAG0025');
INSERT INTO `news_tag` VALUES ('NEWS0008', 'TAG0142');
INSERT INTO `news_tag` VALUES ('NEWS0008', 'TAG0143');
INSERT INTO `news_tag` VALUES ('NEWS0009', 'TAG0011');
INSERT INTO `news_tag` VALUES ('NEWS0009', 'TAG0051');
INSERT INTO `news_tag` VALUES ('NEWS0009', 'TAG0052');
INSERT INTO `news_tag` VALUES ('NEWS0009', 'TAG0053');
INSERT INTO `news_tag` VALUES ('NEWS0009', 'TAG0066');
INSERT INTO `news_tag` VALUES ('NEWS0009', 'TAG0067');
INSERT INTO `news_tag` VALUES ('NEWS0009', 'TAG0068');
INSERT INTO `news_tag` VALUES ('NEWS0010', 'TAG0012');
INSERT INTO `news_tag` VALUES ('NEWS0010', 'TAG0086');
INSERT INTO `news_tag` VALUES ('NEWS0010', 'TAG0087');
INSERT INTO `news_tag` VALUES ('NEWS0010', 'TAG0088');
INSERT INTO `news_tag` VALUES ('NEWS0010', 'TAG0091');
INSERT INTO `news_tag` VALUES ('NEWS0010', 'TAG0092');
INSERT INTO `news_tag` VALUES ('NEWS0011', 'TAG0013');
INSERT INTO `news_tag` VALUES ('NEWS0011', 'TAG0075');
INSERT INTO `news_tag` VALUES ('NEWS0011', 'TAG0076');
INSERT INTO `news_tag` VALUES ('NEWS0011', 'TAG0077');
INSERT INTO `news_tag` VALUES ('NEWS0011', 'TAG0078');
INSERT INTO `news_tag` VALUES ('NEWS0011', 'TAG0079');
INSERT INTO `news_tag` VALUES ('NEWS0011', 'TAG0080');
INSERT INTO `news_tag` VALUES ('NEWS0011', 'TAG0081');
INSERT INTO `news_tag` VALUES ('NEWS0012', 'TAG0014');
INSERT INTO `news_tag` VALUES ('NEWS0012', 'TAG0016');
INSERT INTO `news_tag` VALUES ('NEWS0012', 'TAG0138');
INSERT INTO `news_tag` VALUES ('NEWS0012', 'TAG0139');
INSERT INTO `news_tag` VALUES ('NEWS0012', 'TAG0140');
INSERT INTO `news_tag` VALUES ('NEWS0012', 'TAG0141');
INSERT INTO `news_tag` VALUES ('NEWS0012', 'TAG0142');
INSERT INTO `news_tag` VALUES ('NEWS0061', 'TAG0138');
INSERT INTO `news_tag` VALUES ('NEWS0061', 'TAG0139');
INSERT INTO `news_tag` VALUES ('NEWS0061', 'TAG0140');
INSERT INTO `news_tag` VALUES ('NEWS0061', 'TAG0137');
INSERT INTO `news_tag` VALUES ('NEWS0061', 'TAG0016');
INSERT INTO `news_tag` VALUES ('NEWS0061', 'TAG0014');
INSERT INTO `news_tag` VALUES ('NEWS0061', 'TAG0099');
INSERT INTO `news_tag` VALUES ('NEWS0062', 'TAG0144');
INSERT INTO `news_tag` VALUES ('NEWS0062', 'TAG0145');
INSERT INTO `news_tag` VALUES ('NEWS0062', 'TAG0146');
INSERT INTO `news_tag` VALUES ('NEWS0062', 'TAG0008');
INSERT INTO `news_tag` VALUES ('NEWS0062', 'TAG0009');
INSERT INTO `news_tag` VALUES ('NEWS0062', 'TAG0024');
INSERT INTO `news_tag` VALUES ('NEWS0063', 'TAG0147');
INSERT INTO `news_tag` VALUES ('NEWS0063', 'TAG0148');
INSERT INTO `news_tag` VALUES ('NEWS0063', 'TAG0149');
INSERT INTO `news_tag` VALUES ('NEWS0063', 'TAG0150');
INSERT INTO `news_tag` VALUES ('NEWS0063', 'TAG0009');
INSERT INTO `news_tag` VALUES ('NEWS0063', 'TAG0019');
INSERT INTO `news_tag` VALUES ('NEWS0063', 'TAG0146');
INSERT INTO `news_tag` VALUES ('NEWS0063', 'TAG0008');
INSERT INTO `news_tag` VALUES ('NEWS0064', 'TAG0142');
INSERT INTO `news_tag` VALUES ('NEWS0064', 'TAG0143');
INSERT INTO `news_tag` VALUES ('NEWS0064', 'TAG0025');
INSERT INTO `news_tag` VALUES ('NEWS0064', 'TAG0024');
INSERT INTO `news_tag` VALUES ('NEWS0064', 'TAG0008');
INSERT INTO `news_tag` VALUES ('NEWS0064', 'TAG0016');
INSERT INTO `news_tag` VALUES ('NEWS0064', 'TAG0010');
INSERT INTO `news_tag` VALUES ('NEWS0001', 'TAG0010');
INSERT INTO `news_tag` VALUES ('NEWS0001', 'TAG0020');
INSERT INTO `news_tag` VALUES ('NEWS0001', 'TAG0021');
INSERT INTO `news_tag` VALUES ('NEWS0001', 'TAG0022');
INSERT INTO `news_tag` VALUES ('NEWS0001', 'TAG0023');
INSERT INTO `news_tag` VALUES ('NEWS0001', 'TAG0025');
INSERT INTO `news_tag` VALUES ('NEWS0001', 'TAG0010');
INSERT INTO `news_tag` VALUES ('NEWS0001', 'TAG0020');
INSERT INTO `news_tag` VALUES ('NEWS0001', 'TAG0021');
INSERT INTO `news_tag` VALUES ('NEWS0001', 'TAG0022');
INSERT INTO `news_tag` VALUES ('NEWS0001', 'TAG0023');
INSERT INTO `news_tag` VALUES ('NEWS0001', 'TAG0025');
INSERT INTO `news_tag` VALUES ('NEWS0001', 'TAG0010');
INSERT INTO `news_tag` VALUES ('NEWS0001', 'TAG0021');
INSERT INTO `news_tag` VALUES ('NEWS0001', 'TAG0022');
INSERT INTO `news_tag` VALUES ('NEWS0001', 'TAG0023');
INSERT INTO `news_tag` VALUES ('NEWS0001', 'TAG0024');
INSERT INTO `news_tag` VALUES ('NEWS0001', 'TAG0025');
INSERT INTO `news_tag` VALUES ('NEWS0002', 'TAG0001');
INSERT INTO `news_tag` VALUES ('NEWS0002', 'TAG0002');
INSERT INTO `news_tag` VALUES ('NEWS0002', 'TAG0003');
INSERT INTO `news_tag` VALUES ('NEWS0002', 'TAG0004');
INSERT INTO `news_tag` VALUES ('NEWS0002', 'TAG0005');
INSERT INTO `news_tag` VALUES ('NEWS0002', 'TAG0006');
INSERT INTO `news_tag` VALUES ('NEWS0002', 'TAG0007');
INSERT INTO `news_tag` VALUES ('NEWS0003', 'TAG0001');
INSERT INTO `news_tag` VALUES ('NEWS0003', 'TAG0002');
INSERT INTO `news_tag` VALUES ('NEWS0003', 'TAG0005');
INSERT INTO `news_tag` VALUES ('NEWS0003', 'TAG0007');
INSERT INTO `news_tag` VALUES ('NEWS0001', 'TAG0070');
INSERT INTO `news_tag` VALUES ('NEWS0001', 'TAG0077');
INSERT INTO `news_tag` VALUES ('NEWS0001', 'TAG0017');
INSERT INTO `news_tag` VALUES ('NEWS0001', 'TAG0059');
INSERT INTO `news_tag` VALUES ('NEWS0001', 'TAG0012');
INSERT INTO `news_tag` VALUES ('NEWS0002', 'TAG0052');
INSERT INTO `news_tag` VALUES ('NEWS0002', 'TAG0004');
INSERT INTO `news_tag` VALUES ('NEWS0002', 'TAG0131');
INSERT INTO `news_tag` VALUES ('NEWS0002', 'TAG0092');
INSERT INTO `news_tag` VALUES ('NEWS0002', 'TAG0070');
INSERT INTO `news_tag` VALUES ('NEWS0003', 'TAG0100');
INSERT INTO `news_tag` VALUES ('NEWS0003', 'TAG0033');
INSERT INTO `news_tag` VALUES ('NEWS0003', 'TAG0058');
INSERT INTO `news_tag` VALUES ('NEWS0003', 'TAG0124');
INSERT INTO `news_tag` VALUES ('NEWS0003', 'TAG0007');
INSERT INTO `news_tag` VALUES ('NEWS0004', 'TAG0085');
INSERT INTO `news_tag` VALUES ('NEWS0004', 'TAG0006');
INSERT INTO `news_tag` VALUES ('NEWS0004', 'TAG0073');
INSERT INTO `news_tag` VALUES ('NEWS0004', 'TAG0115');
INSERT INTO `news_tag` VALUES ('NEWS0004', 'TAG0112');
INSERT INTO `news_tag` VALUES ('NEWS0005', 'TAG0052');
INSERT INTO `news_tag` VALUES ('NEWS0005', 'TAG0061');
INSERT INTO `news_tag` VALUES ('NEWS0005', 'TAG0092');
INSERT INTO `news_tag` VALUES ('NEWS0005', 'TAG0079');
INSERT INTO `news_tag` VALUES ('NEWS0005', 'TAG0047');
INSERT INTO `news_tag` VALUES ('NEWS0006', 'TAG0122');
INSERT INTO `news_tag` VALUES ('NEWS0006', 'TAG0079');
INSERT INTO `news_tag` VALUES ('NEWS0006', 'TAG0105');
INSERT INTO `news_tag` VALUES ('NEWS0006', 'TAG0076');
INSERT INTO `news_tag` VALUES ('NEWS0006', 'TAG0067');
INSERT INTO `news_tag` VALUES ('NEWS0007', 'TAG0007');
INSERT INTO `news_tag` VALUES ('NEWS0007', 'TAG0085');
INSERT INTO `news_tag` VALUES ('NEWS0007', 'TAG0083');
INSERT INTO `news_tag` VALUES ('NEWS0007', 'TAG0023');
INSERT INTO `news_tag` VALUES ('NEWS0007', 'TAG0142');
INSERT INTO `news_tag` VALUES ('NEWS0008', 'TAG0075');
INSERT INTO `news_tag` VALUES ('NEWS0008', 'TAG0144');
INSERT INTO `news_tag` VALUES ('NEWS0008', 'TAG0031');
INSERT INTO `news_tag` VALUES ('NEWS0008', 'TAG0149');
INSERT INTO `news_tag` VALUES ('NEWS0008', 'TAG0113');
INSERT INTO `news_tag` VALUES ('NEWS0009', 'TAG0117');
INSERT INTO `news_tag` VALUES ('NEWS0009', 'TAG0147');
INSERT INTO `news_tag` VALUES ('NEWS0009', 'TAG0021');
INSERT INTO `news_tag` VALUES ('NEWS0009', 'TAG0013');
INSERT INTO `news_tag` VALUES ('NEWS0009', 'TAG0082');
INSERT INTO `news_tag` VALUES ('NEWS0010', 'TAG0009');
INSERT INTO `news_tag` VALUES ('NEWS0010', 'TAG0071');
INSERT INTO `news_tag` VALUES ('NEWS0010', 'TAG0147');
INSERT INTO `news_tag` VALUES ('NEWS0010', 'TAG0046');
INSERT INTO `news_tag` VALUES ('NEWS0010', 'TAG0088');
INSERT INTO `news_tag` VALUES ('NEWS0011', 'TAG0006');
INSERT INTO `news_tag` VALUES ('NEWS0011', 'TAG0112');
INSERT INTO `news_tag` VALUES ('NEWS0011', 'TAG0101');
INSERT INTO `news_tag` VALUES ('NEWS0011', 'TAG0053');
INSERT INTO `news_tag` VALUES ('NEWS0011', 'TAG0019');
INSERT INTO `news_tag` VALUES ('NEWS0012', 'TAG0115');
INSERT INTO `news_tag` VALUES ('NEWS0012', 'TAG0056');
INSERT INTO `news_tag` VALUES ('NEWS0012', 'TAG0111');
INSERT INTO `news_tag` VALUES ('NEWS0012', 'TAG0078');
INSERT INTO `news_tag` VALUES ('NEWS0012', 'TAG0117');
INSERT INTO `news_tag` VALUES ('NEWS0013', 'TAG0121');
INSERT INTO `news_tag` VALUES ('NEWS0013', 'TAG0127');
INSERT INTO `news_tag` VALUES ('NEWS0013', 'TAG0052');
INSERT INTO `news_tag` VALUES ('NEWS0013', 'TAG0037');
INSERT INTO `news_tag` VALUES ('NEWS0013', 'TAG0040');
INSERT INTO `news_tag` VALUES ('NEWS0014', 'TAG0085');
INSERT INTO `news_tag` VALUES ('NEWS0014', 'TAG0017');
INSERT INTO `news_tag` VALUES ('NEWS0014', 'TAG0142');
INSERT INTO `news_tag` VALUES ('NEWS0014', 'TAG0137');
INSERT INTO `news_tag` VALUES ('NEWS0014', 'TAG0141');
INSERT INTO `news_tag` VALUES ('NEWS0015', 'TAG0052');
INSERT INTO `news_tag` VALUES ('NEWS0015', 'TAG0100');
INSERT INTO `news_tag` VALUES ('NEWS0015', 'TAG0044');
INSERT INTO `news_tag` VALUES ('NEWS0015', 'TAG0132');
INSERT INTO `news_tag` VALUES ('NEWS0015', 'TAG0124');
INSERT INTO `news_tag` VALUES ('NEWS0016', 'TAG0058');
INSERT INTO `news_tag` VALUES ('NEWS0016', 'TAG0117');
INSERT INTO `news_tag` VALUES ('NEWS0016', 'TAG0085');
INSERT INTO `news_tag` VALUES ('NEWS0016', 'TAG0030');
INSERT INTO `news_tag` VALUES ('NEWS0016', 'TAG0141');
INSERT INTO `news_tag` VALUES ('NEWS0017', 'TAG0123');
INSERT INTO `news_tag` VALUES ('NEWS0017', 'TAG0083');
INSERT INTO `news_tag` VALUES ('NEWS0017', 'TAG0146');
INSERT INTO `news_tag` VALUES ('NEWS0017', 'TAG0024');
INSERT INTO `news_tag` VALUES ('NEWS0017', 'TAG0143');
INSERT INTO `news_tag` VALUES ('NEWS0018', 'TAG0036');
INSERT INTO `news_tag` VALUES ('NEWS0018', 'TAG0049');
INSERT INTO `news_tag` VALUES ('NEWS0018', 'TAG0122');
INSERT INTO `news_tag` VALUES ('NEWS0018', 'TAG0127');
INSERT INTO `news_tag` VALUES ('NEWS0018', 'TAG0040');
INSERT INTO `news_tag` VALUES ('NEWS0019', 'TAG0033');
INSERT INTO `news_tag` VALUES ('NEWS0019', 'TAG0056');
INSERT INTO `news_tag` VALUES ('NEWS0019', 'TAG0040');
INSERT INTO `news_tag` VALUES ('NEWS0019', 'TAG0083');
INSERT INTO `news_tag` VALUES ('NEWS0019', 'TAG0062');
INSERT INTO `news_tag` VALUES ('NEWS0020', 'TAG0013');
INSERT INTO `news_tag` VALUES ('NEWS0020', 'TAG0108');
INSERT INTO `news_tag` VALUES ('NEWS0020', 'TAG0126');
INSERT INTO `news_tag` VALUES ('NEWS0020', 'TAG0120');
INSERT INTO `news_tag` VALUES ('NEWS0020', 'TAG0054');
INSERT INTO `news_tag` VALUES ('NEWS0021', 'TAG0112');
INSERT INTO `news_tag` VALUES ('NEWS0021', 'TAG0039');
INSERT INTO `news_tag` VALUES ('NEWS0021', 'TAG0019');
INSERT INTO `news_tag` VALUES ('NEWS0021', 'TAG0034');
INSERT INTO `news_tag` VALUES ('NEWS0021', 'TAG0120');
INSERT INTO `news_tag` VALUES ('NEWS0022', 'TAG0024');
INSERT INTO `news_tag` VALUES ('NEWS0022', 'TAG0147');
INSERT INTO `news_tag` VALUES ('NEWS0022', 'TAG0071');
INSERT INTO `news_tag` VALUES ('NEWS0022', 'TAG0019');
INSERT INTO `news_tag` VALUES ('NEWS0022', 'TAG0085');
INSERT INTO `news_tag` VALUES ('NEWS0023', 'TAG0038');
INSERT INTO `news_tag` VALUES ('NEWS0023', 'TAG0075');
INSERT INTO `news_tag` VALUES ('NEWS0023', 'TAG0050');
INSERT INTO `news_tag` VALUES ('NEWS0023', 'TAG0022');
INSERT INTO `news_tag` VALUES ('NEWS0023', 'TAG0037');
INSERT INTO `news_tag` VALUES ('NEWS0024', 'TAG0143');
INSERT INTO `news_tag` VALUES ('NEWS0024', 'TAG0007');
INSERT INTO `news_tag` VALUES ('NEWS0024', 'TAG0040');
INSERT INTO `news_tag` VALUES ('NEWS0024', 'TAG0055');
INSERT INTO `news_tag` VALUES ('NEWS0024', 'TAG0035');
INSERT INTO `news_tag` VALUES ('NEWS0025', 'TAG0063');
INSERT INTO `news_tag` VALUES ('NEWS0025', 'TAG0023');
INSERT INTO `news_tag` VALUES ('NEWS0025', 'TAG0043');
INSERT INTO `news_tag` VALUES ('NEWS0025', 'TAG0141');
INSERT INTO `news_tag` VALUES ('NEWS0025', 'TAG0120');
INSERT INTO `news_tag` VALUES ('NEWS0026', 'TAG0054');
INSERT INTO `news_tag` VALUES ('NEWS0026', 'TAG0141');
INSERT INTO `news_tag` VALUES ('NEWS0026', 'TAG0027');
INSERT INTO `news_tag` VALUES ('NEWS0026', 'TAG0147');
INSERT INTO `news_tag` VALUES ('NEWS0026', 'TAG0080');
INSERT INTO `news_tag` VALUES ('NEWS0027', 'TAG0058');
INSERT INTO `news_tag` VALUES ('NEWS0027', 'TAG0139');
INSERT INTO `news_tag` VALUES ('NEWS0027', 'TAG0068');
INSERT INTO `news_tag` VALUES ('NEWS0027', 'TAG0116');
INSERT INTO `news_tag` VALUES ('NEWS0027', 'TAG0104');
INSERT INTO `news_tag` VALUES ('NEWS0028', 'TAG0117');
INSERT INTO `news_tag` VALUES ('NEWS0028', 'TAG0031');
INSERT INTO `news_tag` VALUES ('NEWS0028', 'TAG0148');
INSERT INTO `news_tag` VALUES ('NEWS0028', 'TAG0123');
INSERT INTO `news_tag` VALUES ('NEWS0028', 'TAG0034');
INSERT INTO `news_tag` VALUES ('NEWS0029', 'TAG0128');
INSERT INTO `news_tag` VALUES ('NEWS0029', 'TAG0144');
INSERT INTO `news_tag` VALUES ('NEWS0029', 'TAG0005');
INSERT INTO `news_tag` VALUES ('NEWS0029', 'TAG0019');
INSERT INTO `news_tag` VALUES ('NEWS0029', 'TAG0089');
INSERT INTO `news_tag` VALUES ('NEWS0030', 'TAG0125');
INSERT INTO `news_tag` VALUES ('NEWS0030', 'TAG0015');
INSERT INTO `news_tag` VALUES ('NEWS0030', 'TAG0143');
INSERT INTO `news_tag` VALUES ('NEWS0030', 'TAG0017');
INSERT INTO `news_tag` VALUES ('NEWS0030', 'TAG0121');
INSERT INTO `news_tag` VALUES ('NEWS0031', 'TAG0090');
INSERT INTO `news_tag` VALUES ('NEWS0031', 'TAG0133');
INSERT INTO `news_tag` VALUES ('NEWS0031', 'TAG0056');
INSERT INTO `news_tag` VALUES ('NEWS0031', 'TAG0049');
INSERT INTO `news_tag` VALUES ('NEWS0031', 'TAG0024');
INSERT INTO `news_tag` VALUES ('NEWS0032', 'TAG0111');
INSERT INTO `news_tag` VALUES ('NEWS0032', 'TAG0059');
INSERT INTO `news_tag` VALUES ('NEWS0032', 'TAG0009');
INSERT INTO `news_tag` VALUES ('NEWS0032', 'TAG0057');
INSERT INTO `news_tag` VALUES ('NEWS0032', 'TAG0042');
INSERT INTO `news_tag` VALUES ('NEWS0033', 'TAG0007');
INSERT INTO `news_tag` VALUES ('NEWS0033', 'TAG0091');
INSERT INTO `news_tag` VALUES ('NEWS0033', 'TAG0099');
INSERT INTO `news_tag` VALUES ('NEWS0033', 'TAG0004');
INSERT INTO `news_tag` VALUES ('NEWS0033', 'TAG0041');
INSERT INTO `news_tag` VALUES ('NEWS0034', 'TAG0143');
INSERT INTO `news_tag` VALUES ('NEWS0034', 'TAG0001');
INSERT INTO `news_tag` VALUES ('NEWS0034', 'TAG0002');
INSERT INTO `news_tag` VALUES ('NEWS0034', 'TAG0084');
INSERT INTO `news_tag` VALUES ('NEWS0034', 'TAG0096');
INSERT INTO `news_tag` VALUES ('NEWS0035', 'TAG0114');
INSERT INTO `news_tag` VALUES ('NEWS0035', 'TAG0004');
INSERT INTO `news_tag` VALUES ('NEWS0035', 'TAG0060');
INSERT INTO `news_tag` VALUES ('NEWS0035', 'TAG0087');
INSERT INTO `news_tag` VALUES ('NEWS0035', 'TAG0046');
INSERT INTO `news_tag` VALUES ('NEWS0036', 'TAG0074');
INSERT INTO `news_tag` VALUES ('NEWS0036', 'TAG0077');
INSERT INTO `news_tag` VALUES ('NEWS0036', 'TAG0023');
INSERT INTO `news_tag` VALUES ('NEWS0036', 'TAG0140');
INSERT INTO `news_tag` VALUES ('NEWS0036', 'TAG0043');
INSERT INTO `news_tag` VALUES ('NEWS0037', 'TAG0022');
INSERT INTO `news_tag` VALUES ('NEWS0037', 'TAG0031');
INSERT INTO `news_tag` VALUES ('NEWS0037', 'TAG0138');
INSERT INTO `news_tag` VALUES ('NEWS0037', 'TAG0032');
INSERT INTO `news_tag` VALUES ('NEWS0037', 'TAG0103');
INSERT INTO `news_tag` VALUES ('NEWS0038', 'TAG0076');
INSERT INTO `news_tag` VALUES ('NEWS0038', 'TAG0109');
INSERT INTO `news_tag` VALUES ('NEWS0038', 'TAG0086');
INSERT INTO `news_tag` VALUES ('NEWS0038', 'TAG0105');
INSERT INTO `news_tag` VALUES ('NEWS0038', 'TAG0090');
INSERT INTO `news_tag` VALUES ('NEWS0039', 'TAG0018');
INSERT INTO `news_tag` VALUES ('NEWS0039', 'TAG0092');
INSERT INTO `news_tag` VALUES ('NEWS0039', 'TAG0008');
INSERT INTO `news_tag` VALUES ('NEWS0039', 'TAG0066');
INSERT INTO `news_tag` VALUES ('NEWS0039', 'TAG0123');
INSERT INTO `news_tag` VALUES ('NEWS0040', 'TAG0107');
INSERT INTO `news_tag` VALUES ('NEWS0040', 'TAG0088');
INSERT INTO `news_tag` VALUES ('NEWS0040', 'TAG0118');
INSERT INTO `news_tag` VALUES ('NEWS0040', 'TAG0125');
INSERT INTO `news_tag` VALUES ('NEWS0040', 'TAG0042');
INSERT INTO `news_tag` VALUES ('NEWS0041', 'TAG0045');
INSERT INTO `news_tag` VALUES ('NEWS0041', 'TAG0079');
INSERT INTO `news_tag` VALUES ('NEWS0041', 'TAG0081');
INSERT INTO `news_tag` VALUES ('NEWS0041', 'TAG0113');
INSERT INTO `news_tag` VALUES ('NEWS0041', 'TAG0051');
INSERT INTO `news_tag` VALUES ('NEWS0042', 'TAG0129');
INSERT INTO `news_tag` VALUES ('NEWS0042', 'TAG0105');
INSERT INTO `news_tag` VALUES ('NEWS0042', 'TAG0112');
INSERT INTO `news_tag` VALUES ('NEWS0042', 'TAG0014');
INSERT INTO `news_tag` VALUES ('NEWS0042', 'TAG0002');
INSERT INTO `news_tag` VALUES ('NEWS0043', 'TAG0003');
INSERT INTO `news_tag` VALUES ('NEWS0043', 'TAG0090');
INSERT INTO `news_tag` VALUES ('NEWS0043', 'TAG0064');
INSERT INTO `news_tag` VALUES ('NEWS0043', 'TAG0128');
INSERT INTO `news_tag` VALUES ('NEWS0043', 'TAG0132');
INSERT INTO `news_tag` VALUES ('NEWS0044', 'TAG0117');
INSERT INTO `news_tag` VALUES ('NEWS0044', 'TAG0044');
INSERT INTO `news_tag` VALUES ('NEWS0044', 'TAG0111');
INSERT INTO `news_tag` VALUES ('NEWS0044', 'TAG0053');
INSERT INTO `news_tag` VALUES ('NEWS0044', 'TAG0023');
INSERT INTO `news_tag` VALUES ('NEWS0045', 'TAG0107');
INSERT INTO `news_tag` VALUES ('NEWS0045', 'TAG0048');
INSERT INTO `news_tag` VALUES ('NEWS0045', 'TAG0045');
INSERT INTO `news_tag` VALUES ('NEWS0045', 'TAG0033');
INSERT INTO `news_tag` VALUES ('NEWS0045', 'TAG0083');
INSERT INTO `news_tag` VALUES ('NEWS0046', 'TAG0074');
INSERT INTO `news_tag` VALUES ('NEWS0046', 'TAG0068');
INSERT INTO `news_tag` VALUES ('NEWS0046', 'TAG0038');
INSERT INTO `news_tag` VALUES ('NEWS0046', 'TAG0012');
INSERT INTO `news_tag` VALUES ('NEWS0046', 'TAG0134');
INSERT INTO `news_tag` VALUES ('NEWS0047', 'TAG0051');
INSERT INTO `news_tag` VALUES ('NEWS0047', 'TAG0057');
INSERT INTO `news_tag` VALUES ('NEWS0047', 'TAG0071');
INSERT INTO `news_tag` VALUES ('NEWS0047', 'TAG0144');
INSERT INTO `news_tag` VALUES ('NEWS0047', 'TAG0066');
INSERT INTO `news_tag` VALUES ('NEWS0048', 'TAG0083');
INSERT INTO `news_tag` VALUES ('NEWS0048', 'TAG0113');
INSERT INTO `news_tag` VALUES ('NEWS0048', 'TAG0050');
INSERT INTO `news_tag` VALUES ('NEWS0048', 'TAG0003');
INSERT INTO `news_tag` VALUES ('NEWS0048', 'TAG0111');
INSERT INTO `news_tag` VALUES ('NEWS0049', 'TAG0041');
INSERT INTO `news_tag` VALUES ('NEWS0049', 'TAG0147');
INSERT INTO `news_tag` VALUES ('NEWS0049', 'TAG0137');
INSERT INTO `news_tag` VALUES ('NEWS0049', 'TAG0092');
INSERT INTO `news_tag` VALUES ('NEWS0049', 'TAG0075');
INSERT INTO `news_tag` VALUES ('NEWS0050', 'TAG0078');
INSERT INTO `news_tag` VALUES ('NEWS0050', 'TAG0043');
INSERT INTO `news_tag` VALUES ('NEWS0050', 'TAG0136');
INSERT INTO `news_tag` VALUES ('NEWS0050', 'TAG0074');
INSERT INTO `news_tag` VALUES ('NEWS0050', 'TAG0032');
INSERT INTO `news_tag` VALUES ('NEWS0051', 'TAG0091');
INSERT INTO `news_tag` VALUES ('NEWS0051', 'TAG0097');
INSERT INTO `news_tag` VALUES ('NEWS0051', 'TAG0044');
INSERT INTO `news_tag` VALUES ('NEWS0051', 'TAG0025');
INSERT INTO `news_tag` VALUES ('NEWS0051', 'TAG0120');
INSERT INTO `news_tag` VALUES ('NEWS0052', 'TAG0038');
INSERT INTO `news_tag` VALUES ('NEWS0052', 'TAG0144');
INSERT INTO `news_tag` VALUES ('NEWS0052', 'TAG0074');
INSERT INTO `news_tag` VALUES ('NEWS0052', 'TAG0078');
INSERT INTO `news_tag` VALUES ('NEWS0052', 'TAG0052');
INSERT INTO `news_tag` VALUES ('NEWS0053', 'TAG0033');
INSERT INTO `news_tag` VALUES ('NEWS0053', 'TAG0055');
INSERT INTO `news_tag` VALUES ('NEWS0053', 'TAG0088');
INSERT INTO `news_tag` VALUES ('NEWS0053', 'TAG0031');
INSERT INTO `news_tag` VALUES ('NEWS0053', 'TAG0061');
INSERT INTO `news_tag` VALUES ('NEWS0054', 'TAG0117');
INSERT INTO `news_tag` VALUES ('NEWS0054', 'TAG0004');
INSERT INTO `news_tag` VALUES ('NEWS0054', 'TAG0043');
INSERT INTO `news_tag` VALUES ('NEWS0054', 'TAG0057');
INSERT INTO `news_tag` VALUES ('NEWS0054', 'TAG0133');
INSERT INTO `news_tag` VALUES ('NEWS0055', 'TAG0050');
INSERT INTO `news_tag` VALUES ('NEWS0055', 'TAG0051');
INSERT INTO `news_tag` VALUES ('NEWS0055', 'TAG0007');
INSERT INTO `news_tag` VALUES ('NEWS0055', 'TAG0035');
INSERT INTO `news_tag` VALUES ('NEWS0055', 'TAG0011');
INSERT INTO `news_tag` VALUES ('NEWS0056', 'TAG0100');
INSERT INTO `news_tag` VALUES ('NEWS0056', 'TAG0118');
INSERT INTO `news_tag` VALUES ('NEWS0056', 'TAG0010');
INSERT INTO `news_tag` VALUES ('NEWS0056', 'TAG0137');
INSERT INTO `news_tag` VALUES ('NEWS0056', 'TAG0007');
INSERT INTO `news_tag` VALUES ('NEWS0057', 'TAG0132');
INSERT INTO `news_tag` VALUES ('NEWS0057', 'TAG0064');
INSERT INTO `news_tag` VALUES ('NEWS0057', 'TAG0030');
INSERT INTO `news_tag` VALUES ('NEWS0057', 'TAG0123');
INSERT INTO `news_tag` VALUES ('NEWS0057', 'TAG0051');
INSERT INTO `news_tag` VALUES ('NEWS0058', 'TAG0076');
INSERT INTO `news_tag` VALUES ('NEWS0058', 'TAG0048');
INSERT INTO `news_tag` VALUES ('NEWS0058', 'TAG0006');
INSERT INTO `news_tag` VALUES ('NEWS0058', 'TAG0134');
INSERT INTO `news_tag` VALUES ('NEWS0058', 'TAG0119');
INSERT INTO `news_tag` VALUES ('NEWS0059', 'TAG0074');
INSERT INTO `news_tag` VALUES ('NEWS0059', 'TAG0032');
INSERT INTO `news_tag` VALUES ('NEWS0059', 'TAG0118');
INSERT INTO `news_tag` VALUES ('NEWS0059', 'TAG0079');
INSERT INTO `news_tag` VALUES ('NEWS0059', 'TAG0043');
INSERT INTO `news_tag` VALUES ('NEWS0060', 'TAG0122');
INSERT INTO `news_tag` VALUES ('NEWS0060', 'TAG0019');
INSERT INTO `news_tag` VALUES ('NEWS0060', 'TAG0076');
INSERT INTO `news_tag` VALUES ('NEWS0060', 'TAG0053');
INSERT INTO `news_tag` VALUES ('NEWS0060', 'TAG0073');
INSERT INTO `news_tag` VALUES ('NEWS0065', 'TAG0135');
INSERT INTO `news_tag` VALUES ('NEWS0065', 'TAG0008');
INSERT INTO `news_tag` VALUES ('NEWS0065', 'TAG0108');
INSERT INTO `news_tag` VALUES ('NEWS0065', 'TAG0043');
INSERT INTO `news_tag` VALUES ('NEWS0065', 'TAG0136');
INSERT INTO `news_tag` VALUES ('NEWS0066', 'TAG0085');
INSERT INTO `news_tag` VALUES ('NEWS0066', 'TAG0021');
INSERT INTO `news_tag` VALUES ('NEWS0066', 'TAG0023');
INSERT INTO `news_tag` VALUES ('NEWS0066', 'TAG0095');
INSERT INTO `news_tag` VALUES ('NEWS0066', 'TAG0012');
INSERT INTO `news_tag` VALUES ('NEWS0067', 'TAG0073');
INSERT INTO `news_tag` VALUES ('NEWS0067', 'TAG0104');
INSERT INTO `news_tag` VALUES ('NEWS0067', 'TAG0131');
INSERT INTO `news_tag` VALUES ('NEWS0067', 'TAG0074');
INSERT INTO `news_tag` VALUES ('NEWS0067', 'TAG0077');
INSERT INTO `news_tag` VALUES ('NEWS0068', 'TAG0068');
INSERT INTO `news_tag` VALUES ('NEWS0068', 'TAG0080');
INSERT INTO `news_tag` VALUES ('NEWS0068', 'TAG0037');
INSERT INTO `news_tag` VALUES ('NEWS0068', 'TAG0045');
INSERT INTO `news_tag` VALUES ('NEWS0068', 'TAG0023');
INSERT INTO `news_tag` VALUES ('NEWS0069', 'TAG0137');
INSERT INTO `news_tag` VALUES ('NEWS0069', 'TAG0113');
INSERT INTO `news_tag` VALUES ('NEWS0069', 'TAG0091');
INSERT INTO `news_tag` VALUES ('NEWS0069', 'TAG0029');
INSERT INTO `news_tag` VALUES ('NEWS0069', 'TAG0074');
INSERT INTO `news_tag` VALUES ('NEWS0070', 'TAG0142');
INSERT INTO `news_tag` VALUES ('NEWS0070', 'TAG0049');
INSERT INTO `news_tag` VALUES ('NEWS0070', 'TAG0065');
INSERT INTO `news_tag` VALUES ('NEWS0070', 'TAG0128');
INSERT INTO `news_tag` VALUES ('NEWS0070', 'TAG0074');
INSERT INTO `news_tag` VALUES ('NEWS0071', 'TAG0112');
INSERT INTO `news_tag` VALUES ('NEWS0071', 'TAG0005');
INSERT INTO `news_tag` VALUES ('NEWS0071', 'TAG0133');
INSERT INTO `news_tag` VALUES ('NEWS0071', 'TAG0024');
INSERT INTO `news_tag` VALUES ('NEWS0071', 'TAG0031');
INSERT INTO `news_tag` VALUES ('NEWS0072', 'TAG0044');
INSERT INTO `news_tag` VALUES ('NEWS0072', 'TAG0066');
INSERT INTO `news_tag` VALUES ('NEWS0072', 'TAG0092');
INSERT INTO `news_tag` VALUES ('NEWS0072', 'TAG0137');
INSERT INTO `news_tag` VALUES ('NEWS0072', 'TAG0049');
INSERT INTO `news_tag` VALUES ('NEWS0073', 'TAG0086');
INSERT INTO `news_tag` VALUES ('NEWS0073', 'TAG0087');
INSERT INTO `news_tag` VALUES ('NEWS0073', 'TAG0136');
INSERT INTO `news_tag` VALUES ('NEWS0073', 'TAG0095');
INSERT INTO `news_tag` VALUES ('NEWS0073', 'TAG0107');
INSERT INTO `news_tag` VALUES ('NEWS0074', 'TAG0083');
INSERT INTO `news_tag` VALUES ('NEWS0074', 'TAG0014');
INSERT INTO `news_tag` VALUES ('NEWS0074', 'TAG0027');
INSERT INTO `news_tag` VALUES ('NEWS0074', 'TAG0004');
INSERT INTO `news_tag` VALUES ('NEWS0074', 'TAG0096');
INSERT INTO `news_tag` VALUES ('NEWS0075', 'TAG0076');
INSERT INTO `news_tag` VALUES ('NEWS0075', 'TAG0071');
INSERT INTO `news_tag` VALUES ('NEWS0075', 'TAG0010');
INSERT INTO `news_tag` VALUES ('NEWS0075', 'TAG0136');
INSERT INTO `news_tag` VALUES ('NEWS0075', 'TAG0032');
INSERT INTO `news_tag` VALUES ('NEWS0076', 'TAG0078');
INSERT INTO `news_tag` VALUES ('NEWS0076', 'TAG0013');
INSERT INTO `news_tag` VALUES ('NEWS0076', 'TAG0140');
INSERT INTO `news_tag` VALUES ('NEWS0076', 'TAG0006');
INSERT INTO `news_tag` VALUES ('NEWS0076', 'TAG0087');
INSERT INTO `news_tag` VALUES ('NEWS0077', 'TAG0017');
INSERT INTO `news_tag` VALUES ('NEWS0077', 'TAG0008');
INSERT INTO `news_tag` VALUES ('NEWS0077', 'TAG0103');
INSERT INTO `news_tag` VALUES ('NEWS0077', 'TAG0127');
INSERT INTO `news_tag` VALUES ('NEWS0077', 'TAG0144');
INSERT INTO `news_tag` VALUES ('NEWS0078', 'TAG0010');
INSERT INTO `news_tag` VALUES ('NEWS0078', 'TAG0060');
INSERT INTO `news_tag` VALUES ('NEWS0078', 'TAG0044');
INSERT INTO `news_tag` VALUES ('NEWS0078', 'TAG0122');
INSERT INTO `news_tag` VALUES ('NEWS0078', 'TAG0004');
INSERT INTO `news_tag` VALUES ('NEWS0079', 'TAG0082');
INSERT INTO `news_tag` VALUES ('NEWS0079', 'TAG0076');
INSERT INTO `news_tag` VALUES ('NEWS0079', 'TAG0036');
INSERT INTO `news_tag` VALUES ('NEWS0079', 'TAG0110');
INSERT INTO `news_tag` VALUES ('NEWS0079', 'TAG0122');
INSERT INTO `news_tag` VALUES ('NEWS0080', 'TAG0110');
INSERT INTO `news_tag` VALUES ('NEWS0080', 'TAG0035');
INSERT INTO `news_tag` VALUES ('NEWS0080', 'TAG0131');
INSERT INTO `news_tag` VALUES ('NEWS0080', 'TAG0042');
INSERT INTO `news_tag` VALUES ('NEWS0080', 'TAG0065');
INSERT INTO `news_tag` VALUES ('NEWS0081', 'TAG0060');
INSERT INTO `news_tag` VALUES ('NEWS0081', 'TAG0075');
INSERT INTO `news_tag` VALUES ('NEWS0081', 'TAG0031');
INSERT INTO `news_tag` VALUES ('NEWS0081', 'TAG0139');
INSERT INTO `news_tag` VALUES ('NEWS0081', 'TAG0140');
INSERT INTO `news_tag` VALUES ('NEWS0082', 'TAG0127');
INSERT INTO `news_tag` VALUES ('NEWS0082', 'TAG0149');
INSERT INTO `news_tag` VALUES ('NEWS0082', 'TAG0103');
INSERT INTO `news_tag` VALUES ('NEWS0082', 'TAG0097');
INSERT INTO `news_tag` VALUES ('NEWS0082', 'TAG0032');
INSERT INTO `news_tag` VALUES ('NEWS0083', 'TAG0048');
INSERT INTO `news_tag` VALUES ('NEWS0083', 'TAG0140');
INSERT INTO `news_tag` VALUES ('NEWS0083', 'TAG0104');
INSERT INTO `news_tag` VALUES ('NEWS0083', 'TAG0127');
INSERT INTO `news_tag` VALUES ('NEWS0083', 'TAG0091');
INSERT INTO `news_tag` VALUES ('NEWS0084', 'TAG0090');
INSERT INTO `news_tag` VALUES ('NEWS0084', 'TAG0037');
INSERT INTO `news_tag` VALUES ('NEWS0084', 'TAG0048');
INSERT INTO `news_tag` VALUES ('NEWS0084', 'TAG0138');
INSERT INTO `news_tag` VALUES ('NEWS0084', 'TAG0122');
INSERT INTO `news_tag` VALUES ('NEWS0085', 'TAG0024');
INSERT INTO `news_tag` VALUES ('NEWS0085', 'TAG0114');
INSERT INTO `news_tag` VALUES ('NEWS0085', 'TAG0136');
INSERT INTO `news_tag` VALUES ('NEWS0085', 'TAG0146');
INSERT INTO `news_tag` VALUES ('NEWS0085', 'TAG0035');
INSERT INTO `news_tag` VALUES ('NEWS0086', 'TAG0118');
INSERT INTO `news_tag` VALUES ('NEWS0086', 'TAG0084');
INSERT INTO `news_tag` VALUES ('NEWS0086', 'TAG0018');
INSERT INTO `news_tag` VALUES ('NEWS0086', 'TAG0102');
INSERT INTO `news_tag` VALUES ('NEWS0086', 'TAG0065');
INSERT INTO `news_tag` VALUES ('NEWS0087', 'TAG0112');
INSERT INTO `news_tag` VALUES ('NEWS0087', 'TAG0096');
INSERT INTO `news_tag` VALUES ('NEWS0087', 'TAG0121');
INSERT INTO `news_tag` VALUES ('NEWS0087', 'TAG0006');
INSERT INTO `news_tag` VALUES ('NEWS0087', 'TAG0026');
INSERT INTO `news_tag` VALUES ('NEWS0088', 'TAG0088');
INSERT INTO `news_tag` VALUES ('NEWS0088', 'TAG0087');
INSERT INTO `news_tag` VALUES ('NEWS0088', 'TAG0066');
INSERT INTO `news_tag` VALUES ('NEWS0088', 'TAG0013');
INSERT INTO `news_tag` VALUES ('NEWS0088', 'TAG0072');
INSERT INTO `news_tag` VALUES ('NEWS0089', 'TAG0117');
INSERT INTO `news_tag` VALUES ('NEWS0089', 'TAG0022');
INSERT INTO `news_tag` VALUES ('NEWS0089', 'TAG0129');
INSERT INTO `news_tag` VALUES ('NEWS0089', 'TAG0040');
INSERT INTO `news_tag` VALUES ('NEWS0089', 'TAG0148');
INSERT INTO `news_tag` VALUES ('NEWS0090', 'TAG0021');
INSERT INTO `news_tag` VALUES ('NEWS0090', 'TAG0080');
INSERT INTO `news_tag` VALUES ('NEWS0090', 'TAG0019');
INSERT INTO `news_tag` VALUES ('NEWS0090', 'TAG0120');
INSERT INTO `news_tag` VALUES ('NEWS0090', 'TAG0130');
INSERT INTO `news_tag` VALUES ('NEWS0091', 'TAG0142');
INSERT INTO `news_tag` VALUES ('NEWS0091', 'TAG0045');
INSERT INTO `news_tag` VALUES ('NEWS0091', 'TAG0008');
INSERT INTO `news_tag` VALUES ('NEWS0091', 'TAG0115');
INSERT INTO `news_tag` VALUES ('NEWS0091', 'TAG0059');
INSERT INTO `news_tag` VALUES ('NEWS0092', 'TAG0039');
INSERT INTO `news_tag` VALUES ('NEWS0092', 'TAG0128');
INSERT INTO `news_tag` VALUES ('NEWS0092', 'TAG0126');
INSERT INTO `news_tag` VALUES ('NEWS0092', 'TAG0001');
INSERT INTO `news_tag` VALUES ('NEWS0092', 'TAG0061');
INSERT INTO `news_tag` VALUES ('NEWS0093', 'TAG0006');
INSERT INTO `news_tag` VALUES ('NEWS0093', 'TAG0080');
INSERT INTO `news_tag` VALUES ('NEWS0093', 'TAG0012');
INSERT INTO `news_tag` VALUES ('NEWS0093', 'TAG0130');
INSERT INTO `news_tag` VALUES ('NEWS0093', 'TAG0008');
INSERT INTO `news_tag` VALUES ('NEWS0094', 'TAG0035');
INSERT INTO `news_tag` VALUES ('NEWS0094', 'TAG0104');
INSERT INTO `news_tag` VALUES ('NEWS0094', 'TAG0053');
INSERT INTO `news_tag` VALUES ('NEWS0094', 'TAG0030');
INSERT INTO `news_tag` VALUES ('NEWS0094', 'TAG0009');
INSERT INTO `news_tag` VALUES ('NEWS0095', 'TAG0041');
INSERT INTO `news_tag` VALUES ('NEWS0095', 'TAG0061');
INSERT INTO `news_tag` VALUES ('NEWS0095', 'TAG0130');
INSERT INTO `news_tag` VALUES ('NEWS0095', 'TAG0101');
INSERT INTO `news_tag` VALUES ('NEWS0095', 'TAG0033');
INSERT INTO `news_tag` VALUES ('NEWS0096', 'TAG0142');
INSERT INTO `news_tag` VALUES ('NEWS0096', 'TAG0049');
INSERT INTO `news_tag` VALUES ('NEWS0096', 'TAG0043');
INSERT INTO `news_tag` VALUES ('NEWS0096', 'TAG0036');
INSERT INTO `news_tag` VALUES ('NEWS0096', 'TAG0132');
INSERT INTO `news_tag` VALUES ('NEWS0097', 'TAG0010');
INSERT INTO `news_tag` VALUES ('NEWS0097', 'TAG0143');
INSERT INTO `news_tag` VALUES ('NEWS0097', 'TAG0072');
INSERT INTO `news_tag` VALUES ('NEWS0097', 'TAG0058');
INSERT INTO `news_tag` VALUES ('NEWS0097', 'TAG0124');
INSERT INTO `news_tag` VALUES ('NEWS0098', 'TAG0115');
INSERT INTO `news_tag` VALUES ('NEWS0098', 'TAG0067');
INSERT INTO `news_tag` VALUES ('NEWS0098', 'TAG0043');
INSERT INTO `news_tag` VALUES ('NEWS0098', 'TAG0073');
INSERT INTO `news_tag` VALUES ('NEWS0098', 'TAG0144');
INSERT INTO `news_tag` VALUES ('NEWS0099', 'TAG0046');
INSERT INTO `news_tag` VALUES ('NEWS0099', 'TAG0018');
INSERT INTO `news_tag` VALUES ('NEWS0099', 'TAG0137');
INSERT INTO `news_tag` VALUES ('NEWS0099', 'TAG0134');
INSERT INTO `news_tag` VALUES ('NEWS0099', 'TAG0086');
INSERT INTO `news_tag` VALUES ('NEWS0100', 'TAG0008');
INSERT INTO `news_tag` VALUES ('NEWS0100', 'TAG0094');
INSERT INTO `news_tag` VALUES ('NEWS0100', 'TAG0042');
INSERT INTO `news_tag` VALUES ('NEWS0100', 'TAG0018');
INSERT INTO `news_tag` VALUES ('NEWS0100', 'TAG0108');
INSERT INTO `news_tag` VALUES ('NEWS0101', 'TAG0089');
INSERT INTO `news_tag` VALUES ('NEWS0101', 'TAG0007');
INSERT INTO `news_tag` VALUES ('NEWS0101', 'TAG0002');
INSERT INTO `news_tag` VALUES ('NEWS0101', 'TAG0136');
INSERT INTO `news_tag` VALUES ('NEWS0101', 'TAG0021');
INSERT INTO `news_tag` VALUES ('NEWS0102', 'TAG0110');
INSERT INTO `news_tag` VALUES ('NEWS0102', 'TAG0093');
INSERT INTO `news_tag` VALUES ('NEWS0102', 'TAG0058');
INSERT INTO `news_tag` VALUES ('NEWS0102', 'TAG0144');
INSERT INTO `news_tag` VALUES ('NEWS0102', 'TAG0085');
INSERT INTO `news_tag` VALUES ('NEWS0103', 'TAG0107');
INSERT INTO `news_tag` VALUES ('NEWS0103', 'TAG0017');
INSERT INTO `news_tag` VALUES ('NEWS0103', 'TAG0128');
INSERT INTO `news_tag` VALUES ('NEWS0103', 'TAG0113');
INSERT INTO `news_tag` VALUES ('NEWS0103', 'TAG0131');
INSERT INTO `news_tag` VALUES ('NEWS0104', 'TAG0142');
INSERT INTO `news_tag` VALUES ('NEWS0104', 'TAG0140');
INSERT INTO `news_tag` VALUES ('NEWS0104', 'TAG0110');
INSERT INTO `news_tag` VALUES ('NEWS0104', 'TAG0068');
INSERT INTO `news_tag` VALUES ('NEWS0104', 'TAG0036');
INSERT INTO `news_tag` VALUES ('NEWS0105', 'TAG0119');
INSERT INTO `news_tag` VALUES ('NEWS0105', 'TAG0031');
INSERT INTO `news_tag` VALUES ('NEWS0105', 'TAG0111');
INSERT INTO `news_tag` VALUES ('NEWS0105', 'TAG0128');
INSERT INTO `news_tag` VALUES ('NEWS0105', 'TAG0146');
INSERT INTO `news_tag` VALUES ('NEWS0106', 'TAG0132');
INSERT INTO `news_tag` VALUES ('NEWS0106', 'TAG0099');
INSERT INTO `news_tag` VALUES ('NEWS0106', 'TAG0140');
INSERT INTO `news_tag` VALUES ('NEWS0106', 'TAG0138');
INSERT INTO `news_tag` VALUES ('NEWS0106', 'TAG0035');
INSERT INTO `news_tag` VALUES ('NEWS0107', 'TAG0061');
INSERT INTO `news_tag` VALUES ('NEWS0107', 'TAG0057');
INSERT INTO `news_tag` VALUES ('NEWS0107', 'TAG0056');
INSERT INTO `news_tag` VALUES ('NEWS0107', 'TAG0029');
INSERT INTO `news_tag` VALUES ('NEWS0107', 'TAG0083');
INSERT INTO `news_tag` VALUES ('NEWS0108', 'TAG0089');
INSERT INTO `news_tag` VALUES ('NEWS0108', 'TAG0113');
INSERT INTO `news_tag` VALUES ('NEWS0108', 'TAG0062');
INSERT INTO `news_tag` VALUES ('NEWS0108', 'TAG0054');
INSERT INTO `news_tag` VALUES ('NEWS0108', 'TAG0022');
INSERT INTO `news_tag` VALUES ('NEWS0109', 'TAG0043');
INSERT INTO `news_tag` VALUES ('NEWS0109', 'TAG0053');
INSERT INTO `news_tag` VALUES ('NEWS0109', 'TAG0021');
INSERT INTO `news_tag` VALUES ('NEWS0109', 'TAG0035');
INSERT INTO `news_tag` VALUES ('NEWS0109', 'TAG0009');
INSERT INTO `news_tag` VALUES ('NEWS0110', 'TAG0042');
INSERT INTO `news_tag` VALUES ('NEWS0110', 'TAG0135');
INSERT INTO `news_tag` VALUES ('NEWS0110', 'TAG0022');
INSERT INTO `news_tag` VALUES ('NEWS0110', 'TAG0078');
INSERT INTO `news_tag` VALUES ('NEWS0110', 'TAG0011');
INSERT INTO `news_tag` VALUES ('NEWS0111', 'TAG0061');
INSERT INTO `news_tag` VALUES ('NEWS0111', 'TAG0105');
INSERT INTO `news_tag` VALUES ('NEWS0111', 'TAG0115');
INSERT INTO `news_tag` VALUES ('NEWS0111', 'TAG0088');
INSERT INTO `news_tag` VALUES ('NEWS0111', 'TAG0016');
INSERT INTO `news_tag` VALUES ('NEWS0112', 'TAG0040');
INSERT INTO `news_tag` VALUES ('NEWS0112', 'TAG0014');
INSERT INTO `news_tag` VALUES ('NEWS0112', 'TAG0126');
INSERT INTO `news_tag` VALUES ('NEWS0112', 'TAG0027');
INSERT INTO `news_tag` VALUES ('NEWS0112', 'TAG0024');
INSERT INTO `news_tag` VALUES ('NEWS0113', 'TAG0046');
INSERT INTO `news_tag` VALUES ('NEWS0113', 'TAG0028');
INSERT INTO `news_tag` VALUES ('NEWS0113', 'TAG0080');
INSERT INTO `news_tag` VALUES ('NEWS0113', 'TAG0059');
INSERT INTO `news_tag` VALUES ('NEWS0113', 'TAG0150');
INSERT INTO `news_tag` VALUES ('NEWS0114', 'TAG0092');
INSERT INTO `news_tag` VALUES ('NEWS0114', 'TAG0100');
INSERT INTO `news_tag` VALUES ('NEWS0114', 'TAG0015');
INSERT INTO `news_tag` VALUES ('NEWS0114', 'TAG0144');
INSERT INTO `news_tag` VALUES ('NEWS0114', 'TAG0087');
INSERT INTO `news_tag` VALUES ('NEWS0115', 'TAG0017');
INSERT INTO `news_tag` VALUES ('NEWS0115', 'TAG0150');
INSERT INTO `news_tag` VALUES ('NEWS0115', 'TAG0058');
INSERT INTO `news_tag` VALUES ('NEWS0115', 'TAG0038');
INSERT INTO `news_tag` VALUES ('NEWS0115', 'TAG0013');
INSERT INTO `news_tag` VALUES ('NEWS0116', 'TAG0075');
INSERT INTO `news_tag` VALUES ('NEWS0116', 'TAG0088');
INSERT INTO `news_tag` VALUES ('NEWS0116', 'TAG0008');
INSERT INTO `news_tag` VALUES ('NEWS0116', 'TAG0149');
INSERT INTO `news_tag` VALUES ('NEWS0116', 'TAG0131');
INSERT INTO `news_tag` VALUES ('NEWS0117', 'TAG0025');
INSERT INTO `news_tag` VALUES ('NEWS0117', 'TAG0073');
INSERT INTO `news_tag` VALUES ('NEWS0117', 'TAG0011');
INSERT INTO `news_tag` VALUES ('NEWS0117', 'TAG0110');
INSERT INTO `news_tag` VALUES ('NEWS0117', 'TAG0057');
INSERT INTO `news_tag` VALUES ('NEWS0118', 'TAG0049');
INSERT INTO `news_tag` VALUES ('NEWS0118', 'TAG0078');
INSERT INTO `news_tag` VALUES ('NEWS0118', 'TAG0083');
INSERT INTO `news_tag` VALUES ('NEWS0118', 'TAG0028');
INSERT INTO `news_tag` VALUES ('NEWS0118', 'TAG0091');
INSERT INTO `news_tag` VALUES ('NEWS0119', 'TAG0093');
INSERT INTO `news_tag` VALUES ('NEWS0119', 'TAG0121');
INSERT INTO `news_tag` VALUES ('NEWS0119', 'TAG0123');
INSERT INTO `news_tag` VALUES ('NEWS0119', 'TAG0060');
INSERT INTO `news_tag` VALUES ('NEWS0119', 'TAG0038');
INSERT INTO `news_tag` VALUES ('NEWS0120', 'TAG0077');
INSERT INTO `news_tag` VALUES ('NEWS0120', 'TAG0089');
INSERT INTO `news_tag` VALUES ('NEWS0120', 'TAG0116');
INSERT INTO `news_tag` VALUES ('NEWS0120', 'TAG0032');
INSERT INTO `news_tag` VALUES ('NEWS0120', 'TAG0015');
INSERT INTO `news_tag` VALUES ('NEWS0121', 'TAG0141');
INSERT INTO `news_tag` VALUES ('NEWS0121', 'TAG0039');
INSERT INTO `news_tag` VALUES ('NEWS0121', 'TAG0050');
INSERT INTO `news_tag` VALUES ('NEWS0121', 'TAG0150');
INSERT INTO `news_tag` VALUES ('NEWS0121', 'TAG0009');
INSERT INTO `news_tag` VALUES ('NEWS0122', 'TAG0067');
INSERT INTO `news_tag` VALUES ('NEWS0122', 'TAG0116');
INSERT INTO `news_tag` VALUES ('NEWS0122', 'TAG0148');
INSERT INTO `news_tag` VALUES ('NEWS0122', 'TAG0147');
INSERT INTO `news_tag` VALUES ('NEWS0122', 'TAG0048');
INSERT INTO `news_tag` VALUES ('NEWS0123', 'TAG0142');
INSERT INTO `news_tag` VALUES ('NEWS0123', 'TAG0141');
INSERT INTO `news_tag` VALUES ('NEWS0123', 'TAG0075');
INSERT INTO `news_tag` VALUES ('NEWS0123', 'TAG0149');
INSERT INTO `news_tag` VALUES ('NEWS0123', 'TAG0053');
INSERT INTO `news_tag` VALUES ('NEWS0124', 'TAG0072');
INSERT INTO `news_tag` VALUES ('NEWS0124', 'TAG0097');
INSERT INTO `news_tag` VALUES ('NEWS0124', 'TAG0090');
INSERT INTO `news_tag` VALUES ('NEWS0124', 'TAG0109');
INSERT INTO `news_tag` VALUES ('NEWS0124', 'TAG0014');
INSERT INTO `news_tag` VALUES ('NEWS0125', 'TAG0073');
INSERT INTO `news_tag` VALUES ('NEWS0125', 'TAG0138');
INSERT INTO `news_tag` VALUES ('NEWS0125', 'TAG0149');
INSERT INTO `news_tag` VALUES ('NEWS0125', 'TAG0116');
INSERT INTO `news_tag` VALUES ('NEWS0125', 'TAG0054');
INSERT INTO `news_tag` VALUES ('NEWS0126', 'TAG0091');
INSERT INTO `news_tag` VALUES ('NEWS0126', 'TAG0140');
INSERT INTO `news_tag` VALUES ('NEWS0126', 'TAG0136');
INSERT INTO `news_tag` VALUES ('NEWS0126', 'TAG0142');
INSERT INTO `news_tag` VALUES ('NEWS0126', 'TAG0013');
INSERT INTO `news_tag` VALUES ('NEWS0127', 'TAG0058');
INSERT INTO `news_tag` VALUES ('NEWS0127', 'TAG0123');
INSERT INTO `news_tag` VALUES ('NEWS0127', 'TAG0136');
INSERT INTO `news_tag` VALUES ('NEWS0127', 'TAG0034');
INSERT INTO `news_tag` VALUES ('NEWS0127', 'TAG0120');
INSERT INTO `news_tag` VALUES ('NEWS0128', 'TAG0085');
INSERT INTO `news_tag` VALUES ('NEWS0128', 'TAG0116');
INSERT INTO `news_tag` VALUES ('NEWS0128', 'TAG0040');
INSERT INTO `news_tag` VALUES ('NEWS0128', 'TAG0073');
INSERT INTO `news_tag` VALUES ('NEWS0128', 'TAG0069');
INSERT INTO `news_tag` VALUES ('NEWS0129', 'TAG0112');
INSERT INTO `news_tag` VALUES ('NEWS0129', 'TAG0132');
INSERT INTO `news_tag` VALUES ('NEWS0129', 'TAG0006');
INSERT INTO `news_tag` VALUES ('NEWS0129', 'TAG0059');
INSERT INTO `news_tag` VALUES ('NEWS0129', 'TAG0051');
INSERT INTO `news_tag` VALUES ('NEWS0130', 'TAG0061');
INSERT INTO `news_tag` VALUES ('NEWS0130', 'TAG0033');
INSERT INTO `news_tag` VALUES ('NEWS0130', 'TAG0036');
INSERT INTO `news_tag` VALUES ('NEWS0130', 'TAG0104');
INSERT INTO `news_tag` VALUES ('NEWS0130', 'TAG0123');
INSERT INTO `news_tag` VALUES ('NEWS0131', 'TAG0045');
INSERT INTO `news_tag` VALUES ('NEWS0131', 'TAG0088');
INSERT INTO `news_tag` VALUES ('NEWS0131', 'TAG0022');
INSERT INTO `news_tag` VALUES ('NEWS0131', 'TAG0057');
INSERT INTO `news_tag` VALUES ('NEWS0131', 'TAG0091');
INSERT INTO `news_tag` VALUES ('NEWS0132', 'TAG0121');
INSERT INTO `news_tag` VALUES ('NEWS0132', 'TAG0044');
INSERT INTO `news_tag` VALUES ('NEWS0132', 'TAG0119');
INSERT INTO `news_tag` VALUES ('NEWS0132', 'TAG0072');
INSERT INTO `news_tag` VALUES ('NEWS0132', 'TAG0131');
INSERT INTO `news_tag` VALUES ('NEWS0133', 'TAG0026');
INSERT INTO `news_tag` VALUES ('NEWS0133', 'TAG0067');
INSERT INTO `news_tag` VALUES ('NEWS0133', 'TAG0070');
INSERT INTO `news_tag` VALUES ('NEWS0133', 'TAG0086');
INSERT INTO `news_tag` VALUES ('NEWS0133', 'TAG0069');
INSERT INTO `news_tag` VALUES ('NEWS0134', 'TAG0049');
INSERT INTO `news_tag` VALUES ('NEWS0134', 'TAG0028');
INSERT INTO `news_tag` VALUES ('NEWS0134', 'TAG0113');
INSERT INTO `news_tag` VALUES ('NEWS0134', 'TAG0016');
INSERT INTO `news_tag` VALUES ('NEWS0134', 'TAG0111');
INSERT INTO `news_tag` VALUES ('NEWS0135', 'TAG0133');
INSERT INTO `news_tag` VALUES ('NEWS0135', 'TAG0043');
INSERT INTO `news_tag` VALUES ('NEWS0135', 'TAG0060');
INSERT INTO `news_tag` VALUES ('NEWS0135', 'TAG0100');
INSERT INTO `news_tag` VALUES ('NEWS0135', 'TAG0038');
INSERT INTO `news_tag` VALUES ('NEWS0136', 'TAG0109');
INSERT INTO `news_tag` VALUES ('NEWS0136', 'TAG0007');
INSERT INTO `news_tag` VALUES ('NEWS0136', 'TAG0090');
INSERT INTO `news_tag` VALUES ('NEWS0136', 'TAG0008');
INSERT INTO `news_tag` VALUES ('NEWS0136', 'TAG0115');
INSERT INTO `news_tag` VALUES ('NEWS0137', 'TAG0001');
INSERT INTO `news_tag` VALUES ('NEWS0137', 'TAG0032');
INSERT INTO `news_tag` VALUES ('NEWS0137', 'TAG0132');
INSERT INTO `news_tag` VALUES ('NEWS0137', 'TAG0033');
INSERT INTO `news_tag` VALUES ('NEWS0137', 'TAG0003');
INSERT INTO `news_tag` VALUES ('NEWS0138', 'TAG0027');
INSERT INTO `news_tag` VALUES ('NEWS0138', 'TAG0050');
INSERT INTO `news_tag` VALUES ('NEWS0138', 'TAG0112');
INSERT INTO `news_tag` VALUES ('NEWS0138', 'TAG0121');
INSERT INTO `news_tag` VALUES ('NEWS0138', 'TAG0108');
INSERT INTO `news_tag` VALUES ('NEWS0139', 'TAG0087');
INSERT INTO `news_tag` VALUES ('NEWS0139', 'TAG0134');
INSERT INTO `news_tag` VALUES ('NEWS0139', 'TAG0130');
INSERT INTO `news_tag` VALUES ('NEWS0139', 'TAG0063');
INSERT INTO `news_tag` VALUES ('NEWS0139', 'TAG0111');
INSERT INTO `news_tag` VALUES ('NEWS0140', 'TAG0025');
INSERT INTO `news_tag` VALUES ('NEWS0140', 'TAG0121');
INSERT INTO `news_tag` VALUES ('NEWS0140', 'TAG0028');
INSERT INTO `news_tag` VALUES ('NEWS0140', 'TAG0091');
INSERT INTO `news_tag` VALUES ('NEWS0140', 'TAG0090');
INSERT INTO `news_tag` VALUES ('NEWS0141', 'TAG0029');
INSERT INTO `news_tag` VALUES ('NEWS0141', 'TAG0126');
INSERT INTO `news_tag` VALUES ('NEWS0141', 'TAG0020');
INSERT INTO `news_tag` VALUES ('NEWS0141', 'TAG0125');
INSERT INTO `news_tag` VALUES ('NEWS0141', 'TAG0007');
INSERT INTO `news_tag` VALUES ('NEWS0142', 'TAG0117');
INSERT INTO `news_tag` VALUES ('NEWS0142', 'TAG0016');
INSERT INTO `news_tag` VALUES ('NEWS0142', 'TAG0113');
INSERT INTO `news_tag` VALUES ('NEWS0142', 'TAG0057');
INSERT INTO `news_tag` VALUES ('NEWS0142', 'TAG0058');
INSERT INTO `news_tag` VALUES ('NEWS0143', 'TAG0073');
INSERT INTO `news_tag` VALUES ('NEWS0143', 'TAG0126');
INSERT INTO `news_tag` VALUES ('NEWS0143', 'TAG0019');
INSERT INTO `news_tag` VALUES ('NEWS0143', 'TAG0091');
INSERT INTO `news_tag` VALUES ('NEWS0143', 'TAG0089');
INSERT INTO `news_tag` VALUES ('NEWS0144', 'TAG0020');
INSERT INTO `news_tag` VALUES ('NEWS0144', 'TAG0054');
INSERT INTO `news_tag` VALUES ('NEWS0144', 'TAG0041');
INSERT INTO `news_tag` VALUES ('NEWS0144', 'TAG0064');
INSERT INTO `news_tag` VALUES ('NEWS0144', 'TAG0022');
INSERT INTO `news_tag` VALUES ('NEWS0145', 'TAG0145');
INSERT INTO `news_tag` VALUES ('NEWS0145', 'TAG0130');
INSERT INTO `news_tag` VALUES ('NEWS0145', 'TAG0009');
INSERT INTO `news_tag` VALUES ('NEWS0145', 'TAG0093');
INSERT INTO `news_tag` VALUES ('NEWS0145', 'TAG0090');
INSERT INTO `news_tag` VALUES ('NEWS0146', 'TAG0147');
INSERT INTO `news_tag` VALUES ('NEWS0146', 'TAG0045');
INSERT INTO `news_tag` VALUES ('NEWS0146', 'TAG0053');
INSERT INTO `news_tag` VALUES ('NEWS0146', 'TAG0145');
INSERT INTO `news_tag` VALUES ('NEWS0146', 'TAG0107');
INSERT INTO `news_tag` VALUES ('NEWS0147', 'TAG0098');
INSERT INTO `news_tag` VALUES ('NEWS0147', 'TAG0084');
INSERT INTO `news_tag` VALUES ('NEWS0147', 'TAG0114');
INSERT INTO `news_tag` VALUES ('NEWS0147', 'TAG0046');
INSERT INTO `news_tag` VALUES ('NEWS0147', 'TAG0050');
INSERT INTO `news_tag` VALUES ('NEWS0148', 'TAG0021');
INSERT INTO `news_tag` VALUES ('NEWS0148', 'TAG0146');
INSERT INTO `news_tag` VALUES ('NEWS0148', 'TAG0081');
INSERT INTO `news_tag` VALUES ('NEWS0148', 'TAG0150');
INSERT INTO `news_tag` VALUES ('NEWS0148', 'TAG0009');
INSERT INTO `news_tag` VALUES ('NEWS0149', 'TAG0101');
INSERT INTO `news_tag` VALUES ('NEWS0149', 'TAG0147');
INSERT INTO `news_tag` VALUES ('NEWS0149', 'TAG0142');
INSERT INTO `news_tag` VALUES ('NEWS0149', 'TAG0074');
INSERT INTO `news_tag` VALUES ('NEWS0149', 'TAG0105');
INSERT INTO `news_tag` VALUES ('NEWS0150', 'TAG0142');
INSERT INTO `news_tag` VALUES ('NEWS0150', 'TAG0150');
INSERT INTO `news_tag` VALUES ('NEWS0150', 'TAG0117');
INSERT INTO `news_tag` VALUES ('NEWS0150', 'TAG0074');
INSERT INTO `news_tag` VALUES ('NEWS0150', 'TAG0048');
INSERT INTO `news_tag` VALUES ('NEWS0151', 'TAG0137');
INSERT INTO `news_tag` VALUES ('NEWS0151', 'TAG0032');
INSERT INTO `news_tag` VALUES ('NEWS0151', 'TAG0112');
INSERT INTO `news_tag` VALUES ('NEWS0151', 'TAG0095');
INSERT INTO `news_tag` VALUES ('NEWS0151', 'TAG0105');
INSERT INTO `news_tag` VALUES ('NEWS0152', 'TAG0118');
INSERT INTO `news_tag` VALUES ('NEWS0152', 'TAG0024');
INSERT INTO `news_tag` VALUES ('NEWS0152', 'TAG0083');
INSERT INTO `news_tag` VALUES ('NEWS0152', 'TAG0139');
INSERT INTO `news_tag` VALUES ('NEWS0152', 'TAG0138');
INSERT INTO `news_tag` VALUES ('NEWS0153', 'TAG0065');
INSERT INTO `news_tag` VALUES ('NEWS0153', 'TAG0070');
INSERT INTO `news_tag` VALUES ('NEWS0153', 'TAG0009');
INSERT INTO `news_tag` VALUES ('NEWS0153', 'TAG0127');
INSERT INTO `news_tag` VALUES ('NEWS0153', 'TAG0042');
INSERT INTO `news_tag` VALUES ('NEWS0154', 'TAG0112');
INSERT INTO `news_tag` VALUES ('NEWS0154', 'TAG0068');
INSERT INTO `news_tag` VALUES ('NEWS0154', 'TAG0061');
INSERT INTO `news_tag` VALUES ('NEWS0154', 'TAG0050');
INSERT INTO `news_tag` VALUES ('NEWS0154', 'TAG0071');
INSERT INTO `news_tag` VALUES ('NEWS0155', 'TAG0125');
INSERT INTO `news_tag` VALUES ('NEWS0155', 'TAG0089');
INSERT INTO `news_tag` VALUES ('NEWS0155', 'TAG0139');
INSERT INTO `news_tag` VALUES ('NEWS0155', 'TAG0068');
INSERT INTO `news_tag` VALUES ('NEWS0155', 'TAG0143');
INSERT INTO `news_tag` VALUES ('NEWS0156', 'TAG0060');
INSERT INTO `news_tag` VALUES ('NEWS0156', 'TAG0148');
INSERT INTO `news_tag` VALUES ('NEWS0156', 'TAG0077');
INSERT INTO `news_tag` VALUES ('NEWS0156', 'TAG0004');
INSERT INTO `news_tag` VALUES ('NEWS0156', 'TAG0011');
INSERT INTO `news_tag` VALUES ('NEWS0157', 'TAG0053');
INSERT INTO `news_tag` VALUES ('NEWS0157', 'TAG0001');
INSERT INTO `news_tag` VALUES ('NEWS0157', 'TAG0069');
INSERT INTO `news_tag` VALUES ('NEWS0157', 'TAG0076');
INSERT INTO `news_tag` VALUES ('NEWS0157', 'TAG0135');
INSERT INTO `news_tag` VALUES ('NEWS0158', 'TAG0001');
INSERT INTO `news_tag` VALUES ('NEWS0158', 'TAG0079');
INSERT INTO `news_tag` VALUES ('NEWS0158', 'TAG0141');
INSERT INTO `news_tag` VALUES ('NEWS0158', 'TAG0102');
INSERT INTO `news_tag` VALUES ('NEWS0158', 'TAG0100');
INSERT INTO `news_tag` VALUES ('NEWS0159', 'TAG0065');
INSERT INTO `news_tag` VALUES ('NEWS0159', 'TAG0082');
INSERT INTO `news_tag` VALUES ('NEWS0159', 'TAG0051');
INSERT INTO `news_tag` VALUES ('NEWS0159', 'TAG0031');
INSERT INTO `news_tag` VALUES ('NEWS0159', 'TAG0036');
INSERT INTO `news_tag` VALUES ('NEWS0160', 'TAG0027');
INSERT INTO `news_tag` VALUES ('NEWS0160', 'TAG0010');
INSERT INTO `news_tag` VALUES ('NEWS0160', 'TAG0086');
INSERT INTO `news_tag` VALUES ('NEWS0160', 'TAG0003');
INSERT INTO `news_tag` VALUES ('NEWS0160', 'TAG0019');
INSERT INTO `news_tag` VALUES ('NEWS0161', 'TAG0091');
INSERT INTO `news_tag` VALUES ('NEWS0161', 'TAG0002');
INSERT INTO `news_tag` VALUES ('NEWS0161', 'TAG0104');
INSERT INTO `news_tag` VALUES ('NEWS0161', 'TAG0074');
INSERT INTO `news_tag` VALUES ('NEWS0161', 'TAG0149');
INSERT INTO `news_tag` VALUES ('NEWS0162', 'TAG0059');
INSERT INTO `news_tag` VALUES ('NEWS0162', 'TAG0145');
INSERT INTO `news_tag` VALUES ('NEWS0162', 'TAG0065');
INSERT INTO `news_tag` VALUES ('NEWS0162', 'TAG0028');
INSERT INTO `news_tag` VALUES ('NEWS0162', 'TAG0011');
INSERT INTO `news_tag` VALUES ('NEWS0163', 'TAG0026');
INSERT INTO `news_tag` VALUES ('NEWS0163', 'TAG0046');
INSERT INTO `news_tag` VALUES ('NEWS0163', 'TAG0101');
INSERT INTO `news_tag` VALUES ('NEWS0163', 'TAG0085');
INSERT INTO `news_tag` VALUES ('NEWS0163', 'TAG0038');
INSERT INTO `news_tag` VALUES ('NEWS0164', 'TAG0066');
INSERT INTO `news_tag` VALUES ('NEWS0164', 'TAG0126');
INSERT INTO `news_tag` VALUES ('NEWS0164', 'TAG0081');
INSERT INTO `news_tag` VALUES ('NEWS0164', 'TAG0135');
INSERT INTO `news_tag` VALUES ('NEWS0164', 'TAG0089');
INSERT INTO `news_tag` VALUES ('NEWS0165', 'TAG0116');
INSERT INTO `news_tag` VALUES ('NEWS0165', 'TAG0068');
INSERT INTO `news_tag` VALUES ('NEWS0165', 'TAG0028');
INSERT INTO `news_tag` VALUES ('NEWS0165', 'TAG0054');
INSERT INTO `news_tag` VALUES ('NEWS0165', 'TAG0120');
INSERT INTO `news_tag` VALUES ('NEWS0166', 'TAG0007');
INSERT INTO `news_tag` VALUES ('NEWS0166', 'TAG0084');
INSERT INTO `news_tag` VALUES ('NEWS0166', 'TAG0066');
INSERT INTO `news_tag` VALUES ('NEWS0166', 'TAG0106');
INSERT INTO `news_tag` VALUES ('NEWS0166', 'TAG0047');
INSERT INTO `news_tag` VALUES ('NEWS0167', 'TAG0044');
INSERT INTO `news_tag` VALUES ('NEWS0167', 'TAG0114');
INSERT INTO `news_tag` VALUES ('NEWS0167', 'TAG0012');
INSERT INTO `news_tag` VALUES ('NEWS0167', 'TAG0010');
INSERT INTO `news_tag` VALUES ('NEWS0167', 'TAG0145');
INSERT INTO `news_tag` VALUES ('NEWS0168', 'TAG0116');
INSERT INTO `news_tag` VALUES ('NEWS0168', 'TAG0008');
INSERT INTO `news_tag` VALUES ('NEWS0168', 'TAG0095');
INSERT INTO `news_tag` VALUES ('NEWS0168', 'TAG0030');
INSERT INTO `news_tag` VALUES ('NEWS0168', 'TAG0021');
INSERT INTO `news_tag` VALUES ('NEWS0169', 'TAG0049');
INSERT INTO `news_tag` VALUES ('NEWS0169', 'TAG0108');
INSERT INTO `news_tag` VALUES ('NEWS0169', 'TAG0038');
INSERT INTO `news_tag` VALUES ('NEWS0169', 'TAG0029');
INSERT INTO `news_tag` VALUES ('NEWS0169', 'TAG0080');
INSERT INTO `news_tag` VALUES ('NEWS0170', 'TAG0040');
INSERT INTO `news_tag` VALUES ('NEWS0170', 'TAG0084');
INSERT INTO `news_tag` VALUES ('NEWS0170', 'TAG0113');
INSERT INTO `news_tag` VALUES ('NEWS0170', 'TAG0068');
INSERT INTO `news_tag` VALUES ('NEWS0170', 'TAG0124');
INSERT INTO `news_tag` VALUES ('NEWS0171', 'TAG0031');
INSERT INTO `news_tag` VALUES ('NEWS0171', 'TAG0106');
INSERT INTO `news_tag` VALUES ('NEWS0171', 'TAG0021');
INSERT INTO `news_tag` VALUES ('NEWS0171', 'TAG0020');
INSERT INTO `news_tag` VALUES ('NEWS0171', 'TAG0065');
INSERT INTO `news_tag` VALUES ('NEWS0172', 'TAG0087');
INSERT INTO `news_tag` VALUES ('NEWS0172', 'TAG0052');
INSERT INTO `news_tag` VALUES ('NEWS0172', 'TAG0061');
INSERT INTO `news_tag` VALUES ('NEWS0172', 'TAG0111');
INSERT INTO `news_tag` VALUES ('NEWS0172', 'TAG0075');
INSERT INTO `news_tag` VALUES ('NEWS0173', 'TAG0003');
INSERT INTO `news_tag` VALUES ('NEWS0173', 'TAG0080');
INSERT INTO `news_tag` VALUES ('NEWS0173', 'TAG0130');
INSERT INTO `news_tag` VALUES ('NEWS0173', 'TAG0045');
INSERT INTO `news_tag` VALUES ('NEWS0173', 'TAG0100');
INSERT INTO `news_tag` VALUES ('NEWS0174', 'TAG0054');
INSERT INTO `news_tag` VALUES ('NEWS0174', 'TAG0055');
INSERT INTO `news_tag` VALUES ('NEWS0174', 'TAG0049');
INSERT INTO `news_tag` VALUES ('NEWS0174', 'TAG0119');
INSERT INTO `news_tag` VALUES ('NEWS0174', 'TAG0058');
INSERT INTO `news_tag` VALUES ('NEWS0175', 'TAG0121');
INSERT INTO `news_tag` VALUES ('NEWS0175', 'TAG0056');
INSERT INTO `news_tag` VALUES ('NEWS0175', 'TAG0088');
INSERT INTO `news_tag` VALUES ('NEWS0175', 'TAG0138');
INSERT INTO `news_tag` VALUES ('NEWS0175', 'TAG0026');
INSERT INTO `news_tag` VALUES ('NEWS0176', 'TAG0087');
INSERT INTO `news_tag` VALUES ('NEWS0176', 'TAG0126');
INSERT INTO `news_tag` VALUES ('NEWS0176', 'TAG0106');
INSERT INTO `news_tag` VALUES ('NEWS0176', 'TAG0071');
INSERT INTO `news_tag` VALUES ('NEWS0176', 'TAG0118');
INSERT INTO `news_tag` VALUES ('NEWS0177', 'TAG0032');
INSERT INTO `news_tag` VALUES ('NEWS0177', 'TAG0055');
INSERT INTO `news_tag` VALUES ('NEWS0177', 'TAG0010');
INSERT INTO `news_tag` VALUES ('NEWS0177', 'TAG0113');
INSERT INTO `news_tag` VALUES ('NEWS0177', 'TAG0106');
INSERT INTO `news_tag` VALUES ('NEWS0178', 'TAG0129');
INSERT INTO `news_tag` VALUES ('NEWS0178', 'TAG0046');
INSERT INTO `news_tag` VALUES ('NEWS0178', 'TAG0045');
INSERT INTO `news_tag` VALUES ('NEWS0178', 'TAG0049');
INSERT INTO `news_tag` VALUES ('NEWS0178', 'TAG0002');
INSERT INTO `news_tag` VALUES ('NEWS0179', 'TAG0068');
INSERT INTO `news_tag` VALUES ('NEWS0179', 'TAG0100');
INSERT INTO `news_tag` VALUES ('NEWS0179', 'TAG0142');
INSERT INTO `news_tag` VALUES ('NEWS0179', 'TAG0132');
INSERT INTO `news_tag` VALUES ('NEWS0179', 'TAG0084');
INSERT INTO `news_tag` VALUES ('NEWS0180', 'TAG0050');
INSERT INTO `news_tag` VALUES ('NEWS0180', 'TAG0022');
INSERT INTO `news_tag` VALUES ('NEWS0180', 'TAG0149');
INSERT INTO `news_tag` VALUES ('NEWS0180', 'TAG0064');
INSERT INTO `news_tag` VALUES ('NEWS0180', 'TAG0035');
INSERT INTO `news_tag` VALUES ('NEWS0181', 'TAG0109');
INSERT INTO `news_tag` VALUES ('NEWS0181', 'TAG0028');
INSERT INTO `news_tag` VALUES ('NEWS0181', 'TAG0034');
INSERT INTO `news_tag` VALUES ('NEWS0181', 'TAG0033');
INSERT INTO `news_tag` VALUES ('NEWS0181', 'TAG0048');
INSERT INTO `news_tag` VALUES ('NEWS0182', 'TAG0113');
INSERT INTO `news_tag` VALUES ('NEWS0182', 'TAG0034');
INSERT INTO `news_tag` VALUES ('NEWS0182', 'TAG0135');
INSERT INTO `news_tag` VALUES ('NEWS0182', 'TAG0057');
INSERT INTO `news_tag` VALUES ('NEWS0182', 'TAG0107');
INSERT INTO `news_tag` VALUES ('NEWS0183', 'TAG0055');
INSERT INTO `news_tag` VALUES ('NEWS0183', 'TAG0045');
INSERT INTO `news_tag` VALUES ('NEWS0183', 'TAG0098');
INSERT INTO `news_tag` VALUES ('NEWS0183', 'TAG0123');
INSERT INTO `news_tag` VALUES ('NEWS0183', 'TAG0149');
INSERT INTO `news_tag` VALUES ('NEWS0184', 'TAG0001');
INSERT INTO `news_tag` VALUES ('NEWS0184', 'TAG0087');
INSERT INTO `news_tag` VALUES ('NEWS0184', 'TAG0079');
INSERT INTO `news_tag` VALUES ('NEWS0184', 'TAG0150');
INSERT INTO `news_tag` VALUES ('NEWS0184', 'TAG0098');
INSERT INTO `news_tag` VALUES ('NEWS0185', 'TAG0060');
INSERT INTO `news_tag` VALUES ('NEWS0185', 'TAG0089');
INSERT INTO `news_tag` VALUES ('NEWS0185', 'TAG0034');
INSERT INTO `news_tag` VALUES ('NEWS0185', 'TAG0072');
INSERT INTO `news_tag` VALUES ('NEWS0185', 'TAG0012');
INSERT INTO `news_tag` VALUES ('NEWS0186', 'TAG0084');
INSERT INTO `news_tag` VALUES ('NEWS0186', 'TAG0100');
INSERT INTO `news_tag` VALUES ('NEWS0186', 'TAG0052');
INSERT INTO `news_tag` VALUES ('NEWS0186', 'TAG0073');
INSERT INTO `news_tag` VALUES ('NEWS0186', 'TAG0143');
INSERT INTO `news_tag` VALUES ('NEWS0187', 'TAG0138');
INSERT INTO `news_tag` VALUES ('NEWS0187', 'TAG0019');
INSERT INTO `news_tag` VALUES ('NEWS0187', 'TAG0109');
INSERT INTO `news_tag` VALUES ('NEWS0187', 'TAG0106');
INSERT INTO `news_tag` VALUES ('NEWS0187', 'TAG0020');
INSERT INTO `news_tag` VALUES ('NEWS0188', 'TAG0001');
INSERT INTO `news_tag` VALUES ('NEWS0188', 'TAG0021');
INSERT INTO `news_tag` VALUES ('NEWS0188', 'TAG0117');
INSERT INTO `news_tag` VALUES ('NEWS0188', 'TAG0144');
INSERT INTO `news_tag` VALUES ('NEWS0188', 'TAG0110');
INSERT INTO `news_tag` VALUES ('NEWS0189', 'TAG0075');
INSERT INTO `news_tag` VALUES ('NEWS0189', 'TAG0090');
INSERT INTO `news_tag` VALUES ('NEWS0189', 'TAG0121');
INSERT INTO `news_tag` VALUES ('NEWS0189', 'TAG0083');
INSERT INTO `news_tag` VALUES ('NEWS0189', 'TAG0020');
INSERT INTO `news_tag` VALUES ('NEWS0190', 'TAG0018');
INSERT INTO `news_tag` VALUES ('NEWS0190', 'TAG0060');
INSERT INTO `news_tag` VALUES ('NEWS0190', 'TAG0110');
INSERT INTO `news_tag` VALUES ('NEWS0190', 'TAG0097');
INSERT INTO `news_tag` VALUES ('NEWS0190', 'TAG0081');
INSERT INTO `news_tag` VALUES ('NEWS0191', 'TAG0080');
INSERT INTO `news_tag` VALUES ('NEWS0191', 'TAG0115');
INSERT INTO `news_tag` VALUES ('NEWS0191', 'TAG0079');
INSERT INTO `news_tag` VALUES ('NEWS0191', 'TAG0092');
INSERT INTO `news_tag` VALUES ('NEWS0191', 'TAG0085');
INSERT INTO `news_tag` VALUES ('NEWS0192', 'TAG0076');
INSERT INTO `news_tag` VALUES ('NEWS0192', 'TAG0073');
INSERT INTO `news_tag` VALUES ('NEWS0192', 'TAG0025');
INSERT INTO `news_tag` VALUES ('NEWS0192', 'TAG0132');
INSERT INTO `news_tag` VALUES ('NEWS0192', 'TAG0074');
INSERT INTO `news_tag` VALUES ('NEWS0193', 'TAG0133');
INSERT INTO `news_tag` VALUES ('NEWS0193', 'TAG0019');
INSERT INTO `news_tag` VALUES ('NEWS0193', 'TAG0124');
INSERT INTO `news_tag` VALUES ('NEWS0193', 'TAG0141');
INSERT INTO `news_tag` VALUES ('NEWS0193', 'TAG0037');
INSERT INTO `news_tag` VALUES ('NEWS0194', 'TAG0066');
INSERT INTO `news_tag` VALUES ('NEWS0194', 'TAG0042');
INSERT INTO `news_tag` VALUES ('NEWS0194', 'TAG0031');
INSERT INTO `news_tag` VALUES ('NEWS0194', 'TAG0127');
INSERT INTO `news_tag` VALUES ('NEWS0194', 'TAG0035');
INSERT INTO `news_tag` VALUES ('NEWS0195', 'TAG0101');
INSERT INTO `news_tag` VALUES ('NEWS0195', 'TAG0038');
INSERT INTO `news_tag` VALUES ('NEWS0195', 'TAG0134');
INSERT INTO `news_tag` VALUES ('NEWS0195', 'TAG0081');
INSERT INTO `news_tag` VALUES ('NEWS0195', 'TAG0145');
INSERT INTO `news_tag` VALUES ('NEWS0196', 'TAG0080');
INSERT INTO `news_tag` VALUES ('NEWS0196', 'TAG0111');
INSERT INTO `news_tag` VALUES ('NEWS0196', 'TAG0060');
INSERT INTO `news_tag` VALUES ('NEWS0196', 'TAG0087');
INSERT INTO `news_tag` VALUES ('NEWS0196', 'TAG0112');
INSERT INTO `news_tag` VALUES ('NEWS0197', 'TAG0112');
INSERT INTO `news_tag` VALUES ('NEWS0197', 'TAG0057');
INSERT INTO `news_tag` VALUES ('NEWS0197', 'TAG0082');
INSERT INTO `news_tag` VALUES ('NEWS0197', 'TAG0101');
INSERT INTO `news_tag` VALUES ('NEWS0197', 'TAG0021');
INSERT INTO `news_tag` VALUES ('NEWS0198', 'TAG0121');
INSERT INTO `news_tag` VALUES ('NEWS0198', 'TAG0053');
INSERT INTO `news_tag` VALUES ('NEWS0198', 'TAG0129');
INSERT INTO `news_tag` VALUES ('NEWS0198', 'TAG0072');
INSERT INTO `news_tag` VALUES ('NEWS0198', 'TAG0099');
INSERT INTO `news_tag` VALUES ('NEWS0199', 'TAG0029');
INSERT INTO `news_tag` VALUES ('NEWS0199', 'TAG0044');
INSERT INTO `news_tag` VALUES ('NEWS0199', 'TAG0078');
INSERT INTO `news_tag` VALUES ('NEWS0199', 'TAG0101');
INSERT INTO `news_tag` VALUES ('NEWS0199', 'TAG0039');
INSERT INTO `news_tag` VALUES ('NEWS0200', 'TAG0017');
INSERT INTO `news_tag` VALUES ('NEWS0200', 'TAG0070');
INSERT INTO `news_tag` VALUES ('NEWS0200', 'TAG0032');
INSERT INTO `news_tag` VALUES ('NEWS0200', 'TAG0024');
INSERT INTO `news_tag` VALUES ('NEWS0200', 'TAG0099');
INSERT INTO `news_tag` VALUES ('NEWS0201', 'TAG0132');
INSERT INTO `news_tag` VALUES ('NEWS0201', 'TAG0051');
INSERT INTO `news_tag` VALUES ('NEWS0201', 'TAG0016');
INSERT INTO `news_tag` VALUES ('NEWS0201', 'TAG0024');
INSERT INTO `news_tag` VALUES ('NEWS0201', 'TAG0080');
INSERT INTO `news_tag` VALUES ('NEWS0202', 'TAG0129');
INSERT INTO `news_tag` VALUES ('NEWS0202', 'TAG0088');
INSERT INTO `news_tag` VALUES ('NEWS0202', 'TAG0065');
INSERT INTO `news_tag` VALUES ('NEWS0202', 'TAG0117');
INSERT INTO `news_tag` VALUES ('NEWS0202', 'TAG0055');
INSERT INTO `news_tag` VALUES ('NEWS0203', 'TAG0111');
INSERT INTO `news_tag` VALUES ('NEWS0203', 'TAG0102');
INSERT INTO `news_tag` VALUES ('NEWS0203', 'TAG0135');
INSERT INTO `news_tag` VALUES ('NEWS0203', 'TAG0126');
INSERT INTO `news_tag` VALUES ('NEWS0203', 'TAG0071');
INSERT INTO `news_tag` VALUES ('NEWS0204', 'TAG0070');
INSERT INTO `news_tag` VALUES ('NEWS0204', 'TAG0085');
INSERT INTO `news_tag` VALUES ('NEWS0204', 'TAG0143');
INSERT INTO `news_tag` VALUES ('NEWS0204', 'TAG0131');
INSERT INTO `news_tag` VALUES ('NEWS0204', 'TAG0113');
INSERT INTO `news_tag` VALUES ('NEWS0205', 'TAG0036');
INSERT INTO `news_tag` VALUES ('NEWS0205', 'TAG0042');
INSERT INTO `news_tag` VALUES ('NEWS0205', 'TAG0026');
INSERT INTO `news_tag` VALUES ('NEWS0205', 'TAG0135');
INSERT INTO `news_tag` VALUES ('NEWS0205', 'TAG0114');
INSERT INTO `news_tag` VALUES ('NEWS0206', 'TAG0015');
INSERT INTO `news_tag` VALUES ('NEWS0206', 'TAG0132');
INSERT INTO `news_tag` VALUES ('NEWS0206', 'TAG0149');
INSERT INTO `news_tag` VALUES ('NEWS0206', 'TAG0083');
INSERT INTO `news_tag` VALUES ('NEWS0206', 'TAG0113');
INSERT INTO `news_tag` VALUES ('NEWS0207', 'TAG0058');
INSERT INTO `news_tag` VALUES ('NEWS0207', 'TAG0022');
INSERT INTO `news_tag` VALUES ('NEWS0207', 'TAG0054');
INSERT INTO `news_tag` VALUES ('NEWS0207', 'TAG0140');
INSERT INTO `news_tag` VALUES ('NEWS0207', 'TAG0007');
INSERT INTO `news_tag` VALUES ('NEWS0208', 'TAG0140');
INSERT INTO `news_tag` VALUES ('NEWS0208', 'TAG0059');
INSERT INTO `news_tag` VALUES ('NEWS0208', 'TAG0109');
INSERT INTO `news_tag` VALUES ('NEWS0208', 'TAG0104');
INSERT INTO `news_tag` VALUES ('NEWS0208', 'TAG0103');
INSERT INTO `news_tag` VALUES ('NEWS0209', 'TAG0013');
INSERT INTO `news_tag` VALUES ('NEWS0209', 'TAG0091');
INSERT INTO `news_tag` VALUES ('NEWS0209', 'TAG0079');
INSERT INTO `news_tag` VALUES ('NEWS0209', 'TAG0148');
INSERT INTO `news_tag` VALUES ('NEWS0209', 'TAG0030');
INSERT INTO `news_tag` VALUES ('NEWS0210', 'TAG0092');
INSERT INTO `news_tag` VALUES ('NEWS0210', 'TAG0123');
INSERT INTO `news_tag` VALUES ('NEWS0210', 'TAG0025');
INSERT INTO `news_tag` VALUES ('NEWS0210', 'TAG0009');
INSERT INTO `news_tag` VALUES ('NEWS0210', 'TAG0109');
INSERT INTO `news_tag` VALUES ('NEWS0211', 'TAG0086');
INSERT INTO `news_tag` VALUES ('NEWS0211', 'TAG0027');
INSERT INTO `news_tag` VALUES ('NEWS0211', 'TAG0075');
INSERT INTO `news_tag` VALUES ('NEWS0211', 'TAG0003');
INSERT INTO `news_tag` VALUES ('NEWS0211', 'TAG0116');
INSERT INTO `news_tag` VALUES ('NEWS0212', 'TAG0105');
INSERT INTO `news_tag` VALUES ('NEWS0212', 'TAG0120');
INSERT INTO `news_tag` VALUES ('NEWS0212', 'TAG0009');
INSERT INTO `news_tag` VALUES ('NEWS0212', 'TAG0027');
INSERT INTO `news_tag` VALUES ('NEWS0212', 'TAG0148');
INSERT INTO `news_tag` VALUES ('NEWS0213', 'TAG0008');
INSERT INTO `news_tag` VALUES ('NEWS0213', 'TAG0109');
INSERT INTO `news_tag` VALUES ('NEWS0213', 'TAG0087');
INSERT INTO `news_tag` VALUES ('NEWS0213', 'TAG0056');
INSERT INTO `news_tag` VALUES ('NEWS0213', 'TAG0037');
INSERT INTO `news_tag` VALUES ('NEWS0214', 'TAG0108');
INSERT INTO `news_tag` VALUES ('NEWS0214', 'TAG0064');
INSERT INTO `news_tag` VALUES ('NEWS0214', 'TAG0010');
INSERT INTO `news_tag` VALUES ('NEWS0214', 'TAG0116');
INSERT INTO `news_tag` VALUES ('NEWS0214', 'TAG0053');
INSERT INTO `news_tag` VALUES ('NEWS0215', 'TAG0049');
INSERT INTO `news_tag` VALUES ('NEWS0215', 'TAG0002');
INSERT INTO `news_tag` VALUES ('NEWS0215', 'TAG0025');
INSERT INTO `news_tag` VALUES ('NEWS0215', 'TAG0112');
INSERT INTO `news_tag` VALUES ('NEWS0215', 'TAG0004');
INSERT INTO `news_tag` VALUES ('NEWS0216', 'TAG0139');
INSERT INTO `news_tag` VALUES ('NEWS0216', 'TAG0003');
INSERT INTO `news_tag` VALUES ('NEWS0216', 'TAG0143');
INSERT INTO `news_tag` VALUES ('NEWS0216', 'TAG0026');
INSERT INTO `news_tag` VALUES ('NEWS0216', 'TAG0073');
INSERT INTO `news_tag` VALUES ('NEWS0217', 'TAG0137');
INSERT INTO `news_tag` VALUES ('NEWS0217', 'TAG0082');
INSERT INTO `news_tag` VALUES ('NEWS0217', 'TAG0059');
INSERT INTO `news_tag` VALUES ('NEWS0217', 'TAG0054');
INSERT INTO `news_tag` VALUES ('NEWS0217', 'TAG0061');
INSERT INTO `news_tag` VALUES ('NEWS0218', 'TAG0113');
INSERT INTO `news_tag` VALUES ('NEWS0218', 'TAG0034');
INSERT INTO `news_tag` VALUES ('NEWS0218', 'TAG0128');
INSERT INTO `news_tag` VALUES ('NEWS0218', 'TAG0097');
INSERT INTO `news_tag` VALUES ('NEWS0218', 'TAG0136');
INSERT INTO `news_tag` VALUES ('NEWS0219', 'TAG0032');
INSERT INTO `news_tag` VALUES ('NEWS0219', 'TAG0106');
INSERT INTO `news_tag` VALUES ('NEWS0219', 'TAG0119');
INSERT INTO `news_tag` VALUES ('NEWS0219', 'TAG0004');
INSERT INTO `news_tag` VALUES ('NEWS0219', 'TAG0035');
INSERT INTO `news_tag` VALUES ('NEWS0220', 'TAG0111');
INSERT INTO `news_tag` VALUES ('NEWS0220', 'TAG0114');
INSERT INTO `news_tag` VALUES ('NEWS0220', 'TAG0012');
INSERT INTO `news_tag` VALUES ('NEWS0220', 'TAG0099');
INSERT INTO `news_tag` VALUES ('NEWS0220', 'TAG0005');
INSERT INTO `news_tag` VALUES ('NEWS0221', 'TAG0110');
INSERT INTO `news_tag` VALUES ('NEWS0221', 'TAG0014');
INSERT INTO `news_tag` VALUES ('NEWS0221', 'TAG0004');
INSERT INTO `news_tag` VALUES ('NEWS0221', 'TAG0114');
INSERT INTO `news_tag` VALUES ('NEWS0221', 'TAG0044');
INSERT INTO `news_tag` VALUES ('NEWS0222', 'TAG0018');
INSERT INTO `news_tag` VALUES ('NEWS0222', 'TAG0131');
INSERT INTO `news_tag` VALUES ('NEWS0222', 'TAG0104');
INSERT INTO `news_tag` VALUES ('NEWS0222', 'TAG0051');
INSERT INTO `news_tag` VALUES ('NEWS0222', 'TAG0056');
INSERT INTO `news_tag` VALUES ('NEWS0223', 'TAG0008');
INSERT INTO `news_tag` VALUES ('NEWS0223', 'TAG0109');
INSERT INTO `news_tag` VALUES ('NEWS0223', 'TAG0063');
INSERT INTO `news_tag` VALUES ('NEWS0223', 'TAG0114');
INSERT INTO `news_tag` VALUES ('NEWS0223', 'TAG0105');
INSERT INTO `news_tag` VALUES ('NEWS0224', 'TAG0096');
INSERT INTO `news_tag` VALUES ('NEWS0224', 'TAG0016');
INSERT INTO `news_tag` VALUES ('NEWS0224', 'TAG0045');
INSERT INTO `news_tag` VALUES ('NEWS0224', 'TAG0145');
INSERT INTO `news_tag` VALUES ('NEWS0224', 'TAG0023');
INSERT INTO `news_tag` VALUES ('NEWS0225', 'TAG0141');
INSERT INTO `news_tag` VALUES ('NEWS0225', 'TAG0049');
INSERT INTO `news_tag` VALUES ('NEWS0225', 'TAG0113');
INSERT INTO `news_tag` VALUES ('NEWS0225', 'TAG0001');
INSERT INTO `news_tag` VALUES ('NEWS0225', 'TAG0024');
INSERT INTO `news_tag` VALUES ('NEWS0226', 'TAG0069');
INSERT INTO `news_tag` VALUES ('NEWS0226', 'TAG0028');
INSERT INTO `news_tag` VALUES ('NEWS0226', 'TAG0053');
INSERT INTO `news_tag` VALUES ('NEWS0226', 'TAG0102');
INSERT INTO `news_tag` VALUES ('NEWS0226', 'TAG0132');
INSERT INTO `news_tag` VALUES ('NEWS0227', 'TAG0104');
INSERT INTO `news_tag` VALUES ('NEWS0227', 'TAG0103');
INSERT INTO `news_tag` VALUES ('NEWS0227', 'TAG0014');
INSERT INTO `news_tag` VALUES ('NEWS0227', 'TAG0139');
INSERT INTO `news_tag` VALUES ('NEWS0227', 'TAG0124');
INSERT INTO `news_tag` VALUES ('NEWS0228', 'TAG0131');
INSERT INTO `news_tag` VALUES ('NEWS0228', 'TAG0141');
INSERT INTO `news_tag` VALUES ('NEWS0228', 'TAG0140');
INSERT INTO `news_tag` VALUES ('NEWS0228', 'TAG0019');
INSERT INTO `news_tag` VALUES ('NEWS0228', 'TAG0084');
INSERT INTO `news_tag` VALUES ('NEWS0229', 'TAG0082');
INSERT INTO `news_tag` VALUES ('NEWS0229', 'TAG0109');
INSERT INTO `news_tag` VALUES ('NEWS0229', 'TAG0113');
INSERT INTO `news_tag` VALUES ('NEWS0229', 'TAG0124');
INSERT INTO `news_tag` VALUES ('NEWS0229', 'TAG0121');
INSERT INTO `news_tag` VALUES ('NEWS0230', 'TAG0141');
INSERT INTO `news_tag` VALUES ('NEWS0230', 'TAG0106');
INSERT INTO `news_tag` VALUES ('NEWS0230', 'TAG0039');
INSERT INTO `news_tag` VALUES ('NEWS0230', 'TAG0011');
INSERT INTO `news_tag` VALUES ('NEWS0230', 'TAG0028');
INSERT INTO `news_tag` VALUES ('NEWS0231', 'TAG0097');
INSERT INTO `news_tag` VALUES ('NEWS0231', 'TAG0013');
INSERT INTO `news_tag` VALUES ('NEWS0231', 'TAG0135');
INSERT INTO `news_tag` VALUES ('NEWS0231', 'TAG0095');
INSERT INTO `news_tag` VALUES ('NEWS0231', 'TAG0121');
INSERT INTO `news_tag` VALUES ('NEWS0232', 'TAG0094');
INSERT INTO `news_tag` VALUES ('NEWS0232', 'TAG0038');
INSERT INTO `news_tag` VALUES ('NEWS0232', 'TAG0080');
INSERT INTO `news_tag` VALUES ('NEWS0232', 'TAG0044');
INSERT INTO `news_tag` VALUES ('NEWS0232', 'TAG0032');
INSERT INTO `news_tag` VALUES ('NEWS0233', 'TAG0030');
INSERT INTO `news_tag` VALUES ('NEWS0233', 'TAG0083');
INSERT INTO `news_tag` VALUES ('NEWS0233', 'TAG0107');
INSERT INTO `news_tag` VALUES ('NEWS0233', 'TAG0115');
INSERT INTO `news_tag` VALUES ('NEWS0233', 'TAG0063');
INSERT INTO `news_tag` VALUES ('NEWS0234', 'TAG0091');
INSERT INTO `news_tag` VALUES ('NEWS0234', 'TAG0105');
INSERT INTO `news_tag` VALUES ('NEWS0234', 'TAG0124');
INSERT INTO `news_tag` VALUES ('NEWS0234', 'TAG0064');
INSERT INTO `news_tag` VALUES ('NEWS0234', 'TAG0012');
INSERT INTO `news_tag` VALUES ('NEWS0235', 'TAG0119');
INSERT INTO `news_tag` VALUES ('NEWS0235', 'TAG0147');
INSERT INTO `news_tag` VALUES ('NEWS0235', 'TAG0132');
INSERT INTO `news_tag` VALUES ('NEWS0235', 'TAG0032');
INSERT INTO `news_tag` VALUES ('NEWS0235', 'TAG0033');

-- ----------------------------
-- Table structure for status_of_news
-- ----------------------------
DROP TABLE IF EXISTS `status_of_news`;
CREATE TABLE `status_of_news`  (
  `Id_Status` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Title_Status` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  PRIMARY KEY (`Id_Status`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of status_of_news
-- ----------------------------
INSERT INTO `status_of_news` VALUES ('STS0001', 'Chưa duyệt');
INSERT INTO `status_of_news` VALUES ('STS0002', 'Chưa đạt');
INSERT INTO `status_of_news` VALUES ('STS0003', 'Từ chối');
INSERT INTO `status_of_news` VALUES ('STS0004', 'Đồng ý');
INSERT INTO `status_of_news` VALUES ('STS0005', 'Đã xoá');

-- ----------------------------
-- Table structure for subcategory
-- ----------------------------
DROP TABLE IF EXISTS `subcategory`;
CREATE TABLE `subcategory`  (
  `Id_SubCategory` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Id_Category` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `Name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`Id_SubCategory`) USING BTREE,
  INDEX `Id_Category`(`Id_Category` ASC) USING BTREE,
  CONSTRAINT `subcategory_ibfk_1` FOREIGN KEY (`Id_Category`) REFERENCES `category` (`Id_Category`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of subcategory
-- ----------------------------
INSERT INTO `subcategory` VALUES ('SUB0001', 'CAT0001', 'Chính trị');
INSERT INTO `subcategory` VALUES ('SUB0002', 'CAT0001', 'Xã hội');
INSERT INTO `subcategory` VALUES ('SUB0003', 'CAT0001', 'Kinh tế');
INSERT INTO `subcategory` VALUES ('SUB0004', 'CAT0001', 'Văn hóa');
INSERT INTO `subcategory` VALUES ('SUB0005', 'CAT0002', 'Doanh nghiệp');
INSERT INTO `subcategory` VALUES ('SUB0006', 'CAT0002', 'Tài chính');
INSERT INTO `subcategory` VALUES ('SUB0007', 'CAT0002', 'Thị trường');
INSERT INTO `subcategory` VALUES ('SUB0008', 'CAT0002', 'Khởi nghiệp');
INSERT INTO `subcategory` VALUES ('SUB0009', 'CAT0003', 'Công nghệ');
INSERT INTO `subcategory` VALUES ('SUB0010', 'CAT0003', 'Vũ trụ');
INSERT INTO `subcategory` VALUES ('SUB0011', 'CAT0003', 'Sinh học');
INSERT INTO `subcategory` VALUES ('SUB0012', 'CAT0003', 'Môi trường');
INSERT INTO `subcategory` VALUES ('SUB0013', 'CAT0004', 'Bóng đá');
INSERT INTO `subcategory` VALUES ('SUB0014', 'CAT0004', 'Bóng chuyền');
INSERT INTO `subcategory` VALUES ('SUB0015', 'CAT0004', 'Điền kinh');
INSERT INTO `subcategory` VALUES ('SUB0016', 'CAT0004', 'Cầu lông');
INSERT INTO `subcategory` VALUES ('SUB0017', 'CAT0005', 'Học bổng');
INSERT INTO `subcategory` VALUES ('SUB0018', 'CAT0005', 'Tuyển sinh');
INSERT INTO `subcategory` VALUES ('SUB0019', 'CAT0005', 'Đào tạo');
INSERT INTO `subcategory` VALUES ('SUB0020', 'CAT0005', 'Nghiên cứu');
INSERT INTO `subcategory` VALUES ('SUB0021', 'CAT0006', 'Gia đình');
INSERT INTO `subcategory` VALUES ('SUB0022', 'CAT0006', 'Sức khỏe');
INSERT INTO `subcategory` VALUES ('SUB0023', 'CAT0006', 'Làm đẹp');
INSERT INTO `subcategory` VALUES ('SUB0024', 'CAT0006', 'Tâm sự');
INSERT INTO `subcategory` VALUES ('SUB0025', 'CAT0007', 'Châu Á');
INSERT INTO `subcategory` VALUES ('SUB0026', 'CAT0007', 'Châu Âu');
INSERT INTO `subcategory` VALUES ('SUB0027', 'CAT0007', 'Châu Mỹ');
INSERT INTO `subcategory` VALUES ('SUB0028', 'CAT0007', 'Châu Phi');
INSERT INTO `subcategory` VALUES ('SUB0029', 'CAT0008', 'Nhà ở');
INSERT INTO `subcategory` VALUES ('SUB0030', 'CAT0008', 'Văn phòng');
INSERT INTO `subcategory` VALUES ('SUB0031', 'CAT0008', 'Đầu tư');
INSERT INTO `subcategory` VALUES ('SUB0032', 'CAT0008', 'Pháp lý');
INSERT INTO `subcategory` VALUES ('SUB0033', 'CAT0009', 'Phim ảnh');
INSERT INTO `subcategory` VALUES ('SUB0034', 'CAT0009', 'Ca nhạc');
INSERT INTO `subcategory` VALUES ('SUB0035', 'CAT0009', 'Gameshow');
INSERT INTO `subcategory` VALUES ('SUB0036', 'CAT0009', 'Sân khấu');
INSERT INTO `subcategory` VALUES ('SUB0037', 'CAT0010', 'Hình sự');
INSERT INTO `subcategory` VALUES ('SUB0038', 'CAT0010', 'Dân sự');
INSERT INTO `subcategory` VALUES ('SUB0039', 'CAT0010', 'Lao động');
INSERT INTO `subcategory` VALUES ('SUB0040', 'CAT0010', 'Kinh tế');
INSERT INTO `subcategory` VALUES ('SUB0041', 'CAT0011', 'Dinh dưỡng');
INSERT INTO `subcategory` VALUES ('SUB0042', 'CAT0011', 'Bệnh lý');
INSERT INTO `subcategory` VALUES ('SUB0043', 'CAT0011', 'Tập luyện');
INSERT INTO `subcategory` VALUES ('SUB0044', 'CAT0011', 'Tâm lý');
INSERT INTO `subcategory` VALUES ('SUB0045', 'CAT0012', 'Trong nước');
INSERT INTO `subcategory` VALUES ('SUB0046', 'CAT0012', 'Quốc tế');
INSERT INTO `subcategory` VALUES ('SUB0047', 'CAT0012', 'Ẩm thực');
INSERT INTO `subcategory` VALUES ('SUB0048', 'CAT0012', 'Văn hóa');

-- ----------------------------
-- Table structure for subcriber
-- ----------------------------
DROP TABLE IF EXISTS `subcriber`;
CREATE TABLE `subcriber`  (
  `Id_Subcriber` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Id_User` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Date_register` datetime NOT NULL,
  `Date_expired` datetime NULL DEFAULT NULL,
  `Request` bit(1) NULL DEFAULT b'0',
  PRIMARY KEY (`Id_Subcriber`) USING BTREE,
  UNIQUE INDEX `Id_User`(`Id_User` ASC) USING BTREE,
  CONSTRAINT `subcriber_ibfk_1` FOREIGN KEY (`Id_User`) REFERENCES `user` (`Id_User`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of subcriber
-- ----------------------------
INSERT INTO `subcriber` VALUES ('SUBC0001', 'USR0021', '2024-01-01 00:00:00', '2025-01-08 00:00:00', b'0');

-- ----------------------------
-- Table structure for tag
-- ----------------------------
DROP TABLE IF EXISTS `tag`;
CREATE TABLE `tag`  (
  `Id_Tag` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Status` bit(1) NOT NULL,
  PRIMARY KEY (`Id_Tag`) USING BTREE,
  FULLTEXT INDEX `Name`(`Name`)
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of tag
-- ----------------------------
INSERT INTO `tag` VALUES ('TAG0001', '#Chính trị', b'1');
INSERT INTO `tag` VALUES ('TAG0002', '#Kinh tế', b'1');
INSERT INTO `tag` VALUES ('TAG0003', '#Thể thao', b'1');
INSERT INTO `tag` VALUES ('TAG0004', '#Giáo dục', b'1');
INSERT INTO `tag` VALUES ('TAG0005', '#Công nghệ', b'1');
INSERT INTO `tag` VALUES ('TAG0006', '#Bóng đá', b'1');
INSERT INTO `tag` VALUES ('TAG0007', '#Thời sự', b'1');
INSERT INTO `tag` VALUES ('TAG0008', '#Du lịch', b'1');
INSERT INTO `tag` VALUES ('TAG0009', '#Văn hóa', b'1');
INSERT INTO `tag` VALUES ('TAG0010', '#Giải trí', b'1');
INSERT INTO `tag` VALUES ('TAG0011', '#Khoa học', b'1');
INSERT INTO `tag` VALUES ('TAG0012', '#Y tế', b'1');
INSERT INTO `tag` VALUES ('TAG0013', '#Môi trường', b'1');
INSERT INTO `tag` VALUES ('TAG0014', '#Xã hội', b'1');
INSERT INTO `tag` VALUES ('TAG0015', '#Pháp luật', b'1');
INSERT INTO `tag` VALUES ('TAG0016', '#Đời sống', b'1');
INSERT INTO `tag` VALUES ('TAG0017', '#Kinh doanh', b'1');
INSERT INTO `tag` VALUES ('TAG0018', '#Quốc tế', b'1');
INSERT INTO `tag` VALUES ('TAG0019', '#Nghệ thuật', b'1');
INSERT INTO `tag` VALUES ('TAG0020', '#Âm nhạc', b'1');
INSERT INTO `tag` VALUES ('TAG0021', '#Điện ảnh', b'1');
INSERT INTO `tag` VALUES ('TAG0022', '#Game', b'1');
INSERT INTO `tag` VALUES ('TAG0023', '#Sách', b'1');
INSERT INTO `tag` VALUES ('TAG0024', '#Ẩm thực', b'1');
INSERT INTO `tag` VALUES ('TAG0025', '#Thời trang', b'1');
INSERT INTO `tag` VALUES ('TAG0026', '#Công nghiệp', b'1');
INSERT INTO `tag` VALUES ('TAG0027', '#Nông nghiệp', b'1');
INSERT INTO `tag` VALUES ('TAG0028', '#Giao thông', b'1');
INSERT INTO `tag` VALUES ('TAG0029', '#Bất động sản', b'1');
INSERT INTO `tag` VALUES ('TAG0030', '#Tài chính', b'1');
INSERT INTO `tag` VALUES ('TAG0031', '#Chứng khoán', b'1');
INSERT INTO `tag` VALUES ('TAG0032', '#Tiền tệ', b'1');
INSERT INTO `tag` VALUES ('TAG0033', '#Xuất nhập khẩu', b'1');
INSERT INTO `tag` VALUES ('TAG0034', '#Lao động', b'1');
INSERT INTO `tag` VALUES ('TAG0035', '#Việc làm', b'1');
INSERT INTO `tag` VALUES ('TAG0036', '#Khởi nghiệp', b'1');
INSERT INTO `tag` VALUES ('TAG0037', '#Đổi mới', b'1');
INSERT INTO `tag` VALUES ('TAG0038', '#Sáng tạo', b'1');
INSERT INTO `tag` VALUES ('TAG0039', '#An ninh', b'1');
INSERT INTO `tag` VALUES ('TAG0040', '#Quốc phòng', b'1');
INSERT INTO `tag` VALUES ('TAG0041', '#Biển đảo', b'1');
INSERT INTO `tag` VALUES ('TAG0042', '#Ngoại giao', b'1');
INSERT INTO `tag` VALUES ('TAG0043', '#Hợp tác', b'1');
INSERT INTO `tag` VALUES ('TAG0044', '#Phát triển', b'1');
INSERT INTO `tag` VALUES ('TAG0045', '#Đầu tư', b'1');
INSERT INTO `tag` VALUES ('TAG0046', '#Thương mại', b'1');
INSERT INTO `tag` VALUES ('TAG0047', '#Dịch vụ', b'1');
INSERT INTO `tag` VALUES ('TAG0048', '#Truyền thông', b'1');
INSERT INTO `tag` VALUES ('TAG0049', '#Báo chí', b'1');
INSERT INTO `tag` VALUES ('TAG0050', '#Mạng xã hội', b'1');
INSERT INTO `tag` VALUES ('TAG0051', '#Trí tuệ nhân tạo', b'1');
INSERT INTO `tag` VALUES ('TAG0052', '#Học máy', b'1');
INSERT INTO `tag` VALUES ('TAG0053', '#Người máy', b'1');
INSERT INTO `tag` VALUES ('TAG0054', '#Internet vạn vật', b'1');
INSERT INTO `tag` VALUES ('TAG0055', '#Điện toán đám mây', b'1');
INSERT INTO `tag` VALUES ('TAG0056', '#An ninh mạng', b'1');
INSERT INTO `tag` VALUES ('TAG0057', '#Dữ liệu lớn', b'1');
INSERT INTO `tag` VALUES ('TAG0058', '#Khởi nghiệp sáng tạo', b'1');
INSERT INTO `tag` VALUES ('TAG0059', '#Công nghệ tài chính', b'1');
INSERT INTO `tag` VALUES ('TAG0060', '#Thương mại điện tử', b'1');
INSERT INTO `tag` VALUES ('TAG0061', '#Tiếp thị số', b'1');
INSERT INTO `tag` VALUES ('TAG0062', '#Tối ưu công cụ tìm kiếm', b'1');
INSERT INTO `tag` VALUES ('TAG0063', '#Ứng dụng di động', b'1');
INSERT INTO `tag` VALUES ('TAG0064', '#Phát triển web', b'1');
INSERT INTO `tag` VALUES ('TAG0065', '#Thiết kế trải nghiệm', b'1');
INSERT INTO `tag` VALUES ('TAG0066', '#Khoa học dữ liệu', b'1');
INSERT INTO `tag` VALUES ('TAG0067', '#Thực tế ảo', b'1');
INSERT INTO `tag` VALUES ('TAG0068', '#Thực tế tăng cường', b'1');
INSERT INTO `tag` VALUES ('TAG0069', '#Tiền điện tử', b'1');
INSERT INTO `tag` VALUES ('TAG0070', '#Thành phố thông minh', b'1');
INSERT INTO `tag` VALUES ('TAG0071', '#Năng lượng tái tạo', b'1');
INSERT INTO `tag` VALUES ('TAG0072', '#Năng lượng mặt trời', b'1');
INSERT INTO `tag` VALUES ('TAG0073', '#Năng lượng gió', b'1');
INSERT INTO `tag` VALUES ('TAG0074', '#Xe điện', b'1');
INSERT INTO `tag` VALUES ('TAG0075', '#Biến đổi khí hậu', b'1');
INSERT INTO `tag` VALUES ('TAG0076', '#Phát triển bền vững', b'1');
INSERT INTO `tag` VALUES ('TAG0077', '#Công nghệ xanh', b'1');
INSERT INTO `tag` VALUES ('TAG0078', '#Quản lý rác thải', b'1');
INSERT INTO `tag` VALUES ('TAG0079', '#Tái chế', b'1');
INSERT INTO `tag` VALUES ('TAG0080', '#Đa dạng sinh học', b'1');
INSERT INTO `tag` VALUES ('TAG0081', '#Bảo tồn đại dương', b'1');
INSERT INTO `tag` VALUES ('TAG0082', '#Bảo vệ động vật hoang dã', b'1');
INSERT INTO `tag` VALUES ('TAG0083', '#Nông nghiệp hữu cơ', b'1');
INSERT INTO `tag` VALUES ('TAG0084', '#Nông nghiệp thông minh', b'1');
INSERT INTO `tag` VALUES ('TAG0085', '#An ninh lương thực', b'1');
INSERT INTO `tag` VALUES ('TAG0086', '#Công nghệ y tế', b'1');
INSERT INTO `tag` VALUES ('TAG0087', '#Khám bệnh từ xa', b'1');
INSERT INTO `tag` VALUES ('TAG0088', '#Sức khỏe tâm thần', b'1');
INSERT INTO `tag` VALUES ('TAG0089', '#Sống khỏe', b'1');
INSERT INTO `tag` VALUES ('TAG0090', '#Thể hình', b'1');
INSERT INTO `tag` VALUES ('TAG0091', '#Dinh dưỡng', b'1');
INSERT INTO `tag` VALUES ('TAG0092', '#Y học cổ truyền', b'1');
INSERT INTO `tag` VALUES ('TAG0093', '#Thiền định', b'1');
INSERT INTO `tag` VALUES ('TAG0094', '#Phát triển bản thân', b'1');
INSERT INTO `tag` VALUES ('TAG0095', '#Lãnh đạo', b'1');
INSERT INTO `tag` VALUES ('TAG0096', '#Quản lý', b'1');
INSERT INTO `tag` VALUES ('TAG0097', '#Nhân sự', b'1');
INSERT INTO `tag` VALUES ('TAG0098', '#Làm việc từ xa', b'1');
INSERT INTO `tag` VALUES ('TAG0099', '#Cân bằng cuộc sống', b'1');
INSERT INTO `tag` VALUES ('TAG0100', '#Phát triển nghề nghiệp', b'1');
INSERT INTO `tag` VALUES ('TAG0101', '#Kỹ năng chuyên môn', b'1');
INSERT INTO `tag` VALUES ('TAG0102', '#Kỹ năng mềm', b'1');
INSERT INTO `tag` VALUES ('TAG0103', '#Giao tiếp', b'1');
INSERT INTO `tag` VALUES ('TAG0104', '#Xây dựng đội nhóm', b'1');
INSERT INTO `tag` VALUES ('TAG0105', '#Quản lý dự án', b'1');
INSERT INTO `tag` VALUES ('TAG0106', '#Quản lý chất lượng', b'1');
INSERT INTO `tag` VALUES ('TAG0107', '#Quản lý rủi ro', b'1');
INSERT INTO `tag` VALUES ('TAG0108', '#Chuỗi cung ứng', b'1');
INSERT INTO `tag` VALUES ('TAG0109', '#Vận tải logistics', b'1');
INSERT INTO `tag` VALUES ('TAG0110', '#Nghiên cứu thị trường', b'1');
INSERT INTO `tag` VALUES ('TAG0111', '#Quản lý thương hiệu', b'1');
INSERT INTO `tag` VALUES ('TAG0112', '#Trải nghiệm khách hàng', b'1');
INSERT INTO `tag` VALUES ('TAG0113', '#Chiến lược bán hàng', b'1');
INSERT INTO `tag` VALUES ('TAG0114', '#Học trực tuyến', b'1');
INSERT INTO `tag` VALUES ('TAG0115', '#Giáo dục từ xa', b'1');
INSERT INTO `tag` VALUES ('TAG0116', '#Giáo dục STEM', b'1');
INSERT INTO `tag` VALUES ('TAG0117', '#Học ngoại ngữ', b'1');
INSERT INTO `tag` VALUES ('TAG0118', '#Giáo dục mầm non', b'1');
INSERT INTO `tag` VALUES ('TAG0119', '#Giáo dục đại học', b'1');
INSERT INTO `tag` VALUES ('TAG0120', '#Đào tạo nghề', b'1');
INSERT INTO `tag` VALUES ('TAG0121', '#Giáo dục người lớn', b'1');
INSERT INTO `tag` VALUES ('TAG0122', '#Giáo dục đặc biệt', b'1');
INSERT INTO `tag` VALUES ('TAG0123', '#Công nghệ giáo dục', b'1');
INSERT INTO `tag` VALUES ('TAG0124', '#Phương pháp nghiên cứu', b'1');
INSERT INTO `tag` VALUES ('TAG0125', '#Kỹ năng học tập', b'1');
INSERT INTO `tag` VALUES ('TAG0126', '#Đời sống sinh viên', b'1');
INSERT INTO `tag` VALUES ('TAG0127', '#Văn hóa học đường', b'1');
INSERT INTO `tag` VALUES ('TAG0128', '#Cựu sinh viên', b'1');
INSERT INTO `tag` VALUES ('TAG0129', '#Quản lý trường học', b'1');
INSERT INTO `tag` VALUES ('TAG0130', '#Chính sách giáo dục', b'1');
INSERT INTO `tag` VALUES ('TAG0131', '#Phát triển chương trình', b'1');
INSERT INTO `tag` VALUES ('TAG0132', '#Phương pháp giảng dạy', b'1');
INSERT INTO `tag` VALUES ('TAG0133', '#Đánh giá giáo dục', b'1');
INSERT INTO `tag` VALUES ('TAG0134', '#Phân tích học tập', b'1');
INSERT INTO `tag` VALUES ('TAG0135', '#Tâm lý giáo dục', b'1');
INSERT INTO `tag` VALUES ('TAG0136', '#Phát triển trẻ em', b'1');
INSERT INTO `tag` VALUES ('TAG0137', '#Nuôi dạy con', b'1');
INSERT INTO `tag` VALUES ('TAG0138', '#Đời sống gia đình', b'1');
INSERT INTO `tag` VALUES ('TAG0139', '#Quan hệ xã hội', b'1');
INSERT INTO `tag` VALUES ('TAG0140', '#Hôn nhân', b'1');
INSERT INTO `tag` VALUES ('TAG0141', '#Hẹn hò', b'1');
INSERT INTO `tag` VALUES ('TAG0142', '#Phong cách sống', b'1');
INSERT INTO `tag` VALUES ('TAG0143', '#Sở thích', b'1');
INSERT INTO `tag` VALUES ('TAG0144', '#Du lịch khám phá', b'1');
INSERT INTO `tag` VALUES ('TAG0145', '#Ẩm thực vùng miền', b'1');
INSERT INTO `tag` VALUES ('TAG0146', '#Văn hóa dân tộc', b'1');
INSERT INTO `tag` VALUES ('TAG0147', '#Lễ hội truyền thống', b'1');
INSERT INTO `tag` VALUES ('TAG0148', '#Di sản văn hóa', b'1');
INSERT INTO `tag` VALUES ('TAG0149', '#Nghệ thuật dân gian', b'1');
INSERT INTO `tag` VALUES ('TAG0150', '#Làng nghề truyền thống', b'1');

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `Id_User` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `Birthday` date NOT NULL,
  `Email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Date_register` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`Id_User`, `Email`) USING BTREE,
  UNIQUE INDEX `Email`(`Email` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES ('USR0000', 'Default', '1990-01-01', 'default@example.com', '$2a$10$8yrEB/ruk0r7j6ONWhCJtOnwBGPYC0zJD91Bn9u4TE3oHGAVeI.cq', NULL);
INSERT INTO `user` VALUES ('USR0001', 'Công Thuận', '1990-01-01', 'jozz111hn.doe@example.com', '$2a$10$8yrEB/ruk0r7j6ONWhCJtOnwBGPYC0zJD91Bn9u4TE3oHGAVeI.cq', '2024-12-08 10:30:00');
INSERT INTO `user` VALUES ('USR0002', 'Minh Thư', '1995-05-05', 'janq222e.smith@example.com', '$2a$10$8yrEB/ruk0r7j6ONWhCJtOnwBGPYC0zJD91Bn9u4TE3oHGAVeI.cq', '2024-12-08 10:30:00');
INSERT INTO `user` VALUES ('USR0003', 'Phương Huy', '1988-08-08', 'mikq33e.brown@example.com', '$2a$10$8yrEB/ruk0r7j6ONWhCJtOnwBGPYC0zJD91Bn9u4TE3oHGAVeI.cq', '2024-12-08 10:30:00');
INSERT INTO `user` VALUES ('USR0004', 'Duy Trì', '1992-02-02', 'emaily44.davis@example.com', '$2a$10$8yrEB/ruk0r7j6ONWhCJtOnwBGPYC0zJD91Bn9u4TE3oHGAVeI.cq', '2024-12-08 10:30:00');
INSERT INTO `user` VALUES ('USR0005', 'Minh Louis', '1990-01-01', 'jd56ohn.doe@example.com', '$2a$10$8yrEB/ruk0r7j6ONWhCJtOnwBGPYC0zJD91Bn9u4TE3oHGAVeI.cq', '2024-12-08 10:30:00');
INSERT INTO `user` VALUES ('USR0006', 'Ngọc Vân', '1995-05-05', 'jafne.smith@example.com', '$2a$10$8yrEB/ruk0r7j6ONWhCJtOnwBGPYC0zJD91Bn9u4TE3oHGAVeI.cq', '2024-12-08 10:30:00');
INSERT INTO `user` VALUES ('USR0007', 'Cá sấu', '1988-08-08', 'minske.brown@example.com', '$2a$10$8yrEB/ruk0r7j6ONWhCJtOnwBGPYC0zJD91Bn9u4TE3oHGAVeI.cq', '2024-12-08 10:30:00');
INSERT INTO `user` VALUES ('USR0008', 'Thỏ 7 màu', '1992-02-02', 'emil33by.davis@example.com', '$2a$10$8yrEB/ruk0r7j6ONWhCJtOnwBGPYC0zJD91Bn9u4TE3oHGAVeI.cq', '2024-12-08 10:30:00');
INSERT INTO `user` VALUES ('USR0009', 'Gia Định', '1992-02-02', 'emi33333vly.davis@example.com', '$2a$10$8yrEB/ruk0r7j6ONWhCJtOnwBGPYC0zJD91Bn9u4TE3oHGAVeI.cq', '2024-12-08 10:30:00');
INSERT INTO `user` VALUES ('USR0010', 'Riverside', '1992-02-02', 'emivggly.davis@example.com', '$2a$10$8yrEB/ruk0r7j6ONWhCJtOnwBGPYC0zJD91Bn9u4TE3oHGAVeI.cq', '2024-12-08 10:30:00');
INSERT INTO `user` VALUES ('USR0011', 'Bcon Plaza', '1992-02-02', 'emilngfcy.davis@example.com', '$2a$10$8yrEB/ruk0r7j6ONWhCJtOnwBGPYC0zJD91Bn9u4TE3oHGAVeI.cq', '2024-12-08 10:30:00');
INSERT INTO `user` VALUES ('USR0012', 'Nguyễn Văn A', '1993-03-03', 'nguyenvana@example.com', '$2a$10$8yrEB/ruk0r7j6ONWhCJtOnwBGPYC0zJD91Bn9u4TE3oHGAVeI.cq', '2024-12-08 10:30:00');
INSERT INTO `user` VALUES ('USR0013', 'Trần Thị B', '1994-04-04', 'tranthib@example.com', '$2a$10$8yrEB/ruk0r7j6ONWhCJtOnwBGPYC0zJD91Bn9u4TE3oHGAVeI.cq', '2024-12-08 10:30:00');
INSERT INTO `user` VALUES ('USR0014', 'Lê Văn C', '1991-01-01', 'levanc@example.com', '$2a$10$8yrEB/ruk0r7j6ONWhCJtOnwBGPYC0zJD91Bn9u4TE3oHGAVeI.cq', '2024-12-08 10:30:00');
INSERT INTO `user` VALUES ('USR0015', 'Phạm Thị D', '1990-02-02', 'phamthid@example.com', '$2a$10$8yrEB/ruk0r7j6ONWhCJtOnwBGPYC0zJD91Bn9u4TE3oHGAVeI.cq', '2024-12-08 10:30:00');
INSERT INTO `user` VALUES ('USR0016', 'Đỗ Văn E', '1989-05-05', 'dovanE@example.com', '$2a$10$8yrEB/ruk0r7j6ONWhCJtOnwBGPYC0zJD91Bn9u4TE3oHGAVeI.cq', '2024-12-08 10:30:00');
INSERT INTO `user` VALUES ('USR0017', 'Nguyễn Thị F', '1995-06-06', 'nguyenthif@example.com', '$2a$10$8yrEB/ruk0r7j6ONWhCJtOnwBGPYC0zJD91Bn9u4TE3oHGAVeI.cq', '2024-12-08 10:30:00');
INSERT INTO `user` VALUES ('USR0018', 'Trần Văn G', '1992-07-07', 'tranvang@example.com', '$2a$10$8yrEB/ruk0r7j6ONWhCJtOnwBGPYC0zJD91Bn9u4TE3oHGAVeI.cq', '2024-12-08 10:30:00');
INSERT INTO `user` VALUES ('USR0019', 'Lê Thị H', '1993-08-08', 'lethih@example.com', '$2a$10$8yrEB/ruk0r7j6ONWhCJtOnwBGPYC0zJD91Bn9u4TE3oHGAVeI.cq', '2024-12-08 10:30:00');
INSERT INTO `user` VALUES ('USR0020', 'Phạm Văn I', '1994-09-09', 'phamvani@example.com', '$2a$10$8yrEB/ruk0r7j6ONWhCJtOnwBGPYC0zJD91Bn9u4TE3oHGAVeI.cq', '2024-12-08 10:30:00');
INSERT INTO `user` VALUES ('USR0021', 'Đỗ Thị J', '1991-10-10', 'dothij@example.com', '$2a$10$8yrEB/ruk0r7j6ONWhCJtOnwBGPYC0zJD91Bn9u4TE3oHGAVeI.cq', '2024-12-08 10:30:00');
INSERT INTO `user` VALUES ('USR0022', 'Luong Vi Minh', '1984-09-09', 'lvm@gmail.com', '$2a$10$8yrEB/ruk0r7j6ONWhCJtOnwBGPYC0zJD91Bn9u4TE3oHGAVeI.cq', '2024-12-08 10:30:00');

-- ----------------------------
-- Table structure for writer
-- ----------------------------
DROP TABLE IF EXISTS `writer`;
CREATE TABLE `writer`  (
  `Id_Writer` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Id_User` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Pen_Name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `Id_Category` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`Id_Writer`) USING BTREE,
  UNIQUE INDEX `Id_User`(`Id_User` ASC) USING BTREE,
  INDEX `Id_Category`(`Id_Category` ASC) USING BTREE,
  CONSTRAINT `writer_ibfk_1` FOREIGN KEY (`Id_User`) REFERENCES `user` (`Id_User`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `writer_ibfk_2` FOREIGN KEY (`Id_Category`) REFERENCES `category` (`Id_Category`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of writer
-- ----------------------------
INSERT INTO `writer` VALUES ('DEFAULT', 'USR0000', 'Pen_Name_Default', 'CAT0000');
INSERT INTO `writer` VALUES ('WRT0001', 'USR0006', 'Mị Châu MC', 'CAT0001');
INSERT INTO `writer` VALUES ('WRT0002', 'USR0007', 'Tôn Hoàng Gold', 'CAT0001');
INSERT INTO `writer` VALUES ('WRT0003', 'USR0008', 'Sơn blog', 'CAT0001');
INSERT INTO `writer` VALUES ('WRT0004', 'USR0009', 'Tùng TV', 'CAT0001');
INSERT INTO `writer` VALUES ('WRT0005', 'USR0010', 'Anh Nông Thôn', 'CAT0002');
INSERT INTO `writer` VALUES ('WRT0006', 'USR0011', 'Vân Sắc', 'CAT0003');
INSERT INTO `writer` VALUES ('WRT0007', 'USR0012', 'Lã Vy', 'CAT0004');
INSERT INTO `writer` VALUES ('WRT0008', 'USR0013', 'NgoVanThang', 'CAT0005');
INSERT INTO `writer` VALUES ('WRT0009', 'USR0014', 'MCK-Key', 'CAT0006');
INSERT INTO `writer` VALUES ('WRT0010', 'USR0015', 'IG Tuấn', 'CAT0007');
INSERT INTO `writer` VALUES ('WRT0011', 'USR0016', 'Hảng Hôn', 'CAT0008');
INSERT INTO `writer` VALUES ('WRT0012', 'USR0017', 'Đom đóm', 'CAT0009');
INSERT INTO `writer` VALUES ('WRT0013', 'USR0018', 'Ben Tree', 'CAT0010');
INSERT INTO `writer` VALUES ('WRT0014', 'USR0019', 'Ngô Tú', 'CAT0011');
INSERT INTO `writer` VALUES ('WRT0015', 'USR0020', 'Jelly Lê', 'CAT0012');

-- ----------------------------
-- Triggers structure for table editor
-- ----------------------------
DROP TRIGGER IF EXISTS `Before_Delete_Editor`;
delimiter ;;
CREATE TRIGGER `Before_Delete_Editor` BEFORE DELETE ON `editor` FOR EACH ROW BEGIN
    UPDATE Editor_Check_News
    SET Id_Editor = 'DEFAULT'
    WHERE Id_Editor = OLD.Id_Editor;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table news
-- ----------------------------
DROP TRIGGER IF EXISTS `After_News_Delete`;
delimiter ;;
CREATE TRIGGER `After_News_Delete` AFTER DELETE ON `news` FOR EACH ROW BEGIN
    INSERT INTO List_Deleted_News (
        Id_SubCategory,
        Id_Writer,
        Id_Status,
        Id_News,
        Date,
        Comments,
        Premium,
        Views,
        Content,
        Image,
        Title,
        Meta_title,
        Meta_description
    )
    VALUES (
        OLD.Id_SubCategory,
        OLD.Id_Writer,
        'STS0005',
        OLD.Id_News,
        OLD.Date,
        OLD.Comments,
        OLD.Premium,
        OLD.Views,
        OLD.Content,
        OLD.Image,
        OLD.Title,
        OLD.Meta_title,
        OLD.Meta_description
    );
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table subcriber
-- ----------------------------
DROP TRIGGER IF EXISTS `Before_Insert_Subcriber`;
delimiter ;;
CREATE TRIGGER `Before_Insert_Subcriber` BEFORE INSERT ON `subcriber` FOR EACH ROW BEGIN
    -- Nếu Date_expired không được cung cấp, tự động tính toán bằng cách thêm 7 ngày vào Date_register
    IF NEW.Date_expired IS NULL THEN
        SET NEW.Date_expired = DATE_ADD(NEW.Date_register, INTERVAL 7 DAY);
    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table writer
-- ----------------------------
DROP TRIGGER IF EXISTS `Before_Delete_Writer`;
delimiter ;;
CREATE TRIGGER `Before_Delete_Writer` BEFORE DELETE ON `writer` FOR EACH ROW BEGIN
    UPDATE News
    SET Id_Writer = 'DEFAULT'
    WHERE Id_Writer = OLD.Id_Writer;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
