﻿USE BAITHUCHANHSO1_2
GO
/*1. HIỂN THỊ THÔNG TIN CÁC BẢNG DỮ LIỆU TRÊN. ví dụ hiển thị thông tin bảng NHẬP*/
SELECT * FROM BANGNHAP, BANGXUAT, HANGSX, NHANVIEN, SANPHAM
/*2. ĐƯA RA THÔNG TIN MASP,TENSP,TENHANG,SOLUONG,MAUSSAC,GIABAN,DONVITINH,MOTA CỦA CÁC SẢN PHẨM SẮP XẾP THEO CHIỀU GIẢM DẦN*/
SELECT MASP,TENSP,SOLUONG,MAUSAC,GIABAN,DONVITINH,MOTA
FROM SANPHAM
ORDER BY GIABAN DESC
/*3. ĐƯA RA THÔNG TIN CÁC SẢN PHẨM CÓ TRONG CỬA HÀNG DO CÔNG TY CÓ TÊN HÃNG LÀ SAMSUNG SẢN XUẤT*/
SELECT * FROM HANGSX
WHERE TENHANG = N'SAMSUNG'
/*4. ĐƯA RA THÔNG TIN CÁC NHÂN VIÊN NỮ Ở PHÒNG KẾ TOÁN*/
SELECT * FROM NHANVIEN
WHERE PHONG = N'KẾ TOÁN' AND GIOITINH = N'NỮ'  
/*5. ĐƯA RA THÔNG TIN PHIẾU NHẬP GỒM: SOHD, MASP, TENSP, TENHANG, SOLUONGN,DONGIAN, TIENNHAP = SOLUONGN*DONGIAN, MAUSAC, DONVITINH, NGAYNHAP, TENDV, PHONG, SẮP XẾP THEO CHIỀU TĂNG DẦN CỦA HOÁ ĐƠN NHẬP */

SELECT N.SOHDN, SP.MASP, SP.TENSP, HANGSX.TENHANG, N.SOLUONGN, N.DONGIAN, N.SOLUONGN * N.DONGIAN AS TIENNHAP, SP.MAUSAC, SP.DONVITINH, N.NGAYNHAP, NV.TENNV, NV.PHONG
FROM BANGNHAP N
JOIN SANPHAM SP ON N.MASP = SP.MASP
JOIN HANGSX ON SP.MAHANGSX = HANGSX.MAHANGSX
JOIN NHANVIEN NV ON N.MANV = NV.MANV
ORDER BY N.SOHDN ASC

/*6. ĐƯA RA THÔNG TIN PHIẾU XUẤT GỒM: SOHDX, MASP,TENSP, TENHANG, SOLUONGX, GIABAN,TIENXUAT=SOLUONGX*GIABAN,MAUSAC,DONVITINH,NGAYXUAT,TENV,PHONG TRONG THÁNG 10 NĂM 2018, SẮP XẾP THEO CHIỀU TĂNG DẦN CỦA SOHDX*/
SELECT X.SOHDX, SP.MASP, SP.TENSP, HANGSX.TENHANG, X.SOLUONGX, SP.GIABAN, X.SOLUONGX * SP.GIABAN AS TIENNHAP, SP.MAUSAC, SP.DONVITINH, X.NGAYXUAT, NV.TENNV, NV.PHONG
FROM BANGXUAT X
JOIN SANPHAM SP ON X.MASP = SP.MASP
JOIN HANGSX ON SP.MAHANGSX = HANGSX.MAHANGSX
JOIN NHANVIEN NV ON X.MANV = NV.MANV
WHERE YEAR(X.NGAYXUAT) = 2018 AND MONTH(X.NGAYXUAT) = 10
ORDER BY X.SOHDX ASC

/*7. ĐƯA RA CÁC THÔNG TIN VỀ CÁC HOÁ ĐƠN MÀ HÃNG SAMSUNG ĐÃ NHẬP TRONG NĂM 2017, GỒM: SOHDN, TENSP, SOLUONGN,DONGIAN,NGAYNHAP, TENNV, PHONG*/
SELECT N.SOHDN, SP.TENSP, N.SOLUONGN, N.DONGIAN, N.NGAYNHAP, NV.TENNV, NV.PHONG
FROM BANGNHAP N
JOIN SANPHAM SP ON N.MASP = SP.MASP
JOIN HANGSX ON SP.MAHANGSX = HANGSX.MAHANGSX
JOIN NHANVIEN NV ON N.MANV = NV.MANV
WHERE YEAR (N.NGAYNHAP) = 2017 AND TENHANG = N'SAMSUNG' 

/*8. ĐƯA RA TOP 10 HOÁ ĐƠN XUẤT CÓ SỐ LƯỢNG XUẤT NHIỀU NHẤT TRONG NĂM 2018, SẮP XẾP THOE CHIỀU GIẢM DẦN GIÁ BÁN*/
SELECT TOP 10 X.SOHDX, SP.MASP, X.MANV, X.NGAYXUAT, X.SOLUONGX, SP.GIABAN
FROM BANGXUAT X
JOIN SANPHAM SP ON X.MASP = SP.MASP
ORDER BY GIABAN DESC

/*9. ĐƯA RA CÁC THÔNG TIN SẢN PHẨM CÓ GIÁ BÁN CAO NHẤT TRONG CỦA HÀNG, THEO CHIỀU GIẢM DẦN GIÁ BÁN*/
SELECT TOP 10 * FROM SANPHAM
ORDER BY GIABAN DESC

/*10. đưa ra các thông tin sản phẩm có giá bán từ 100.000 đến 500.000 của hãng samsung*/
SELECT *
FROM SANPHAM SP
INNER JOIN HANGSX HS ON SP.MAHANGSX = HS.MAHANGSX
/*DO TRONG DỮ LIỆU KHI NHẬP VÔ GIÁ BÁN CỦA ĐIỆN THOẠI KHÔNG CÓ GIÁ 100000 CHO TỚI 500000 NÊN SẼ KHÔNG RA GÌ HẾT
VÌ VẬY ĐỔI ĐIỀU KIỆ LÀ CÓ GIÁ TỪ 1000000 CHO TỚI 50000000 */
WHERE HS.TENHANG = 'SAMSUNG' AND SP.GIABAN BETWEEN 1000000 AND 50000000

/*11. TÍNH TỔNG TIỀN ĐÃ NHẬP TRONG NĂM 2018 CỦA HÃNG SAMSUNG*/
SELECT N.SOHDN, SP.MASP, N.MANV,HX.TENHANG, N.NGAYNHAP, N.SOLUONGN, N.DONGIAN, N.SOLUONGN*N.DONGIAN AS TONGTIEN
FROM BANGNHAP N
JOIN SANPHAM SP ON N.MASP = SP.MASP
JOIN HANGSX HX ON SP.MAHANGSX = HX.MAHANGSX
WHERE YEAR(NGAYNHAP) = 2018

/*12. THỐNG KÊ TỔNG TIỀN ĐÃ XUẤT TRONG NGÀY 2/9/2018*/
SELECT  X.SOHDX, SP.MASP, X.MANV, X.NGAYXUAT, X.SOLUONGX, SP.GIABAN, X.SOLUONGX * SP.GIABAN AS TONGTIENXUAT
FROM BANGXUAT X
JOIN SANPHAM SP ON X.MASP = SP.MASP
WHERE YEAR(X.NGAYXUAT) = 2020 AND MONTH(X.NGAYXUAT) = 6 AND DAY(X.NGAYXUAT) = 14

/*13. ĐƯA RA SOHDN, NGAYNHAP CÓ TIỀN PHẢI TRẢ CAO NHẤT NĂM 2018*/
SELECT TOP 1 N.SOHDN, N.NGAYNHAP
FROM BANGNHAP N
WHERE YEAR(N.NGAYNHAP) = 2018
ORDER BY (N.SOLUONGN * N.DONGIAN) DESC

/*14. ĐƯA RA 10 MẶT HÀNG CÓ SỐ LƯỢNG NHẬP NHIỀU NHẤT NĂM 2019*/
SELECT TOP 10 N.MANV, SP.TENSP, N.SOLUONGN
FROM BANGNHAP N
JOIN SANPHAM SP ON N.MASP = SP.MASP
ORDER BY SOLUONGN DESC

/*15. ĐƯA RA MASP, TENSP, CỦA CÁC SẢN PHẨM DO CÔNG TY "SAMSUNG " SẢN XUẤT DO NHÂN VIÊN CÓ MÃ *NV01* NHẬP*/
SELECT SP.MASP, SP.TENSP, HX.TENHANG, N.SOLUONGN, N.MANV
FROM SANPHAM SP 
JOIN HANGSX HX ON SP.MAHANGSX = HX.MAHANGSX
JOIN BANGNHAP N ON SP.MASP = N.MASP
WHERE MANV = N'NV01' AND TENHANG = N'SAMSUNG'

/*16. ĐƯA RA SOHDN, MASP,SOLUONGN, NGAYNHAP CỦA MẶT HÀNG CÓ MÃ SẢN PHẨM'SP02', ĐƯỢC NHÂN VIÊN 'NV02'XUẤT*/
SELECT N.MANV, N.SOHDN, N.MASP, N.SOLUONGN, N.NGAYNHAP
FROM BANGNHAP N
JOIN NHANVIEN NV ON N.MANV = NV.MANV
JOIN BANGXUAT X ON NV.MANV = X.MANV
WHERE X.MASP='SP02' AND N.MANV = 'NV01'

/*17. ĐƯA RA MANV, TENNV ĐÃ XUẤT MẶT HÀNG CÓ MÃ 'SP02'NGÀY '3/2/2020'*/
SELECT N.MANV, TENNV
FROM NHANVIEN N
JOIN BANGXUAT X ON N.MANV=X.MANV
WHERE MASP = 'SP02' AND  YEAR(X.NGAYXUAT) = 2020 AND MONTH(X.NGAYXUAT) = 12 AND DAY(X.NGAYXUAT) = 12