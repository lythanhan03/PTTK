USE ANLY
CREATE PROCEDURE Sachsaphet
AS
BEGIN
    SELECT masach, tensach, soluong
    FROM Sach
    WHERE soluong < 3;
END;
---------------------------------------------------------------------------

CREATE PROCEDURE ThemPhieuNhapSach
    @maphieunhap NVARCHAR(50), -- Thêm tham số maphieunhap
    @masach NVARCHAR(50),
    @slnhap INT,
    @dgnhap INT,
    @mancc NVARCHAR(50),
    @manv NVARCHAR(50)
AS
BEGIN
    DECLARE @tongtien INT;

    SET @tongtien = @slnhap * @dgnhap;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Thêm dữ liệu vào bảng PhieuNhap
        INSERT INTO PhieuNhap (maphieunhap, masach, mancc, manv, ngaynhap, slnhap, dgnhap, tongtien)
        VALUES (@maphieunhap, @masach, @mancc, @manv, GETDATE(), @slnhap, @dgnhap, @tongtien);

        -- Cập nhật số lượng trong bảng Sach
        UPDATE Sach
        SET soluong = soluong + @slnhap
        WHERE masach = @masach;

        COMMIT TRANSACTION;
        PRINT 'Nhập sách thành công!';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Có lỗi xảy ra: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO
------------------------------------------------------------
ALTER PROCEDURE ThemPhieuNhapSach
    @maphieunhap NVARCHAR(50), -- Thêm tham số maphieunhap
    @masach NVARCHAR(50),
    @slnhap INT,
    @dgnhap INT,
    @mancc NVARCHAR(50),
    @manv NVARCHAR(50)
AS
BEGIN
    DECLARE @tongtien INT;

    SET @tongtien = @slnhap * @dgnhap;

    BEGIN TRANSACTION;
    BEGIN TRY
        -- Thêm dữ liệu vào bảng PhieuNhap
        INSERT INTO PhieuNhap (maphieunhap, masach, mancc, manv, ngaynhap, slnhap, dgnhap, tongtien)
        VALUES (@maphieunhap, @masach, @mancc, @manv, GETDATE(), @slnhap, @dgnhap, @tongtien);

        -- Cập nhật số lượng trong bảng Sach
        UPDATE Sach
        SET soluong = soluong + @slnhap
        WHERE masach = @masach;

        COMMIT TRANSACTION;
        PRINT 'Nhập sách thành công!';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Có lỗi xảy ra: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO
----------------------
----báo cáo chi phí theo tháng---
ALTER PROCEDURE BaoCaoChiPhiNhapTheoThang
    @Thang INT,
    @Nam INT
AS
BEGIN
    SELECT 
        MONTH(ngaynhap) AS Thang, 
        YEAR(ngaynhap) AS Nam,
        SUM(slnhap * dgnhap) AS TongChiPhiNhap
    FROM 
        PhieuNhap
    WHERE 
        MONTH(ngaynhap) = @Thang AND YEAR(ngaynhap) = @Nam
    GROUP BY 
        YEAR(ngaynhap), MONTH(ngaynhap);
END;
GO
----------------------------------------
---------- Xem khách hàng Top------------
CREATE PROCEDURE sp_KhachHangDoanhThuCao
    @MinDoanhThu INT
AS
BEGIN
    SELECT 
        KhachHang.makh,
        KhachHang.tenkh,
        KhachHang.diachi,
        KhachHang.dienthoai,
        SUM(HoaDon.tongtien) AS TongDoanhThu
    FROM 
        KhachHang
    INNER JOIN 
        HoaDon ON KhachHang.makh = HoaDon.makh
    GROUP BY 
        KhachHang.makh, KhachHang.tenkh, KhachHang.diachi, KhachHang.dienthoai
    HAVING 
        SUM(HoaDon.tongtien) >= @MinDoanhThu
    ORDER BY 
        TongDoanhThu DESC
END
-----------------------Báo cáo doanh thu ----------------------------
CREATE PROCEDURE BaoCaoDoanhThuTheoThang
    @Thang INT,
    @Nam INT
AS
BEGIN
    SELECT 
        MONTH(ngaymuahang) AS Thang,
        YEAR(ngaymuahang) AS Nam,
        SUM(tongtien) AS TongDoanhThu
    FROM HoaDon
    WHERE MONTH(ngaymuahang) = @Thang AND YEAR(ngaymuahang) = @Nam
    GROUP BY MONTH(ngaymuahang), YEAR(ngaymuahang)
END
--------------------------Tổng tiền hoá đơn-------------
CREATE PROCEDURE TongTienHoaDon
    @mahoadon NVARCHAR(50)
AS
BEGIN
    DECLARE @tongtien INT;

    -- Tính tổng tiền của các chi tiết hóa đơn (số lượng * giá bán)
    SELECT @tongtien = SUM(CT.soluong * S.dgban)
    FROM ChiTietHD CT
    JOIN Sach S ON CT.masach = S.masach
    WHERE CT.mahoadon = @mahoadon;

    -- Kiểm tra nếu không có kết quả (không có chi tiết hóa đơn), gán tổng tiền = 0
    IF @tongtien IS NULL
    BEGIN
        SET @tongtien = 0;
    END

    -- Cập nhật tổng tiền vào bảng HoaDon
    UPDATE HoaDon
    SET tongtien = @tongtien
    WHERE mahoadon = @mahoadon;

    -- Trả về tổng tiền tính được
    SELECT @tongtien AS TotalAmount;
END

--------------Rank Khách hàng---------
CREATE PROCEDURE sp_SapXepKhachHangTheoDoanhThu
AS
BEGIN
    SELECT 
        ROW_NUMBER() OVER (ORDER BY SUM(hd.tongtien) DESC) AS TopRank,
        kh.makh,
        kh.tenkh,
        kh.diachi,
        kh.dienthoai,
        SUM(hd.tongtien) AS TongDoanhThu
    FROM KhachHang kh
    INNER JOIN HoaDon hd ON kh.makh = hd.makh
    GROUP BY kh.makh, kh.tenkh, kh.diachi, kh.dienthoai
END
CREATE PROCEDURE sp_TimThuHangKhachHang
    @makh NVARCHAR(50)
AS
BEGIN
    WITH CTE_DoanhThu AS
    (
        SELECT 
            ROW_NUMBER() OVER (ORDER BY SUM(hd.tongtien) DESC) AS TopRank,
            kh.makh,
            SUM(hd.tongtien) AS TongDoanhThu
        FROM KhachHang kh
        INNER JOIN HoaDon hd ON kh.makh = hd.makh
        GROUP BY kh.makh
    )
    SELECT TopRank, TongDoanhThu
    FROM CTE_DoanhThu
    WHERE makh = @makh
END
