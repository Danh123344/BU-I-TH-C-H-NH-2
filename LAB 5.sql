USE BAITHUCHANHSO1_2
GO
/*1. HÃY XÂY DỰNG HÀM ĐƯA RA TÊN HÃNG SẢN XUẤT KHI NHẬP VÀO MÃ SẢN PHẨM TỪ BÀN PHÍM*/
CREATE FUNCTION LayTenHangSX(@MASP varchar(10))
RETURNS varchar(50)
AS
BEGIN
DECLARE @TENHANGSX varchar(50)
SELECT @TENHANGSX = hs.TENHANG
FROM SANPHAM SP
INNER JOIN HANGSX hs ON SP.MAHANGSX = hs.MAHANGSX
WHERE SP.MASP = @MASP
RETURN @TENHANGSX
END

SELECT dbo.LayTenHangSX('SP01')

/*2. */
create function thongkenhaptheonam(@x int,@y int)
returns int
as
begin
declare @TONGTIEN int
select @TONGTIEN = sum(SOLUONGN*DONGIAN)
from BANGNHAP
where year(NGAYNHAP) between @x and @y
return @TONGTIEN
end

SELECT DBO.thongkenhaptheonam(2019, 2020) as thongke

/*3. THỐNG KÊ TỔNG TỔNG SỐ LƯỢNG THAY ĐỔI NHẬP XUẤT CỦA TÊN SẢN PHẨM X TRONG NĂM Y, VỚI X Y ĐƯỢC NHẬP TỪ BÀN PHÍM*/
CREATE FUNCTION TongSoLuongThayDoi_NhapXuat(@TENSP varchar(50), @NAM int)
RETURNS int
AS
BEGIN
DECLARE @TongSoLuongThayDoi int
SET @TongSoLuongThayDoi = 0

SELECT @TongSoLuongThayDoi = SUM(ISNULL(SOLUONGX,0)) - SUM(ISNULL(SOLUONGN,0))
FROM SANPHAM SP
LEFT JOIN BANGNHAP N ON SP.MASP = N.MASP AND YEAR(N.NGAYNHAP) = @Nam
LEFT JOIN BANGXUAT X ON SP.MASP = X.MASP AND YEAR(X.NGAYXUAT) = @Nam
WHERE SP.TENSP = @TenSP

RETURN @TongSoLuongThayDoi
END
 
 SELECT DBO.TongSoLuongThayDoi_NhapXuat(N'GALAXY NOTE 11', 2020) AS KQ

 /*4. XÂY ĐỰNG HÀM ĐƯA RA TỔNG GIÁ TRỊ NHẬP TỪ NGÀY NHẬP X ĐẾN NGÀY NHẬP Y, VỚI X,Y ĐƯỢC NHẬP TỪ BÀN PHÍM */
CREATE FUNCTION tong_gia_tri_nhap_tu_ngay_den_ngay(@X DATE, @Y DATE)
RETURNS NUMERIC
BEGIN
    DECLARE @tong_gia_tri NUMERIC;
    SET @tong_gia_tri = 0;
    SELECT @tong_gia_tri = SUM(N.SOLUONGN * N.DONGIAN)
    FROM BANGNHAP N
    WHERE N.NGAYNHAP BETWEEN @X AND @Y;
    RETURN @tong_gia_tri;
END;
/*5. XÂY ĐỰNG HÀM ĐƯA RA TỔNG GIÁ TRỊ XUẤT CỦA HÃNG TÊN LÀ A, TRONG NĂM TÀI KHOÁ X, VỚI A,X ĐƯỢC NHẬP TỪ BÀN PHÍM*/
CREATE FUNCTION tong_gia_tri_xuat_cua_hang_ten_A_trong_nam_tai_khoa_X(@A VARCHAR(50), @X INT)
RETURNS NUMERIC
BEGIN
    DECLARE @tong_gia_tri NUMERIC;
    SET @tong_gia_tri = 0;
    SELECT @tong_gia_tri = SUM(X.SOLUONGX * S.GIABAN)
    FROM BANGXUAT X
    INNER JOIN SANPHAM S ON X.MASP = S.MASP
    WHERE YEAR(X.NGAYXUAT) = @X AND S.MAHANGSX = @A;
    RETURN @tong_gia_tri;
END;
/*6.  XÂY DỰNG HÀM THỐNG KÊ SỐ LƯỢNG NHÂN VIÊN MỖI PHÒNG VỚI TÊN PHÒNG NHẬP TỪ BÀN PHÍM*/
CREATE FUNCTION thong_ke_so_luong_nhan_vien_moi_phong_voi_ten_phong(@ten_phong VARCHAR(50))
RETURNS INT
BEGIN
    DECLARE @so_luong INT;
    SET @so_luong = 0;
    SELECT @so_luong = COUNT(*) 
    FROM NHANVIEN N   
    WHERE N.PHONG = @ten_phong;
    RETURN @so_luong;
END;
/*7. VIẾT HÀM THỐNG KÊ XEM TÊN SẢN PHẨM X ĐÃ ĐƯỢC XUẤT BAO NHIÊU SẢN PHẨM TRONG NGÀY Y, VỚI X,Y ĐƯỢC NHẬP TỪ BÀN PHÍM*/
CREATE FUNCTION thong_ke_so_luong_xuat(@X NVARCHAR(50), @Y DATE)
RETURNS INT
AS
BEGIN
    DECLARE @so_luong INT;
    SELECT @so_luong = SUM(X.SOLUONGX)
    FROM BANGXUAT X
    INNER JOIN SANPHAM SP ON X.MASP = SP.MASP
    WHERE SP.TENSP = @X AND X.NGAYXUAT = @Y;
    RETURN @so_luong;
END;
/*8. VIẾT HÀM TRẢ VẾ SỐ ĐIẸN THOẠI CỦA NHÂN VIÊN ĐÃ XUẤT SỐ HOÁ ĐƠN X VỚI X NHẬP TỪ BÀN PHÍM*/
CREATE FUNCTION tra_ve_so_dien_thoai_nhan_vien_xuat_hd(@X INT)
RETURNS NVARCHAR(20)
BEGIN
    DECLARE @so_dien_thoai NVARCHAR(20);
    SELECT @so_dien_thoai = NV.SDT
    FROM NHANVIEN NV
    INNER JOIN BANGXUAT X ON NV.MANV = X.MANV
    WHERE X.SOHDX = @X;
    RETURN @so_dien_thoai;
END;

/*9. HÃY VIẾT HÀM THỐNG KÊ TỔNG SỐ LƯỢNG THAY ĐỔI NHẬP XUẤT XỦA TÊN SẢN PHẨM X TRONG NĂM Y, VỚI X,Y ĐƯỢC NHẬP TỪ BÀN PHÍM*/
CREATE FUNCTION tong_so_luong_thay_doi_nhap_xuat_san_pham_x_trong_nam_y(@X VARCHAR(50), @Y INT)
RETURNS INT
BEGIN
    DECLARE @tong_so_luong INT;
    SELECT @tong_so_luong = SUM(COALESCE(N.SOLUONGN,0) + COALESCE(X.SOLUONGX,0))
    FROM BANGNHAP N
    FULL OUTER JOIN BANGXUAT X ON N.MASP = X.MASP AND YEAR(N.NGAYNHAP) = @Y AND YEAR(X.NGAYXUAT) = @Y
    WHERE N.MASP = @X OR X.MASP = @X;
    RETURN @tong_so_luong;
END;
/*10. VIẾT HÀM THỐNG KÊ TỔNG SỐ LƯỢNG SẢN PHẨM CỦA HÃNG X, VỚI TÊN HÃNG NHẬP TỪ BÀN PHÍM*/
CREATE FUNCTION thong_ke_so_luong_san_pham_hang_x(@ten_hang NVARCHAR(50))
RETURNS INT
BEGIN
    DECLARE @so_luong INT;
    SELECT @so_luong = SUM(SP.SOLUONG) 
    FROM SANPHAM SP
	JOIN HANGSX HX ON SP.MAHANGSX = HX.MAHANGSX 
    WHERE TENHANG = @ten_hang;
    RETURN @so_luong;
END;
SELECT DBO.thong_ke_so_luong_san_pham_hang_x(N'SAMSUNG')