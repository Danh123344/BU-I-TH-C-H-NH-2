﻿use BAITHUCHANHSO1_2
go

/*1. mỗi hãng sản xuất có bao nhiêu loại sản phẩm*/
SELECT HX.TENHANG, COUNT (*) AS N'TỔNG LOẠI SẢN PHẨM'
FROM SANPHAM SP
JOIN HANGSX HX ON SP.MAHANGSX = HX.MAHANGSX
GROUP BY HX.TENHANG
/*2. TỔNG TIỀN NHẬP CỦA MỖI SẢN PHẨM NĂM 2018*/
SELECT MASP, SUM (SOLUONGN*DONGIAN) AS N'TỔNG TIỀN NHẬP'
FROM BANGNHAP
WHERE YEAR(NGAYNHAP) = 2018
GROUP BY MASP
/*3. SẢN PHẨM CÓ TỔNG SỐ LƯỢNG XUẤT NĂM 2018 LÀ LỚN HƠN 10000 SẢN PHẨM CỦA HÃNG SAMSUNG*/
SELECT SANPHAM.MASP, SUM(BANGXUAT.SOLUONGX) AS TONGSOLUONGXUAT
FROM BANGXUAT
JOIN SANPHAM ON BANGXUAT.MASP = SANPHAM.MASP
WHERE YEAR(BANGXUAT.NGAYXUAT) = 2018 AND SANPHAM.MAHANGSX = (SELECT MAHANGSX FROM HANGSX WHERE TENHANG = N'SAMSUNG')
GROUP BY SANPHAM.MASP
HAVING SUM(BANGXUAT.SOLUONGX) > 10000
/*4. THỐNG KÊ SỐ LƯỢNG NHÂN VIÊN NAM CỦA MỖI PHÒNG BAN*/
SELECT PHONG, COUNT(*) AS N'TỔNG NHÂN VIÊN NAM'
FROM NHANVIEN
WHERE GIOITINH = N'NAM'
GROUP BY PHONG
/*5. TỔNG SỐ LƯỢNG NHẬP CỦA MỖI HÃNG SẢN XUẤTTRONG NĂM 2018*/
SELECT HX.MAHANGSX, SUM (P.SOLUONGN) AS TỔNG
FROM BANGNHAP P 
JOIN SANPHAM SP ON P.MASP = SP.MASP
JOIN HANGSX HX ON SP.MAHANGSX = HX.MAHANGSX
WHERE YEAR(NGAYNHAP) = 2020
GROUP BY HX.MAHANGSX
/*6. TỔNG LƯỢNG TIỀN XUẤT CỦA MỖI NHÂN VIÊN TRONG NĂM 2018 LÀ BAO NHIÊU*/
SELECT X.MANV, SUM (X.SOLUONGX*SP.GIABAN) AS TỔNG
FROM BANGXUAT X
JOIN SANPHAM SP ON SP.MASP = X.MASP
WHERE YEAR(NGAYXUAT) = 2019
GROUP BY X.MANV
/*7. TỔNG TIỀN NHẬP CỦA MỖI NHÂN VIÊN TRONG THÁNG 8 NĂM 2018 CÓ TỔNG GIÁ TRỊ LỚN HƠN 100.000*/
SELECT MANV, SUM(SOLUONGN*DONGIAN) AS TỔNG
FROM BANGNHAP 
WHERE MONTH(NGAYNHAP) = 8 AND YEAR(NGAYNHAP) = 2018
GROUP BY MANV
HAVING SUM(SOLUONGN*DONGIAN) >100000 
/*8. ĐƯA RA DANH SÁCH CÁC SẢN PHẨM ĐÃ NHẬP NHỮNG CHƯA XUẤT BAO GIỜ*/
SELECT SP.MASP, SP.TENSP
FROM SANPHAM SP
LEFT JOIN BANGNHAP N ON SP.MASP = N.MASP
LEFT JOIN BANGXUAT X ON SP.MASP = X.MASP
WHERE N.SOLUONGN IS NOT NULL AND X.MASP IS NULL
GROUP BY SP.MASP, SP.TENSP
/*9. ĐƯA RA DANH SÁCH CÁC SẨN PHẨM ĐÃ NHẬP NĂM 2018 VÀ XUẤT NĂM 2018*/
SELECT SP.MASP, SP.TENSP
FROM SANPHAM SP
LEFT JOIN BANGNHAP N ON SP.MASP = N.MASP
LEFT JOIN BANGXUAT X ON SP.MASP = X.MASP
WHERE YEAR(NGAYNHAP) = 2020 AND YEAR(NGAYXUAT) = 2020
GROUP BY SP.MASP, SP.TENSP
/*10. ĐƯA RA DANH SÁCH CÁC NHÂN VIÊN VỪA NHẬP VỪA XUẤT*/
SELECT NV.MANV, TENNV
FROM NHANVIEN NV
LEFT JOIN BANGNHAP N ON NV.MANV = N.MANV
LEFT JOIN BANGXUAT X ON NV.MANV = X.MANV
WHERE SOLUONGN IS NOT NULL AND SOLUONGX IS NOT NULL
GROUP BY NV.MANV, NV.TENNV
/*11. ĐƯA RA DANH SÁCH CÁC NHÂN VIÊN KHÔNG THAM GIA VIỆC NHẬP XUẤT*/
SELECT NV.MANV, TENNV
FROM NHANVIEN NV
LEFT JOIN BANGNHAP N ON NV.MANV = N.MANV
LEFT JOIN BANGXUAT X ON NV.MANV = X.MANV
WHERE SOLUONGN IS NULL AND SOLUONGX IS NULL
GROUP BY NV.MANV, NV.TENNV