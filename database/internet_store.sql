drop schema if exists `internet_store`;
CREATE SCHEMA IF NOT EXISTS `internet_store`;
USE `internet_store`;
CREATE TABLE IF NOT EXISTS `Cau Hinh` (
    ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `kich thuoc man hinh` FLOAT NOT NULL,
    `cpu` CHAR(255) NOT NULL,
    `card do hoa` CHAR(255) NOT NULL,
    ram INT NOT NULL,
    `tan so man hinh` INT NOT NULL,
    gia INT NOT NULL,
    check (gia > 0 and ram>4 and `kich thuoc man hinh`>20 and `tan so man hinh` >= 60)
);
CREATE TABLE IF NOT EXISTS `Khu Vuc` (
    `loai khu vuc` CHAR(255) NOT NULL PRIMARY KEY,
    `phu thu` INT NOT NULL
);
CREATE TABLE IF NOT EXISTS `May Tinh` (
    ID INT NOT NULL auto_increment PRIMARY KEY,
    hang CHAR(255) NOT NULL,
    `ngay mua` DATE NOT NULL,
    `phan loai khu vuc` CHAR(255) NOT NULL,
    `id cau hinh` INT NOT NULL,
    FOREIGN KEY (`phan loai khu vuc`)
        REFERENCES `Khu Vuc` (`loai khu vuc`),
    FOREIGN KEY (`id cau hinh`)
        REFERENCES `Cau Hinh` (ID)
);
CREATE TABLE IF NOT EXISTS `Hoi Vien` (
    `account` CHAR(255) NOT NULL PRIMARY KEY,
    `password` CHAR(255) NOT NULL,
    `ten` CHAR(255) NOT NULL,
    `sdt` CHAR(10) NOT NULL UNIQUE,
    email CHAR(255),
    `so du` INT NOT NULL DEFAULT 0,
    `level` INT NOT NULL DEFAULT 0,
    CHECK (`level` >= 0 AND `so du` >= 0)
);
CREATE TABLE IF NOT EXISTS `Session` (
    `Session ID` INT NOT NULL PRIMARY KEY auto_increment,
    `gio bat dau` DATETIME NOT NULL,
    `gio ket thuc` DATETIME,
    `id may tinh` INT NOT NULL,
    `tai khoan hv` CHAR(255) NOT NULL,
    FOREIGN KEY (`id may tinh`)
        REFERENCES `May Tinh` (id),
    FOREIGN KEY (`tai khoan hv`)
        REFERENCES `Hoi Vien` (`account`)
);
CREATE TABLE IF NOT EXISTS `Nhan Vien` (
    ID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    `ho ten` CHAR(255) NOT NULL,
    `gioi tinh` INT NOT NULL,
    `ngay sinh` DATE NOT NULL,
    `ngay ki ket` DATE NOT NULL,
    `ngay het han` DATE NOT NULL,
    CHECK (`gioi tinh` >= 0 AND `gioi tinh` <= 3)
);
CREATE TABLE IF NOT EXISTS `Ky Thuat` (
    ID INT NOT NULL PRIMARY KEY,
    `loai hinh lam viec` CHAR(255) NOT NULL,
    FOREIGN KEY (ID)
        REFERENCES `Nhan Vien` (ID)
);
CREATE TABLE IF NOT EXISTS `Chuyen Mon` (
    ID INT NOT NULL,
    `chuyen mon` CHAR(255) NOT NULL PRIMARY KEY,
    FOREIGN KEY (ID)
        REFERENCES `Ky Thuat` (ID)
);
CREATE TABLE IF NOT EXISTS `Tap Vu` (
    ID INT NOT NULL PRIMARY KEY,
    `nhiem vu` CHAR(255) NOT NULL,
    FOREIGN KEY (ID)
        REFERENCES `Nhan Vien` (ID)
);
CREATE TABLE IF NOT EXISTS `Le Tan` (
    ID INT NOT NULL PRIMARY KEY,
    `account` CHAR(255) NOT NULL UNIQUE,
    `password` CHAR(255) NOT NULL,
    `lich truc` CHAR(255),
    FOREIGN KEY (ID)
        REFERENCES `Nhan Vien` (ID)
);
CREATE TABLE IF NOT EXISTS `Hoa Don` (
    `ma hoa don` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `ngay thuc hien` DATETIME NOT NULL,
    `tong tien` INT NOT NULL DEFAULT(0),
    `tai khoan hv` CHAR(255) NOT NULL,
    `id le tan` INT NOT NULL,
    FOREIGN KEY (`tai khoan hv`)
        REFERENCES `Hoi Vien` (`account`),
    FOREIGN KEY (`id le tan`)
        REFERENCES `Le Tan` (ID),
    CHECK (`tong tien` >= 0)
);
CREATE TABLE IF NOT EXISTS `San Pham` (
    `ma san pham` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `ten san pham` CHAR(255) NOT NULL,
    `gia niem yet` INT NOT NULL,
    CHECK (`gia niem yet` >= 0)
);
CREATE TABLE IF NOT EXISTS `Chua` (
    `ma hoa don` INT NOT NULL,
    `ma san pham` INT NOT NULL,
    `so luong` INT NOT NULL,
    FOREIGN KEY (`ma hoa don`)
        REFERENCES `Hoa Don` (`ma hoa don`),
    FOREIGN KEY (`ma san pham`)
        REFERENCES `San Pham` (`ma san pham`),
    PRIMARY KEY (`ma hoa don` , `ma san pham`)
);
CREATE TABLE IF NOT EXISTS `Gio Choi` (
    `ma san pham` INT NOT NULL PRIMARY KEY,
    FOREIGN KEY (`ma san pham`)
        REFERENCES `San Pham` (`ma san pham`)
);
CREATE TABLE IF NOT EXISTS `Nha Cung Cap` (
    id INT NOT NULL PRIMARY KEY,
    sdt CHAR(255) NOT NULL UNIQUE,
    ten CHAR(255) NOT NULL UNIQUE,
    address CHAR(255) NOT NULL
);
CREATE TABLE IF NOT EXISTS `Dich Vu Them` (
    `ma san pham` INT NOT NULL PRIMARY KEY,
    `id nha cung cap` INT NOT NULL,
    `so luong` INT NOT NULL,
    `loai san pham` CHAR(255) NOT NULL,
    `hinh anh` CHAR(255),
    `mo ta` CHAR(255),
    `loai the` CHAR(255),
    `nha phat hanh` CHAR(255),
    check (`so luong` >=0),
    FOREIGN KEY (`ma san pham`)
        REFERENCES `San Pham` (`ma san pham`),
    FOREIGN KEY (`id nha cung cap`)
        REFERENCES `Nha Cung Cap` (id)
);
CREATE TABLE IF NOT EXISTS `Hoa Don Chi` (
    `ma hoa don` INT NOT NULL PRIMARY KEY,
    `ngay thuc hien` DATETIME NOT NULL,
    `id le tan` INT NOT NULL,
    FOREIGN KEY (`id le tan`)
        REFERENCES `Le Tan` (id)
);
CREATE TABLE IF NOT EXISTS `Ghi Hoa Don Chi` (
    `ma hoa don chi` INT NOT NULL,
    `ma san pham` INT NOT NULL,
    `so luong` INT NOT NULL,
    `gia nhap` INT NOT NULL,
    CHECK (`so luong` > 0 AND `gia nhap` > 0),
    FOREIGN KEY (`ma san pham`)
        REFERENCES `Dich Vu Them` (`ma san pham`),
    FOREIGN KEY (`ma hoa don chi`)
        REFERENCES `Hoa Don Chi` (`ma hoa don`),
    PRIMARY KEY (`ma hoa don chi` , `ma san pham`)
);
CREATE TABLE IF NOT EXISTS `Bien Ban` (
    `ma bien ban` INT NOT NULL PRIMARY KEY,
    `phuong an xu ly` CHAR(255) NOT NULL,
    `tinh trang truoc bao tri` CHAR(255) NOT NULL,
    `chi phi sua chua` INT NOT NULL,
    `ngay thuc hien` DATE NOT NULL,
    `tinh trang sau bao tri` CHAR(255) NOT NULL,
    `id may tinh` INT NOT NULL,
    `ma hoa don chi` INT NOT NULL,
    CHECK (`chi phi sua chua` >= 0),
    FOREIGN KEY (`id may tinh`)
        REFERENCES `May Tinh` (id),
    FOREIGN KEY (`ma hoa don chi`)
        REFERENCES `Hoa Don Chi` (`ma hoa don`)
);
CREATE TABLE IF NOT EXISTS `Khuyen Mai` (
    `ma khuyen mai` INT NOT NULL PRIMARY KEY,
    `ten chuong trinh` CHAR(255) NOT NULL,
    `mo ta` CHAR(255),
    `ngay bat dau` DATETIME NOT NULL,
    `ngay ket thuc` DATETIME NOT NULL,
    loai char(255) NOT NULL,
    `dieu kien` INT NOT NULL,
    `muc giam` FLOAT NOT NULL,
    CHECK (`ngay ket thuc` > `ngay bat dau`
        AND `muc giam` > 0
        AND `muc giam` < 1
        AND `dieu kien` > 0)
);
CREATE TABLE IF NOT EXISTS `Ap Dung San Pham` (
    `ma san pham` INT NOT NULL,
    `ma khuyen mai` INT NOT NULL,
    FOREIGN KEY (`ma khuyen mai`)
        REFERENCES `Khuyen Mai` (`ma khuyen mai`),
    FOREIGN KEY (`ma san pham`)
        REFERENCES `San Pham` (`ma san pham`),
    PRIMARY KEY (`ma san pham` , `ma khuyen mai`)
);
CREATE TABLE IF NOT EXISTS `Ap Dung Hoa Don` (
    `ma hoa don` INT NOT NULL PRIMARY KEY,
    `ma khuyen mai` INT NOT NULL,
    FOREIGN KEY (`ma hoa don`)
        REFERENCES `Hoa Don` (`ma hoa don`),
    FOREIGN KEY (`ma khuyen mai`)
        REFERENCES `Khuyen Mai` (`ma khuyen mai`)
);

CREATE TABLE QuanTriVien (
STT INT NOT NULL DEFAULT 1,
    ID VARCHAR(16) PRIMARY KEY,
    Ten VARCHAR(255) NOT NULL,
    TenDangNhap VARCHAR(255) NOT NULL UNIQUE,
    MatKhau VARCHAR(255) NOT NULL,
    ChucVu VARCHAR(255) NOT NULL,
    RefreshToken TEXT
);
