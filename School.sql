-- DATABASE:  Xây dựng hệ CSDL quản lý Trường phổ thông liên cấp.

DROP DATABASE IF EXISTS truong_pho_thong_lien_cap;
CREATE DATABASE truong_pho_thong_lien_cap CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE truong_pho_thong_lien_cap;

-- Phần 1: Xây dựng các thực thể mạnh 
-- Bảng Con người
CREATE TABLE Con_Nguoi (
	ID_con_nguoi  VARCHAR(20) PRIMARY KEY,
    Ho VARCHAR(25) NOT NULL,
    Dem VARCHAR(50),
    Ten VARCHAR(25) NOT NULL,
    Ngay_sinh DATE NOT NULL,
    Gioi_tinh ENUM('Nam', 'Nữ', 'Khác'),
    Dan_toc VARCHAR(50) DEFAULT 'Kinh',
    Dia_chi_thuong_tru TEXT
);

-- Bảng Phòng ban hành chính
CREATE TABLE Phong_Ban_Hanh_Chinh_Loai(
	Loai_phong_ban ENUM('Kế toán', 'Hành chính', 'Y tế', 'IT', 'Thư viện', 'Tổng hợp') PRIMARY KEY,
    Mo_ta TEXT
);
CREATE TABLE Phong_Ban_Hanh_Chinh (
	Ma_phong_ban VARCHAR(20) PRIMARY KEY,
    Ten_phong_ban VARCHAR(100) NOT NULL,
    Loai_phong_ban ENUM('Kế toán', 'Hành chính', 'Y tế', 'IT', 'Thư viện', 'Tổng hợp'),
    
    FOREIGN KEY (Loai_phong_ban) REFERENCES Phong_Ban_Hanh_Chinh_Loai(Loai_phong_ban)
);

-- Bảng Phòng học
CREATE TABLE Phong_Hoc (
	Ma_phong VARCHAR(20) PRIMARY KEY,
    Ten_phong VARCHAR(50) NOT NULL,
    Loai_phong ENUM('Lý thuyết', 'Thực hành', 'Đa năng','Phòng chức năng'),
    Suc_chua INT ,
    Dien_tich DECIMAL(5,2),
    Trang_thai ENUM('Hoạt động', 'Bảo trì', 'Ngừng sử dụng'),
    Toa_nha VARCHAR(50)
);

-- Bảng Năm học
CREATE TABLE Nam_Hoc (
	Ma_nam_hoc VARCHAR(20) PRIMARY KEY,
    Ten_nam_hoc VARCHAR(20) NOT NULL,
    Ngay_bat_dau DATE,
    Ngay_ket_thuc DATE,
    Trang_thai ENUM('Chưa bắt đầu', 'Đang diễn ra', 'Đã kết thúc')
);
-- Phần 2: Xây dựng các thực thể được kế thừa từ thực thể mạnh 

-- Bảng Giáo vien
CREATE TABLE GiaoVien_PhuCap_LuongCoBan (
	Chuc_vu VARCHAR(100) NOT NULL ,
    Trinh_do_hoc_van VARCHAR(100) NOT NULL,
    Phu_cap DECIMAL(12, 2),
    Luong_co_ban DECIMAL(12, 2),
    PRIMARY KEY (Chuc_vu, Trinh_do_hoc_van)
);

CREATE TABLE Giao_Vien (
	ID_giao_vien VARCHAR(20) PRIMARY KEY,
    Ngay_vao_lam DATE,
    Chuyen_mon_chinh VARCHAR(100),
    Chuyen_mon_phu VARCHAR(100),
    Trang_thai ENUM('Đang làm việc', 'Nghỉ phép', 'Thôi việc'),
    Chuc_vu VARCHAR(100) NOT NULL ,
    Trinh_do_hoc_van VARCHAR(100) NOT NULL,
    
    FOREIGN KEY (ID_giao_vien) REFERENCES Con_Nguoi(ID_con_nguoi)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (Chuc_vu, Trinh_do_hoc_van) 
        REFERENCES GiaoVien_PhuCap_LuongCoBan(Chuc_vu, Trinh_do_hoc_van)
        ON UPDATE CASCADE
);
-- Bảng Phụ huynh
CREATE TABLE Phu_Huynh(
	ID_phu_huynh VARCHAR(20) PRIMARY KEY,
    Nghe_nghiep VARCHAR(100),
    Noi_lam_viec VARCHAR(150),
    
    FOREIGN KEY (ID_phu_huynh) REFERENCES Con_Nguoi(ID_con_nguoi)
);

-- Bảng Nhân viên hành chính
CREATE TABLE NhanVienHanhChinh_PhuCap_LuongCoBan(
	Chuc_vu  ENUM('Trưởng phòng', 'Phó phòng', 'Nhân viên') NOT NULL,
    Trinh_do_hoc_van VARCHAR(100) NOT NULL,
    Phu_cap DECIMAL(12,2),
    Luong_co_ban DECIMAL(12,2),
    PRIMARY KEY (Chuc_vu, Trinh_do_hoc_van)
);
CREATE TABLE NhanVienHanhChinh_BangChungChi(
	Loai_cong_viec ENUM('Kế toán', 'Thủ quỹ', 'Thư ký', 'Văn thư'
						, 'Y tế', 'Bảo vệ', 'IT', 'Thư viện', 'Tạp vụ') PRIMARY KEY,
    Bang_chung_chi TEXT
);
CREATE TABLE Nhan_Vien_Hanh_Chinh(
	ID_nhan_vien VARCHAR(20) PRIMARY KEY,
    Ma_phong_ban VARCHAR(20),
    Chuc_vu ENUM('Trưởng phòng', 'Phó phòng', 'Nhân viên'),
    Trinh_do_hoc_van VARCHAR(100) NOT NULL,
    Loai_cong_viec ENUM('Kế toán', 'Thủ quỹ', 'Thư ký', 'Văn thư'
						, 'Y tế', 'Bảo vệ', 'IT', 'Thư viện', 'Tạp vụ'),
    Trang_thai ENUM('Đang làm việc', 'Nghỉ phép', 'Tạm nghỉ', 'Thôi việc'),
    Ngay_vao_lam DATE,
    Chuyen_mon  VARCHAR(150),
    
    FOREIGN KEY (ID_nhan_vien) REFERENCES Con_Nguoi(ID_con_nguoi)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (Chuc_vu, Trinh_do_hoc_van) REFERENCES NhanVienHanhChinh_PhuCap_LuongCoBan(Chuc_vu, Trinh_do_hoc_van)
		ON UPDATE CASCADE,
	FOREIGN KEY (Loai_cong_viec) REFERENCES NhanVienHanhChinh_BangChungChi(Loai_cong_viec)
		ON UPDATE CASCADE
);
-- Không xây được bảng Học sinh vì học sinh còn phụ thuộc vào lớp học

-- Phần 3: Xây dựng các thực thể liên kết 
-- Bảng Tổ bộ môn
CREATE TABLE To_Bo_Mon (
	Ma_to VARCHAR(20) PRIMARY KEY,
    Ten_to VARCHAR(100) NOT NULL,
    Mo_ta TEXT,
    ID_giao_vien_truong VARCHAR(20) NOT NULL,
    
    FOREIGN KEY (ID_giao_vien_truong) REFERENCES Giao_Vien(ID_giao_vien)
);

-- Bảng Môn học
CREATE TABLE MonHoc_Loai (
	Loai_mon ENUM('Bắt buộc', 'Tự chọn', 'Chuyên') PRIMARY KEY,
    He_so_diem DECIMAL(3,2)
);
CREATE TABLE Mon_Hoc (
	Ma_mon_hoc VARCHAR(20) PRIMARY KEY,
    Ten_mon_hoc VARCHAR(100) NOT NULL,
    Ma_to VARCHAR(20) NOT NULL,
    Loai_mon ENUM('Bắt buộc', 'Tự chọn', 'Chuyên'),
    So_tiet_tren_nam INT,
    So_tiet_tren_tuan INT,
    
    FOREIGN KEY (Loai_mon) REFERENCES MonHoc_Loai(Loai_mon)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (Ma_to) REFERENCES To_Bo_Mon(Ma_to)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Bảng Học kỳ
CREATE TABLE Hoc_Ky(
	Ma_hoc_ky VARCHAR(20) PRIMARY KEY,
    Ten_hoc_ky  VARCHAR(20),
    Trang_thai ENUM('Chưa bắt đầu', 'Đang diễn ra', 'Đã kết thúc'),
    Ngay_bat_dau DATE,
    Ngay_ket_thuc DATE,
    Ma_nam_hoc VARCHAR(20),
    FOREIGN KEY (Ma_nam_hoc) REFERENCES Nam_Hoc(Ma_nam_hoc)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);
-- Bảng Lớp học 
CREATE TABLE Lop_Hoc(
	Ma_lop_hoc VARCHAR(20) PRIMARY KEY,
    
);
-- Phần 3: Xây dựng các bảng thuộc tính đa trị
-- Phần 4: Xây dựng các thực thể yếu
-- Phần 5: Xây dựng các bảng liên kết