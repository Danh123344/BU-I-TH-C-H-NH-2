create database QuanLyDeAn2
on primary 
(
  size = 20MB
  ,filegrowth = 1MB
  ,maxsize = 500MB
  ,filename = 'E:\MaiThanhDanh\QuanLyDeAn2_Data.mdf'
  ,name = QuanLyDeAn2_Data
)
log on 
(
  size = 2MB
  ,filegrowth = 10%
  ,maxsize = 48MB
  ,filename = 'E:\MaiThanhDanh\QuanLyDeAn2_log.ldf'
  ,name = QuanLyDeAn2_Log
)

USE QuanLyDeAn2
GO

CREATE TABLE PHANCONG
(
	MaNV VARCHAR(9),
	MaDA VARCHAR(2) NOT NULL,
	ThoiGian numeric(18,0) NULL,
	
	
	PRIMARY KEY (MaNV,MaDA)
)

CREATE TABLE DeAn
(
	MaDA VARCHAR(2),
	TenDA nvarchar(50)null,
	DDiemDA varchar(20)NULL,
	
	
	PRIMARY KEY (MaDA)
)

CREATE TABLE NHANVIEN
(
	MaNV VARCHAR(9),
	HoNV nvarchar(15) null,
	TenLot nvarchar(30)  null,
	TenNv nvarchar(30)  null,
	NgSinh smalldatetime null,
	DiaChi nvarchar(150) null,
	Phai nvarchar (3) null,
	Luong numeric(18,0) null,
	Phong varchar(2)null
	
	
	PRIMARY KEY (MaNV)
)
    
CREATE TABLE PHONGBAN
(
	MaPhg VARCHAR(2),
	TenPhong nvarchar(20) null,
		
	PRIMARY KEY (MaPhg)
)

CREATE TABLE THANHnHAN
(
	MaNV VARCHAR(9),
	TenTN varchar(20) ,
	NgaySinh smalldatetime null,
	Phai varchar(3) null,
	QuanHe varchar(15) null
	
	
	
	PRIMARY KEY (MaNV,TenTN)
)


GO
ALTER TABLE PHANCONG
ADD CONSTRAINT PB_MaDA_FK FOREIGN KEY (MaDA)  REFERENCES DEAN (MaDA)


ALTER TABLE PHANCONG
ADD CONSTRAINT PB_MaNV_FK FOREIGN KEY (MaNV)  REFERENCES NHANVIEN (MaNV)

ALTER TABLE NHANVIEN
ADD CONSTRAINT PB_PHONG_FK FOREIGN KEY (PHONG)  REFERENCES PHONGBAN (MaPhg)

ALTER TABLE THANHnHAN
ADD CONSTRAINT THANHnHAN_MaNV_FK FOREIGN KEY (MaNV)  REFERENCES NHANVIEN (MaNV)


/**Trong bảng PHONGBAN, chỉnh sửa kiểu dữ liệu của cột TenPhg thành nvarchar(30)**/
ALTER TABLE PHONGBAN
ALTER COLUMN TenPhong nvarchar(30)
/**Trong bảng DEAN, chỉnh sửa kiểu dữ liệu của cột DDiemDA thành nvarchar(20)**/
ALTER TABLE DEAN 
ALTER COLUMN DDiemDA nvarchar(20)
/**Trong bảng THANnHAN, dữ liệu của cột Phai thành nvarchar(3)**/
ALTER TABLE THANHnHAN
ALTER COLUMN Phai nvarchar(3)
/**Trong bảng THANnHAN, kiểu dữ liệu của cột QuanHe thành nvarchar(15)**/
ALTER TABLE THANhnHAN
ALTER COLUMN QuanHe nvarchar(15)
/**Trong bảng THANNHAN, chỉnh sửa kiểu dữ liệu của cột TenTN thành nvarchar(20)**/
ALTER TABLE THANHnHAN
DROP CONSTRAINT THANHnHAN_MaNV_FK

ALTER TABLE THANHnHAN DROP CONSTRAINT PK__THANHnHA__63EA497D83FEFAF7
ALTER TABLE THANHnHAN
ALTER COLUMN TenTN nvarchar(20)


ALTER TABLE THANHnHAN
ADD CONSTRAINT FK_THANHnHAN_NHANVIEN
FOREIGN KEY (MaNV) REFERENCES NHANVIEN (MaNV);
/**Trong bảng NHANVIEN, thêm cột SoDienThoai với kiểu dữ liệu varchar(15)**/
ALTER TABLE NHANVIEN
ADD Sodienthoai varchar(15);
/**Trong bảng NHANVIEN, xóa cột SoDienThoai vừa tạo.**/
ALTER TABLE NHANVIEN
DROP column Sodienthoai
BEGIN /** NHANVIEN **/
	ALTER TABLE NHANVIEN
	NOCHECK CONSTRAINT ALL
	INSERT INTO NHANVIEN (MaNV, HoNV, TenLot, TenNv, NgSinh, DiaChi, Phai, Luong,Phong)
	VALUES (N'123',N'Đinh', N'Bá', N'Tiến', '02/27/1982', N'Mộ Đức', N'Nam', null, 5)
	INSERT INTO NHANVIEN (MaNV, HoNV, TenLot, TenNv, NgSinh, DiaChi, Phai, Luong,Phong)
    VALUES (N'234',N'Nguyễn', N'Thanh', N'Tùng', '08/12/1956', N'Sơn Tịng', N'Nam', null, 5)
	INSERT INTO NHANVIEN (MaNV, HoNV, TenLot, TenNv, NgSinh, DiaChi, Phai, Luong,Phong)
	VALUES (N'345',N'Bùi', N'Thuý', N'Vũ', null, N'Từ Nghĩa', N'Nữ', null, 4)
	INSERT INTO NHANVIEN (MaNV, HoNV, TenLot, TenNv, NgSinh, DiaChi, Phai, Luong,Phong)
	VALUES (N'456',N'Lê', N'Thị', N'Nhàn', '07/12/1962', N'Mộ Đức', N'Nữ', null, 4)
	INSERT INTO NHANVIEN (MaNV, HoNV, TenLot, TenNv, NgSinh, DiaChi, Phai, Luong,Phong)
	VALUES (N'567',N'Nguyễn', N'Thị Mạnh', N'Hùng', '03/25/1985', N'Sơn Tịnh', N'Nam', null, 5)
	INSERT INTO NHANVIEN (MaNV, HoNV, TenLot, TenNv, NgSinh, DiaChi, Phai, Luong,Phong)
	VALUES (N'678',N'Trần', N'Hồng', N'Quang', null, N'Bình Sơn', N'Nam', null, 5)
	INSERT INTO NHANVIEN (MaNV, HoNV, TenLot, TenNv, NgSinh, DiaChi, Phai, Luong,Phong)
	VALUES (N'789',N'Trần', N'Thanh', N'Tâm', '06/17/1972', N'Tp Quảng Ngãi', N'Nam', null, 5)
	INSERT INTO NHANVIEN (MaNV, HoNV, TenLot, TenNv, NgSinh, DiaChi, Phai, Luong,Phong)
	VALUES (N'890',N'Cao', N'Thanh', N'Huyền', null, N'Tự Nghĩa', N'Nữ', null, 1)
	INSERT INTO NHANVIEN (MaNV, HoNV, TenLot, TenNv, NgSinh, DiaChi, Phai, Luong,Phong)
	VALUES (N'901',N'Vương', N'Ngọc', N'Quyền', '12/12/1987', N'Mộ Đức', N'Nam', null, 1)
END

BEGIN /** PHONGBAN **/
	ALTER TABLE PHONGBAN
	NOCHECK CONSTRAINT ALL
	INSERT INTO PHONGBAN (MaPhg, TenPhong)
	VALUES ('1',N'QUẢN LÝ')
	INSERT INTO PHONGBAN (MaPhg, TenPhong)
	VALUES('4',N'ĐIỀU HÀNH')
	INSERT INTO PHONGBAN (MaPhg, TenPhong)
	VALUES('5',N'NGHIÊN CỨU')
	ALTER TABLE PHONGBAN
	CHECK CONSTRAINT ALL
END

BEGIN /** DEAN **/
	ALTER TABLE DeAn
	NOCHECK CONSTRAINT ALL
	INSERT INTO DEAN (MaDA, TenDA, DDiemDA)
	VALUES (1,N'Nâng cao chất lượng muối',N'Sa Huỳnh')
	INSERT INTO DEAN (MADA, TENDA, DDIEMDA)
	VALUES (10,N'Xây dựng nhà máy chế biến thủy sản',N'Dung Quất')
	INSERT INTO DEAN (MADA, TENDA, DDIEMDA)
	VALUES (2,N'Phát triển hạ tầng mạng',N'Tp Quãng Ngãi')
	INSERT INTO DEAN (MADA, TENDA, DDIEMDA)
	VALUES (20,N'Truyền tải cáp quang',N'Tp Quãng Ngãi')
	INSERT INTO DEAN (MADA, TENDA, DDIEMDA)
	VALUES (2,N'Tin học hóa trường học',N'Ba Tơ')
	INSERT INTO DEAN (MADA, TENDA, DDIEMDA)
	VALUES (30,N'Đào tạo nhân lực',N'Tịnh Phong')
	ALTER TABLE DEAN
	CHECK CONSTRAINT ALL
END

BEGIN /** THANNHAN **/
	ALTER TABLE THANHnHAN
	NOCHECK CONSTRAINT ALL
	INSERT INTO THANHnHAN(Manv, TenTN, NgaySinh,Phai, QuanHe)
	VALUES ('123', N'Châu', '10/30/2005',N'Nữ', N'Con gái')
	INSERT INTO THANHnHAN(Manv, TenTN, NgaySinh,Phai, QuanHe)
	VALUES ('123', N'Duy', '10/25/2005',N'Nam', N'Con trai')
	INSERT INTO THANHnHAN(Manv, TenTN, NgaySinh,Phai, QuanHe)
	VALUES ('123', N'Phương','10/30/1985',N'Nữ', N'Vợ chồng')
	INSERT INTO THANHnHAN(Manv, TenTN, NgaySinh,Phai, QuanHe)
	VALUES ('234', N'Thanh', '04/05/1980',N'Nữ', N'Con gái')
	INSERT INTO THANHnHAN(Manv, TenTN, NgaySinh,Phai, QuanHe)
	VALUES ('345', N'Dương', '10/30/1956',N'Nam', N'Vợ chồng')
	INSERT INTO THANHnHAN(Manv, TenTN, NgaySinh,Phai, QuanHe)
	VALUES ('345', N'Khang', '10/25/1982',N'Nam', N'Con trai')
	INSERT INTO THANHnHAN(Manv, TenTN, NgaySinh,Phai, QuanHe)
	VALUES ('456', N'Hùng', '01/01/1987',N'Nam', N'Con trai')
	INSERT INTO THANHnHAN(Manv, TenTN, NgaySinh,Phai, QuanHe)
	VALUES ('901', N'Thương', '04/05/1988',N'Nữ', N'Vợ chồng')
	ALTER TABLE THANHPHAN
	CHECK CONSTRAINT ALL
END
BEGIN /** PHANCONG **/
	ALTER TABLE PHANCONG
	NOCHECK CONSTRAINT ALL
	INSERT INTO PHANCONG (MaNV, MaDA, ThoiGian)
	VALUES ('123',1,33)
	INSERT INTO PHANCONG (MaNV, MaDA, ThoiGian)
	VALUES ('123',2,8)
	INSERT INTO PHANCONG (MaNV, MaDA, ThoiGian)
	VALUES ('345',10,10)
	INSERT INTO PHANCONG (MaNV, MaDA, ThoiGian)
	VALUES ('345',20,10)
	INSERT INTO PHANCONG (MaNV, MaDA, ThoiGian)
	VALUES ('345',3,10)
	INSERT INTO PHANCONG (MaNV, MaDA, ThoiGian)
	VALUES ('456',1,20)
	INSERT INTO PHANCONG (MaNV, MaDA, ThoiGian)
	VALUES ('456',2,20)
	INSERT INTO PHANCONG (MaNV, MaDA, ThoiGian)
	VALUES ('678',3,40)
	INSERT INTO PHANCONG (MaNV, MaDA, ThoiGian)
	VALUES ('789',10,35)
	INSERT INTO PHANCONG (MaNV, MaDA, ThoiGian)
	VALUES ('789',20,30)
	INSERT INTO PHANCONG (MaNV, MaDA, ThoiGian)
	VALUES ('789',30,5)
	ALTER TABLE PHANCONG
	CHECK CONSTRAINT ALL
END


