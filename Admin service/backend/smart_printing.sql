DROP DATABASE if exists smart_printing;
CREATE DATABASE smart_printing;
USE smart_printing;

CREATE TABLE NguoiDung (
	STT INT NOT NULL DEFAULT 0,
    ID VARCHAR(16) PRIMARY KEY,
    Ten VARCHAR(255) NOT NULL,
    TenDangNhap VARCHAR(255) NOT NULL UNIQUE,
    MatKhau VARCHAR(255) NOT NULL,
    SoLuongGiay INT,
    VaiTro VARCHAR(255) NOT NULL,
    RefreshToken TEXT
);

CREATE TABLE LuotMuaGiay (
	STT INT NOT NULL DEFAULT 1,
    ID VARCHAR(16) PRIMARY KEY,
    ThoiGian TIMESTAMP NOT NULL,
    Loai VARCHAR(255) NOT NULL,
    SoLuong INT NOT NULL,
    ID_NguoiDung VARCHAR(16) NOT NULL,
    PhuongThucThanhToan VARCHAR(255) NOT NULL,
    FOREIGN KEY (ID_NguoiDung)
        REFERENCES NguoiDung (ID)
);

-- Quản trị viên
CREATE TABLE QuanTriVien (
STT INT NOT NULL DEFAULT 1,
    ID VARCHAR(16) PRIMARY KEY,
    Ten VARCHAR(255) NOT NULL,
    TenDangNhap VARCHAR(255) NOT NULL UNIQUE,
    MatKhau VARCHAR(255) NOT NULL,
    ChucVu VARCHAR(255) NOT NULL,
    RefreshToken TEXT
);
CREATE TABLE LuotIn (
STT INT NOT NULL DEFAULT 1,
	ID VARCHAR(16) PRIMARY KEY,
	ThoiGian TIMESTAMP NOT NULL,
	TinhTrang VARCHAR(255),
	ID_QuanTriVien VARCHAR(16),
	FOREIGN KEY (ID_QuanTriVien) REFERENCES QuanTriVien(ID)
);

-- Tài liệu
CREATE TABLE TaiLieu (
	Ten VARCHAR(255),
	ID_LuotIn VARCHAR(16),
	SoTrang INT,
	SoBan INT,
	LoaiGiay VARCHAR(255),
	QRCode VARCHAR(255),
	FilePath VARCHAR(255),
	SttHangDoi INT,
	HuongIn VARCHAR(50),
	KieuIn VARCHAR(50),
	PRIMARY KEY (Ten, ID_LuotIn),
	FOREIGN KEY (ID_LuotIn) REFERENCES LuotIn(ID)
);

-- Máy in
CREATE TABLE MayIn (
	STT INT NOT NULL DEFAULT 1,
	ID VARCHAR(16) PRIMARY KEY,
	Hang VARCHAR(255),
	Model VARCHAR(255),
	KhayGiay VARCHAR(255),
	LoaiMuc VARCHAR(255),
	ViTri VARCHAR(255),
	TinhTrang VARCHAR(255),
	InMau BOOLEAN,
	CongSuat VARCHAR(255),
	TrongLuong VARCHAR(255),
    DoPhanGiai VARCHAR(255),
	Kieu VARCHAR(255),
	TocDoIn VARCHAR(255),
	KichThuoc VARCHAR(255),
	BoNho VARCHAR(255),
	AnhMayIn VARCHAR(255)
);

-- In
CREATE TABLE InAn (
	ID_LuotIn VARCHAR(16) PRIMARY KEY,
	ID_MayIn VARCHAR(16),
	ID_NguoiDung VARCHAR(16) ,
	FOREIGN KEY (ID_LuotIn) REFERENCES LuotIn(ID),
	FOREIGN KEY (ID_MayIn) REFERENCES MayIn(ID)
	ON DELETE SET NULL,
	FOREIGN KEY (ID_NguoiDung) REFERENCES NguoiDung(ID)
);

-- Khổ giấy
CREATE TABLE KhoGiay (
	MayIn VARCHAR(16),
	KhoGiay VARCHAR(255),
	PRIMARY KEY (MayIn, KhoGiay),
	FOREIGN KEY (MayIn) REFERENCES MayIn(ID)
    ON DELETE CASCADE
);

-- Quản lý máy in
CREATE TABLE QuanLyMayIn (
	ID_MayIn VARCHAR(16),
	ID_QuanTriVien VARCHAR(16),
	PRIMARY KEY (ID_MayIn, ID_QuanTriVien),
	FOREIGN KEY (ID_MayIn) REFERENCES MayIn(ID)
    ON DELETE CASCADE,
	FOREIGN KEY (ID_QuanTriVien) REFERENCES QuanTriVien(ID)
);


-- Tin nhắn
CREATE TABLE TinNhan (
	STT INT NOT NULL DEFAULT 1,
	ID VARCHAR(16) PRIMARY KEY,
	NoiDung TEXT,
	TieuDe VARCHAR(255),
	Loai VARCHAR(255),
	ThoiGian TIMESTAMP NOT NULL,
	ID_NguoiDung VARCHAR(16),
	FOREIGN KEY (ID_NguoiDung) REFERENCES NguoiDung(ID)
);


-- Quản lý tin nhắn
CREATE TABLE QuanLyTinNhan (
    ID_TinNhan VARCHAR(16),
    ID_QuanTriVien VARCHAR(16),
    PRIMARY KEY (ID_TinNhan , ID_QuanTriVien),
    FOREIGN KEY (ID_TinNhan)
        REFERENCES TinNhan (ID),
    FOREIGN KEY (ID_QuanTriVien)
        REFERENCES QuanTriVien (ID)
);

	DELIMITER //

	CREATE PROCEDURE GetPrintingHistory(IN PrinterID VARCHAR(16))
	BEGIN
		SELECT 
			nd.ID AS IDNguoiDung,
			nd.Ten AS NguoiDung,
			li.ThoiGian,
			tl.Ten AS TenTaiLieu,
			tl.SoTrang,
			tl.LoaiGiay,
			li.TinhTrang
		FROM 
			InAn ia
			JOIN LuotIn li ON ia.ID_LuotIn = li.ID
			JOIN TaiLieu tl ON tl.ID_LuotIn = li.ID
			JOIN NguoiDung nd ON ia.ID_NguoiDung = nd.ID
		WHERE 
			ia.ID_MayIn = PrinterID
        ORDER BY li.ThoiGian DESC;
	END //

	DELIMITER ;
    
    
	use smart_printing
	DELIMITER //

	-- use smart_priting
	DELIMITER //

	CREATE PROCEDURE UserPrintingHistory()
	BEGIN
		SELECT 
			nd.Ten AS 'Người dùng',
            nd.ID AS 'ID',
			IFNULL(COUNT(DISTINCT li.ID), 0) AS 'Số lượt in',
			IFNULL(SUM(tl.SoTrang * tl.SoBan), 0) AS 'Số lượng giấy đã in'
		FROM 
			NguoiDung nd
			LEFT JOIN InAn ia ON nd.ID = ia.ID_NguoiDung
			LEFT JOIN LuotIn li ON ia.ID_LuotIn = li.ID
			LEFT JOIN TaiLieu tl ON li.ID = tl.ID_LuotIn
		WHERE 
			nd.Ten != 'Mọi người'
		GROUP BY 
			nd.ID, nd.Ten;
	END //

	DELIMITER ;
use smart_printing
CALL UserPrintingHistory()
	use smart_printing
	DELIMITER //

	CREATE PROCEDURE PersonalPrintingHistory(IN userID VARCHAR(16))
	BEGIN
		SELECT 
			mi.Hang AS 'Máy in',
			li.ThoiGian AS 'Thời gian In',
			tl.Ten AS 'Tên tài liệu',
			(tl.SoTrang * tl.SoBan) AS 'Số tờ',
			tl.LoaiGiay AS 'Loại giấy',
			li.TinhTrang AS 'Tình trạng'
		FROM 
			InAn ia
			JOIN LuotIn li ON ia.ID_LuotIn = li.ID
			JOIN TaiLieu tl ON li.ID = tl.ID_LuotIn
			JOIN MayIn mi ON ia.ID_MayIn = mi.ID
		WHERE 
			ia.ID_NguoiDung = userID;
	END //

	DELIMITER ;

	-- CALL PersonalPrintingHistory('ND0001');


	DELIMITER $$

	CREATE PROCEDURE PrintSchedule (
		IN p_IDNguoiDung VARCHAR(16),
		IN p_TenFile VARCHAR(255),
		IN p_FilePath VARCHAR(255),
		IN p_HuongIn VARCHAR(50),
		IN p_SoTrang INT,
		IN p_SoBan INT,
		IN p_KieuIn VARCHAR(50),
		IN p_LoaiGiay VARCHAR(50),
		IN p_IDMayIn VARCHAR(16),
		IN p_ThoiGianIn TIMESTAMP
	)
	BEGIN
		DECLARE v_IDLuotIn VARCHAR(16);
		DECLARE v_SttHangDoi INT;
		
		-- Tạo ID lượt in mới
		SELECT CONCAT('LI', LPAD(CONVERT(IFNULL(MAX(SUBSTRING(ID, 3)), 0) + 1, CHAR), 4, '0')) 
		INTO v_IDLuotIn 
		FROM LuotIn;

		-- Tìm số thứ tự hàng đợi nhỏ nhất còn trống
		SELECT MIN(t1.SttHangDoi + 1)
		INTO v_SttHangDoi
		FROM TaiLieu t1
		LEFT JOIN TaiLieu t2 ON t1.SttHangDoi + 1 = t2.SttHangDoi
		WHERE t2.SttHangDoi IS NULL;

		-- Insert dữ liệu vào bảng LuotIn
		INSERT INTO LuotIn (ID, ThoiGian, ID_QuanTriVien, TinhTrang) 
		VALUES (v_IDLuotIn, p_ThoiGianIn, NULL, 'Chờ xử lý');
		
		-- Insert dữ liệu vào bảng TaiLieu
		INSERT INTO TaiLieu (Ten, ID_LuotIn, SoTrang, SoBan, LoaiGiay, HuongIn, KieuIn, QRCode, FilePath, SttHangDoi) 
		VALUES (p_TenFile, v_IDLuotIn, p_SoTrang, p_SoBan, p_LoaiGiay, p_HuongIn, p_KieuIn, NULL, p_FilePath, IFNULL(v_SttHangDoi, 1));
		
		-- Insert dữ liệu vào bảng InAn
		INSERT INTO InAn (ID_LuotIn, ID_MayIn, ID_NguoiDung) 
		VALUES (v_IDLuotIn, p_IDMayIn, p_IDNguoiDung);

	END $$

	DELIMITER ;


	-- CALL PrintSchedule(
	--     'ND0001',                 -- ID người dùng
	--     'Test điền form',               -- Tên file
	--     'DaylaURL',    -- FilePath
	--     'Dọc',                    -- Hướng in
	--     10,                       -- Số trang
	--     2,                        -- Số bản
	--     '1 mặt',                  -- Kiểu in
	--     'A4',                     -- Loại giấy
	--     'MI0001',                 -- ID máy in
	--     '2023-01-01 10:00:00'     -- Thời gian in
	-- );
	use smart_printing
	DELIMITER $$

	CREATE PROCEDURE PrintingQueue (
		IN p_IDNguoiDung VARCHAR(16)
	)
	BEGIN
		SELECT 
			TaiLieu.Ten AS TenTaiLieu, 
			TaiLieu.SttHangDoi AS SoThuTuHangDoi,
			LuotIn.TinhTrang AS TinhTrang
		FROM TaiLieu
		INNER JOIN InAn ON TaiLieu.ID_LuotIn = InAn.ID_LuotIn
		INNER JOIN LuotIn ON TaiLieu.ID_LuotIn = LuotIn.ID
		WHERE InAn.ID_NguoiDung = p_IDNguoiDung
		AND LuotIn.TinhTrang <> "Hoàn Thành"
		ORDER BY TaiLieu.SttHangDoi;
	END $$

	DELIMITER ;


	-- CALL PrintingQueue('ND0001')

	DELIMITER $$

	CREATE PROCEDURE PrintedDocument (
		IN p_IDNguoiDung VARCHAR(16)
	)
	BEGIN
		SELECT 
			TaiLieu.Ten AS TenTaiLieu,
			TaiLieu.QRCode
		FROM TaiLieu
		INNER JOIN InAn ON TaiLieu.ID_LuotIn = InAn.ID_LuotIn
		INNER JOIN LuotIn ON InAn.ID_LuotIn = LuotIn.ID
		WHERE InAn.ID_NguoiDung = p_IDNguoiDung AND LuotIn.TinhTrang = 'Hoàn Thành';
	END $$

	DELIMITER ;

	-- CALL PrintedDocument('ND0003');
DELIMITER //
CREATE TRIGGER deletePrinter BEFORE DELETE ON mayin
FOR EACH ROW
BEGIN
	IF OLD.TinhTrang = 'Working' THEN
		SIGNAL SQLSTATE '45000';
	END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER generateIDPRINTER BEFORE INSERT ON mayin
FOR EACH ROW
BEGIN
    SET NEW.STT = IFNULL((SELECT MAX(STT) + 1 FROM mayin), 01);
    SET NEW.ID = CONCAT('MI', LPAD(NEW.STT, 4, '0'));
END;
//
DELIMITER ;

    DELIMITER //
CREATE TRIGGER generateIDNGUOIDUNG BEFORE INSERT ON nguoidung
FOR EACH ROW
BEGIN
    SET NEW.STT = IFNULL((SELECT MAX(STT) + 1 FROM nguoidung), 0);
    SET NEW.ID = CONCAT('ND', LPAD(NEW.STT, 4, '0'));
END;
//
DELIMITER ;

    DELIMITER //
CREATE TRIGGER generateIDLUOTMUAGIAY BEFORE INSERT ON LUOTMUAGIAY
FOR EACH ROW
BEGIN
    SET NEW.STT = IFNULL((SELECT MAX(STT) + 1 FROM LUOTMUAGIAY), 0);
    SET NEW.ID = CONCAT('MG', LPAD(NEW.STT, 4, '0'));
END;
//
DELIMITER ;

    DELIMITER //
CREATE TRIGGER generateIDQUANTRIVIEN BEFORE INSERT ON QUANTRIVIEN
FOR EACH ROW
BEGIN
    SET NEW.STT = IFNULL((SELECT MAX(STT) + 1 FROM QUANTRIVIEN), 0);
    SET NEW.ID = CONCAT('QT', LPAD(NEW.STT, 4, '0'));
END;
//
DELIMITER ;
    DELIMITER //
CREATE TRIGGER generateIDLUOTIN BEFORE INSERT ON LUOTIN
FOR EACH ROW
BEGIN
    SET NEW.STT = IFNULL((SELECT MAX(STT) + 1 FROM LUOTIN), 0);
    SET NEW.ID = CONCAT('LI', LPAD(NEW.STT, 4, '0'));
END;
//
DELIMITER ;
DELIMITER //
CREATE TRIGGER generateIDTINNHAN BEFORE INSERT ON TINNHAN
FOR EACH ROW
BEGIN
    SET NEW.STT = IFNULL((SELECT MAX(STT) + 1 FROM TINNHAN), 0);
    SET NEW.ID = CONCAT('TN', LPAD(NEW.STT, 4, '0'));
END;
//
DELIMITER ;




	-- Insert into Người Dùng table
    INSERT INTO NguoiDung ( Ten, TenDangNhap,MatKhau, SoLuongGiay, VaiTro) VALUES
	('Mọi người', 'everyone','$2a$10$Gc8dmWKflXierwfMF.QldeK70W70vZBDapgQsjcu3X10daIQU1s/O', 00, 'System');
	
	INSERT INTO NguoiDung ( Ten, TenDangNhap, MatKhau, SoLuongGiay, VaiTro) VALUES
	('Nguyễn Văn A', 'A.Nguyen', '$2a$10$Gc8dmWKflXierwfMF.QldeK70W70vZBDapgQsjcu3X10daIQU1s/O',80, 'Student'),
	('Trần Thị B', 'B.Tran', '$2a$10$Gc8dmWKflXierwfMF.QldeK70W70vZBDapgQsjcu3X10daIQU1s/O',120, 'Lecturer'),
	('Lê Văn C', 'C.Le', '$2a$10$Gc8dmWKflXierwfMF.QldeK70W70vZBDapgQsjcu3X10daIQU1s/O',90, 'Student'),
	('Phạm Thị D', 'D.Pham', '$2a$10$Gc8dmWKflXierwfMF.QldeK70W70vZBDapgQsjcu3X10daIQU1s/O',110, 'Lecturer'),
	('Hoàng Văn E', 'E.Hoang', '$2a$10$Gc8dmWKflXierwfMF.QldeK70W70vZBDapgQsjcu3X10daIQU1s/O',70, 'Student'),
	('Ngô Thị F', 'F.Ngo', '$2a$10$Gc8dmWKflXierwfMF.QldeK70W70vZBDapgQsjcu3X10daIQU1s/O',130, 'Lecturer'),
	('Đặng Văn G', 'G.Dang', '$2a$10$Gc8dmWKflXierwfMF.QldeK70W70vZBDapgQsjcu3X10daIQU1s/O',100, 'Student'),
	('Bùi Thị H', 'H.Bui', '$2a$10$Gc8dmWKflXierwfMF.QldeK70W70vZBDapgQsjcu3X10daIQU1s/O',150, 'Lecturer'),
	('Vũ Văn I', 'I.Vu', '$2a$10$Gc8dmWKflXierwfMF.QldeK70W70vZBDapgQsjcu3X10daIQU1s/O',85, 'Student'),
	('Trương Thị K', 'K.Truong', '$2a$10$Gc8dmWKflXierwfMF.QldeK70W70vZBDapgQsjcu3X10daIQU1s/O',95, 'Lecturer');
	-- Insert into Quản trị viên table
	INSERT INTO QuanTriVien (Ten, TenDangNhap, MatKhau, ChucVu) VALUES
	('Nguyễn Thị L', 'NguyenHoang', '$2a$10$Gc8dmWKflXierwfMF.QldeK70W70vZBDapgQsjcu3X10daIQU1s/O', 'Officer'),
	('Trần Văn M', 'TheHieu', '$2a$10$Gc8dmWKflXierwfMF.QldeK70W70vZBDapgQsjcu3X10daIQU1s/O', 'Manager'),
	('Lê Thị N', 'XuanTho', '$2a$10$Gc8dmWKflXierwfMF.QldeK70W70vZBDapgQsjcu3X10daIQU1s/O', 'Officer'),
	('Phạm Văn P', 'TuanMinh', '$2a$10$Gc8dmWKflXierwfMF.QldeK70W70vZBDapgQsjcu3X10daIQU1s/O', 'Manager'),
	('Hoàng Thị Q', 'TienTa', '$2a$10$Gc8dmWKflXierwfMF.QldeK70W70vZBDapgQsjcu3X10daIQU1s/O', 'Officer'),
	('Ngô Văn R', 'ThaiHoc', '$2a$10$Gc8dmWKflXierwfMF.QldeK70W70vZBDapgQsjcu3X10daIQU1s/O', 'Director'),
    ('Hoàng Thị Q', 'AnhKhoa', '$2a$10$Gc8dmWKflXierwfMF.QldeK70W70vZBDapgQsjcu3X10daIQU1s/O', 'Officer');


	-- Insert into LuotMuaGiay table
	INSERT INTO LuotMuaGiay (ThoiGian, Loai, SoLuong, ID_NguoiDung, PhuongThucThanhToan) VALUES
	('2023-04-12 14:00:00', 'A4', 150, 'ND0001', 'BKPay'),
	('2023-05-18 10:30:00', 'Letter', 80, 'ND0002', 'Momo'),
	('2023-06-25 08:45:00', 'A3', 120, 'ND0003', 'OCB'),
	('2023-07-02 16:20:00', 'A4', 200, 'ND0004', 'BKPay'),
	('2023-08-09 12:15:00', 'Letter', 90, 'ND0005', 'Momo'),
	('2023-09-14 09:30:00', 'A3', 110, 'ND0006', 'OCB'),
	('2023-10-20 11:45:00', 'A4', 180, 'ND0007', 'BKPay'),
	('2023-11-27 13:00:00', 'Letter', 100, 'ND0008', 'Momo'),
	('2023-12-03 14:30:00', 'A3', 130, 'ND0009', 'OCB'),
	('2024-01-10 09:00:00', 'A4', 160, 'ND0010', 'BKPay'),
	('2024-02-17 15:45:00', 'Letter', 120, 'ND0001', 'Momo'),
	('2024-03-25 08:30:00', 'A3', 140, 'ND0002', 'OCB'),
	('2024-04-01 16:10:00', 'A4', 180, 'ND0003', 'BKPay'),
	('2024-05-08 12:00:00', 'Letter', 110, 'ND0004', 'Momo'),
	('2024-06-14 10:15:00', 'A3', 100, 'ND0005', 'OCB');


	-- Insert feedback messages from users to admin
	INSERT INTO TinNhan (NoiDung, TieuDe, Loai, ThoiGian, ID_NguoiDung) VALUES
	('Mình có một gợi ý để cải thiện dịch vụ in ấn.', 'Phản Hồi của Người Dùng', 'Phản Hồi', '2023-05-15 09:30:00', 'ND0001'),
	('Có vẻ như có một vấn đề với máy in ở 302B1.', 'Vấn Đề Kỹ Thuật', 'Vấn Đề', '2023-06-22 14:45:00', 'ND0002'),
	('Liệu chúng ta có thể thêm nhiều tùy chọn in hơn không?', 'Yêu Cầu Tính Năng', 'Yêu Cầu', '2023-07-30 11:15:00', 'ND0003');
	-- Insert feedback messages from users to admin
	INSERT INTO TinNhan (NoiDung, TieuDe, Loai, ThoiGian, ID_NguoiDung) VALUES
	('Dịch vụ in của bạn thật sự tuyệt vời!', 'Cảm ơn', 'Phản Hồi', '2023-11-20 08:30:00', 'ND0004'),
	('Máy in của chúng tôi đang hoạt động không đúng. Bạn có thể kiểm tra giúp không?', 'Báo Lỗi', 'Vấn Đề', '2024-01-05 16:00:00', 'ND0005'),
	('Các tùy chọn in màu thêm vào rất phong cách!', 'Phản Hồi', 'Phản Hồi', '2024-02-12 09:45:00', 'ND0006');
	-- Insert notifications from admin to users
	INSERT INTO TinNhan (NoiDung, TieuDe, Loai, ThoiGian, ID_NguoiDung) VALUES
	('Các tính năng in mới đã được thêm vào! Hãy kiểm tra chúng.', 'Cập Nhật Dịch Vụ', 'Thông Báo', '2023-08-10 10:00:00', 'ND0000'),
	('Bảo dưỡng sẽ được thực hiện trên các máy in vào tuần tới.', 'Thông Báo Bảo Dưỡng', 'Thông Báo', '2023-09-05 15:30:00', 'ND0000'),
	('Nhắc nhở: Hãy sử dụng máy in một cách có trách nhiệm.', 'Nhắc Nhở Sử Dụng', 'Thông Báo', '2023-10-12 13:45:00', 'ND0000');
	-- Insert notifications from admin to users
	INSERT INTO TinNhan (NoiDung, TieuDe, Loai, ThoiGian, ID_NguoiDung) VALUES
	('Chúc mừng bạn đã đạt được cột mốc mới trong việc in ấn!', 'Thành Tích', 'Thông Báo', '2024-03-10 10:30:00', 'ND0000'),
	('Lịch bảo dưỡng cho các máy in đã được cập nhật. Xin lưu ý!', 'Thông Báo Bảo Dưỡng', 'Thông Báo', '2024-04-15 14:15:00', 'ND0000'),
	('Thông báo quan trọng về việc nâng cấp hệ thống in.', 'Cập Nhật Hệ Thống', 'Thông Báo', '2024-05-22 11:30:00', 'ND0000'),
	('Chúc mừng bạn đã được thăng chức lên vị trí mới!', 'Thăng Chức', 'Thông Báo', '2024-06-28 13:45:00', 'ND0000'),
	('Hãy kiểm tra email của bạn để biết thông tin cập nhật mới nhất.', 'Thông Báo Quan Trọng', 'Thông Báo', '2024-07-05 09:00:00', 'ND0000');

	INSERT INTO QuanLyTinNhan (ID_QuanTriVien, ID_TinNhan) VALUES
	('QT0001', 'TN0001'),
	('QT0002', 'TN0001'),
	('QT0004', 'TN0001'),
	('QT0005', 'TN0001'),
	('QT0001', 'TN0002'),
	('QT0003', 'TN0002'),
	('QT0004', 'TN0002'),
	('QT0004', 'TN0003'),
	('QT0006', 'TN0003'),
	('QT0001', 'TN0007'),
	('QT0006', 'TN0008'),
	('QT0002', 'TN0009'),
	('QT0002', 'TN0010'),
	('QT0004', 'TN0011'),
	('QT0004', 'TN0012'),
	('QT0004', 'TN0013');
	-- Insert data into MayIn table
	INSERT INTO MayIn (Hang, Model, KhayGiay, LoaiMuc, ViTri, TinhTrang, InMau, CongSuat, TrongLuong, DoPhanGiai, Kieu, TocDoIn, KichThuoc, BoNho, AnhMayIn ) VALUES
	('HP', 'MFP M236DW', '150 tờ/khay', 'HP 136X W1360X Đen', '302B1', 'Working', TRUE, '500 Tờ', '60 kg', '600x600 dpi', 'Laser', '30 trang/phút', '418 x 308 x 294.4 mm', '1024 MB' , 'https://s3.pricemestatic.com/Large/Images/RetailerProductImages/StRetailer1450/rp_39470408_0021477728_l.png'),
	('Canon', 'GM3055', '50 tờ/khay', 'Canon CL-741', '106A5', 'Working', FALSE, '4000 Tờ', '50 kg','600x600 dpi', 'Inkjet', '35 trang/phút', '418 x 308 x 494.4 mm', '512 MB' , 'https://s3.pricemestatic.com/Large/Images/RetailerProductImages/StRetailer1450/rp_39470408_0021477728_l.png'),
	('Canon', 'GM2070', '75 tờ/khay', 'Canon CL-222', '101H1', 'Working', TRUE, '12900 Tờ', '70 kg','600x600 dpi', 'Laser', '25 trang/phút', '518 x 408 x 994.4 mm', '2048 MB', 'https://s3.pricemestatic.com/Large/Images/RetailerProductImages/StRetailer1450/rp_39470408_0021477728_l.png'),
	('HP', 'MFP M435DW', '150 tờ/khay', 'HP 134X W1340X Đen', '203H6', 'Disabled', TRUE, '10500 Tờ', '30 kg', '600x600 dpi','Laser', '40 trang/phút', '418 x 308 x 294.4 mm', '1024 MB', 'https://s3.pricemestatic.com/Large/Images/RetailerProductImages/StRetailer1450/rp_39470408_0021477728_l.png'),
	('Canon', 'LBP2900', '200 tờ/khay', 'Canon K2240X ', '103C6', 'Working', FALSE, '1500 Tờ', '30 kg', '600x600 dpi','Inkjet', '30 trang/phút', '418 x 308 x 294.4 mm', '768 MB', 'https://s3.pricemestatic.com/Large/Images/RetailerProductImages/StRetailer1450/rp_39470408_0021477728_l.png'),
	('Canon', 'LBP2900', '200 tờ/khay', 'Canon K2240X ', '103C6', 'Working', FALSE, '1500 Tờ', '30 kg', '600x600 dpi','Inkjet', '30 trang/phút', '418 x 308 x 294.4 mm', '768 MB', 'https://s3.pricemestatic.com/Large/Images/RetailerProductImages/StRetailer1450/rp_39470408_0021477728_l.png');


	-- Insert data into QuanLyMayIn table
	INSERT INTO QuanLyMayIn (ID_MayIn, ID_QuanTriVien) VALUES
	('MI0001', 'QT0001'),
	('MI0001', 'QT0002'),
	('MI0001', 'QT0003'),
	('MI0002', 'QT0001'),
	('MI0002', 'QT0002'),
	('MI0003', 'QT0004'),
	('MI0003', 'QT0005'),
	('MI0003', 'QT0006'),
	('MI0004', 'QT0004'),
	('MI0005', 'QT0001'),
	('MI0005', 'QT0002'),
	('MI0005', 'QT0003'),
	('MI0005', 'QT0004'),
	('MI0005', 'QT0006');

	-- Insert data into KhoGiay table with specific paper sizes per printer
	INSERT INTO KhoGiay (MayIn, KhoGiay) VALUES
	('MI0001', 'A4'),
	('MI0001', 'A3'),
	('MI0001', 'Letter'),
	('MI0002', 'A5'),
	('MI0002', 'B4'),
	('MI0002', 'B5'),
	('MI0003', 'A4'),
	('MI0003', 'A3'),
	('MI0003', 'B4'),
	('MI0004', 'A5'),
	('MI0004', 'B3'),
	('MI0005', 'A4'),
	('MI0005', 'Letter'),
	('MI0005', 'C4');

	-- Insert data into LuotIn table with administrator IDs in the range (1, 6)
	INSERT INTO LuotIn (ThoiGian, TinhTrang, ID_QuanTriVien) VALUES
	('2023-04-10 08:30:00', 'Đang In', 'QT0001'),
	('2023-05-15 10:00:00', 'Hoàn Thành', 'QT0002'),
	('2023-06-20 13:45:00', 'Đang In', 'QT0003'),
	('2023-07-25 15:30:00', 'Chờ Xử Lý', 'QT0004'),
	('2023-08-30 09:15:00', 'Hoàn Thành', 'QT0005'),
	('2023-09-05 14:00:00', 'Chờ Xử Lý', 'QT0001'),
	('2023-10-10 11:45:00', 'Hoàn Thành', 'QT0002'),
	('2023-11-15 09:30:00', 'Đang In', 'QT0003'),
	('2023-12-20 12:15:00', 'Chờ Xử Lý', 'QT0004'),
	('2024-01-25 16:45:00', 'Hoàn Thành', 'QT0005'),
	('2024-02-29 08:00:00', 'Đang In', 'QT0001'),
	('2024-03-05 14:30:00', 'Chờ Xử Lý', 'QT0002'),
	('2024-04-10 10:15:00', 'Hoàn Thành', 'QT0003'),
	('2024-05-15 13:00:00', 'Chờ Xử Lý', 'QT0004'),
	('2024-06-20 15:45:00', 'Đang In', 'QT0005'),
	('2024-07-25 11:30:00', 'Hoàn Thành', 'QT0001'),
	('2024-08-30 09:00:00', 'Đang In', 'QT0002'),
	('2024-09-05 14:45:00', 'Chờ Xử Lý', 'QT0003'),
	('2024-10-10 12:30:00', 'Hoàn Thành', 'QT0004'),
	('2024-11-15 08:15:00', 'Đang In', 'QT0005'),
	('2024-12-20 15:30:00', 'Chờ Xử Lý', 'QT0001'),
	('2025-01-25 13:45:00', 'Hoàn Thành', 'QT0002'),
	('2025-02-28 10:30:00', 'Đang In', 'QT0003'),
	('2025-03-05 16:00:00', 'Chờ Xử Lý', 'QT0004'),
	('2025-04-10 14:15:00', 'Hoàn Thành', 'QT0005');


	-- Insert more data into TaiLieu table with 2-3 documents for each ID_LuotIn
	INSERT INTO TaiLieu (Ten, ID_LuotIn, SoTrang, SoBan, LoaiGiay, QRCode, SttHangDoi, FilePath) VALUES
	-- ID_LuotIn: LI0001
	('Document1', 'LI0001', 12, 3, 'A4', 'https://drive.google.com/file/d/12AiWS8-BvyYpuKWfoJNDUcNLLKChh_tl/view?usp=sharing', 1, '/path/to/uploaded/file/document1.pdf'),

	-- ID_LuotIn: LI0002
	('Document24', 'LI0002', 18, 4, 'A5', 'https://drive.google.com/file/d/12AiWS8-BvyYpuKWfoJNDUcNLLKChh_tl/view?usp=sharing', 2, '/path/to/uploaded/file/document24.pdf'),
	('Document25', 'LI0002', 20, 3, 'B4', 'https://drive.google.com/file/d/15LzjQeoaKsAWClzEvk7g5XkFst3GsChy/view?usp=sharing', 3, '/path/to/uploaded/file/document25.pdf'),

	-- ID_LuotIn: LI0003
	('Document27', 'LI0003', 8, 1, 'A4', 'https://drive.google.com/file/d/12AiWS8-BvyYpuKWfoJNDUcNLLKChh_tl/view?usp=sharing', 4, '/path/to/uploaded/file/document27.pdf'),
	('Document28', 'LI0003', 10, 3, 'A3', 'https://drive.google.com/file/d/12AiWS8-BvyYpuKWfoJNDUcNLLKChh_tl/view?usp=sharing', 5, '/path/to/uploaded/file/document28.pdf'),
	('Document29', 'LI0003', 12, 2, 'B4', 'https://drive.google.com/file/d/15LzjQeoaKsAWClzEvk7g5XkFst3GsChy/view?usp=sharing', 6, '/path/to/uploaded/file/document29.pdf'),

	-- ID_LuotIn: LI0004
	('Document30', 'LI0004', 14, 4, 'A4', 'https://drive.google.com/file/d/12AiWS8-BvyYpuKWfoJNDUcNLLKChh_tl/view?usp=sharing', 7, '/path/to/uploaded/file/document30.pdf'),
	('Document31', 'LI0004', 16, 3, 'A3', 'https://drive.google.com/file/d/15LzjQeoaKsAWClzEvk7g5XkFst3GsChy/view?usp=sharing', 8, '/path/to/uploaded/file/document31.pdf'),
	('Document32', 'LI0004', 20, 1, 'B3', 'https://drive.google.com/file/d/15LzjQeoaKsAWClzEvk7g5XkFst3GsChy/view?usp=sharing', 9, '/path/to/uploaded/file/document32.pdf'),

	-- ID_LuotIn: LI0005
	('Document33', 'LI0005', 22, 2, 'C4', 'https://drive.google.com/file/d/12AiWS8-BvyYpuKWfoJNDUcNLLKChh_tl/view?usp=sharing', 10, '/path/to/uploaded/file/document33.pdf');

	-- Insert more data into TaiLieu table with 2-3 documents for each ID_LuotIn
	INSERT INTO TaiLieu (Ten, ID_LuotIn, SoTrang, SoBan, LoaiGiay, QRCode, SttHangDoi) VALUES
	-- ID_LuotIn: LI0006
	('Document36', 'LI0006', 18, 4, 'A4', 'https://drive.google.com/file/d/12AiWS8-BvyYpuKWfoJNDUcNLLKChh_tl/view?usp=sharing', 11),
	('Document38', 'LI0006', 15, 2, 'B4', 'https://drive.google.com/file/d/15LzjQeoaKsAWClzEvk7g5XkFst3GsChy/view?usp=sharing', 12),

	-- ID_LuotIn: LI0007
	('Document39', 'LI0007', 8, 1, 'A4', 'https://drive.google.com/file/d/12AiWS8-BvyYpuKWfoJNDUcNLLKChh_tl/view?usp=sharing', 13),
	('Document40', 'LI0007', 10, 3, 'A3', 'https://drive.google.com/file/d/15LzjQeoaKsAWClzEvk7g5XkFst3GsChy/view?usp=sharing', 14),
	('Document41', 'LI0007', 12, 2, 'B4', 'https://drive.google.com/file/d/15LzjQeoaKsAWClzEvk7g5XkFst3GsChy/view?usp=sharing', 15),

	-- ID_LuotIn: LI0008
	('Document42', 'LI0008', 14, 4, 'A4', 'https://drive.google.com/file/d/12AiWS8-BvyYpuKWfoJNDUcNLLKChh_tl/view?usp=sharing', 16),


	-- ID_LuotIn: LI0009
	('Document45', 'LI0009', 22, 2, 'C4', 'https://drive.google.com/file/d/12AiWS8-BvyYpuKWfoJNDUcNLLKChh_tl/view?usp=sharing', 17),


	-- ID_LuotIn: LI0010
	('Document48', 'LI0010', 30, 2, 'A4', 'https://drive.google.com/file/d/12AiWS8-BvyYpuKWfoJNDUcNLLKChh_tl/view?usp=sharing', 18),
	('Document49', 'LI0010', 35, 3, 'A3', 'https://drive.google.com/file/d/15LzjQeoaKsAWClzEvk7g5XkFst3GsChy/view?usp=sharing', 19),
	('Document50', 'LI0010', 40, 4, 'B5', 'https://drive.google.com/file/d/15LzjQeoaKsAWClzEvk7g5XkFst3GsChy/view?usp=sharing', 20),

	-- ID_LuotIn: LI0011
	('Document51', 'LI0011', 28, 1, 'A4', 'https://drive.google.com/file/d/12AiWS8-BvyYpuKWfoJNDUcNLLKChh_tl/view?usp=sharing', 21),
	('Document52', 'LI0011', 32, 3, 'A3', 'https://drive.google.com/file/d/15LzjQeoaKsAWClzEvk7g5XkFst3GsChy/view?usp=sharing', 22),


	-- ID_LuotIn: LI0012
	('Document54', 'LI0012', 38, 4, 'A4', 'https://drive.google.com/file/d/12AiWS8-BvyYpuKWfoJNDUcNLLKChh_tl/view?usp=sharing', 23),
	('Document55', 'LI0012', 40, 3, 'A3', 'https://drive.google.com/file/d/15LzjQeoaKsAWClzEvk7g5XkFst3GsChy/view?usp=sharing', 24),
	('Document56', 'LI0012', 45, 2, 'B4', 'https://drive.google.com/file/d/12AiWS8-BvyYpuKWfoJNDUcNLLKChh_tl/view?usp=sharing', 25),

	-- ID_LuotIn: LI0013
	('Document57', 'LI0013', 26, 1, 'A4', 'https://drive.google.com/file/d/12AiWS8-BvyYpuKWfoJNDUcNLLKChh_tl/view?usp=sharing', 26),
	('Document58', 'LI0013', 30, 3, 'A3', 'https://drive.google.com/file/d/12AiWS8-BvyYpuKWfoJNDUcNLLKChh_tl/view?usp=sharing', 27),


	-- ID_LuotIn: LI0014
	('Document60', 'LI0014', 42, 4, 'A4', 'https://drive.google.com/file/d/15LzjQeoaKsAWClzEvk7g5XkFst3GsChy/view?usp=sharing', 28),
	('Document61', 'LI0014', 46, 3, 'A3', 'https://drive.google.com/file/d/12AiWS8-BvyYpuKWfoJNDUcNLLKChh_tl/view?usp=sharing', 29),
	('Document62', 'LI0014', 50, 2, 'B4', 'https://drive.google.com/file/d/15LzjQeoaKsAWClzEvk7g5XkFst3GsChy/view?usp=sharing', 30),

	-- ID_LuotIn: LI0015
	('Document63', 'LI0015', 28, 1, 'A4', 'https://drive.google.com/file/d/12AiWS8-BvyYpuKWfoJNDUcNLLKChh_tl/view?usp=sharing', 31),
	('Document64', 'LI0015', 32, 3, 'A3', 'https://drive.google.com/file/d/15LzjQeoaKsAWClzEvk7g5XkFst3GsChy/view?usp=sharing', 32),
	('Document65', 'LI0015', 36, 2, 'B4', 'https://drive.google.com/file/d/15LzjQeoaKsAWClzEvk7g5XkFst3GsChy/view?usp=sharing', 33),

	-- ID_LuotIn: LI0016
	('Document66', 'LI0016', 38, 4, 'A4', 'https://drive.google.com/file/d/12AiWS8-BvyYpuKWfoJNDUcNLLKChh_tl/view?usp=sharing', 34),


	-- ID_LuotIn: LI0017
	('Document69', 'LI0017', 42, 4, 'A4', 'https://drive.google.com/file/d/15LzjQeoaKsAWClzEvk7g5XkFst3GsChy/view?usp=sharing', 35),
	('Document70', 'LI0017', 46, 3, 'A3', 'https://drive.google.com/file/d/12AiWS8-BvyYpuKWfoJNDUcNLLKChh_tl/view?usp=sharing', 36),

	-- ID_LuotIn: LI0018
	('Document72', 'LI0018', 42, 4, 'A4', 'https://drive.google.com/file/d/12AiWS8-BvyYpuKWfoJNDUcNLLKChh_tl/view?usp=sharing', 37),
	('Document73', 'LI0018', 46, 3, 'A3', 'https://drive.google.com/file/d/15LzjQeoaKsAWClzEvk7g5XkFst3GsChy/view?usp=sharing', 38),


	-- ID_LuotIn: LI0019
	('Document75', 'LI0019', 42, 4, 'A4', 'https://drive.google.com/file/d/15LzjQeoaKsAWClzEvk7g5XkFst3GsChy/view?usp=sharing', 39),
	('Document76', 'LI0019', 46, 3, 'A3', 'https://drive.google.com/file/d/15LzjQeoaKsAWClzEvk7g5XkFst3GsChy/view?usp=sharing', 40),
	('Document77', 'LI0019', 50, 2, 'B4', 'https://drive.google.com/file/d/12AiWS8-BvyYpuKWfoJNDUcNLLKChh_tl/view?usp=sharing', 41),
	('Document22', 'LI0019', 50, 2, 'B4', 'https://drive.google.com/file/d/15LzjQeoaKsAWClzEvk7g5XkFst3GsChy/view?usp=sharing', 42),
	-- ID_LuotIn: LI0020
	('Document78', 'LI0020', 42, 4, 'A4', 'https://drive.google.com/file/d/12AiWS8-BvyYpuKWfoJNDUcNLLKChh_tl/view?usp=sharing', 43),
	('Document79', 'LI0020', 46, 3, 'A3', 'https://drive.google.com/file/d/15LzjQeoaKsAWClzEvk7g5XkFst3GsChy/view?usp=sharing', 44),
	('Document80', 'LI0020', 50, 2, 'B4', 'https://drive.google.com/file/d/15LzjQeoaKsAWClzEvk7g5XkFst3GsChy/view?usp=sharing', 45),
	('Document77', 'LI0020', 50, 2, 'B4', 'https://drive.google.com/file/d/12AiWS8-BvyYpuKWfoJNDUcNLLKChh_tl/view?usp=sharing', 46),
	-- ID_LuotIn: LI0021
	('Document81', 'LI0021', 42, 4, 'A4', 'https://drive.google.com/file/d/12AiWS8-BvyYpuKWfoJNDUcNLLKChh_tl/view?usp=sharing', 47),

	-- ID_LuotIn: LI0022
	('Document84', 'LI0022', 42, 4, 'A4', 'https://drive.google.com/file/d/12AiWS8-BvyYpuKWfoJNDUcNLLKChh_tl/view?usp=sharing',48),


	-- ID_LuotIn: LI0023
	('Document87', 'LI0023', 42, 4, 'A4', 'https://drive.google.com/file/d/15LzjQeoaKsAWClzEvk7g5XkFst3GsChy/view?usp=sharing', 49),
	('Document88', 'LI0023', 46, 3, 'A3', 'https://drive.google.com/file/d/12AiWS8-BvyYpuKWfoJNDUcNLLKChh_tl/view?usp=sharing', 50),
	('Document89', 'LI0023', 50, 2, 'B4', 'https://drive.google.com/file/d/15LzjQeoaKsAWClzEvk7g5XkFst3GsChy/view?usp=sharing', 51),
	('Document85', 'LI0022', 46, 3, 'A3', 'https://drive.google.com/file/d/12AiWS8-BvyYpuKWfoJNDUcNLLKChh_tl/view?usp=sharing', 52),
	('Document86', 'LI0022', 50, 2, 'B4', 'https://drive.google.com/file/d/12AiWS8-BvyYpuKWfoJNDUcNLLKChh_tl/view?usp=sharing', 53),
	-- ID_LuotIn: LI0024
	('Document90', 'LI0023', 42, 4, 'A4', 'https://drive.google.com/file/d/15LzjQeoaKsAWClzEvk7g5XkFst3GsChy/view?usp=sharing', 54),
	('Document91', 'LI0023', 46, 3, 'A3', 'https://drive.google.com/file/d/12AiWS8-BvyYpuKWfoJNDUcNLLKChh_tl/view?usp=sharing', 55),
	('Document92', 'LI0023', 50, 2, 'B4', 'https://drive.google.com/file/d/12AiWS8-BvyYpuKWfoJNDUcNLLKChh_tl/view?usp=sharing', 56),

	-- ID_LuotIn: LI0025
	('Document93', 'LI0024', 42, 4, 'A4', 'https://drive.google.com/file/d/15LzjQeoaKsAWClzEvk7g5XkFst3GsChy/view?usp=sharing', 57),
	('Document94', 'LI0024', 46, 3, 'A3', 'https://drive.google.com/file/d/12AiWS8-BvyYpuKWfoJNDUcNLLKChh_tl/view?usp=sharing', 58),
	('Document95', 'LI0024', 50, 2, 'B4', 'https://drive.google.com/file/d/15LzjQeoaKsAWClzEvk7g5XkFst3GsChy/view?usp=sharing', 59);


	-- Insert data into InAn table with shuffled values for ID_MayIn and ID_NguoiDung
	INSERT INTO InAn (ID_LuotIn, ID_MayIn, ID_NguoiDung) VALUES
	('LI0001', 'MI0004', 'ND0001'),
	('LI0002', 'MI0002', 'ND0009'),
	('LI0003', 'MI0001', 'ND0004'),
	('LI0004', 'MI0005', 'ND0005'),
	('LI0005', 'MI0003', 'ND0008'),
	('LI0006', 'MI0001', 'ND0002'),
	('LI0007', 'MI0005', 'ND0003'),
	('LI0008', 'MI0003', 'ND0007'),
	('LI0009', 'MI0002', 'ND0006'),
	('LI0010', 'MI0004', 'ND0010'),
	('LI0011', 'MI0002', 'ND0005'),
	('LI0012', 'MI0004', 'ND0008'),
	('LI0013', 'MI0001', 'ND0003'),
	('LI0014', 'MI0003', 'ND0001'),
	('LI0015', 'MI0005', 'ND0009'),
	('LI0016', 'MI0004', 'ND0002'),
	('LI0017', 'MI0003', 'ND0004'),
	('LI0018', 'MI0001', 'ND0006'),
	('LI0019', 'MI0005', 'ND0007'),
	('LI0020', 'MI0002', 'ND0010'),
	('LI0021', 'MI0005', 'ND0001'),
	('LI0022', 'MI0003', 'ND0002'),
	('LI0023', 'MI0002', 'ND0008'),
	('LI0024', 'MI0001', 'ND0004');
