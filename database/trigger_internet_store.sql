USE `internet_store`;
DELIMITER //

CREATE TRIGGER update_account_balance
AFTER INSERT
ON `Chua`
FOR EACH ROW
BEGIN
    DECLARE tai_khoan_hv VARCHAR(255);
    DECLARE new_so_du INT;
    
    IF NEW.`ma san pham` = 1 THEN
        SELECT `tai khoan hv` INTO tai_khoan_hv FROM `Hoa Don` WHERE `ma hoa don` = NEW.`ma hoa don`;
        SELECT `so du` INTO new_so_du FROM `Hoi Vien` WHERE `account` = tai_khoan_hv;
        SET new_so_du = new_so_du + NEW.`so luong` * 1000;
        UPDATE `Hoi Vien` SET `so du` = new_so_du WHERE `account` = tai_khoan_hv;
    END IF;
END;
//
DELIMITER ;
DELIMITER //
CREATE TRIGGER update_product_quantity
AFTER INSERT
ON `Ghi Hoa Don Chi`
FOR EACH ROW
BEGIN
    DECLARE so_luong INT;
    
    SELECT `so luong` INTO so_luong FROM `Dich Vu Them` WHERE `ma san pham` = NEW.`ma san pham`;
    SET so_luong = so_luong + NEW.`so luong`;
    UPDATE `Dich Vu Them` SET `so luong` = so_luong WHERE `ma san pham` = NEW.`ma san pham`;
END;
//
DELIMITER ;
DELIMITER //
CREATE TRIGGER out_of_balance BEFORE UPDATE ON `Hoi Vien`
FOR EACH ROW
BEGIN
    IF NEW.`so du` <= 0 THEN
        SET NEW.`so du` = 0;
    END IF;
END;
//
DELIMITER ;
DELIMITER //
CREATE TRIGGER add_product_for_discount BEFORE INSERT ON `ap dung san pham`
FOR EACH ROW
BEGIN
    declare loai_km varchar(255);
    select loai into loai_km from `khuyen mai` where `ma khuyen mai`=new.`ma khuyen mai`;
    if loai_km != 'product' then
		SIGNAL SQLSTATE '45000';
    end if;
END;
//
DELIMITER ;
DELIMITER //
create Trigger sign_up BEFORE INSERT ON `session`
for each row
BEGIN
	declare so_du int;
    select `so du` into so_du from `hoi vien` where `account` = new.`tai khoan hv`;
    if so_du <=0 then
		signal sqlstate '45000';
	end if;
END;
//
DELIMITER ;
DELIMITER //
create trigger sign_out before update on `session`
for each row
begin
	declare price int;
    declare phuthu int;
    declare cost float;
    declare period float;
    declare sodu int;
    if old.`gio ket thuc` is null then
		set period = new.`gio ket thuc` - new.`gio bat dau`;
        set period = period / 3600;
        SELECT gia INTO price FROM `may tinh` 
		JOIN `cau hinh` ON `may tinh`.`id cau hinh` = `cau hinh`.ID 
		WHERE `may tinh`.ID = new.`id may tinh`;
        
        SELECT `phu thu` INTO phuthu FROM `may tinh` 
		JOIN `khu vuc` ON `may tinh`.`phan loai khu vuc` = `khu vuc`.`loai khu vuc` 
		WHERE `may tinh`.ID = new.`id may tinh`;
        set cost = period*(price+phuthu);
        select `so du` into sodu from `hoi vien` where `account` = new.`tai khoan hv`;
        set sodu = sodu - cost;
        update `hoi vien` set `so du` = sodu where `account` = new.`tai khoan hv`;
	end if;
end;
//
DELIMITER ;