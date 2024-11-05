﻿CREATE DATABASE QLKFC

GO
--drop databasE QLKFC
USE QLKFC;

set dateformat dmy

GO

-- Bảng Quan Ly Nhan Vien  
CREATE TABLE NhanVien (  
    MaNhanVien VARCHAR(30) PRIMARY KEY NOT NULL,  
	AnhNhanVien  VARBINARY(MAX),
    TenNhanVien NVARCHAR(250) NOT NULL,  
    GioiTinh NVARCHAR(3),  
    NgaySinh DATETIME,  
    SoDienThoai VARCHAR(15),  
    Email VARCHAR(150),  
    DiaChi NVARCHAR(300),  
    ChucVu NVARCHAR(100),  
    SoGioLam int 
); 


-- Bảng Tinh Luong Nhan Vien  
CREATE TABLE Luong (  
    MaNhanVien VARCHAR(30) NOT NULL,  
    Thang INT NOT NULL,  
	Nam INT NOT NULL,  
    LuongCoBan INT NOT NULL,  
    SoNgayLam INT NOT NULL,  
    SoGioLamThem INT , -- Số giờ làm thêm
    ThuongChuyenCan INT, -- Thưởng chuyên cần
    ThuongHieuSuat INT , -- Thưởng hiệu suất
    KhoanTru INT, -- Khoản trừ (thuế, bảo hiểm, v.v.)
    PRIMARY KEY (MaNhanVien, Thang, Nam),  
    FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien)  
);  
--ALTER TABLE Luong
--ALTER COLUMN LuongCoBan DECIMAL(18, 2);
--ALTER TABLE Luong
--ALTER COLUMN ThuongChuyenCan DECIMAL(18, 2);
--ALTER TABLE Luong
--ALTER COLUMN ThuongHieuSuat DECIMAL(18, 2);


-- Bảng Loai Hang  
CREATE TABLE LoaiHang (  
    MaLoaiHang VARCHAR(20) PRIMARY KEY NOT NULL,  
    TenLoaiHang NVARCHAR(150) NOT NULL  
);  

-- bảng nhà cung cấp
CREATE TABLE NhaCungCap (  
    MaNhaCungCap VARCHAR(10) PRIMARY KEY,  
    TenNhaCungCap NVARCHAR(100) NOT NULL,  
	AnhNhaCungCap  VARBINARY(MAX),
    DiaChi NVARCHAR(200),  
    SoDienThoai VARCHAR(10),  
    GhiChu NVARCHAR(200)  
);  

-- Bảng Kho  
CREATE TABLE Kho (  
    MaSanPham VARCHAR(30) PRIMARY KEY NOT NULL,  
    TenSanPham NVARCHAR(250) NOT NULL,  
    SoLuong INT NOT NULL,  
	DonViTinh NVARCHAR(50),  
	DonGia FLOAT, 
	NgaySanXuat DATE,
	NgayHetHan DATE,
    MaLoaiHang VARCHAR(20),  
    CONSTRAINT CK_SoLuong CHECK (SoLuong >= 0),  
    FOREIGN KEY (MaLoaiHang) REFERENCES LoaiHang(MaLoaiHang) 
); 
 
-- Bảng NhapHang  
CREATE TABLE NhapHang (  
    MaNhapHang INT IDENTITY(1,1) PRIMARY KEY,  
    MaSanPham VARCHAR(30) NOT NULL,  
    SoLuong INT NOT NULL,  
    DonViTinh NVARCHAR(50),  
    DonGia FLOAT,  
    NgayNhap DATETIME NOT NULL,  
    MaLoaiHang VARCHAR(20),  
	MaNhaCungCap VARCHAR(10),
    FOREIGN KEY (MaSanPham) REFERENCES Kho(MaSanPham),  
    FOREIGN KEY (MaLoaiHang) REFERENCES LoaiHang(MaLoaiHang),
	FOREIGN KEY (MaNhaCungCap) REFERENCES NhaCungCap(MaNhaCungCap)
);  

-- Bảng Quan Ly Combo  
CREATE TABLE Combo (  
    MaCombo VARCHAR(30) PRIMARY KEY NOT NULL,  
    TenCombo NVARCHAR(250) NOT NULL,  
    GiaCombo FLOAT,  
    ThoiGianHieuLuc DATETIME  
); 

-- Bảng Chi Tiet Combo  
CREATE TABLE ChiTietCombo (  
    MaChiTietCombo INT PRIMARY KEY IDENTITY(1,1),  
    MaCombo VARCHAR(30) NOT NULL,  
    MaSanPham VARCHAR(30) NOT NULL,  
    SoLuong INT NOT NULL,  
    FOREIGN KEY (MaCombo) REFERENCES Combo(MaCombo),  
    FOREIGN KEY (MaSanPham) REFERENCES Kho(MaSanPham)  
);

-- Bảng Quan Ly Thuc Don  
CREATE TABLE ThucDon (  
    MaSanPham VARCHAR(30) PRIMARY KEY NOT NULL,  
    TenSanPham NVARCHAR(250) NOT NULL,  
	HinhAnh VARBINARY(MAX),
    DonGia FLOAT,
	MaLoaiHang VARCHAR(20)
);  

-- Bảng Quan Ly Khuyen Mai  
CREATE TABLE KhuyenMai (  
    MaKhuyenMai VARCHAR(12) PRIMARY KEY,  
    NgayBatDau DATETIME NOT NULL,  
    NgayKetThuc DATETIME NOT NULL,  
    GiaTriGiam DECIMAL(10, 2),  
    SoLuong INT,  
    TrangThai BIT  
);  

-- Bảng Quan Ly Ban  
CREATE TABLE Ban (  
    MaBan VARCHAR(20) PRIMARY KEY NOT NULL,  
    TenBan NVARCHAR(50) NOT NULL,  
    TrangThaiBan BIT  
);  

-- Bảng Khach Hang Than Thiet  
CREATE TABLE KhachHangThanThiet (  
    MaKhachHang VARCHAR(30) PRIMARY KEY NOT NULL,  
    TenKhachHang NVARCHAR(250) NOT NULL,  
    SoDienThoai VARCHAR(15),   
    DiemTichLuy INT DEFAULT 0,  
);

-- bảng đơn đặt
CREATE TABLE DonDat (  
    MaDonDat INT IDENTITY(1,1) PRIMARY KEY,  
    MaBan VARCHAR(20) NOT NULL,  
	TongTien FLOAT,
    HinhThucThanhToan NVARCHAR(50),  
    SoTienNhan FLOAT NULL, 
    SoTienTra FLOAT NULL,  
	MaKhuyenMai VARCHAR(12) null,
	MaKhachHang VARCHAR(30) null,
    FOREIGN KEY (MaBan) REFERENCES Ban(MaBan)  ,
	FOREIGN KEY (MaKhuyenMai) REFERENCES KhuyenMai(MaKhuyenMai),
	FOREIGN KEY (MaKhachHang) REFERENCES KhachHangThanThiet(MaKhachHang)
);

-- Bảng chi tiết hóa đơn
CREATE TABLE ChiTietDonDat (  
	MaDonDat INT NOT NULL, 
    ID INT IDENTITY(1,1) PRIMARY KEY,  
    MaSanPham VARCHAR(30) NULL,  
    MaCombo VARCHAR(30) NULL,  
    SoLuong INT NOT NULL,   
	DonGia FLOAT NULL, 
	FOREIGN KEY (MaDonDat) REFERENCES DonDat(MaDonDat),
    FOREIGN KEY (MaSanPham) REFERENCES ThucDon(MaSanPham),  
    FOREIGN KEY (MaCombo) REFERENCES Combo(MaCombo)  
);


-- Bảng Hoa Don  
CREATE TABLE HoaDon (  
    MaHoaDon INT IDENTITY(1,1) PRIMARY KEY, 
	MaDonDat INT not NULL,   
    NgayThanhToan DATETIME,   
    FOREIGN KEY (MaDonDat) REFERENCES DonDat(MaDonDat)  
);   

-- Bảng Doanh Thu  
CREATE TABLE DoanhThu (  
	MaNhapHang INT,
    Thang INT NOT NULL,  
    Nam INT NOT NULL,  
    NgayGhiNhan DATE NOT NULL,  
    MaHoaDon INT,  -- Kết nối với bảng HoaDon (Hóa đơn)  
    TongChiTieu FLOAT,  -- Tổng chi tiêu  
    TongDoanhThu FLOAT,  -- Tổng doanh thu  
    PRIMARY KEY (Thang, Nam, NgayGhiNhan),  
    FOREIGN KEY (MaHoaDon) REFERENCES HoaDon(MaHoaDon),  
	FOREIGN KEY (MaNhapHang) REFERENCES NhapHang(MaNhapHang)
);
<<<<<<< HEAD

INSERT INTO NhanVien (MaNhanVien, AnhNhanVien, TenNhanVien, GioiTinh, NgaySinh, SoDienThoai, Email, DiaChi, ChucVu, SoGioLam) VALUES
('NV001', NULL, N'Nguyễn Văn A', N'Nam', '01/01/1990', '0123456789', 'vana@gmail.com', N'Hà Nội', N'Quản lý', 160),
('NV002', NULL, N'Trần Thị B', N'Nữ', '02/02/1991', '0123456780', 'thib@gmail.com', N'Hà Nội', N'Nhân viên', 160),
('NV003', NULL, N'Lê Văn C', N'Nam', '03/03/1992', '0123456781', 'vanc@gmail.com', N'Hà Nội', N'Nhân viên', 160),
('NV004', NULL, N'Phạm Thị D', N'Nữ', '04/04/1993', '0123456782', 'thid@gmail.com', N'Hà Nội', N'Nhân viên', 160),
('NV005', NULL, N'Nguyễn Văn E', N'Nam', '05/05/1994', '0123456783', 'vane@gmail.com', N'Hà Nội', N'Quản lý', 160),
('NV006', NULL, N'Trần Thị F', N'Nữ', '06/06/1995', '0123456784', 'thif@gmail.com', N'Hà Nội', N'Nhân viên', 160),
('NV007', NULL, N'Lê Văn G', N'Nam', '07/07/1996', '0123456785', 'vang@gmail.com', N'Hà Nội', N'Nhân viên', 160),
('NV008', NULL, N'Phạm Thị H', N'Nữ', '08/08/1997', '0123456786', 'thih@gmail.com', N'Hà Nội', N'Nhân viên', 160),
('NV009', NULL, N'Nguyễn Văn I', N'Nam', '09/09/1998', '0123456787', 'vani@gmail.com', N'Hà Nội', N'Quản lý', 160),
('NV010', NULL, N'Trần Thị J', N'Nữ', '10/10/1999', '0123456788', 'thij@gmail.com', N'Hà Nội', N'Nhân viên', 160),
('NV011', NULL, N'Lê Văn K', N'Nam', '11/11/1988', '0123456789', 'vank@gmail.com', N'Hà Nội', N'Nhân viên', 160),
('NV012', NULL, N'Phạm Thị L', N'Nữ', '12/12/1987', '0123456790', 'thil@gmail.com', N'Hà Nội', N'Nhân viên', 160),
('NV013', NULL, N'Nguyễn Văn M', N'Nam', '13/01/1986', '0123456791', 'vanm@gmail.com', N'Hà Nội', N'Quản lý', 160),
('NV014', NULL, N'Trần Thị N', N'Nữ', '14/02/1985', '0123456792', 'thin@gmail.com', N'Hà Nội', N'Nhân viên', 160),
('NV015', NULL, N'Lê Văn O', N'Nam', '15/03/1984', '0123456793', 'vano@gmail.com', N'Hà Nội', N'Nhân viên', 160),
('NV016', NULL, N'Phạm Thị P', N'Nữ', '16/04/1983', '0123456794', 'thip@gmail.com', N'Hà Nội', N'Nhân viên', 160),
('NV017', NULL, N'Nguyễn Văn Q', N'Nam', '17/05/1982', '0123456795', 'vanq@gmail.com', N'Hà Nội', N'Quản lý', 160),
('NV018', NULL, N'Trần Thị R', N'Nữ', '18/06/1981', '0123456796', 'thir@gmail.com', N'Hà Nội', N'Nhân viên', 160),
('NV019', NULL, N'Lê Văn S', N'Nam', '19/07/1980', '0123456797', 'vans@gmail.com', N'Hà Nội', N'Nhân viên', 160),
('NV020', NULL, N'Phạm Thị T', N'Nữ', '20/08/1979', '0123456798', 'thit@gmail.com', N'Hà Nội', N'Nhân viên', 160);
=======
ALTER TABLE NhapHang
ADD NgaySanXuat DATETIME,
    NgayHetHan DATETIME;
INSERT INTO NhanVien (MaNhanVien, AnhNhanVien, TenNhanVien, GioiTinh, NgaySinh, SoDienThoai, Email, DiaChi, ChucVu, SoGioLam) 
VALUES 
(N'NV001', NULL, N'Nguyễn Văn A', N'Nam', '01/01/1990', '0901234567', 'vana@gmail.com', N'Hà Nội', N'Quản lý', 160),
(N'NV002', NULL, N'Trần Thị B', N'Nữ', '02/02/1992', '0902234567', 'thib@gmail.com', N'Hà Nội', N'Nhân viên', 150),
(N'NV003', NULL, N'Lê Văn C', N'Nam', '03/03/1989', '0903234567', 'vanc@gmail.com', N'Hồ Chí Minh', N'Quản lý', 170),
(N'NV004', NULL, N'Phạm Thị D', N'Nữ', '04/04/1993', '0904234567', 'thid@gmail.com', N'Hải Phòng', N'Nhân viên', 145),
(N'NV005', NULL, N'Hoàng Văn E', N'Nam', '05/05/1991', '0905234567', 'vane@gmail.com', N'Đà Nẵng', N'Nhân viên', 155),
(N'NV006', NULL, N'Nguyễn Thị F', N'Nữ', '06/06/1990', '0906234567', 'thif@gmail.com', N'Cần Thơ', N'Nhân viên', 160),
(N'NV007', NULL, N'Đỗ Văn G', N'Nam', '07/07/1994', '0907234567', 'vang@gmail.com', N'Quảng Ninh', N'Nhân viên', 165),
(N'NV008', NULL, N'Vũ Thị H', N'Nữ', '08/08/1991', '0908234567', 'thih@gmail.com', N'Thanh Hóa', N'Nhân viên', 150),
(N'NV009', NULL, N'Bùi Văn I', N'Nam', '09/09/1992', '0909234567', 'vani@gmail.com', N'Hà Nội', N'Nhân viên', 140),
(N'NV010', NULL, N'Phạm Thị K', N'Nữ', '10/10/1993', '0900234567', 'thik@gmail.com', N'Hải Phòng', N'Nhân viên', 130),
(N'NV011', NULL, N'Nguyễn Văn L', N'Nam', '11/11/1988', '0910234567', 'vanl@gmail.com', N'Hồ Chí Minh', N'Quản lý', 170),
(N'NV012', NULL, N'Lê Thị M', N'Nữ', '12/12/1990', '0911234567', 'thim@gmail.com', N'Đà Nẵng', N'Nhân viên', 160),
(N'NV013', NULL, N'Phạm Văn N', N'Nam', '13/01/1995', '0912234567', 'vann@gmail.com', N'Cần Thơ', N'Nhân viên', 140),
(N'NV014', NULL, N'Trần Thị O', N'Nữ', '14/02/1992', '0913234567', 'thio@gmail.com', N'Thanh Hóa', N'Nhân viên', 150),
(N'NV015', NULL, N'Đỗ Văn P', N'Nam', '15/03/1989', '0914234567', 'vanp@gmail.com', N'Quảng Ninh', N'Quản lý', 160),
(N'NV016', NULL, N'Vũ Thị Q', N'Nữ', '16/04/1993', '0915234567', 'thiq@gmail.com', N'Hà Nội', N'Nhân viên', 155),
(N'NV017', NULL, N'Bùi Văn R', N'Nam', '17/05/1991', '0916234567', 'vanr@gmail.com', N'Hồ Chí Minh', N'Nhân viên', 150),
(N'NV018', NULL, N'Hoàng Thị S', N'Nữ', '18/06/1990', '0917234567', 'this@gmail.com', N'Hải Phòng', N'Nhân viên', 145),
(N'NV019', NULL, N'Nguyễn Văn T', N'Nam', '19/07/1992', '0918234567', 'vant@gmail.com', N'Đà Nẵng', N'Nhân viên', 150),
(N'NV020', NULL, N'Phạm Thị U', N'Nữ', '20/08/1994', '0919234567', 'thiu@gmail.com', N'Cần Thơ', N'Nhân viên', 160);
>>>>>>> hungg






INSERT INTO Luong (MaNhanVien, Thang, Nam, LuongCoBan, SoNgayLam, SoGioLamThem, ThuongChuyenCan, ThuongHieuSuat, KhoanTru) VALUES
('NV001', 10, 2024, 5000000, 22, 5, 500000, 300000, 100000),
('NV002', 10, 2024, 4000000, 22, 2, 300000, 200000, 80000),
('NV003', 10, 2024, 4000000, 22, 0, 300000, 200000, 80000),
('NV004', 10, 2024, 3500000, 22, 4, 200000, 150000, 70000),
('NV005', 10, 2024, 5000000, 22, 3, 500000, 300000, 100000),
('NV006', 10, 2024, 3500000, 22, 1, 200000, 150000, 70000),
('NV007', 10, 2024, 4000000, 22, 2, 300000, 200000, 80000),
('NV008', 10, 2024, 4000000, 22, 0, 300000, 200000, 80000),
('NV009', 10, 2024, 5000000, 22, 5, 500000, 300000, 100000),
('NV010', 10, 2024, 4000000, 22, 2, 300000, 200000, 80000),
('NV011', 10, 2024, 4000000, 22, 0, 300000, 200000, 80000),
('NV012', 10, 2024, 3500000, 22, 4, 200000, 150000, 70000),
('NV013', 10, 2024, 5000000, 22, 3, 500000, 300000, 100000),
('NV014', 10, 2024, 3500000, 22, 1, 200000, 150000, 70000),
('NV015', 10, 2024, 4000000, 22, 2, 300000, 200000, 80000),
('NV016', 10, 2024, 4000000, 22, 0, 300000, 200000, 80000),
('NV017', 10, 2024, 5000000, 22, 5, 500000, 300000, 100000),
('NV018', 10, 2024, 4000000, 22, 2, 300000, 200000, 80000),
('NV019', 10, 2024, 4000000, 22, 0, 300000, 200000, 80000),
('NV020', 10, 2024, 3500000, 22, 4, 200000, 150000, 70000);




-- Bảng Loại Hàng
INSERT INTO LoaiHang (MaLoaiHang, TenLoaiHang) VALUES
('GR', N'Gà Rán'),
('GQ', N'Gà Quay'),
('NUOC', N'Nước Uống'),
('TM', N'Món Tráng Miệng'),
('TAN', N'Thức Ăn Nhẹ'),
('BMC', N'Burger - Mì Ý - Cơm');

-- Bảng Kho 
INSERT INTO Kho (MaSanPham, TenSanPham, SoLuong, DonViTinh, DonGia, NgaySanXuat, NgayHetHan, MaLoaiHang)
VALUES
('GR001', N'Gà Rán Giòn', 100, N'Chiếc', 65000, '2024-12-01', '2025-06-30', 'GR'),
('GR002', N'Gà Rán Nguyên Tâm', 50, N'Chiếc', 70000, '2024-12-02', '2025-07-30', 'GR'),
('GQ001', N'Gà Quay Nguyên Tâm', 80, N'Chiếc', 85000, '2024-12-15', '2025-06-15', 'GQ'),
('NUOC001', N'Nước Ngọt', 200, N'Lít', 15000, '2024-12-03', '2025-12-03', 'NUOC'),
('TM001', N'Bánh Tart', 150, N'Cái', 20000, '2024-12-20', '2025-04-20', 'TM'),
('TAN001', N'Khoai Tây Chiên', 120, N'Cái', 30000, '2024-12-15', '2025-08-15', 'TAN'),
('BMC001', N'Burger Gà', 80, N'Chiếc', 50000, '2024-12-25', '2025-05-25', 'BMC'),
('BMC002', N'Mì Ý', 70, N'Dĩa', 60000, '2024-12-05', '2025-05-05', 'BMC'),
('GR003', N'Gà Rán Cay', 90, N'Chiếc', 68000, '2024-12-30', '2025-07-30', 'GR'),
('NUOC002', N'Nước Trái Cây', 180, N'Lít', 18000, '2024-12-01', '2025-12-01', 'NUOC'),
('NUOC003', N'Nước CoCa', 160, N'Lít', 12000, '2024-03-11', '2024-04-11', 'NUOC');


-- Bảng Thực Đơn
INSERT INTO ThucDon (MaSanPham, TenSanPham, HinhAnh, DonGia, MaLoaiHang) VALUES
('GR001', N'Gà Rán Giòn', NULL, 65000, 'GR'),
('GR002', N'Gà Rán Nguyên Tâm', NULL, 70000, 'GR'),
('GQ001', N'Gà Quay Nguyên Tâm', NULL, 85000, 'GQ'),
('NUOC001', N'Nước Ngọt', NULL, 15000, 'NUOC'),
('TM001', N'Bánh Tart', NULL, 20000, 'TM'),
('TAN001', N'Khoai Tây Chiên', NULL, 30000, 'TAN'),
('BMC001', N'Burger Gà', NULL, 50000, 'BMC'),
('BMC002', N'Mì Ý', NULL, 60000, 'BMC'),
('GR003', N'Gà Rán Cay', NULL, 68000, 'GR'),
('NUOC002', N'Nước Trái Cây', NULL, 18000, 'NUOC');

-- Bảng Nhà Cung Cấp
INSERT INTO NhaCungCap (MaNhaCungCap, TenNhaCungCap, AnhNhaCungCap, DiaChi, SoDienThoai, GhiChu) VALUES
('NCC01', N'Nhà Cung Cấp A', NULL, N'Địa chỉ NCC A', '0123456789', N'Nhà cung cấp thực phẩm'),
('NCC02', N'Nhà Cung Cấp B', NULL, N'Địa chỉ NCC B', '0987654321', N'Nhà cung cấp nước uống'),
('NCC03', N'Nhà Cung Cấp C', NULL, N'Địa chỉ NCC C', '0912345678', N'Nhà cung cấp đồ ăn nhẹ'),
('NCC04', N'Nhà Cung Cấp D', NULL, N'Địa chỉ NCC D', '0981234567', N'Nhà cung cấp bánh ngọt'),
('NCC05', N'Nhà Cung Cấp E', NULL, N'Địa chỉ NCC E', '0962345671', N'Nhà cung cấp nước giải khát'),
('NCC06', N'Nhà Cung Cấp F', NULL, N'Địa chỉ NCC F', '0932123456', N'Nhà cung cấp gia vị'),
('NCC07', N'Nhà Cung Cấp G', NULL, N'Địa chỉ NCC G', '0901122334', N'Nhà cung cấp nguyên liệu'),
('NCC08', N'Nhà Cung Cấp H', NULL, N'Địa chỉ NCC H', '0922133445', N'Nhà cung cấp bánh'),
('NCC09', N'Nhà Cung Cấp I', NULL, N'Địa chỉ NCC I', '0987654444', N'Nhà cung cấp trái cây'),
('NCC10', N'Nhà Cung Cấp J', NULL, N'Địa chỉ NCC J', '0976543333', N'Nhà cung cấp rau củ');

-- Bảng Khách Hàng 
INSERT INTO KhachHangThanThiet (MaKhachHang, TenKhachHang, SoDienThoai, DiemTichLuy) VALUES
('KH001', N'Nguyễn Văn A', '0123456789', 100),
('KH002', N'Trần Thị B', '0123456790', 150),
('KH003', N'Nguyễn Thị C', '0123456791', 200),
('KH004', N'Phạm Văn D', '0123456792', 250),
('KH005', N'Đỗ Thị E', '0123456793', 300),
('KH006', N'Lê Văn F', '0123456794', 120),
('KH007', N'Nguyễn Văn G', '0123456795', 180),
('KH008', N'Vũ Thị H', '0123456796', 220),
('KH009', N'Hồ Văn I', '0123456797', 140),
('KH010', N'Tôn Thị J', '0123456798', 160);


-- Bảng Nhập Hàng
INSERT INTO NhapHang (MaSanPham, SoLuong, DonViTinh, DonGia, NgayNhap, MaLoaiHang, MaNhaCungCap) VALUES
('GR001', 100, N'Chiếc', 65000, GETDATE(), 'GR', 'NCC01'),
('GR002', 50, N'Chiếc', 70000, GETDATE(), 'GR', 'NCC02'),
('GQ001', 80, N'Chiếc', 85000, GETDATE(), 'GQ', 'NCC03'),
('NUOC001', 200, N'Lít', 15000, GETDATE(), 'NUOC', 'NCC04'),
('TAN001', 120, N'Cái', 30000, GETDATE(), 'TAN', 'NCC05'),
('BMC001', 80, N'Chiếc', 50000, GETDATE(), 'BMC', 'NCC06'),
('BMC002', 70, N'Dĩa', 60000, GETDATE(), 'BMC', 'NCC07'),
('GR003', 90, N'Chiếc', 68000, GETDATE(), 'GR', 'NCC08'),
('NUOC002', 180, N'Lít', 18000, GETDATE(), 'NUOC', 'NCC09'),
('TM001', 150, N'Cái', 20000, GETDATE(), 'TM', 'NCC10');

-- Bảng Combo
INSERT INTO Combo (MaCombo, TenCombo, GiaCombo, ThoiGianHieuLuc) VALUES
('CMB01', N'Combo Gà Rán', 95000, GETDATE()),
('CMB02', N'Combo Gà Quay', 115000, GETDATE()),
('CMB03', N'Combo Nước Uống', 20000, GETDATE()),
('CMB04', N'Combo Món Tráng Miệng', 50000, GETDATE()),
('CMB05', N'Combo Thức Ăn Nhẹ', 75000, GETDATE()),
('CMB06', N'Combo Burger', 80000, GETDATE()),
('CMB07', N'Combo Mì Ý', 60000, GETDATE()),
('CMB08', N'Combo Bánh Tart', 40000, GETDATE()),
('CMB09', N'Combo Khoai Tây', 30000, GETDATE()),
('CMB10', N'Combo Gà Cay', 95000, GETDATE());

-- Bảng Chi Tiết Combo
INSERT INTO ChiTietCombo (MaCombo, MaSanPham, SoLuong) VALUES
('CMB01', 'GR001', 1),
('CMB01', 'NUOC001', 1),
('CMB02', 'GQ001', 1),
('CMB02', 'TAN001', 1),
('CMB03', 'NUOC001', 2),
('CMB04', 'TM001', 2),
('CMB05', 'TAN001', 2),
('CMB06', 'BMC001', 1),
('CMB07', 'BMC002', 1),
('CMB08', 'TM001', 3),
('CMB09', 'TAN001', 2),
('CMB10', 'GR003', 1);
INSERT INTO KhuyenMai (MaKhuyenMai, NgayBatDau, NgayKetThuc, GiaTriGiam, SoLuong, TrangThai) VALUES
('KM01', GETDATE(), DATEADD(DAY, 30, GETDATE()), 20000, 100, 1);

UPDATE NhapHang
SET NgaySanXuat = '2024-10-01', NgayHetHan = '2024-12-01'
WHERE MaSanPham = 'GR01';

UPDATE NhapHang
SET NgaySanXuat = '2024-10-05', NgayHetHan = '2024-12-05'
WHERE MaSanPham = 'GQ01';

UPDATE NhapHang
SET NgaySanXuat = '2024-10-10', NgayHetHan = '2025-10-10'
WHERE MaSanPham = 'NUOC01';

UPDATE NhapHang
SET NgaySanXuat = '2024-10-12', NgayHetHan = '2025-01-12'
WHERE MaSanPham = 'TAN01';

UPDATE NhapHang
SET NgaySanXuat = '2024-10-15', NgayHetHan = '2024-11-15'
WHERE MaSanPham = 'BMC01';

select * from Luong

select * from Kho

SELECT * FROM Luong WHERE MaNhanVien = 'NV001' AND Thang = 10 AND Nam = 2024;
DELETE FROM Luong WHERE MaNhanVien = 'NV001' AND Thang = 2; -- Thay MãNhânViênCầnXóa và 1 bằng giá trị cụ thể



SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Luong';

EXEC sp_help 'Luong';




























---- 11. Bảng Chi Tiet Hoa Don  
--CREATE TABLE ChiTietHoaDon (  
--    MaChiTiet INT IDENTITY(1,1) PRIMARY KEY,  
--    MaHoaDon INT NOT NULL,  
--    MaSanPham VARCHAR(30) NOT NULL,	0
--    TenSanPham NVARCHAR(250) NOT NULL,  
--    SoLuong INT,  
--    DonGia FLOAT,  
--    FOREIGN KEY (MaHoaDon) REFERENCES HoaDon(MaHoaDon),  
--    FOREIGN KEY (MaSanPham) REFERENCES ThucDon(MaSanPham)  
--);  