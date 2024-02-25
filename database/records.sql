USE `internet_store`;
-- Insert into `nhan vien`
INSERT INTO `nhan vien` (`ho ten`, `gioi tinh`, `ngay sinh`, `ngay ki ket`, `ngay het han`)
VALUES ('nhanvien1', 1, '2003-01-01', '2023-01-01', '2024-01-01');

-- Insert into `Le Tan`
INSERT INTO `Le Tan` (id, `account`, `password`, `lich truc`)
VALUES (1, 'nhanvien1', '123 ','thu 2 thu 3 thu 4');

-- Insert into `cau hinh`
INSERT INTO `cau hinh` (id, `kich thuoc man hinh`, `cpu`, `card do hoa`, `ram`, `tan so man hinh`, `gia`)
VALUES (1, 24, 'i5', 'rtx-3060', 16, 60, 6000),
       (2, 30, 'i7', 'rtx-3080', 32, 120, 1000),
       (3, 33, 'i7', 'rtx-3100', 32, 240, 10000);

-- Insert into `khu vuc`
INSERT INTO `khu vuc` (`loai khu vuc`, `phu thu`)
VALUES ('khong may lanh', 0),
       ('may lanh', 1000),
       ('su kien', 5000);

-- Insert into `may tinh`
INSERT INTO `may tinh` (hang, `ngay mua`, `phan loai khu vuc`, `id cau hinh`)
SELECT 'intel', '2023-01-01', 'may lanh', FLOOR(RAND() * 3 )+ 1
FROM dual
LIMIT 10;

INSERT INTO `may tinh` (hang, `ngay mua`, `phan loai khu vuc`, `id cau hinh`)
SELECT 'intel', '2023-01-01', 'khong may lanh', FLOOR(RAND() * 3) + 1
FROM dual
LIMIT 10;

INSERT INTO `may tinh` (hang, `ngay mua`, `phan loai khu vuc`, `id cau hinh`)
VALUES ('intel', '2023-01-01', 'su kien', 3);

-- Insert into `San Pham`
INSERT INTO `San Pham` (`ma san pham`, `gia niem yet`, `ten san pham`)
VALUES (1, 1000, 'gio choi'),
       (2, 15000, 'mi tom'),
       (3, 50000, 'card viettel 50k'),
       (4, 100000, 'card viettel 100k'),
       (5, 20000, 'hu tiu'),
       (6, 20000, 'mi xao'),
       (7, 10000, 'sting'),
       (8, 10000, 'coca'),
       (9, 15000, 'bo huc'),
       (10, 20000, 'com cuon');

-- Insert into `Gio Choi`
INSERT INTO `Gio Choi` (`ma san pham`)
VALUES (1);

-- Insert into `Nha Cung Cap`
INSERT INTO `Nha Cung Cap` (id, sdt, ten, address)
VALUES (1, '666', 'hao hao', 'tphcm'),
       (2, '999', 'viettel', 'tphcm');

-- Insert into `dich vu them`
INSERT INTO `dich vu them` (`ma san pham`, `id nha cung cap`, `so luong`, `loai san pham`)
VALUES (2, 1, 1000, 'do an'),
       (3, 2, 1000, 'the nap'),
       (4, 2, 1000, 'the nap'),
       (5, 1, 1000, 'do an'),
       (6, 1, 1000, 'do an'),
       (7, 1, 1000, 'do an'),
       (8, 1, 1000, 'do an'),
       (9, 1, 1000, 'do an'),
       (10, 1, 1000, 'do an');
       
-- Insert into `quantrivien`
INSERT INTO `internet_store`.`quantrivien` (`STT`, `ID`, `Ten`, `TenDangNhap`, `MatKhau`, `ChucVu`) 
VALUES 
('1', '1', 'hoc', 'hoc', '2a$10$Gc8dmWKflXierwfMF.QldeK70W70vZBDapgQsjcu3X10daIQU1s/O', 'admin');

-- Insert into `Hoi Vien`
INSERT INTO `Hoi Vien` (`account`, `ten`, `email`, `password`, `sdt`)
VALUES 
('account1','abc1' ,'abc@abc.abc', '$2a$12$z.RpqTSe07c5UkPv2a0gXuva4CqyNYlAaafi7kws.Vf0mVnzAIBSG', '11'),
('account2','abc2' ,'abc@abc.abc', '$2a$12$z.RpqTSe07c5UkPv2a0gXuva4CqyNYlAaafi7kws.Vf0mVnzAIBSG', '12'),
('account3','abc3' ,'abc@abc.abc', '$2a$12$z.RpqTSe07c5UkPv2a0gXuva4CqyNYlAaafi7kws.Vf0mVnzAIBSG', '13'),
('account4','abc4' ,'abc@abc.abc', '$2a$12$z.RpqTSe07c5UkPv2a0gXuva4CqyNYlAaafi7kws.Vf0mVnzAIBSG', '14'),
('account5','abc5' ,'abc@abc.abc', '$2a$12$z.RpqTSe07c5UkPv2a0gXuva4CqyNYlAaafi7kws.Vf0mVnzAIBSG', '15'),
('account6','abc6' ,'abc@abc.abc', '$2a$12$z.RpqTSe07c5UkPv2a0gXuva4CqyNYlAaafi7kws.Vf0mVnzAIBSG', '16'),
('account7','abc7' ,'abc@abc.abc', '$2a$12$z.RpqTSe07c5UkPv2a0gXuva4CqyNYlAaafi7kws.Vf0mVnzAIBSG', '17'),
('account8','abc8' ,'abc@abc.abc', '$2a$12$z.RpqTSe07c5UkPv2a0gXuva4CqyNYlAaafi7kws.Vf0mVnzAIBSG', '18'),
('account9','abc9' ,'abc@abc.abc', '$2a$12$z.RpqTSe07c5UkPv2a0gXuva4CqyNYlAaafi7kws.Vf0mVnzAIBSG', '19'),
('account10','abc10' ,'abc@abc.abc', '$2a$12$z.RpqTSe07c5UkPv2a0gXuva4CqyNYlAaafi7kws.Vf0mVnzAIBSG', '110');

insert into `khuyen mai` (`ma khuyen mai`,`ten chuong trinh`,`ngay bat dau`,`ngay ket thuc`,`loai`,`dieu kien`,`muc giam`) 
values 
(202350,'happy net','2022-01-01','2025-01-01','product',5,0.5),
(202330,'happy net','2022-01-01','2025-01-01','product',4,0.3),
(202320,'happy net','2022-01-01','2025-01-01','product',3,0.2),
(202310,'happy net','2022-01-01','2025-01-01','product',2,0.1),
(202305,'happy net','2022-01-01','2025-01-01','product',2,0.05);
call  addNewDiscount(112023,'new member',NULL,now(),'2024-01-01 00:00:00',True,100000,0.2);
call  addNewDiscount(122023,'new member',NULL,now(),'2024-01-01 00:00:00',True,200000,0.3);
call  addNewDiscount(1112023,'new member',NULL,now(),'2024-01-01 00:00:00',True,300000,0.5);
insert into `ap dung san pham` (`ma san pham`, `ma khuyen mai`) values 
(3,202330),
(1,202350),
(4,202310),
(5,202305),
(4,202350),
(2,202330),
(2,202350);
insert into `Hoa Don` (`ngay thuc hien`,`tai khoan hv`,`id le tan`) values 
(NOW(),'account1',1),
(NOW(),'account2',1),
(NOW(),'account3',1),
(NOW(),'account4',1),
(NOW(),'account5',1),
(NOW(),'account6',1),
(NOW(),'account7',1);
CALL addProductToBill(1,10,1);
CALL addProductToBill(2,1,1);
CALL addProductToBill(3,1,1);
CALL addProductToBill(1,2,2);
CALL addProductToBill(3,10,2);
CALL addProductToBill(5,1,2);
CALL addProductToBill(4,7,3);
CALL addProductToBill(1,4,3);
CALL addProductToBill(2,1,3);
CALL addProductToBill(3,5,3);
CALL addProductToBill(1,1,4);
CALL addProductToBill(1,4,5);
CALL addProductToBill(1,3,6);
CALL addProductToBill(4,1,6);
CALL addProductToBill(1,10,7);
CALL addProductToBill(2,10,7);
CALL addProductToBill(3,10,7);
CALL addProductToBill(4,10,7);
CALL addProductToBill(5,10,7);
