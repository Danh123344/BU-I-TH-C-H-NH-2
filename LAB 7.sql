use BAITHUCHANHSO1_2
go
--1 tạo thủ tục nhập liệucho bảng HANGSX, với các them biến truyền vào MAHANGSX, TENHANG, DIACHI, SDT, EMAIL, hãy kiểm tra xen TENHANG đã tồn tại trước đó hay chưa? nếu có rồi thì không cho nhập và đưa ra thông báo.
CREATE PROCEDURE sp_nhap_HANGSX
    @MAHANGSX nchar(10),
    @TENHANG nvarchar(20),
    @DIACHI nvarchar(30),
    @SDT nvarchar(20),
    @EMAIL nvarchar(30)
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS(SELECT 1 FROM HANGSX WHERE TENHANG = @TENHANG)
    BEGIN
        PRINT 'TENHANG đã tồn tại.';
        RETURN;
    END

    INSERT INTO HANGSX (MAHANGSX, TENHANG, DIACHI, SDT, EMAIL)
    VALUES (@MAHANGSX, @TENHANG, @DIACHI, @SDT, @EMAIL);
END
EXEC sp_nhap_HANGSX N'H01', N'SAMSUNG', N'KOREA', N'011-08271717', N'SS@GMAIL.COM.KR';

--2 2. tạo thủ tục nhập dữ liệu cho bảng sản phẩm với các tham biến truyền vào MASP, TENHANGSX, TENSP, SOLUONG, MAUSAC, GIABAN, DONVITINH, MOTA. Hãy kiểm tra xem nếu MASP đã tồn tại thì cập nhật thông tin sản phẩm theo mã, ngược lại thêm mới sản phẩm vào bảng SANPHAM
CREATE PROCEDURE sp_nhaphoaccapnhatSanPham
    @MASP nchar(10),
    @TENHANGSX nchar(10),
    @TENSP nvarchar(20),
    @SOLUONG int,
    @MAUSAC nvarchar(2),
    @GIABAN money,
    @DONVITINH nchar(10),
    @MOTA nvarchar(max)
AS
BEGIN
    IF EXISTS (SELECT * FROM SANPHAM WHERE MASP = @MASP)
    BEGIN
        UPDATE SANPHAM
        SET MAHANGSX = (SELECT MAHANGSX FROM HANGSX WHERE TENHANG = @TENHANGSX),
            TENSP = @TENSP,
            SOLUONG = @SOLUONG,
            MAUSAC = @MAUSAC,
            GIABAN = @GIABAN,
            DONVITINH = @DONVITINH,
            MOTA = @MOTA
        WHERE MASP = @MASP
    END
    ELSE
    BEGIN
        INSERT INTO SANPHAM (MASP, MAHANGSX, TENSP, SOLUONG, MAUSAC, GIABAN, DONVITINH, MOTA)
        VALUES (@MASP, (SELECT MAHANGSX FROM HANGSX WHERE TENHANG = @TENHANGSX), @TENSP, @SOLUONG, @MAUSAC, @GIABAN, @DONVITINH, @MOTA)
    END
END
EXEC sp_nhaphoaccapnhatSanPham N'SP06', N'H02', N'F2 PLUS', 100, N'X', 15000000, N'CHIẾC', N'HÀNG CẬN CAO CẤP';
--3. viết thủ tục xoá dữ liệu bảng HANGSX với tham biến là TEHHANH, nếu TENHANG chưa có thì thông báo, ngược lại xoá HANGSX với hãng bị xoá là TENHANG(lưu ý: xoá HANGSX thì phải xoá các sản phẩm mà HANGSX này cung ứng)
CREATE PROCEDURE USP_XOA_HANGSX
    @TENHANG NVARCHAR(20)
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM HANGSX WHERE TENHANG = @TENHANG)
        PRINT 'TENHANG KHÔNG TỒN TẠI'
    ELSE
        BEGIN
            DELETE FROM SANPHAM WHERE MAHANGSX = (SELECT MAHANGSX FROM HANGSX WHERE TENHANG = @TENHANG)
            DELETE FROM HANGSX WHERE TENHANG = @TENHANG
        END
END
EXEC USP_XOA_HANGSX N'XIAOMI';
--4 viết thủ tục nhập dữ liệu cho bảng nhập với các tham biến MANV, TENNV, GIOITINH, DIACHI, SDT, EMAIL,PHONG, và 1 biến cờ Flag, nếu FLag = 0 thì cập nhật dữu liệu cho bảng nhân viên theo MANV, ngược lại thêm mới nhân viên này
CREATE PROCEDURE sp_themcapnhat_nhanvien 
    @MANV NCHAR(10),
    @TENNV NVARCHAR(20),
    @GIOITINH NCHAR(10),
    @DIACHI NVARCHAR(30),
    @SDT NVARCHAR(20),
    @EMAIL NVARCHAR(30),
    @PHONG NVARCHAR(30),
    @FLAG BIT
AS
BEGIN
    IF @FLAG = 0
    BEGIN
        UPDATE NHANVIEN 
        SET TENNV = @TENNV,
            GIOITINH = @GIOITINH,
            DIACHI = @DIACHI,
            SDT = @SDT,
            EMAIL = @EMAIL,
            PHONG = @PHONG
        WHERE MANV = @MANV
    END
    ELSE
    BEGIN
        INSERT INTO NHANVIEN (MANV, TENNV, GIOITINH, DIACHI, SDT, EMAIL, PHONG)
        VALUES (@MANV, @TENNV, @GIOITINH, @DIACHI, @SDT, @EMAIL, @PHONG)
    END
END
EXEC sp_themcapnhat_nhanvien N'NV01', N'Nguyen Thi Thu', N'Nu', N'Ha Noi', N'0982626521', N'thu@gmail.com', N'Ke toan', 0;
--5viết thủ tục nhập dữ liệu cho bảng BANGNHAP với các tham biến SOHD, MASP, MANV, NGAYNHAP, SOLUONGN, DONGIAN, kiểm tra xem MASP có tồn tại trong bảng SANPHAM hay khôngMANV có tồn tại trong bảng NHAN VIEN hay không? nếu không thì thông báo, ngược lại thì hãy kiểm tra: nếu SOHD đã tồn tại thì cập nhật bảng BANGNHAP theo SOHD, ngược lại thêm mới bảng nhập.
CREATE PROCEDURE SP_INSERT_BANGNHAP
(
    @SOHDN NCHAR(10),
    @MASP NCHAR(10),
    @MANV NCHAR(10),
    @NGAYNHAP DATE,
    @SOLUONGN INT,
    @DONGIAN MONEY
)
AS
BEGIN
    SET NOCOUNT ON;
    
    IF NOT EXISTS(SELECT * FROM SANPHAM WHERE MASP = @MASP)
    BEGIN
        RAISERROR ('Mã sản phẩm không tồn tại trong bảng SANPHAM!', 16, 1);
        RETURN;
    END
    
    IF NOT EXISTS(SELECT * FROM NHANVIEN WHERE MANV = @MANV)
    BEGIN
        RAISERROR ('Mã nhân viên không tồn tại trong bảng NHANVIEN!', 16, 1);
        RETURN;
    END
  
    IF EXISTS(SELECT * FROM BANGNHAP WHERE SOHDN = @SOHDN)
    BEGIN
        UPDATE BANGNHAP
        SET MASP = @MASP,
            MANV = @MANV,
            NGAYNHAP = @NGAYNHAP,
            SOLUONGN = @SOLUONGN,
            DONGIAN = @DONGIAN
        WHERE SOHDN = @SOHDN
    END
    ELSE
    BEGIN
        INSERT INTO BANGNHAP (SOHDN, MASP, MANV, NGAYNHAP, SOLUONGN, DONGIAN)
        VALUES (@SOHDN, @MASP, @MANV, @NGAYNHAP, @SOLUONGN, @DONGIAN)
    END
END
EXECUTE SP_INSERT_BANGNHAP N'HD001', N'SP001', N'NV001', '2023-04-11', 10, 100000
--6 viết thủ tục nhập dữ liệu cho bảng BANGXUAT với các tham biến SOHD, MASP, MANV, NGAYXUAT, SOLUONGX, kiểm tra xem MASP có tồn tại trong bảng SANPHAM hay không MANV có tồn tại trong bảng NHAN VIEN hay không? SOLUONGX <= SOLUONG? nếu không thì thông báo, ngược lại thì hãy kiểm tra: nếu SOHD đã tồn tại thì cập nhật bảng BANGNHAP theo SOHD, ngược lại thêm mới bảng XUẤT.
CREATE PROCEDURE sp_ThemXuatHang (
    @SOHD nchar(10),
    @MASP nchar(10),
    @MANV nchar(10),
    @NGAYXUAT date,
    @SOLUONGX int
)
AS
BEGIN
    SET NOCOUNT ON;
    

    IF NOT EXISTS(SELECT MASP FROM SANPHAM WHERE MASP = @MASP)
    BEGIN
        RAISERROR('MASP không tồn tại trong bảng SANPAHM.', 16, 1);
        RETURN;
    END
    

    IF NOT EXISTS(SELECT MANV FROM NHANVIEN WHERE MANV = @MANV)
    BEGIN
        RAISERROR('MANV không tồn tại trong bảng NHANVIEN.', 16, 1);
        RETURN;
    END
    

    IF (SELECT SOLUONG FROM SANPHAM WHERE MASP = @MASP) < @SOLUONGX
    BEGIN
        RAISERROR('SOLUONGX lớn hơn SOLUONG trong bảng SANPHAM.', 16, 1);
        RETURN;
    END
    

    IF EXISTS(SELECT SOHDN FROM BANGNHAP WHERE SOHDN = @SOHD)
    BEGIN

        UPDATE BANGNHAP 
        SET MANV = @MANV, NGAYNHAP = @NGAYXUAT, SOLUONGN = @SOLUONGX, DONGIAN = (SELECT GIABAN FROM SANPHAM WHERE MASP = @MASP)
        WHERE SOHDN = @SOHD AND MASP = @MASP;
    END
    ELSE
    BEGIN

        INSERT INTO BANGXUAT (SOHDX, MASP, MANV, NGAYXUAT, SOLUONGX)
        VALUES (@SOHD, @MASP, @MANV, @NGAYXUAT, @SOLUONGX);
    END
END
--7viết thủ tục xoá dữu liệu bảng NHANVIEN với tham biến là MANV. nếu MANV chưa có thì thông báo, ngược lại  xoá NHANVIEN với NHANVIEN bị xoá là MANV (lưu ý: xoá NHANVIEN thì phải xoá các BANGNHAP, BANGXUAT mà nhan viên này tham gia)
CREATE PROCEDURE DeleteNhanVien
    @MANV NCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;
    
    IF NOT EXISTS (SELECT * FROM NHANVIEN WHERE MANV = @MANV)
    BEGIN
        PRINT 'Không tồn tại nhân viên có MANV là ' + @MANV + '.'
        RETURN;
    END
    

    DELETE FROM BANGNHAP WHERE MANV = @MANV;
    DELETE FROM BANGXUAT WHERE MANV = @MANV;
    

    DELETE FROM NHANVIEN WHERE MANV = @MANV;
    
    PRINT 'Đã xoá thành công nhân viên có MANV là ' + @MANV + '.';
END
EXEC DeleteNhanVien N'NV05';
--8viết thủ tục xoá dữ liệu bảng SANPHAM với tham biến MASP. nếu MASP chưa có thì thông báo, ngược lại xoá SANPHAM với SANPHAM bị xoá là MÁP.(lưu ý: xoá SANPHAM thì phải xoá các bảng BANGNHAP, BANGXUAT mà SANPHAM này cung ứng)
CREATE PROCEDURE DeleteSanPham
    @MASP NCHAR(10)
AS
BEGIN

    IF NOT EXISTS(SELECT * FROM SANPHAM WHERE MASP = @MASP)
    BEGIN
        RAISERROR('MASP does not exist in SANPHAM table', 16, 1)
        RETURN
    END

    DELETE FROM BANGNHAP WHERE MASP = @MASP
    

    DELETE FROM BANGXUAT WHERE MASP = @MASP
    

    DELETE FROM SANPHAM WHERE MASP = @MASP
    
END
EXEC DeleteSanPham 'SP01';