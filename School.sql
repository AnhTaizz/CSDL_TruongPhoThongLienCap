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
    Ma_phong_ban VARCHAR(20) NOT NULL,
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
		ON UPDATE CASCADE,
	FOREIGN KEY (Ma_phong_ban) REFERENCES Phong_Ban_Hanh_Chinh(Ma_phong_ban)
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
-- Thêm cột Ma_to vào bảng Giao_Vien
ALTER TABLE Giao_Vien
ADD COLUMN Ma_to VARCHAR(20);
-- Thêm ràng buộc Khóa Ngoại Ma_to (Tham chiếu đến bảng To_Bo_Mon vừa tạo)
ALTER TABLE Giao_Vien
ADD CONSTRAINT fk_giao_vien_ma_to
FOREIGN KEY (Ma_to) 
    REFERENCES To_Bo_Mon(Ma_to) 
    ON UPDATE CASCADE
    ON DELETE SET NULL;

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
    Ten_lop VARCHAR(50) NOT NULL,
    Khoi_hoc INT,
    Loai_lop ENUM('Thường', 'Chuyên', 'Tích hợp'),
    Si_so INT NOT NULL,
    ID_giao_vien_chu_nhiem VARCHAR(20) NOT NULL,
    
    FOREIGN KEY (ID_giao_vien_chu_nhiem) REFERENCES Giao_Vien(ID_giao_vien)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	CONSTRAINT chk_khoi_hoc CHECK (Khoi_hoc > 0 AND Khoi_hoc <= 12)
);

-- Bảng học sinh
CREATE TABLE Hoc_Sinh (
	ID_hoc_sinh VARCHAR(20) PRIMARY KEY,
    Ma_so_BHYT VARCHAR(20),
    Ngay_nhap_hoc DATE,
    Hanh_kiem VARCHAR(20),
    Trang_thai ENUM('Đang học', 'Nghỉ học', 'Chuyển trường', 'Thôi học'),
    Ma_lop_hoc VARCHAR(20),
    
    FOREIGN KEY (Ma_lop_hoc) REFERENCES Lop_Hoc(Ma_lop_hoc)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

ALTER TABLE Hoc_Sinh
ADD COLUMN ID_lop_truong VARCHAR(50) NULL, 
ADD CONSTRAINT fk_hocsinh_loptruong
FOREIGN KEY (ID_lop_truong)
    REFERENCES HOC_SINH(ID_hoc_sinh)
    ON UPDATE CASCADE
    ON DELETE SET NULL;


-- Phần 3: Xây dựng các bảng thuộc tính đa trị

-- Bảng Con người số điện thoại
-- Bảng Con người số điện thoại
CREATE TABLE Con_Nguoi_Sdt (
	ID_con_nguoi VARCHAR(20) NOT NULL,
    So_dien_thoai VARCHAR(15),
    PRIMARY KEY (ID_con_nguoi, So_dien_thoai),
    FOREIGN KEY (ID_con_nguoi) REFERENCES Con_Nguoi(ID_con_nguoi)
);

-- Bảng con người email
CREATE TABLE Con_Nguoi_Email (
	ID_con_nguoi VARCHAR(20) NOT NULL,
    Email VARCHAR(100),
    PRIMARY KEY (ID_con_nguoi, Email),
    FOREIGN KEY (ID_con_nguoi) REFERENCES Con_Nguoi(ID_con_nguoi)
);

-- Phần 4: Xây dựng các thực thể yếu

-- Bảng Lịch học
CREATE TABLE Lich_Hoc (
	Ma_lich_hoc VARCHAR(20) PRIMARY KEY,
    Tiet_hoc INT CHECK (Tiet_hoc < 10 AND Tiet_hoc >= 1),
    Thu ENUM('Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7'),
    Ngay_bat_dau DATE,
    Ngay_ket_thuc DATE,
    ID_giao_vien VARCHAR(20) NOT NULL,
    Ma_hoc_ky VARCHAR(20) NOT NULL,
    Ma_lop_hoc VARCHAR(20) NOT NULL,
    Ma_phong VARCHAR(20) NOT NULL,
    
    FOREIGN KEY (ID_giao_vien) REFERENCES Giao_Vien(ID_giao_vien)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (Ma_hoc_ky) REFERENCES Hoc_Ky(Ma_hoc_ky)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (Ma_lop_hoc) REFERENCES Lop_Hoc(Ma_lop_hoc)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (Ma_phong) REFERENCES Phong_Hoc(Ma_phong)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	
	-- Ràng buộc UNIQUE để tránh trùng lịch học
    UNIQUE KEY uk_lichhoc_thulop (Thu, Tiet_hoc, Ma_lop_hoc, Ma_hoc_ky),
    CONSTRAINT chk_tiet_hoc CHECK (Tiet_hoc BETWEEN 1 AND 9)
);

-- Bảng điểm số
CREATE TABLE DiemSo_Loai(
	Loai_diem ENUM('Miệng', '15 phút', '1 tiết', 'Cuối kỳ') PRIMARY KEY,
    He_so INT
);
CREATE TABLE Diem_So(
	Ma_diem VARCHAR(20) PRIMARY KEY,
    Diem DECIMAL(3,1),
    Ngay_ghi_diem DATE,
    ID_hoc_sinh VARCHAR(20) NOT NULL,
    Ma_mon_hoc VARCHAR(20) NOT NULL,
    Loai_diem ENUM('Miệng', '15 phút', '1 tiết', 'Cuối kỳ'),
    
    FOREIGN KEY (ID_hoc_sinh) REFERENCES Hoc_Sinh(ID_hoc_sinh)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (Ma_mon_hoc) REFERENCES Mon_Hoc(Ma_mon_hoc)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (Loai_diem) REFERENCES DiemSo_Loai(Loai_diem)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Bảng Thanh toán
CREATE TABLE Thanh_Toan(
	Ma_thanh_toan VARCHAR(20) PRIMARY KEY,
    Ma_bien_lai  VARCHAR(50),
    Phuong_thuc_thanh_toan ENUM('Tiền mặt', 'Chuyển khoản', 'Online', 'Ví điện tử'),
    Ngay_thanh_toan DATE,
    So_tien_thanh_toan DECIMAL(12,2),
    Trang_thai ENUM('Hợp lệ', 'Hủy', 'Hoàn tiền'),
    Ghi_chu TEXT,
    ID_nhan_vien_thanh_toan VARCHAR(20),
    
    FOREIGN KEY (ID_nhan_vien_thanh_toan) REFERENCES Nhan_Vien_Hanh_Chinh(ID_nhan_vien)
		ON UPDATE CASCADE
        ON DELETE CASCADE
    
);

-- Bảng Công nợ
CREATE TABLE CongNo_Loai_Phi (
	Loai_phi ENUM('Học phí', 'Phí dịch vụ', 'Phí hoạt động', 'Phí bảo hiểm') PRIMARY KEY,
	So_tien DECIMAL(12,2),
    Han_nop DATE
);
CREATE TABLE Cong_No (
	Ma_cong_no VARCHAR(20) PRIMARY KEY,
    Loai_phi ENUM('Học phí', 'Phí dịch vụ', 'Phí hoạt động', 'Phí bảo hiểm'),
    Ghi_chu TEXT,
    Trang_thai ENUM('Đã nộp đủ', 'Nợ', 'Đang xử lý'),
	Ma_thanh_toan VARCHAR(20) NOT NULL,
    ID_hoc_sinh VARCHAR(20) NOT NULL,
    
    FOREIGN KEY (Loai_phi) REFERENCES CongNo_Loai_Phi(Loai_phi)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (Ma_thanh_toan) REFERENCES Thanh_Toan(Ma_thanh_toan)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (ID_hoc_sinh) REFERENCES Hoc_Sinh(ID_hoc_sinh)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);
-- Phần 5: Xây dựng các bảng liên kết
-- Bảng Quan hệ phụ huynh- học sinh
CREATE TABLE PhuHuynh_HocSinh (
	ID_phu_huynh VARCHAR(20) NOT NULL,
    ID_hoc_sinh VARCHAR(20) NOT NULL,
	Moi_quan_he TEXT,
    PRIMARY KEY (ID_phu_huynh, ID_hoc_sinh),
    FOREIGN KEY (ID_phu_huynh) REFERENCES Phu_Huynh(ID_phu_huynh),
    FOREIGN KEY (ID_hoc_sinh) REFERENCES Hoc_Sinh(ID_hoc_sinh)
);