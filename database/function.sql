USE internet_store;
DELIMITER //

CREATE FUNCTION getPCPrice(pc_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE price INT;
    DECLARE phuthu INT;

    SELECT gia INTO price FROM `may tinh` 
    JOIN `cau hinh` ON `may tinh`.`id cau hinh` = `cau hinh`.ID 
    WHERE `may tinh`.ID = pc_id;

    SELECT `phu thu` INTO phuthu FROM `may tinh` 
    JOIN `khu vuc` ON `may tinh`.`phan loai khu vuc` = `khu vuc`.`loai khu vuc` 
    WHERE `may tinh`.ID = pc_id;
	
    SET price = price + phuthu;
    RETURN price;
END;
//
DELIMITER ;
drop function if exists checkAccountPasswordHoiVien;
DELIMITER //
create function checkPCID(pc_id int)
RETURNS int
deterministic
BEGIN
	declare id_check int;
    select ID into id_check from `may tinh` where ID = pc_id;
    if id_check is not null then
		return 1;
	else
		return 0;
	end if ;
END;
//
DELIMITER ;
