-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th12 01, 2023 lúc 08:01 AM
-- Phiên bản máy phục vụ: 10.4.27-MariaDB
-- Phiên bản PHP: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `simbsc`
--
CREATE DATABASE IF NOT EXISTS `simbsc` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `simbsc`;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `borrow`
--

CREATE TABLE IF NOT EXISTS `borrow` (
  `student_id` int(11) NOT NULL,
  `document_id` int(11) NOT NULL,
  `borrow_date` date NOT NULL DEFAULT current_timestamp(),
  `return_date` int(11) DEFAULT NULL,
  KEY `student_id` (`student_id`),
  KEY `document_id` (`document_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `documents`
--

CREATE TABLE IF NOT EXISTS `documents` (
  `document_id` int(11) NOT NULL AUTO_INCREMENT,
  `doc_name` varchar(256) NOT NULL,
  `type` varchar(256) NOT NULL,
  `author` varchar(256) NOT NULL,
  `publisher` varchar(512) NOT NULL,
  `publish_year` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `text` varchar(2048) NOT NULL,
  `description` varchar(4096) NOT NULL,
  PRIMARY KEY (`document_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `documents`
--

INSERT INTO `documents` (`document_id`, `doc_name`, `type`, `author`, `publisher`, `publish_year`, `quantity`, `text`, `description`) VALUES
(1, 'Kiến trúc máy tính', 'Sách cơ sở ngành', 'Phạm Quốc Cường', 'NXB Đại học Quốc gia TPHCM', 2019, 1, 'Kiến trúc máy tính cũng là một trong các môn cơ sở ngành quan trọng, môn học đề cập tới cơ sở về kiến trúc tập lệnh và tổ chức của máy tính, các vấn đề cơ bản trong thiết kế máy tính. Ngoài ra các bạn còn được học cơ bản về ngôn ngữ lập trình gần gũi nhất với máy tính đó là Assembly (cụ thể là MIPS).', 'Chương I: ĐẠI CƯƠNG \\\\n Lịch sử phát triển của máy tính, thông tin và sự mã hoá thông tin \\\\n Chương II: KIẾN TRÚC PHẦN MỀM BỘ XỬ LÝ \\\\n Giới thiệu các thành phần cơ bản của một hệ thống máy tính, kiến trúc máy tính, tập lệnh và các kiểu định vị cơ bản. Khái niệm về kiến trúc RISC và CISC, ngôn ngữ cấp cao và ngôn ngữ máy.'),
(3, 'Cấu trúc dữ liệu và giải thuật', 'Sách cơ sở ngành', 'Nguyễn Trung Trực', 'NXB Đại học Quốc gia TPHCM', 2019, 1, 'Quyển sách Cấu trúc dữ liệu và Giải thuật trình bày cấu trúc dữ liệu tuyến tính (mảng, danh sách liên kết) và cấu trúc dữ liệu phi tuyến (cây, đồ thị) và các giải thuật của các cấu trúc dữ liệu này. Các cấu trúc dữ liệu và giải thuật được trình bày theo kiểu lập trình có cấu trúc (structured programming) (minh họa bằng ngôn ngữ lập trình C++) và theo kiểu lập trình hướng đối tượng (object-oriented programming) (minh họa bằng ngôn ngữ lập trình C#). Các phần phụ lục là các chương trình được viết theo kiểu lập trình tổng quát (generic programming). Quyển sách này bao gồm 12 chương và 9 phụ lục.', 'CHƯƠNG 1: TỔNG QUAN VỀ CẤU TRÚC DỮ LIỆU & GIẢI THUẬT   1.1. Tầm quan trọng của CTDL & GT trong một đề án tin học   1.2. Đánh giá Cấu trúc dữ liệu & Giải thuật   1.3. Kiểu dữ liệu   Câu hỏi và bài tập'),
(4, 'Kiến trúc máy tính', 'Sách cơ sở ngành', 'Phạm Quốc Cường', 'NXB Đại học Quốc gia TPHCM', 2019, 1, 'Kiến trúc máy tính cũng là một trong các môn cơ sở ngành quan trọng, môn học đề cập tới cơ sở về kiến trúc tập lệnh và tổ chức của máy tính, các vấn đề cơ bản trong thiết kế máy tính. Ngoài ra các bạn còn được học cơ bản về ngôn ngữ lập trình gần gũi nhất với máy tính đó là Assembly (cụ thể là MIPS).', 'Chương I: ĐẠI CƯƠNG \\n Lịch sử phát triển của máy tính, thông tin và sự mã hoá thông tin \\n Chương II: KIẾN TRÚC PHẦN MỀM BỘ XỬ LÝ \\n Giới thiệu các thành phần cơ bản của một hệ thống máy tính, kiến trúc máy tính, tập lệnh và các kiểu định vị cơ bản. Khái niệm về kiến trúc RISC và CISC, ngôn ngữ cấp cao và ngôn ngữ máy.'),
(5, 'Kiến trúc máy tính', 'Sách cơ sở ngành', 'Phạm Quốc Cường', 'NXB Đại học Quốc gia TPHCM', 2019, 1, 'Kiến trúc máy tính cũng là một trong các môn cơ sở ngành quan trọng, môn học đề cập tới cơ sở về kiến trúc tập lệnh và tổ chức của máy tính, các vấn đề cơ bản trong thiết kế máy tính. Ngoài ra các bạn còn được học cơ bản về ngôn ngữ lập trình gần gũi nhất với máy tính đó là Assembly (cụ thể là MIPS).', 'Chương I: ĐẠI CƯƠNG \\n Lịch sử phát triển của máy tính, thông tin và sự mã hoá thông tin \\n Chương II: KIẾN TRÚC PHẦN MỀM BỘ XỬ LÝ \\n Giới thiệu các thành phần cơ bản của một hệ thống máy tính, kiến trúc máy tính, tập lệnh và các kiểu định vị cơ bản. Khái niệm về kiến trúc RISC và CISC, ngôn ngữ cấp cao và ngôn ngữ máy.'),
(6, 'Kiến trúc máy tính', 'Sách cơ sở ngành', 'Phạm Quốc Cường', 'NXB Đại học Quốc gia TPHCM', 2019, 1, 'Kiến trúc máy tính cũng là một trong các môn cơ sở ngành quan trọng, môn học đề cập tới cơ sở về kiến trúc tập lệnh và tổ chức của máy tính, các vấn đề cơ bản trong thiết kế máy tính. Ngoài ra các bạn còn được học cơ bản về ngôn ngữ lập trình gần gũi nhất với máy tính đó là Assembly (cụ thể là MIPS).', 'Chương I: ĐẠI CƯƠNG \\n Lịch sử phát triển của máy tính, thông tin và sự mã hoá thông tin \\n Chương II: KIẾN TRÚC PHẦN MỀM BỘ XỬ LÝ \\n Giới thiệu các thành phần cơ bản của một hệ thống máy tính, kiến trúc máy tính, tập lệnh và các kiểu định vị cơ bản. Khái niệm về kiến trúc RISC và CISC, ngôn ngữ cấp cao và ngôn ngữ máy.'),
(7, 'Cấu trúc dữ liệu và giải thuật', 'Sách cơ sở ngành', 'Nguyễn Trung Trực', 'NXB Đại học Quốc gia TPHCM', 2019, 1, 'Quyển sách Cấu trúc dữ liệu và Giải thuật trình bày cấu trúc dữ liệu tuyến tính (mảng, danh sách liên kết) và cấu trúc dữ liệu phi tuyến (cây, đồ thị) và các giải thuật của các cấu trúc dữ liệu này. Các cấu trúc dữ liệu và giải thuật được trình bày theo kiểu lập trình có cấu trúc (structured programming) (minh họa bằng ngôn ngữ lập trình C++) và theo kiểu lập trình hướng đối tượng (object-oriented programming) (minh họa bằng ngôn ngữ lập trình C#). Các phần phụ lục là các chương trình được viết theo kiểu lập trình tổng quát (generic programming). Quyển sách này bao gồm 12 chương và 9 phụ lục.', 'CHƯƠNG 1: TỔNG QUAN VỀ CẤU TRÚC DỮ LIỆU & GIẢI THUẬT   1.1. Tầm quan trọng của CTDL & GT trong một đề án tin học   1.2. Đánh giá Cấu trúc dữ liệu & Giải thuật   1.3. Kiểu dữ liệu   Câu hỏi và bài tập'),
(8, 'Cấu trúc dữ liệu và giải thuật', 'Sách cơ sở ngành', 'Nguyễn Trung Trực', 'NXB Đại học Quốc gia TPHCM', 2019, 1, 'Quyển sách Cấu trúc dữ liệu và Giải thuật trình bày cấu trúc dữ liệu tuyến tính (mảng, danh sách liên kết) và cấu trúc dữ liệu phi tuyến (cây, đồ thị) và các giải thuật của các cấu trúc dữ liệu này. Các cấu trúc dữ liệu và giải thuật được trình bày theo kiểu lập trình có cấu trúc (structured programming) (minh họa bằng ngôn ngữ lập trình C++) và theo kiểu lập trình hướng đối tượng (object-oriented programming) (minh họa bằng ngôn ngữ lập trình C#). Các phần phụ lục là các chương trình được viết theo kiểu lập trình tổng quát (generic programming). Quyển sách này bao gồm 12 chương và 9 phụ lục.', 'CHƯƠNG 1: TỔNG QUAN VỀ CẤU TRÚC DỮ LIỆU & GIẢI THUẬT   1.1. Tầm quan trọng của CTDL & GT trong một đề án tin học   1.2. Đánh giá Cấu trúc dữ liệu & Giải thuật   1.3. Kiểu dữ liệu   Câu hỏi và bài tập'),
(9, 'Kiến trúc máy tính', 'Sách cơ sở ngành', 'Phạm Quốc Cường', 'NXB Đại học Quốc gia TPHCM', 2019, 1, 'Kiến trúc máy tính cũng là một trong các môn cơ sở ngành quan trọng, môn học đề cập tới cơ sở về kiến trúc tập lệnh và tổ chức của máy tính, các vấn đề cơ bản trong thiết kế máy tính. Ngoài ra các bạn còn được học cơ bản về ngôn ngữ lập trình gần gũi nhất với máy tính đó là Assembly (cụ thể là MIPS).', 'Chương I: ĐẠI CƯƠNG \\n Lịch sử phát triển của máy tính, thông tin và sự mã hoá thông tin \\n Chương II: KIẾN TRÚC PHẦN MỀM BỘ XỬ LÝ \\n Giới thiệu các thành phần cơ bản của một hệ thống máy tính, kiến trúc máy tính, tập lệnh và các kiểu định vị cơ bản. Khái niệm về kiến trúc RISC và CISC, ngôn ngữ cấp cao và ngôn ngữ máy.');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `members`
--

CREATE TABLE IF NOT EXISTS `members` (
  `student_id` int(11) NOT NULL,
  `student_name` varchar(255) NOT NULL,
  `email` varchar(127) NOT NULL,
  `password` varchar(127) NOT NULL,
  `state` varchar(127) NOT NULL,
  `join_date` date NOT NULL DEFAULT current_timestamp(),
  `permission` varchar(255) NOT NULL,
  PRIMARY KEY (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `members`
--

INSERT INTO `members` (`student_id`, `student_name`, `email`, `password`, `state`, `join_date`, `permission`) VALUES
(0, 'Trần Văn A', 'tranvanA@hcmut.edu.vn', 'tranvana', '', '2023-11-09', ''),
(1, 'a', 'abc', '###v', 'ok', '0000-00-00', 'A'),
(2, 'a', 'abc', '###v', 'ok', '2023-12-11', 'A'),
(2000000, 'Admin 1', 'abc@def.com', '$2b$10$UpVm2Pt389EY0anjTZAwIulqMNBSo3Wmqk8inN47l9ABQyk5XfWKK', 'Đang hoạt động', '2023-11-14', 'Thành viên ban chủ nhiệm'),
(2000001, 'Admin 2', 'abd@def.com', '$2b$10$ExtohTHcom1BvBpujafeQet/o8rMJNppbF4xQ8J8MbLE9eE3oilJO', 'Đang hoạt động', '2023-11-14', 'Thành viên ban chủ nhiệm'),
(2000002, 'Collab 1', 'abe@def.com', '$2b$10$E30b5YunGc0lJ1G7D/PrZenQXV.oeiHuNaCH2T/QLB6eX3J2DCLFe', 'Đang hoạt động', '2023-11-15', 'Cộng tác viên');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `requestborrow`
--

CREATE TABLE IF NOT EXISTS `requestborrow` (
  `student_id` int(11) NOT NULL,
  `document_id` int(11) NOT NULL,
  `request_day` date NOT NULL,
  `state` int(11) NOT NULL DEFAULT 0,
  `update_date` date DEFAULT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `received_day` date DEFAULT NULL,
  `returned_day` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `requestborrow`
--

INSERT INTO `requestborrow` (`student_id`, `document_id`, `request_day`, `state`, `update_date`, `id`, `received_day`, `returned_day`) VALUES
(1, 1, '2023-11-15', 0, '2023-11-20', 1, NULL, NULL),
(5, 3, '0000-00-00', 0, NULL, 2, NULL, NULL),
(5, 1, '2023-12-23', 0, NULL, 3, NULL, NULL),
(5, 2, '2023-11-08', 0, NULL, 4, NULL, NULL),
(5, 2, '2023-11-09', 0, NULL, 5, NULL, NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `reviews`
--

CREATE TABLE IF NOT EXISTS `reviews` (
  `review_id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(1024) NOT NULL,
  `book_name` varchar(2048) NOT NULL,
  `book_author` varchar(2048) NOT NULL,
  `summary` varchar(10000) NOT NULL,
  `content` mediumtext NOT NULL,
  `submit_date` date NOT NULL,
  `status` varchar(128) NOT NULL,
  `student_id` int(11) NOT NULL,
  PRIMARY KEY (`review_id`),
  KEY `student_id` (`student_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `reviews`
--

INSERT INTO `reviews` (`review_id`, `title`, `book_name`, `book_author`, `summary`, `content`, `submit_date`, `status`, `student_id`) VALUES
(1, 'Đây là tiêu đề bài review', 'Kỹ thuật lập trình', 'Nguyễn Trung Trực', 'Đây là tóm tắt bài review (tối đa 10000 kí tự)', 'Đây là nội dung bài review', '2023-12-01', 'Chấp nhận', 2000002);

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `borrow`
--
ALTER TABLE `borrow`
  ADD CONSTRAINT `borrow_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `members` (`student_id`),
  ADD CONSTRAINT `borrow_ibfk_2` FOREIGN KEY (`document_id`) REFERENCES `documents` (`document_id`);

--
-- Các ràng buộc cho bảng `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `members` (`student_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
