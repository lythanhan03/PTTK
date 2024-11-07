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
