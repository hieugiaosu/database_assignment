drop procedure if exists signIn;
DELIMITER //
CREATE PROCEDURE signIn(
				IN hoivien varchar(255),
                IN matkhau varchar(255),
                IN maytinh int,
                out `status` boolean,
                out	session_id int
                )
BEGIN
    declare tai_khoan varchar(255);
    declare id_may_tinh int;
    declare latest_end_time_account datetime;
    declare start_time datetime;
    declare latest_end_time_pc datetime;
    select `account` into tai_khoan from `Hoi Vien` where `account` =  hoivien and `password`= matkhau;
    select id into id_may_tinh from `may tinh` where id = maytinh;
    if tai_khoan is not null and id_may_tinh is not null then
		select `gio ket thuc`, `gio bat dau` into latest_end_time_account, start_time 
        from `session` 
        where `tai khoan hv`= tai_khoan
        ORDER BY `gio bat dau` DESC
		LIMIT 1;
        select `gio ket thuc` into latest_end_time_pc
        from `session` 
        where `id may tinh` = id_may_tinh
        ORDER BY `gio bat dau` DESC
		LIMIT 1;
        if start_time is null then
			insert into `session` (`gio bat dau`,`id may tinh`,`tai khoan hv`) values (now(),maytinh,hoivien);
			set `status`=true;
            select `Session ID` into session_id from `session` where `id may tinh`=id_may_tinh and `gio ket thuc` is null;
        else
			if latest_end_time_account is null or latest_end_time_pc is null then
				set `status` = FALSE;
			else
				if latest_end_time_account > now() or latest_end_time_pc>now() then
                    set `status`=False;
				else
					insert into `session` (`gio bat dau`,`id may tinh`,`tai khoan hv`) values (now(),maytinh,hoivien);
					set `status`=true;
                    select `Session ID` into session_id from `session` where `id may tinh`=id_may_tinh and `gio ket thuc` is null;
				end if;
			end if;
		end if;
	ELSE
		set `status` = FALSE;
	END IF;
END; 
//
DELIMITER ;
DELIMITER //
create procedure signOutBySessionID(
	in session_id int
)
BEGIN
	update `session` set `gio ket thuc` = now() where `session id` = session_id;
END ;
//
DELIMITER ;
DELIMITER //
create procedure signOutByAccount(
	in `account` char(255)
)
BEGIN
	update `session` set `gio ket thuc` = now() where `tai khoan hv` = `account` and `gio ket thuc` is null;
END ;
//
DELIMITER ;
DELIMITER //
create procedure signOutByPCID(
	in pc_id int
)
BEGIN
	update `session` set `gio ket thuc` = now() where `id may tinh` = pc_id and `gio ket thuc` is null;
END ;
//
DELIMITER ;
DELIMITER //
-- for compute the  price
create procedure getDiscountForProduct(
	in product_id int,
    in so_luong int,
    in date_apply date,
    out ma_khuyen_mai int,
    out muc_giam float
)
begin
	select `khuyen mai`.`ma khuyen mai`, `muc giam` into ma_khuyen_mai, muc_giam from `khuyen mai` join `ap dung san pham` 
    on `khuyen mai`.`ma khuyen mai` = `ap dung san pham`.`ma khuyen mai`
    where `ap dung san pham`.`ma san pham` = product_id 
    and `khuyen mai`.`dieu kien` <= so_luong
    and `khuyen mai`.`ngay bat dau` <= date_apply 
    and `khuyen mai`.`ngay ket thuc`>=date_apply 
    order by `khuyen mai`.`muc giam` desc, `khuyen mai`.`ma khuyen mai` ASC 
    limit 1;
end;
//
DELIMITER ;
DELIMITER //
create procedure applyDiscountToBill(
	in bill_id int
)
begin
	declare muc_giam float;
    declare bill_cost int;
    declare id_khuyen_mai int;
    declare ngay_thuc_hien datetime;
	select `ngay thuc hien`, `tong tien` into ngay_thuc_hien,bill_cost from `hoa don` where `ma hoa don` = bill_id;
    select `ma khuyen mai` ,`muc_giam` into id_khuyen_mai,muc_giam from `khuyen mai` 
    where `loai` = 'bill' 
    and `dieu kien` <= bill_cost
    and ngay_thuc_hien >= `ngay bat dau`
    and ngay_thuc_hien <= `ngay ket thuc`;
    if id_khuyen_mai is not null then
		set bill_cost = (1-muc_giam)*bill_cost;
        insert into `ap dung hoa don` (`ma hoa don`, `ma khuyen mai`) values (bill_id,id_khuyen_mai);
        update `hoa don` set `tong tien` = bill_cost where `ma hoa don`=bill_id;
    end if;
end;
//
DELIMITER ;
DELIMITER //
create procedure addNewDiscount(
	in id int,
    in program_name varchar(255),
    in program_description varchar(255),
    in start_datetime datetime,
    in end_datetime datetime,
    in apply_on_bill boolean,
    in dieu_kien int,
    in muc_giam float
)
begin
	declare loai_km varchar(255);
    if apply_on_bill then
		set loai_km = 'bill';
	else
		set loai_km = 'product';
    end if;
    insert into `khuyen mai` (`ma khuyen mai`,`ten chuong trinh`,`mo ta`,`ngay bat dau`,`ngay ket thuc`,loai,`dieu kien`,`muc giam`)
    values (id,program_name,program_description,start_datetime,end_datetime,loai_km,dieu_kien,muc_giam);
end;
//
DELIMITER ;
DELIMITER //
create procedure addNewProductForDiscount(
	in discount_id int,
    in product_id int
)
begin
	insert into `ap dung san pham` (`ma san pham`, `ma khuyen mai`) values (product_id,discount_id);
end;
//
DELIMITER ;
-- DELIMITER //

-- CREATE PROCEDURE AddHoiVien(
--     IN p_account CHAR(255),
--     IN p_password CHAR(255),
--     IN p_ten CHAR(255),
--     IN p_sdt CHAR(10),
--     IN p_email CHAR(255)
-- )
-- BEGIN
--     INSERT INTO `Hoi Vien` (
--         `account`,
--         `password`,
--         `ten`,
--         `sdt`,
--         `email`
--     ) VALUES (
--         p_account,
--         p_password,
--         p_ten,
--         p_sdt,
--         p_email
--     );
-- END;

-- //

DELIMITER ;
DROP PROCEDURE IF EXISTS thongKeKhuyenMai;
DELIMITER //
CREATE PROCEDURE thongKeKhuyenMai(
	in ma_khuyen_mai int
)
BEGIN
	Select ct.`ma san pham`, ct.`so luong`,ct.`ma hoa don`
    from `hoa don` as hd natural join
	(SELECT *
	FROM chua as c natural join
	(SELECT km.`ngay bat dau`, km.`ngay ket thuc`,adsp.`ma san pham` 
    from `khuyen mai` AS km 
    natural join `ap dung san pham` as adsp
    where  km.`ma khuyen mai`= ma_khuyen_mai and km.`ma khuyen mai` = adsp.`ma khuyen mai`) as spkm
	where spkm.`ma san pham` = c.`ma san pham`) AS ct
    where hd.`ma hoa don` = ct.`ma hoa don` 
    and hd.`ngay thuc hien` >= ct.`ngay bat dau` 
    and hd.`ngay thuc hien` <= ct.`ngay ket thuc`;
END;
//
DELIMITER ;
DELIMITER //
CREATE PROCEDURE getTotalTimeByPCConfigID(
	in configID int
)
BEGIN
	select ss.`gio bat dau`, ss.`gio ket thuc`, pc.ID 
    from `Session` as ss 
    join `may tinh` as pc
    on pc.ID = ss.`ID may tinh`
    where pc.`id cau hinh` = configID;
END;
//
DELIMITER ;
DELIMITER //
CREATE PROCEDURE getCostByPCid(
	in pcID int
)
BEGIN
	SELECT `may tinh`.ID,`phu thu`, `gia` from
    `may tinh` JOIN `cau hinh` JOIN `khu vuc`
    ON `may tinh`.`phan loai khu vuc` = `khu vuc`.`loai khu vuc` and `may tinh`.`id cau hinh` = `cau hinh`.ID
    WHERE `may tinh`.ID = pcID;
END;
//
DELIMITER ;
DELIMITER //
CREATE PROCEDURE updateUserBalance(
	in balanceChange int, -- balanceChange < 0 if minus, >0 if add to account,
    in accountHV char(255)
)
BEGIN
	DECLARE currentBalance int;
	SELECT `so du` into currentBalance from `hoi vien` where `account` = accountHV;
    SET currentBalance = balanceChange + currentBalance;
    UPDATE `hoi vien` SET `so du` = currentBalance where `acount` = accountHV;
END ;
//
DELIMITER ;
DELIMITER //
CREATE PROCEDURE getUserData(
	in accountHV char(255),
    in passwordHV char(255)
)
BEGIN
	SELECT * FROM `hoi vien` WHERE `account`=accountHV and `password` = passwordHV;
END;
//
DELIMITER ;
drop procedure if exists UpdateHoiVienRecord;
DELIMITER //
CREATE PROCEDURE UpdateHoiVienRecord(
    IN p_account CHAR(255),
    IN `old_password` CHAR(255),
    IN p_password CHAR(255),
    IN p_ten CHAR(255),
    IN p_sdt CHAR(10),
    IN p_email CHAR(255),
    IN p_level INT
)
BEGIN
    -- Update a record in the Hoi Vien table
    UPDATE `Hoi Vien`
    SET
        `password` = p_password,
        `ten` = p_ten,
        `sdt` = p_sdt,
        `email` = p_email,
        `level` = p_level
    WHERE
        `account` = p_account
        and `password` = `old_password`;
END; //
DELIMITER ;
DELIMITER //
CREATE PROCEDURE getPassword(
	in p_account char(255)
)
BEGIN
	select `password` from `hoi vien` where `account` = p_account;
END;
//
DELIMITER ;
DELIMITER //
CREATE PROCEDURE thongKeSPKhuyenMai(
	in ma_khuyen_mai int
)
BEGIN
	Select `ma san pham`, `ten san pham`, `so luong`
    from `san pham` as sp natural join
	(Select ct.`ma san pham`, ct.`so luong`
    from `hoa don` as hd natural join
	(SELECT *
	FROM chua as c natural join
	(SELECT km.`ngay bat dau`, km.`ngay ket thuc`,adsp.`ma san pham` 
    from `khuyen mai` AS km 
    natural join `ap dung san pham` as adsp
    where  km.`ma khuyen mai`= ma_khuyen_mai and km.`ma khuyen mai` = adsp.`ma khuyen mai`) as spkm
	where spkm.`ma san pham` = c.`ma san pham`) AS ct
    where hd.`ma hoa don` = ct.`ma hoa don` 
    and hd.`ngay thuc hien` >= ct.`ngay bat dau` 
    and hd.`ngay thuc hien` <= ct.`ngay ket thuc`) as kq
    where sp.`ma san pham` = kq.`ma san pham`;
END;
//
DELIMITER ;
DELIMITER //
CREATE PROCEDURE SelectHoiVienInfo()
BEGIN
    SELECT
        `ten` AS `name`,
        `sdt` AS `phoneNumber`,
        `email`,
        `so du` AS `balance`,
        `level`
    FROM
        `Hoi Vien`;
END //
DELIMITER ;

DELIMITER //

CREATE PROCEDURE AddHoiVien(
    IN p_account CHAR(255),
    IN p_password CHAR(255),
    IN p_ten CHAR(255),
    IN p_sdt CHAR(10),
    IN p_email CHAR(255)
)
BEGIN
	IF p_account IS NULL OR p_account = '' THEN
		SIGNAL SQLSTATE '45001'
		SET MESSAGE_TEXT = 'Khong duoc bo trong tai khoan hoi vien';
	END IF;

	IF p_password IS NULL OR p_password = '' THEN
		SIGNAL SQLSTATE '45002'
		SET MESSAGE_TEXT = 'Khong duoc bo trong mat khau hoi vien';
	END IF;

	IF p_ten IS NULL OR p_ten = '' THEN
		SIGNAL SQLSTATE '45003'
		SET MESSAGE_TEXT = 'Khong duoc bo trong ten hoi vien';
	END IF;

	IF p_sdt IS NULL OR p_sdt = '' THEN
		SIGNAL SQLSTATE '45004'
		SET MESSAGE_TEXT = 'Khong duoc bo trong so dien thoai hoi vien';
	END IF;

	IF p_email IS NULL OR p_email = '' THEN
		SIGNAL SQLSTATE '45005'
		SET MESSAGE_TEXT = 'Khong duoc bo trong email hoi vien';
	END IF;

	IF NOT REGEXP_LIKE(p_sdt, '^[0-9]+$') THEN
		SIGNAL SQLSTATE '45006'
		SET MESSAGE_TEXT = 'So dien thoai hoi vien chi duoc chua ki tu so, khong duoc co ki tu chu cai hay dac biet';
	END IF;

    IF EXISTS (SELECT 1 FROM `Hoi Vien` WHERE email = p_email) THEN
        SIGNAL SQLSTATE '45007'
        SET MESSAGE_TEXT = 'Email nay da duoc dang ky boi nguoi khac';
    END IF;

    IF EXISTS (SELECT 1 FROM `Hoi Vien` WHERE sdt = p_sdt) THEN
        SIGNAL SQLSTATE '45008'
        SET MESSAGE_TEXT = 'So dien thoai nay da duoc dang ky boi nguoi khac';
    END IF;

    INSERT INTO `Hoi Vien` (
        `account`,
        `password`,
        `ten`,
        `sdt`,
        `email`
    ) VALUES (
        p_account,
        p_password,
        p_ten,
        p_sdt,
        p_email
    );
END;

//

DELIMITER ;

DELIMITER //
CREATE PROCEDURE SelectKhuyenMaiInfo()
BEGIN
    SELECT
        `ma khuyen mai` AS `id`,
        `ten chuong trinh` AS `discountName`,
        `mo ta` AS `description`,
        `ngay bat dau` AS `startDate`,
        `ngay ket thuc` AS `endDate`,
        `loai` AS `category`,
        `dieu kien` AS `condition`,
        `muc giam` AS `discountValue`
    FROM
        `Khuyen Mai`;
END //
DELIMITER ;

DELIMITER //

CREATE PROCEDURE InsertKhuyenMai(
	IN p_ma_khuyen_mai INT,
    IN p_ten_chuong_trinh CHAR(255),
    IN p_mo_ta CHAR(255),
    IN p_ngay_bat_dau DATETIME,
    IN p_ngay_ket_thuc DATETIME,
    IN p_loai CHAR(255),
    IN p_dieu_kien INT,
    IN p_muc_giam FLOAT
)
BEGIN
	IF p_ma_khuyen_mai IS NULL OR p_ma_khuyen_mai = '' THEN
		SIGNAL SQLSTATE '45001'
		SET MESSAGE_TEXT = 'Khong duoc bo trong ma khuyen mai';
	END IF;
    
	IF p_ten_chuong_trinh IS NULL OR p_ten_chuong_trinh = '' THEN
		SIGNAL SQLSTATE '45001'
		SET MESSAGE_TEXT = 'Khong duoc bo trong ten chuong trinh khuyen mai';
	END IF;

	IF p_mo_ta IS NULL OR p_mo_ta = '' THEN
		SIGNAL SQLSTATE '45002'
		SET MESSAGE_TEXT = 'Khong duoc bo trong mo ta khuyen mai';
	END IF;

	IF p_ngay_bat_dau IS NULL THEN
		SIGNAL SQLSTATE '45003'
		SET MESSAGE_TEXT = 'Khong duoc bo trong ngay bat dau khuyen mai';
	END IF;

	IF p_ngay_ket_thuc IS NULL THEN
		SIGNAL SQLSTATE '45004'
		SET MESSAGE_TEXT = 'Khong duoc bo trong ngay ket thuc khuyen mai';
	END IF;

	IF p_loai IS NULL OR p_loai = '' THEN
		SIGNAL SQLSTATE '45005'
		SET MESSAGE_TEXT = 'Khong duoc bo trong loai khuyen mai';
	END IF;

	IF p_dieu_kien IS NULL OR p_dieu_kien = '' OR NOT p_dieu_kien REGEXP '^[0-9]+$'  OR p_dieu_kien <= 0 THEN
		SIGNAL SQLSTATE '45006'
		SET MESSAGE_TEXT = 'Khong duoc bo trong dieu kien khuyen mai, dieu kien phai la so nguyen duong';
	END IF;

	IF p_muc_giam IS NULL OR p_muc_giam = '' OR p_muc_giam <= 0 OR p_muc_giam >= 1 THEN
		SIGNAL SQLSTATE '45007'
		SET MESSAGE_TEXT = 'Khong duoc bo trong muc giam, muc giam phai lon hon 0 va nho hon 1';
	END IF;

    INSERT INTO `Khuyen Mai` (
		`ma khuyen mai`,
        `ten chuong trinh`,
        `mo ta`,
        `ngay bat dau`,
        `ngay ket thuc`,
        loai,
        `dieu kien`,
        `muc giam`
    ) VALUES (
		p_ma_khuyen_mai,
        p_ten_chuong_trinh,
        p_mo_ta,
        p_ngay_bat_dau,
        p_ngay_ket_thuc,
        p_loai,
        p_dieu_kien,
        p_muc_giam
    );
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE GetKhuyenMaiInfoForSanPham(IN p_ma_san_pham INT)
BEGIN
    IF p_ma_san_pham IS NULL OR p_ma_san_pham = '' OR NOT p_ma_san_pham REGEXP '^[0-9]+$' OR p_ma_san_pham <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ma san pham khong duoc bo trong va phai la so nguyen duong';
    END IF;
    
    SELECT km.`dieu kien` AS `condition`, km.`muc giam` AS `discountValue`
    FROM `Ap Dung San Pham` ap
    JOIN `Khuyen Mai` km ON ap.`ma khuyen mai` = km.`ma khuyen mai`
    WHERE ap.`ma san pham` = p_ma_san_pham;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE GetMayTinhInfo(IN may_tinh_id INT)
BEGIN
	IF may_tinh_id IS NULL OR may_tinh_id = '' OR NOT may_tinh_id REGEXP '^[0-9]+$' OR may_tinh_id <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ma may tinh khong duoc bo trong va phai la so nguyen duong';
    END IF;
    SELECT ch.`gia` AS `price`, kv.`phu thu` AS `additionalCharge`
    FROM `May Tinh` mt
    JOIN `Cau Hinh` ch ON mt.`id cau hinh` = ch.ID
    JOIN `Khu Vuc` kv ON mt.`phan loai khu vuc` = kv.`loai khu vuc`
    WHERE mt.ID = may_tinh_id;
END //

DELIMITER //

CREATE PROCEDURE GetActiveSessions()
BEGIN
    SELECT `Session ID` AS `id`, `gio bat dau` AS `startTime`, `id may tinh` AS `computerId`, `tai khoan hv` AS `memberId`
    FROM `Session`
    WHERE `gio ket thuc` IS NULL;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE GetActiveSessionsByIdMayTinh(IN may_tinh_id INT)
BEGIN
    IF may_tinh_id IS NULL OR may_tinh_id = '' OR NOT may_tinh_id REGEXP '^[0-9]+$' OR may_tinh_id <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ma san pham khong duoc bo trong va phai la so nguyen duong';
    END IF;

    SELECT `Session ID` AS `id`, `gio bat dau` AS `startTime`, `id may tinh` AS `computerId`, `tai khoan hv` AS `memberId`
    FROM `Session`
    WHERE `gio ket thuc` IS NULL AND `id may tinh` = may_tinh_id;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE GetActiveSessionsByTaiKhoanHV(IN tai_khoan_hv VARCHAR(255))
BEGIN
    IF tai_khoan_hv IS NULL OR tai_khoan_hv = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tai khoan hoi vien khong duoc bo trong';
    END IF;

    SELECT `Session ID` AS `id`, `gio bat dau` AS `startTime`, `id may tinh` AS `computerId`, `tai khoan hv` AS `memberId`
    FROM `Session`
    WHERE `gio ket thuc` IS NULL AND `tai khoan hv` = tai_khoan_hv;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE InsertHoaDon(IN tai_khoan_hv VARCHAR(255), IN id_le_tan INT)
BEGIN
    DECLARE existing_account INT;
    DECLARE existing_le_tan INT;

    IF tai_khoan_hv IS NULL OR tai_khoan_hv = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tai Khoan HV khong duoc bo trong';
    END IF;

    IF id_le_tan IS NULL OR id_le_tan = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ID Le Tan khong duoc bo trong';
    END IF;

    SELECT COUNT(*) INTO existing_account
    FROM `Hoi Vien`
    WHERE `account` = tai_khoan_hv;

    IF existing_account = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tai Khoan HV khong ton tai';
    END IF;

    SELECT COUNT(*) INTO existing_le_tan
    FROM `Le Tan`
    WHERE `ID` = id_le_tan;

    IF existing_le_tan = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'ID Le Tan khong ton tai';
    END IF;

    INSERT INTO `Hoa Don` (`ngay thuc hien`, `tong tien`, `tai khoan hv`, `id le tan`)
    VALUES (NOW(), 0, tai_khoan_hv, id_le_tan);
    
    SELECT LAST_INSERT_ID() AS `insertId`;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE addProductToBill(
    IN p_product_id INT,
    IN p_so_luong INT,
    IN p_bill_id INT
)
BEGIN
    DECLARE date_apply DATETIME;
    DECLARE muc_giam FLOAT;
    DECLARE ma_khuyen_mai INT;
    DECLARE thanh_tien INT;
    DECLARE bill_cost INT;
    DECLARE available_quantity INT;

    IF p_product_id IS NULL OR p_so_luong IS NULL OR p_bill_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tham so dau vao khong duoc bo trong';
    END IF;

    IF p_product_id <> 1 THEN
        SELECT `so luong` INTO available_quantity
        FROM `Dich Vu Them`
        WHERE `ma san pham` = p_product_id;

        IF available_quantity = 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'So luong cua san pham nay trong Dich Vu Them dang la 0';
        END IF;

        IF available_quantity < p_so_luong THEN
            SET p_so_luong = available_quantity;
        END IF;
    END IF;

    SELECT `ngay thuc hien` INTO date_apply FROM `Hoa Don` WHERE `ma hoa don` = p_bill_id;
    CALL getDiscountForProduct(p_product_id, p_so_luong, date_apply, ma_khuyen_mai, muc_giam);

    SELECT `gia niem yet` INTO thanh_tien FROM `San Pham` WHERE `ma san pham` = p_product_id;

    SELECT `tong tien` INTO bill_cost FROM `Hoa Don` WHERE `ma hoa don` = p_bill_id;

    IF muc_giam IS NOT NULL THEN
        SET thanh_tien = (1 - muc_giam) * thanh_tien * p_so_luong;
	ELSE
		SET thanh_tien = thanh_tien * p_so_luong;
    END IF;

    SET bill_cost = bill_cost + thanh_tien;
    UPDATE `Hoa Don` SET `tong tien` = bill_cost WHERE `ma hoa don` = p_bill_id;

    INSERT INTO `Chua` (`ma hoa don`, `ma san pham`, `so luong`) VALUES (p_bill_id, p_product_id, p_so_luong);

    IF p_product_id <> 1 THEN
        UPDATE `Dich Vu Them`
        SET `so luong` = available_quantity - p_so_luong
        WHERE `ma san pham` = p_product_id;
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE GetProductInfo(IN p_ten_san_pham VARCHAR(255))
BEGIN
    -- Validate input
    IF p_ten_san_pham IS NULL OR p_ten_san_pham = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Khong duoc bo trong Ten san pham';
    END IF;

    -- Check if there are any matching rows in San Pham
    IF EXISTS (
        SELECT 1
        FROM `San Pham`
        WHERE LOWER(`ten san pham`) LIKE LOWER(CONCAT('%', p_ten_san_pham, '%'))
    ) THEN
        -- If there are matching rows, select from San Pham with or without Dich Vu Them
        SELECT
			sp.`ma san pham` AS `productId`,
			sp.`ten san pham` AS `name`,
			sp.`gia niem yet` AS `price`,
			dv.`so luong` AS `instock`
		FROM `San Pham` sp
		LEFT JOIN `Dich Vu Them` dv ON sp.`ma san pham` = dv.`ma san pham`
			AND dv.`ma san pham` <> 1 -- Exclude the case where ma san pham is 1
		WHERE LOWER(sp.`ten san pham`) LIKE LOWER(CONCAT('%', p_ten_san_pham, '%'));

    ELSE
        -- If there are no matching rows, return an empty result set
        SELECT
            NULL AS `productId`,
            NULL AS `name`,
            NULL AS `price`,
            NULL AS `instock`
        WHERE 1 = 0; -- Always false condition to return an empty result set
    END IF;
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE GetHoaDonByMaHoaDon(IN p_ma_hoa_don INT)
BEGIN
    IF p_ma_hoa_don IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ma Hoa Don khong duoc bo trong';
    END IF;

    SELECT `ma hoa don` AS `id`, `ngay thuc hien` AS `date`, `tong tien` AS `totalPrice`, `tai khoan hv` AS `memberId`, `id le tan` AS `employeeId`
    FROM `Hoa Don`
    WHERE `ma hoa don` = p_ma_hoa_don;
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE GetChuaByMaHoaDon(IN p_ma_hoa_don INT)
BEGIN
    IF p_ma_hoa_don IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ma Hoa Don khong duoc bo trong';
    END IF;

    SELECT c.`ma san pham` AS `productId`, c.`so luong` AS `quantity`, sp.`ten san pham` AS `name`, sp.`gia niem yet` AS `price`
    FROM `Chua` c
    JOIN `San Pham` sp ON c.`ma san pham` = sp.`ma san pham`
    WHERE c.`ma hoa don` = p_ma_hoa_don;
END //

DELIMITER ;
drop procedure if exists getAllComputerInfo;
DELIMITER //
create procedure getAllComputerInfo()
Begin
	SELECT pc.*, ch.gia,kv.`phu thu`
    FROM `may tinh` as pc 
    join (SELECT id, gia from `cau hinh`) as ch
    join (SELECT `loai khu vuc`, `phu thu` from `khu vuc`) as kv
    on pc.`id cau hinh` = ch.id and pc.`phan loai khu vuc` = kv.`loai khu vuc` ORDER BY pc.ID ASC;
END;
//
DELIMITER ;
drop procedure if exists updateComputerInfo;
DELIMITER //

CREATE PROCEDURE updateComputerInfo(
    IN computerID INT,
    IN newHang CHAR(255),
    IN newNgayMua DATE,
    IN newPhanLoaiKhuVuc CHAR(255),
    IN newIdCauHinh INT
)
BEGIN
    UPDATE `May Tinh`
    SET
        hang = newHang,
        `ngay mua` = newNgayMua,
        `phan loai khu vuc` = newPhanLoaiKhuVuc,
        `id cau hinh` = newIdCauHinh
    WHERE ID = computerID;
END //
DELIMITER ;
drop procedure if exists addComputer;
DELIMITER //
CREATE PROCEDURE addComputer(
    IN newHang CHAR(255),
    IN newNgayMua DATE,
    IN newPhanLoaiKhuVuc CHAR(255),
    IN newIdCauHinh INT
)
BEGIN
    insert into `May Tinh` (hang,`ngay mua`,`phan loai khu vuc`,`id cau hinh`)
    values (newHang,newNgayMua,newPhanLoaiKhuVuc,newIdCauHinh);
END //
DELIMITER ;
drop procedure if exists getAllConfigInfo;
DELIMITER //
create procedure getAllConfigInfo()
Begin
	select * from `cau hinh` order by id asc;
END;
//
DELIMITER ;
drop procedure if exists updateConfigInfo;
DELIMITER //
CREATE PROCEDURE updateConfigInfo(
    IN p_id INT,
    IN p_kich_thuoc_man_hinh FLOAT,
    IN p_cpu CHAR(255),
    IN p_card_do_hoa CHAR(255),
    IN p_ram INT,
    IN p_tan_so_man_hinh INT,
    IN p_gia INT
)
BEGIN
    DECLARE v_valid BOOLEAN;

    -- Check if the new values meet the specified conditions
    SET v_valid = (p_gia > 0 AND p_ram > 4 AND p_kich_thuoc_man_hinh > 20 AND p_tan_so_man_hinh >= 60);

    IF v_valid THEN
        -- Update the record if the conditions are met
        UPDATE `Cau Hinh`
        SET
            `kich thuoc man hinh` = p_kich_thuoc_man_hinh,
            `cpu` = p_cpu,
            `card do hoa` = p_card_do_hoa,
            ram = p_ram,
            `tan so man hinh` = p_tan_so_man_hinh,
            gia = p_gia
        WHERE ID = p_id;

        SELECT 'Update successful' AS result;
    ELSE
        SELECT 'Update failed. New values do not meet the specified conditions' AS result;
    END IF;
END //
DELIMITER ;
DELIMITER //

CREATE PROCEDURE SignInForLeTan(IN p_account VARCHAR(255), IN p_password VARCHAR(255))

BEGIN
	IF p_account IS NULL OR p_account = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tai khoan Le Tan khong duoc bo trong';
    END IF;
    IF p_password IS NULL OR p_password = '' THEN
        SIGNAL SQLSTATE '45001'
        SET MESSAGE_TEXT = 'Mat khau khong duoc bo trong';
    END IF;
    
    SELECT `ID` AS `employeeID`, `account` FROM `Le Tan` WHERE `account` = p_account AND `password` = p_password;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE AuthorizeLeTan(IN p_id INT, IN p_account VARCHAR(255))

BEGIN
	IF p_account IS NULL OR p_account = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Khong tim thay tai khoan Le Tan trong token xac thuc';
    END IF;
    IF p_id IS NULL OR p_id = '' THEN
        SIGNAL SQLSTATE '45001'
        SET MESSAGE_TEXT = 'Khong tim thay ID Le Tan trong token xac thuc';
    END IF;
    
    SELECT `ID` AS `employeeID`, `account` FROM `Le Tan` WHERE `account` = p_account AND `ID` = p_id;
END //

DELIMITER ;




