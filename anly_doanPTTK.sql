CREATE DATABASE ANLY
USE ANLY
CREATE TABLE Sach
(
 masach nvarchar(50) PRIMARY KEY,
 matheloai nvarchar(50),
 tensach nvarchar(50),
 tacgia nvarchar(50),
 nhaxuatban nvarchar(50),
 soluong int,
 FOREIGN KEY (matheloai) REFERENCES TheLoai(matheloai)
 )

 CREATE TABLE TheLoai
 (
 matheloai nvarchar(50) PRIMARY KEY,
 tentheloai nvarchar(50)
 )

 CREATE TABLE PhieuNhap
 (
 maphieunhap nvarchar(50) PRIMARY KEY,
 masach nvarchar(50),
 mancc nvarchar(50),
 manv nvarchar(50),
 ngaynhap datetime,
 slnhap int,
 dgnhap int,
 tongtien int,
  FOREIGN KEY (masach) REFERENCES Sach(masach),
  FOREIGN KEY (mancc) REFERENCES NhaCungCap(mancc),
  FOREIGN KEY (manv) REFERENCES NhanVien(manv)
 )

select * from PhieuNhap
 CREATE TABLE NhaCungCap
 (
 mancc nvarchar(50) PRIMARY KEY,
 tenncc nvarchar(50),
 diachi nvarchar(50),
 dienthoai int
 )

 CREATE TABLE NhanVien
 ( 
 manv nvarchar(50) PRIMARY KEY,
 maphongban nvarchar(50),
 tennv nvarchar(50),
 sdt int,
 email nvarchar(50),
 diachi nvarchar(50),
 ngayvaolam int,
 tinhtrang nvarchar(50),
 FOREIGN KEY (maphongban) REFERENCES PhongBan(maphongban)
 
 )

 CREATE TABLE PhongBan
 (
 maphongban nvarchar(50) PRIMARY KEY,
 tenphongban nvarchar(50),
 chucvu nvarchar(50),
 luongcb int
 )

 CREATE TABLE HoaDon
 (
 mahoadon nvarchar(50) PRIMARY KEY,
 manv nvarchar(50),
 makh nvarchar(50),
 ngaymuahang datetime,
 tongtien int
 FOREIGN KEY (manv) REFERENCES NhanVien(manv),
 FOREIGN KEY (makh) REFERENCES KhachHang(makh)
 )
 CREATE TABLE ChiTietHD
 (
 machitiethd nvarchar(50) PRIMARY KEY,
 mahoadon nvarchar(50),
 masach nvarchar(50),
 soluong int
 )
 ALTER TABLE ChiTietHD
 ADD CONSTRAINT FK_HoaDon_ChiTietHD
FOREIGN KEY (mahoadon) REFERENCES HoaDon(mahoadon);
ALTER TABLE ChiTietHD
 ADD CONSTRAINT FK_Sach_ChiTietHD
FOREIGN KEY (masach) REFERENCES Sach(masach);

 CREATE TABLE KhachHang
 (
 makh nvarchar(50) PRIMARY KEY,
 tenkh  nvarchar(50),
 diachi  nvarchar(50),
 dienthoai int
 )

 --------------------------------------------------------------------------------------
 --------------------------------------------------------------------------------------
 INSERT INTO TheLoai (matheloai, tentheloai) VALUES 
(N'TL01', N'Tiểu thuyết'),
(N'TL02', N'Khoa học viễn tưởng'),
(N'TL03', N'Giáo dục'),
(N'TL04', N'Truyện tranh');
INSERT INTO Sach (masach, matheloai, tensach, tacgia, nhaxuatban, soluong) VALUES 
(N'S01', N'TL01', N'Những người khốn khổ', N'Victor Hugo', N'NXB Văn Học', 10),
(N'S02', N'TL02', N'Dune', N'Frank Herbert', N'NXB Kim Đồng', 15),
(N'S03', N'TL03', N'Giáo trình SQL', N'Nguyễn Văn A', N'NXB Giáo Dục', 20),
(N'S04', N'TL04', N'Doraemon', N'Fujiko F. Fujio', N'NXB Kim Đồng', 30);
INSERT INTO NhaCungCap (mancc, tenncc, diachi, dienthoai) VALUES 
(N'NCC01', N'Nhà cung cấp A', N'123 Lê Lợi, Hà Nội', 123456789),
(N'NCC02', N'Nhà cung cấp B', N'456 Trần Phú, Đà Nẵng', 987654321);
INSERT INTO PhongBan (maphongban, tenphongban, chucvu, luongcb) VALUES 
(N'PB01', N'Phòng Thu Ngân', N'Nhân Viên', 7000000),
(N'PB02', N'Phòng Kho ', N'Quản Lý', 10000000);
INSERT INTO NhanVien (manv, maphongban, tennv, sdt, email, diachi, ngayvaolam, tinhtrang) VALUES 
(N'NV01', N'PB01', N'Nguyễn Văn A', 123456789, N'nva@gmail.com', N'12 Hàng Bài, Hà Nội', '20200115', N'Hoạt động'),
(N'NV02', N'PB02', N'Trần Thị B', 987654321, N'ttb@gmail.com', N'34 Điện Biên Phủ, Đà Nẵng', '20190310', N'Hoạt động');
INSERT INTO KhachHang (makh, tenkh, diachi, dienthoai) VALUES 
(N'KH01', N'Phạm Văn C', N'56 Quang Trung, TP HCM', 123123123),
(N'KH02', N'Lê Thị D', N'78 Lê Duẩn, Hà Nội', 321321321);
INSERT INTO PhieuNhap (maphieunhap, masach, mancc, manv, ngaynhap, slnhap, dgnhap, tongtien) VALUES 
(N'PN01', N'S01', N'NCC01', N'NV01', '2024-01-15', 10, 50000, 500000),
(N'PN02', N'S02', N'NCC02', N'NV02', '2024-02-20', 15, 70000, 1050000);
INSERT INTO HoaDon (mahoadon, manv, makh, ngaymuahang, tongtien) VALUES 
(N'HD01', N'NV01', N'KH01', '2024-03-05', 150000),
(N'HD02', N'NV02', N'KH02', '2024-04-10', 200000);
INSERT INTO ChiTietHD (machitiethd, mahoadon, masach, soluong) VALUES 
(N'CTHD01', N'HD01', N'S01', 2),
(N'CTHD02', N'HD01', N'S02', 3),
(N'CTHD03', N'HD02', N'S03', 1),
(N'CTHD04', N'HD02', N'S04', 5);
