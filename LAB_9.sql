--1. TẠO TRIGER KIỂM SOÁT VIỆC NHẬP DỮ LIỆU CHO BẢNG NHẬP, HÃY KIỂM TRA CÁC RÀNG BUỘC TOÀN VẸN: MASP CÓ TRONG BẢNG SẢN PHẨM CHƯA? MANV CÓ TRONG BẢNG NHÂN VIÊN CHƯA? KIỂM TRA CÁC RÀNG BUỘC DỮ LIỆU: SOLUONGN VÀ DONGIAN>0? SAU KHI NHẬP THÌ SOLUONG Ở BẢNG SANPHAM SẼ ĐƯỢC CẬP NHẬT THEO

CREATE TRIGGER TR_BANGNHAP
ON BANGNHAP
AFTER INSERT
AS
BEGIN
	IF NOT EXISTS (SELECT MASP FROM SANPHAM WHERE MASP IN (SELECT MASP FROM INSERTED))
	BEGIN
		RAISERROR ('MASP khong ton tai trong bang SANPHAM!', 16, 1)
		ROLLBACK TRANSACTION
		RETURN
	END
	IF NOT EXISTS (SELECT MANV FROM NHANVIEN WHERE MANV IN (SELECT MANV FROM INSERTED))
	BEGIN
		RAISERROR ('MANV khong ton tai trong bang NHANVIEN!', 16, 1)
		ROLLBACK TRANSACTION
		RETURN
	END	
	IF EXISTS (SELECT * FROM INSERTED WHERE SOLUONGN <= 0 OR DONGIAN <= 0)
	BEGIN
		RAISERROR ('SOLUONGN va DONGIAN phai lon hon 0!', 16, 1)
		ROLLBACK TRANSACTION
		RETURN
	END	
	UPDATE SANPHAM
	SET SOLUONG = SOLUONG + INSERTED.SOLUONGN
	FROM SANPHAM
	INNER JOIN INSERTED
	ON SANPHAM.MASP = INSERTED.MASP
END

select * from SANPHAM
select * from NHANVIEN
select * from BANGNHAP
insert into BANGNHAP values('N07','SP01','NV01','3/7/2018',300,1500000)
--2. TẠO TRIGGER KIỂM SOÁT VIỆC NHẬP DỮ LIỆU CHO BẢNG XUẤT, HÃY KIỂM TRA CÁC RÀNG BUỘC TOÀN VẸN: MASP CÓ TRONG BẢNG SẢN PHẨM CHƯA? MANV CÓ TRONG BẢNG NHÂN VIÊN CHƯA? KIỂM TRA CÁC RÀNG BUỘC DỮ LIỆU: SOLUONGX< SOLUONG TRONG BẢNG SẢN PHẨM? SAU KHI XUẤT THÌ SOLUONG Ở BẢNG SAN PHAM SẼ ĐƯỢC CẬP NHẬT THEO

CREATE TRIGGER TR_BANGXUAT ON BANGXUAT
AFTER INSERT
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM SANPHAM WHERE MASP = (SELECT MASP FROM inserted))
    BEGIN
        RAISERROR('Mã sản phẩm không tồn tại trong bảng SANPHAM', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

    IF NOT EXISTS (SELECT * FROM NHANVIEN WHERE MANV = (SELECT MANV FROM inserted))
    BEGIN
        RAISERROR('Mã nhân viên không tồn tại trong bảng NHANVIEN', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

    DECLARE @soluong INT, @soluongx INT
    SELECT @soluong = SOLUONG FROM SANPHAM WHERE MASP = (SELECT MASP FROM inserted)
    SELECT @soluongx = SOLUONGX FROM inserted
    IF @soluongx > @soluong
    BEGIN
        RAISERROR('Số lượng xuất vượt quá số lượng trong kho', 16, 1)
        ROLLBACK TRANSACTION
        RETURN
    END

    UPDATE SANPHAM
    SET SOLUONG = @soluong - @soluongx
    WHERE MASP = (SELECT MASP FROM inserted)
END
select * from SANPHAM
select * from NHANVIEN
select * from BANGXUAT
insert into BANGXUAT values('X06','SP01','NV03','3/7/2019',2)
--3. TẠO TRIGGER KIỂM SOÁT VIỆC XOÁ PHIẾU XUẤT, KHI PHIẾU XUẤT XOÁ THÌ SỐ LƯỢNG HÀNG TRONG BẢNG SẢN PHẨM SẼ ĐƯỢC CẬP NHẬT TĂNG LÊN--
CREATE TRIGGER TR_XOA_PHIEU_XUAT
ON BANGXUAT
AFTER DELETE
AS
BEGIN
    UPDATE SANPHAM
    SET SOLUONG = SOLUONG + D.SOLUONGX
    FROM SANPHAM SP
    JOIN DELETED D ON SP.MASP = D.MASP
END
select * from SANPHAM
select * from BANGXUAT
DELETE FROM BANGXUAT WHERE SOHDX = N'X06';
--4. TẠO TRIGGER CHO VIỆC CẬP NHẬT LẠI SỐ LƯỢNG XUẤT TRONG BẢNG XUẤT, HÃY KIỂM TRA XEM SỐ LƯỢNG XUẤT THAY ĐỔI CÓ NHỎ HƠN SOLUONG TRONG BẢNG SANPHAM HAY KO? SỐ BẢN GHI THAY ĐỔI> 1 BẢN GHI HAY KHÔNG? NẾU THOẢ MÃN THÌ CHO PHÉP UPDATE BẢNG XUẤT VÀ UPDATE LẠI SOLUONG TRONG BANG SANPHAM
CREATE TRIGGER trg_UpdateSoLuongXuat
ON BANGXUAT
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN SANPHAM s ON i.MASP = s.MASP
        WHERE i.SOLUONGX > s.SOLUONG
    )
    BEGIN
        RAISERROR('Số lượng xuất không thể lớn hơn số lượng sản phẩm', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    DECLARE @Count INT;
    SET @Count = (SELECT COUNT(*) FROM deleted);
    IF @Count = 0
    BEGIN
        RETURN;
    END
    UPDATE SANPHAM
    SET SOLUONG = SOLUONG + (SELECT SUM(i.SOLUONGX - d.SOLUONGX) FROM inserted i INNER JOIN deleted d ON i.SOHDX = d.SOHDX AND i.MASP = d.MASP)
    FROM SANPHAM s
    INNER JOIN (
        SELECT i.MASP, i.SOHDX, SUM(i.SOLUONGX) AS SOLUONGX
        FROM inserted i
        GROUP BY i.MASP, i.SOHDX
    ) x ON s.MASP = x.MASP
    INNER JOIN (
        SELECT d.MASP, d.SOHDX, SUM(d.SOLUONGX) AS SOLUONGX
        FROM deleted d
        GROUP BY d.MASP, d.SOHDX
    ) y ON x.MASP = y.MASP AND x.SOHDX = y.SOHDX
    WHERE s.SOLUONG >= x.SOLUONGX;
END
--5. Tạo trigger cho việc cập nhật lại số lượng Nhập trong bảng Nhập, Hãy kiểm tra xem số bản ghi thay đổi >1 bản ghi hay không? nếu thỏa mãn thì cho phép update bảng Nhập và update lại soluong trong bảng sanpham.
CREATE TRIGGER tr_Nhap_Update
ON Nhap
AFTER UPDATE
AS
BEGIN
  DECLARE @count INT
  SET @count = (SELECT COUNT(*) FROM inserted)
  
  IF @count > 1
  BEGIN
    RAISERROR('Khong duoc cap nhat qua 1 ban ghi!', 16, 1)
    ROLLBACK TRANSACTION
    RETURN
  END
  
  DECLARE @masp nchar(10)
  DECLARE @soluongN int
  
  SELECT @masp = i.masp, @soluongN = i.soluongN
  FROM inserted i

  DECLARE @soluongS int
  
  SELECT @soluongS = s.soluong
  FROM Sanpham s
  WHERE s.masp = @masp

  IF @soluongN - @soluongS > 0
  BEGIN
    RAISERROR('So luong nhap khong duoc lon hon so luong trong kho!', 16, 1)
    ROLLBACK TRANSACTION
    RETURN
  END

  UPDATE Sanpham
  SET soluong = soluong - (@soluongS - @soluongN)
  WHERE masp = @masp
END

--6. Tạo trigger kiểm soát việc xóa phiếu nhập, khi phiếu nhập xóa thì số lượng hàng trong bảng sanpham sẽ được cập nhật giảm xuống.
CREATE TRIGGER update_soluongsanpham
ON Nhap
AFTER DELETE
AS

BEGIN
    
    UPDATE Sanpham
    SET Soluong = Sanpham.Soluong - deleted.soluongN
    FROM Sanpham
    JOIN deleted ON Sanpham.Masp = deleted.Masp
END
