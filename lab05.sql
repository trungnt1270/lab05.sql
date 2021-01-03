USE master
IF EXISTS (SELECT * FROM sys.sysdatabases WHERE Name Like 'lab05')
	DROP DATABASE lab05

CREATE DATABASE lab05
GO

USE lab05
CREATE TABLE PhongBan(
	MaPB VARCHAR(7) PRIMARY KEY,
	TenPB NVARCHAR(50)
)

CREATE TABLE NhanVien(
	MaNV VARCHAR(7) PRIMARY KEY,
	TenNV NVARCHAR(50),
	NgaySinh DATETIME, CONSTRAINT CH_date CHECK (NgaySinh<GetDate()),
	SoCMND CHAR(9), CONSTRAINT CH_socmnd CHECK (SoCMND LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	GioiTinh CHAR(1) DEFAULT('M'), CONSTRAINT CH_GT CHECK (GioiTinh='M' OR GioiTinh='F'),
	DiaChi NVARCHAR(100),
	NgayVaoLam DATETIME,
	MaPB VARCHAR(7),
	CONSTRAINT fk_MaPB FOREIGN KEY (MaPB) REFERENCES PhongBan(MaPB),
	CONSTRAINT chk_ngayvaolam CHECK (DateDiff(yy,NgaySinh,NgayVaoLam)>=20)
)

CREATE TABLE LuongDA(
	MaDA VARCHAR(8),
	MaNV VARCHAR(7),
	NgayNhan DATETIME DEFAULT (GETDATE()) NOT NULL,
	SoTien MONEY, CONSTRAINT CH_tien CHECK (SoTien > 0),
	CONSTRAINT pk_luongda PRIMARY KEY (MaDA,MaNV),
	CONSTRAINT fk_manvda FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
)

--1
INSERT INTO PhongBan 
VALUES  ('5','Phong Maketing'),
		('4','Phong Nghiep Vu'),
		('3','Phong Tai Chinh'),
		('2','Phong Ky Thuat'),
		('1','Phong Ban Quan Tri')

INSERT INTO NhanVien(MaNV,TenNV,NgaySinh,SoCMND,GioiTinh,DiaChi,NgayVaoLam,MaPB)
VALUES  ('1','Nguyen Van A','1990-01-01','111111111','M','Ha Noi','2015-01-01','1'),
		('2','Nguyen Van B','1992-02-02','111111112','M','Ha Noi','2015-01-01','2'),
		('3','Nguyen Van C','1993-03-03','111111113','M','Ha Noi','2015-01-01','3'),
		('4','Nguyen Van D','1994-04-04','111111114','M','Ha Noi','2015-01-01','4'),
		('5','Nguyen Van E','1995-05-05','111111115','M','Ha Noi','2015-01-01','5')
		
INSERT INTO LuongDA(MaDA,MaNV,NgayNhan,SoTien)
VALUES  ('1','1','2019-01-01',100000000),
		('2','2','2019-01-01',30000000),
		('3','2','2019-01-01',20000000),
		('4','3','2019-01-01',40000000),
		('5','4','2019-01-01',50000000)
		
--2
SELECT * FROM PhongBan
SELECT * FROM NhanVien
SELECT * FROM LuongDA

--3
SELECT * FROM NhanVien WHERE GioiTinh = 'F'

--4
SELECT * FROM LuongDA

--5
SELECT MaNV, SUM(SoTien) 'Tong Luong' FROM LuongDA GROUP BY MaNV

--6
SELECT * FROM NhanVien INNER JOIN PhongBan ON NhanVien.MaPB = PhongBan.MaPB WHERE PhongBan.TenPB LIKE 'Phong Ky Thuat'

--7
SELECT NhanVien.TenNV, SUM(SoTien) 'Tong Luong' 
FROM NhanVien INNER JOIN LuongDA ON NhanVien.MaNV = LuongDA.MaNV 
WHERE NhanVien.MaPB ='3' 
GROUP BY NhanVien.TenNV
--8
SELECT MaPB, COUNT(MaPB) AS N'Số Lượng NV'
FROM NhanVien
GROUP BY MaPB
--9
SELECT LuongDA.MaNV, NhanVien.TenNV
FROM LuongDA
INNER JOIN NhanVien ON NhanVien.MaNV = LuongDA.MaNV
GROUP BY LuongDA.MaNV
--10
SELECT TOP 1 MaPB, COUNT(MaPB) AS N'Số Lượng NV'
FROM NhanVien
GROUP BY MaPB 
ORDER BY COUNT(MaPB) DESC
--11
SELECT MaPB, COUNT(MaPB) AS N'Số Lượng NV'
FROM NhanVien
WHERE MaPB = '3'
GROUP BY MaPB
--12
SELECT NhanVien.MaNV, SUM(LuongDA.SoTien) AS N'Tổng Lương'
FROM NhanVien
INNER JOIN LuongDA ON NhanVien.MaNV = LuongDA.MaNV
WHERE NhanVien.SoCMND LIKE '%4'
GROUP BY NhanVien.MaNV
--13
SELECT TOP 1 MaNV, SUM(SoTien) AS N'Lương Cao Nhất'
FROM LuongDA
GROUP BY MaNV
ORDER BY SUM(SoTien) DESC
--14
SELECT NhanVien.MaNV
FROM NhanVien INNER JOIN LuongDA ON NhanVien.MaNV = LuongDA.MaNV
WHERE NhanVien.GioiTinh = 'F'
GROUP BY NhanVien.MaNV
HAVING SUM(LuongDA.SoTien)>5000000
--15
SELECT MaPB, SUM(LuongDA.SoTien) AS N'Tổng Lương'
FROM NhanVien INNER JOIN LuongDA ON NhanVien.MaNV = LuongDA.MaNV
GROUP BY MaPB
--16
SELECT MaDA,COUNT(MaNV) AS N'Số Lượng Nhân Viên'
	FROM LuongDA  GROUP BY MaDA HAVING Count(MaNV)>=2
--17
SELECT * FROM NhanVien
WHERE TenNV LIKE 'N%'
--18
SELECT NhanVien.*
FROM LuongDA INNER JOIN NhanVien ON LuongDA.MaNV = NhanVien.MaNV
WHERE LuongDA.NgayNhan >'2003-01-01' AND LuongDA.NgayNhan <'2003-12-31'
GROUP BY LuongDA.MaNV
--19
SELECT *
FROM NhanVien
WHERE MaNV IN (SELECT MaNV FROM LuongDA GROUP BY MaNV HAVING COUNT(MaNV)<1)
--20
DELETE FROM LuongDA WHERE MaDA = 'DXD02'
--21
DELETE FROM LuongDA WHERE MaNV IN (SELECT MaNV FROM LuongDA GROUP BY MaNV HAVING SUM(SoTien)<20000)
--22
UPDATE LuongDA
	SET SoTien = SoTien*1.1 WHERE MaDA = 'XDX01'
--23
DELETE FROM NhanVien
WHERE MaNV IN (SELECT MaNV FROM LuongDA GROUP BY MaNV HAVING COUNT(MaNV)<1)
--24
UPDATE NhanVien
	SET NgayVaoLam = '2019-02-12' WHERE MaPB = '4'