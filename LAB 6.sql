use BAITHUCHANHSO1_2
go
--1 hãy xây dựng hàm đưa ra thông tin các sản phẩm của hãng có tên nhập từ bàn phím
CREATE FUNCTION fn_DanhSachSanPhamTheoHang(@tenHang nvarchar(50))
RETURNS TABLE
AS
RETURN
SELECT sp.masp, sp.tensp, sp.soluong, sp.mausac, sp.giaban, sp.donvitinh, sp.mota
FROM SANPHAM sp
INNER JOIN HANGSX hs ON sp.mahangsx = hs.mahangsx
WHERE hs.tenhang = @tenHang

SELECT * FROM DBO.fn_DanhSachSanPhamTheoHang(N'SAMSUNG')
--2 hãy viết hàm đưa ra danh sách các sản phẩm theo hãng sản xuất tương ứng đã được nhập từ ngày x đến ngày y, với x,y được nhập từ bàn phím
CREATE FUNCTION DanhSachSanPhamTheoHangSXVaKhoangThoiGianNhap(@x DATE, @y DATE)
RETURNS TABLE
AS
RETURN
    SELECT HANGSX.TENHANG, SANPHAM.MASP, SANPHAM.TENSP, SANPHAM.SOLUONG, SANPHAM.GIABAN, SANPHAM.DONVITINH, BANGNHAP.NGAYNHAP
    FROM SANPHAM
    JOIN BANGNHAP ON SANPHAM.MASP = BANGNHAP.MASP
    JOIN HANGSX ON SANPHAM.MAHANGSX = HANGSX.MAHANGSX
    WHERE BANGNHAP.NGAYNHAP BETWEEN @x AND @y
    GROUP BY HANGSX.TENHANG, SANPHAM.MASP, SANPHAM.TENSP, SANPHAM.SOLUONG, SANPHAM.GIABAN, SANPHAM.DONVITINH, BANGNHAP.NGAYNHAP
SELECT * FROM DBO.DanhSachSanPhamTheoHangSXVaKhoangThoiGianNhap(N'1-1-2019', N'1-1-2021')
--3. xây dựng hàm đưua ra danh sách các sản phẩm theo hãng sản xuất và 1 lựa chọn, nếu lựa chọn = 0 thì đưa ra danh sách các sản phẩm có soluong = 0, ngược lại lựa chọn =1 thì đưua ra các danh sách các sản phẩm có soluong >0 
CREATE FUNCTION DANHSACHSANPHAM (@X nchar(10), @Y int)
RETURNS TABLE
AS
RETURN 
(
    SELECT MASP, TENSP, SOLUONG
    FROM SANPHAM
    WHERE MAHANGSX = @X
    AND (SOLUONG = 0 AND @Y = 0 OR SOLUONG > 0 AND @Y = 1)
)
SELECT * FROM DANHSACHSANPHAM(N'H01', 1)
--4. hãy xây dựng hàm đưa ra danh sách các nhân viên có tên phòng nhập từ bàn phím

CREATE FUNCTION DANHSACHNHANVIEN(@TEN NVARCHAR(50))
RETURNS TABLE
AS
RETURN 
(
	SELECT *
	FROM NHANVIEN
	WHERE PHONG = @TEN
)
SELECT *FROM dbo.DANHSACHNHANVIEN(N'KẾ TOÁN');
--5. tạo hàm đưa ra danh sách các hãng sản xuất có địa chỉ nhập vào từ bàn phím (Lưu ý- dùng hàm like để lọc)
CREATE FUNCTION dbo.fn_DanhSachHangSXTheoDiaChi
    (@dia_chi NVARCHAR(30))
RETURNS TABLE
AS
RETURN
    SELECT MAHANGSX, TENHANG, DIACHI, SDT, EMAIL
    FROM HANGSX
    WHERE DIACHI LIKE '%' + @dia_chi + '%';
SELECT*FROM fn_DanhSachHangSXTheoDiaChi (N'KOREA')
--6.hãy viết hàm đưa ra danh sách các sản phẩm và hãng sản xuất tương ứng đã được xuất từ năm x đến năm y, với x,y nhập từ bàn phím
CREATE FUNCTION DANH_SACH_SAN_PHAM_XUAT_TRONG_KHOANG_THOI_GIAN(@nam_x INT, @nam_y INT)
RETURNS TABLE
AS
RETURN
SELECT SANPHAM.MASP, SANPHAM.TENSP, HANGSX.TENHANG, BANGXUAT.NGAYXUAT
FROM SANPHAM
JOIN HANGSX ON SANPHAM.MAHANGSX = HANGSX.MAHANGSX
JOIN BANGXUAT ON SANPHAM.MASP = BANGXUAT.MASP
WHERE YEAR(BANGXUAT.NGAYXUAT) BETWEEN @nam_x AND @nam_y
GO
SELECT * FROM DANH_SACH_SAN_PHAM_XUAT_TRONG_KHOANG_THOI_GIAN(N'2019', N'2021')
--7. hãy xây dựng hàm đưa ra danh sách các sản phẩm theo hãng sản xuất cad 1 lựa chọn, nếu lựa chọn =0 thì đưa ra danh sách các sản phẩm đã được nhập, ngược lại lựa chọn =1 thì đưa ra danh sách các sản phẩm đã được xuất.
CREATE FUNCTION DANHSACHSANPHAM1 (@MAHANGSX NCHAR(10), @LUACHON INT)
RETURNS TABLE
AS
RETURN 
(
    SELECT SP.MASP, SP.TENSP, SP.MAUSAC, SP.GIABAN, SP.DONVITINH,
        CASE 
            WHEN @LUACHON = 0 THEN BN.NGAYNHAP
            WHEN @LUACHON = 1 THEN BX.NGAYXUAT
        END AS 'NGAYNHAPXUAT'
    FROM SANPHAM SP
    LEFT JOIN BANGNHAP BN ON SP.MASP = BN.MASP
    LEFT JOIN BANGXUAT BX ON SP.MASP = BX.MASP
    WHERE SP.MAHANGSX = @MAHANGSX AND (@LUACHON = 0 OR @LUACHON = 1)
)
select * from DANHSACHSANPHAM1(N'H01',1)
--8. hãy xây dựng hàm đưa ra danh sách các nhân viên đã nhập hàng vào  ngày được đưa vào bàn phím
CREATE FUNCTION danhsachnhanvien1(@date DATE)
RETURNS TABLE
AS
RETURN (
    SELECT NHANVIEN.MANV, NHANVIEN.TENNV, BANGNHAP.SOLUONGN, BANGNHAP.DONGIAN, BANGNHAP.NGAYNHAP
    FROM NHANVIEN
    JOIN BANGNHAP ON NHANVIEN.MANV = BANGNHAP.MANV
    WHERE BANGNHAP.NGAYNHAP = @date
)
select * from danhsachnhanvien1('2019-02-05')
--9. hãy xây dựng hàm đưa ra danh sách các sản phẩm có giá trị bán từ x tới y do công ty z sản xuất với x,y,z được nhập từ bàn phím
CREATE FUNCTION danhsachsanpham2
(
    @min_price MONEY,
    @max_price MONEY,
    @company_name NVARCHAR(20)
)
RETURNS TABLE
AS
RETURN (
    SELECT 
        SANPHAM.MASP, 
        SANPHAM.TENSP, 
        SANPHAM.GIABAN
    FROM 
        SANPHAM
        INNER JOIN HANGSX ON SANPHAM.MAHANGSX = HANGSX.MAHANGSX
    WHERE 
        HANGSX.TENHANG = @company_name 
        AND SANPHAM.GIABAN BETWEEN @min_price AND @max_price
);
SELECT *
FROM danhsachsanpham2('8000000', '19000000', N'SAMSUNG');
--10. xây dựng hàm không tham biến đưa ra danh sách cá sản phẩm và hãng sản xuất tương ứng
CREATE FUNCTION danhsachcacsanphamvahangsanxuat()
RETURNS TABLE
AS
RETURN (
  SELECT SANPHAM.TENSP, HANGSX.TENHANG
  FROM SANPHAM
  JOIN HANGSX ON SANPHAM.MAHANGSX = HANGSX.MAHANGSX
)
SELECT * FROM danhsachcacsanphamvahangsanxuat()