
-- 1. Xóa bảng liên kết và phụ thuộc trước
DROP TABLE IF EXISTS News_Tag;
DROP TABLE IF EXISTS Editor_Check_News;
DROP TABLE IF EXISTS Comment;

-- 2. Xóa bảng News và các bảng liên quan
DROP TABLE IF EXISTS News;
DROP TABLE IF EXISTS List_Deleted_News;
DROP TABLE IF EXISTS Status_Of_News;

-- 3. Xóa các bảng phụ thuộc vào User
DROP TABLE IF EXISTS Subcriber;
DROP TABLE IF EXISTS Writer;
DROP TABLE IF EXISTS Editor;
DROP TABLE IF EXISTS Administrator;

-- 4. Xóa các bảng khác liên quan
DROP TABLE IF EXISTS SubCategory;
DROP TABLE IF EXISTS Category;
DROP TABLE IF EXISTS Tag;

-- 5. Xóa bảng User
DROP TABLE IF EXISTS User;


-- 6. Xoá các trigger
DROP TRIGGER IF EXISTS Before_Insert_Subcriber;
DROP TRIGGER IF EXISTS After_Delete_Writer;
DROP TRIGGER IF EXISTS Before_Delete_Writer;
DROP TRIGGER IF EXISTS Before_Delete_Editor;
DROP TRIGGER IF EXISTS After_News_Delete;
DROP TRIGGER IF EXISTS SetDefaultStatus;



CREATE TABLE Category (
    Id_Category VARCHAR(100) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Status BIT NOT NULL
);

CREATE TABLE SubCategory (
    Id_SubCategory VARCHAR(100) PRIMARY KEY,
    Id_Category VARCHAR(100),
    Name VARCHAR(100) NOT NULL,
    FOREIGN KEY (Id_Category) REFERENCES Category(Id_Category) ON DELETE SET NULL ON UPDATE CASCADE
		-- ON DELETE SET NULL
);

-- //////////////////////



CREATE TABLE User (
    Id_User VARCHAR(100),
    Name VARCHAR(100),
    Birthday DATE NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Password VARCHAR(100) NOT NULL,
		
		Date_register DATETIME,
		PRIMARY KEY (Id_User, Email)
);

CREATE TABLE Administrator (
    Id_Administrator VARCHAR(100) PRIMARY KEY,
    Id_User VARCHAR(100) UNIQUE NOT NULL,
    FOREIGN KEY (Id_User) REFERENCES User(Id_User) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Editor (
    Id_Editor VARCHAR(100) PRIMARY KEY,
    Id_User VARCHAR(100) UNIQUE NOT NULL,
    Id_Category VARCHAR(100) NOT NULL,
    FOREIGN KEY (Id_User) REFERENCES User(Id_User) ON DELETE CASCADE ON UPDATE CASCADE,
		FOREIGN KEY (Id_Category) REFERENCES Category(Id_Category) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Writer (
    Id_Writer VARCHAR(100) PRIMARY KEY,
    Id_User VARCHAR(100) UNIQUE NOT NULL,
		Pen_Name VARCHAR(100) NOT NULL,
    Id_Category VARCHAR(100) NOT NULL,
    FOREIGN KEY (Id_User) REFERENCES User(Id_User) ON DELETE CASCADE ON UPDATE CASCADE,
		FOREIGN KEY (Id_Category) REFERENCES Category(Id_Category) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Subcriber (
    Id_Subcriber VARCHAR(100) PRIMARY KEY,
    Id_User VARCHAR(100) UNIQUE NOT NULL,
    Date_register DATETIME NOT NULL,
		Date_expired DATETIME, 
		Request BIT DEFAULT 0,
    FOREIGN KEY (Id_User) REFERENCES User(Id_User) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ///////////////////////////////////////////////////////////////////////////



CREATE TABLE Tag (
    Id_Tag VARCHAR(100) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Status BIT NOT NULL
);


CREATE TABLE Status_Of_News (
		Id_Status VARCHAR(100) PRIMARY KEY,
		Title_Status VARCHAR(100)
);

CREATE TABLE News (

    Id_SubCategory VARCHAR(100),
		Id_Writer VARCHAR(100),
		Id_Status VARCHAR(100) NOT NULL,
		
		Id_News VARCHAR(100) PRIMARY KEY,
    Date DATETIME NOT NULL,
    Comments TEXT,
		Premium BIT,
    Views INT,
    Content TEXT,
    Image LONGBLOB,
    Title VARCHAR(400) NOT NULL,
    Meta_title LONGTEXT NOT NULL,
    Meta_description LONGTEXT NOT NULL,
    FOREIGN KEY (Id_SubCategory) REFERENCES SubCategory(Id_SubCategory) ON DELETE SET NULL ON UPDATE CASCADE, -- khi 1 subcatelogy bị xoá, thì news có subcatelogy đó sẽ bị xoá theo
		FOREIGN KEY (Id_Writer) REFERENCES Writer(Id_Writer) ON DELETE SET NULL ON UPDATE CASCADE,
		FOREIGN KEY (Id_Status) REFERENCES Status_Of_News(Id_Status)

   
);


CREATE TABLE List_Deleted_News (

		Id_SubCategory VARCHAR(100),
		Id_Writer VARCHAR(100),
		Id_Status VARCHAR(100) NOT NULL,
		
		Id_News VARCHAR(100) PRIMARY KEY,
    Date DATETIME NOT NULL,
    Comments TEXT,
		Premium BIT,
    Views INT,
    Content TEXT,
    Image LONGBLOB,
    Title VARCHAR(100) NOT NULL,
    Meta_title VARCHAR(100) NOT NULL,
    Meta_description LONGTEXT NOT NULL
);



CREATE TABLE Comment (
    Id_Comment VARCHAR(100) PRIMARY KEY,
    Id_User VARCHAR(100) NOT NULL,
		Id_News VARCHAR(100) NOT NULL,
		Time DATETIME,
    Comment TEXT,
    FOREIGN KEY (Id_User) REFERENCES User(Id_User) ON DELETE CASCADE ON UPDATE CASCADE,
		FOREIGN KEY (Id_News) REFERENCES News(Id_News) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Editor_Check_News (
		Id_Editor VARCHAR(100) ,
		Id_News VARCHAR(100) , 
		Reason VARCHAR(100) NOT NULL, 
		Date_feedback DATE,
		FOREIGN KEY (Id_Editor) REFERENCES Editor(Id_Editor) ON DELETE SET NULL ON UPDATE CASCADE, -- thêm trigger nếu xoá id_editor thì id_editor của news đó giữ lại id_editor cập nhật cuối cùng
		FOREIGN KEY (Id_News) REFERENCES News(Id_News) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE News_Tag (
    Id_News VARCHAR(100) NOT NULL,
    Id_Tag VARCHAR(100) NOT NULL,
    FOREIGN KEY (Id_News) REFERENCES News(Id_News) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (Id_Tag) REFERENCES Tag(Id_Tag) ON DELETE CASCADE ON UPDATE CASCADE
);


-- Trigger: Khi tạo đăng kí 1 Subcriber chỉ cần ngày đăng kí (Date_register), trigger tự động tính ngày hết hạn (Date_expired) = Date_register + 7 
DELIMITER //

CREATE TRIGGER Before_Insert_Subcriber
BEFORE INSERT ON Subcriber
FOR EACH ROW
BEGIN
    -- Nếu Date_expired không được cung cấp, tự động tính toán bằng cách thêm 7 ngày vào Date_register
    IF NEW.Date_expired IS NULL THEN
        SET NEW.Date_expired = DATE_ADD(NEW.Date_register, INTERVAL 7 DAY);
    END IF;
END //

DELIMITER ;




ALTER TABLE News 
ADD FULLTEXT(title, content, Meta_title, Meta_description);

ALTER TABLE Tag 
ADD FULLTEXT(Name);


-- Insert values into Category
INSERT INTO Category (Id_Category, Name, Status) 
VALUES 
('CAT0000', 'default', 0),
('CAT0001', 'Thời sự1', 1),
('CAT0002', 'Kinh doanh2', 1),
('CAT0003', 'Khoa học3', 1),
('CAT0004', 'Thể thao4', 1),
('CAT0005', 'Giáo dục5', 1),
('CAT0006', 'Đời sống6', 1),
('CAT0007', 'Thế giới7', 1),
('CAT0008', 'Bất động sản8', 1),
('CAT0009', 'Giải trí9', 1),
('CAT0010', 'Pháp luật10', 1),
('CAT0011', 'Sức khỏe11', 1),
('CAT0012', 'Du lịch12', 1);

-- Insert values into SubCategory
INSERT INTO SubCategory (Id_SubCategory, Id_Category, Name)
VALUES 
-- Subcategories for CAT001 (Thời sự1)
('SUB0001', 'CAT0001', 'Chính trị1'),
('SUB0002', 'CAT0001', 'Xã hội'),
('SUB0003', 'CAT0001', 'Kinh tế'),
('SUB0004', 'CAT0001', 'Văn hóa'),

-- Subcategories for CAT002 (Kinh doanh1)
('SUB0005', 'CAT0002', 'Doanh nghiệp2'),
('SUB0006', 'CAT0002', 'Tài chính'),
('SUB0007', 'CAT0002', 'Thị trường'),
('SUB0008', 'CAT0002', 'Khởi nghiệp'),

-- Subcategories for CAT003 (Khoa học1)
('SUB0009', 'CAT0003', 'Công nghệ3'),
('SUB0010', 'CAT0003', 'Vũ trụ'),
('SUB0011', 'CAT0003', 'Sinh học'),
('SUB0012', 'CAT0003', 'Môi trường'),

-- Subcategories for CAT004 (Thể thao1)
('SUB0013', 'CAT0004', 'Bóng đá4'),
('SUB0014', 'CAT0004', 'Bóng chuyền'),
('SUB0015', 'CAT0004', 'Điền kinh'),
('SUB0016', 'CAT0004', 'Cầu lông'),

-- Subcategories for CAT005 (Giáo dục)
('SUB0017', 'CAT0005', 'Học bổng5'),
('SUB0018', 'CAT0005', 'Tuyển sinh'),
('SUB0019', 'CAT0005', 'Đào tạo'),
('SUB0020', 'CAT0005', 'Nghiên cứu'),

-- Subcategories for CAT006 (Đời sống)
('SUB0021', 'CAT0006', 'Gia đình6'),
('SUB0022', 'CAT0006', 'Sức khỏe'),
('SUB0023', 'CAT0006', 'Làm đẹp'),
('SUB0024', 'CAT0006', 'Tâm sự'),

-- Subcategories for CAT007 (Thế giới)
('SUB0025', 'CAT0007', 'Châu Á7'),
('SUB0026', 'CAT0007', 'Châu Âu'),
('SUB0027', 'CAT0007', 'Châu Mỹ'),
('SUB0028', 'CAT0007', 'Châu Phi'),

-- Subcategories for CAT008 (Bất động sản)
('SUB0029', 'CAT0008', 'Nhà ở8'),
('SUB0030', 'CAT0008', 'Văn phòng'),
('SUB0031', 'CAT0008', 'Đầu tư'),
('SUB0032', 'CAT0008', 'Pháp lý'),

-- Subcategories for CAT009 (Giải trí)
('SUB0033', 'CAT0009', 'Phim ảnh9'),
('SUB0034', 'CAT0009', 'Ca nhạc'),
('SUB0035', 'CAT0009', 'Gameshow'),
('SUB0036', 'CAT0009', 'Sân khấu'),

-- Subcategories for CAT010 (Pháp luật)
('SUB0037', 'CAT0010', 'Hình sự10'),
('SUB0038', 'CAT0010', 'Dân sự'),
('SUB0039', 'CAT0010', 'Lao động'),
('SUB0040', 'CAT0010', 'Kinh tế'),

-- Subcategories for CAT011 (Sức khỏe)
('SUB0041', 'CAT0011', 'Dinh dưỡng11'),
('SUB0042', 'CAT0011', 'Bệnh lý'),
('SUB0043', 'CAT0011', 'Tập luyện'),
('SUB0044', 'CAT0011', 'Tâm lý'),

-- Subcategories for CAT012 (Du lịch)
('SUB0045', 'CAT0012', 'Trong nước12'),
('SUB0046', 'CAT0012', 'Quốc tế'),
('SUB0047', 'CAT0012', 'Ẩm thực'),
('SUB0048', 'CAT0012', 'Văn hóa');


-- Insert values into User
INSERT INTO User (Id_User, Name, Birthday, Email, Password, Date_register) 
VALUES 
-- admin
('USR0001', 'Công Thuận', '1990-01-01', 'jozz111hn.doe@example.com', 'password123', '2024-12-08 10:30:00'),

-- editor
('USR0002', 'Minh Thư', '1995-05-05', 'janq222e.smith@example.com', 'password123', '2024-12-08 10:30:00'),
('USR0003', 'Phương Huy', '1988-08-08', 'mikq33e.brown@example.com', 'password123', '2024-12-08 10:30:00'),
('USR0004', 'Duy Trì', '1992-02-02', 'emaily44.davis@example.com', 'password123', '2024-12-08 10:30:00'),
('USR0005', 'Minh Louis Vuitton', '1990-01-01', 'jd56ohn.doe@example.com', 'password123', '2024-12-08 10:30:00'),


-- writer
('USR0006', 'Chán đời', '1995-05-05', 'jafne.smith@example.com', 'password123', '2024-12-08 10:30:00'),
('USR0007', 'Cá sấu', '1988-08-08', 'minske.brown@example.com', 'password123', '2024-12-08 10:30:00'),
('USR0008', 'Thỏ 7màu', '1992-02-02', 'emil33by.davis@example.com', 'password123', '2024-12-08 10:30:00'),
('USR0009', 'Jack97', '1992-02-02', 'emi33333vly.davis@example.com', 'password123', '2024-12-08 10:30:00'),
('USR0010', 'Riverside', '1992-02-02', 'emivggly.davis@example.com', 'password123', '2024-12-08 10:30:00'),
('USR0011', 'Bcon Plaza', '1992-02-02', 'emilngfcy.davis@example.com', 'password123', '2024-12-08 10:30:00'),
('USR0012', 'Nguyễn Văn A', '1993-03-03', 'nguyenvana@example.com', 'password123', '2024-12-08 10:30:00'),
('USR0013', 'Trần Thị B', '1994-04-04', 'tranthib@example.com', 'password123', '2024-12-08 10:30:00'),
('USR0014', 'Lê Văn C', '1991-01-01', 'levanc@example.com', 'password123', '2024-12-08 10:30:00'),
('USR0015', 'Phạm Thị D', '1990-02-02', 'phamthid@example.com', 'password123', '2024-12-08 10:30:00'),
('USR0016', 'Đỗ Văn E', '1989-05-05', 'dovanE@example.com', 'password123', '2024-12-08 10:30:00'),
('USR0017', 'Nguyễn Thị F', '1995-06-06', 'nguyenthif@example.com', 'password123', '2024-12-08 10:30:00'),
('USR0018', 'Trần Văn G', '1992-07-07', 'tranvang@example.com', 'password123', '2024-12-08 10:30:00'),
('USR0019', 'Lê Thị H', '1993-08-08', 'lethih@example.com', 'password123', '2024-12-08 10:30:00'),
('USR0020', 'Phạm Văn I', '1994-09-09', 'phamvani@example.com', 'password123', '2024-12-08 10:30:00'),


-- Subcriber
('USR0021', 'Đỗ Thị J', '1991-10-10', 'dothij@example.com', 'password123', '2024-12-08 10:30:00'),


-- ortherUser
('USR0022', 'Luong Vi Minh', '1984-09-09', 'lvm@gmail.com', 'password123', '2024-12-08 10:30:00');


-- Insert values into Administrator
INSERT INTO Administrator (Id_Administrator, Id_User) 
VALUES 
('ADM0001', 'USR0001');

-- Insert values into Editor
INSERT INTO Editor (Id_Editor, Id_User, Id_Category) 
VALUES 
('EDT0001', 'USR0002', 'CAT0001'),
('EDT0002', 'USR0003', 'CAT0002'),
('EDT0003', 'USR0004', 'CAT0003'),  -- Editor 3
('EDT0004', 'USR0005', 'CAT0004');  -- Editor 4

-- Insert values into Writer
INSERT INTO Writer (Id_Writer, Id_User, Id_Category , Pen_Name) 
VALUES 
('WRT0001', 'USR0006', 'CAT0001', 'Son Tinh'),
('WRT0002', 'USR0007', 'CAT0001', 'Son Nippon'),
('WRT0003', 'USR0008', 'CAT0001', 'Son duong'),
('WRT0004', 'USR0009', 'CAT0001', 'Son tung'),

('WRT0005', 'USR0010', 'CAT0002', 'lung tung'),
('WRT0006', 'USR0011', 'CAT0003', 'Son tung'),
('WRT0007', 'USR0012', 'CAT0004', 'Son tung'),
('WRT0008', 'USR0013', 'CAT0005', 'Son tung'),
('WRT0009', 'USR0014', 'CAT0006', 'Son tung'),
('WRT0010', 'USR0015', 'CAT0007', 'Son tung'),
('WRT0011', 'USR0016', 'CAT0008', '5 trieu'),
('WRT0012', 'USR0017', 'CAT0009', 'Dom dom'),
('WRT0013', 'USR0018', 'CAT0010', 'Ben Tree'),
('WRT0014', 'USR0019', 'CAT0011', 'Jack'),
('WRT0015', 'USR0020', 'CAT0012', 'J97'); 

-- Insert values into Subcriber
INSERT INTO Subcriber (Id_Subcriber, Id_User, Date_register) 
VALUES 
('SUBC0001', 'USR0021', '2024-01-01');


-- INSERT INTO Subcriber (Id_Subcriber, Id_User, Date_register) 
-- VALUES 
-- ('SUBC0002', 'USR0022', '2024-08-01');

-- Insert values into Tag
INSERT INTO Tag (Id_Tag, Name, Status) 
VALUES 
('TAG0001', '#Chính trị', 1),
('TAG0002', '#Kinh tế', 1),
('TAG0003', '#Thể thao', 1),
('TAG0004', '#Giáo dục', 1),
('TAG0005', '#Công nghệ', 1),
('TAG0006', '#Bóng đá', 1),
('TAG0007', '#Thời sự', 1),
('TAG0008', '#Du lịch', 1),
('TAG0009', '#Văn hóa', 1),
('TAG0010', '#Giải trí', 1),
('TAG0011', '#Khoa học', 1),
('TAG0012', '#Y tế', 1),
('TAG0013', '#Môi trường', 1),
('TAG0014', '#Xã hội', 1),
('TAG0015', '#Pháp luật', 1),
('TAG0016', '#Đời sống', 1),
('TAG0017', '#Kinh doanh', 1),
('TAG0018', '#Quốc tế', 1),
('TAG0019', '#Nghệ thuật', 1),
('TAG0020', '#Âm nhạc', 1),
('TAG0021', '#Điện ảnh', 1),
('TAG0022', '#Game', 1),
('TAG0023', '#Sách', 1),
('TAG0024', '#Ẩm thực', 1),
('TAG0025', '#Thời trang', 1),
('TAG0026', '#Công nghiệp', 1),
('TAG0027', '#Nông nghiệp', 1),
('TAG0028', '#Giao thông', 1),
('TAG0029', '#Bất động sản', 1),
('TAG0030', '#Tài chính', 1),
('TAG0031', '#Chứng khoán', 1),
('TAG0032', '#Tiền tệ', 1),
('TAG0033', '#Xuất nhập khẩu', 1),
('TAG0034', '#Lao động', 1),
('TAG0035', '#Việc làm', 1),
('TAG0036', '#Khởi nghiệp', 1),
('TAG0037', '#Đổi mới', 1),
('TAG0038', '#Sáng tạo', 1),
('TAG0039', '#An ninh', 1),
('TAG0040', '#Quốc phòng', 1),
('TAG0041', '#Biển đảo', 1),
('TAG0042', '#Ngoại giao', 1),
('TAG0043', '#Hợp tác', 1),
('TAG0044', '#Phát triển', 1),
('TAG0045', '#Đầu tư', 1),
('TAG0046', '#Thương mại', 1),
('TAG0047', '#Dịch vụ', 1),
('TAG0048', '#Truyền thông', 1),
('TAG0049', '#Báo chí', 1),
('TAG0050', '#Mạng xã hội', 1),
('TAG0051', '#Trí tuệ nhân tạo', 1),
('TAG0052', '#Học máy', 1),
('TAG0053', '#Người máy', 1),
('TAG0054', '#Internet vạn vật', 1),
('TAG0055', '#Điện toán đám mây', 1),
('TAG0056', '#An ninh mạng', 1),
('TAG0057', '#Dữ liệu lớn', 1),
('TAG0058', '#Khởi nghiệp sáng tạo', 1),
('TAG0059', '#Công nghệ tài chính', 1),
('TAG0060', '#Thương mại điện tử', 1),
('TAG0061', '#Tiếp thị số', 1),
('TAG0062', '#Tối ưu công cụ tìm kiếm', 1),
('TAG0063', '#Ứng dụng di động', 1),
('TAG0064', '#Phát triển web', 1),
('TAG0065', '#Thiết kế trải nghiệm', 1),
('TAG0066', '#Khoa học dữ liệu', 1),
('TAG0067', '#Thực tế ảo', 1),
('TAG0068', '#Thực tế tăng cường', 1),
('TAG0069', '#Tiền điện tử', 1),
('TAG0070', '#Thành phố thông minh', 1),
('TAG0071', '#Năng lượng tái tạo', 1),
('TAG0072', '#Năng lượng mặt trời', 1),
('TAG0073', '#Năng lượng gió', 1),
('TAG0074', '#Xe điện', 1),
('TAG0075', '#Biến đổi khí hậu', 1),
('TAG0076', '#Phát triển bền vững', 1),
('TAG0077', '#Công nghệ xanh', 1),
('TAG0078', '#Quản lý rác thải', 1),
('TAG0079', '#Tái chế', 1),
('TAG0080', '#Đa dạng sinh học', 1),
('TAG0081', '#Bảo tồn đại dương', 1),
('TAG0082', '#Bảo vệ động vật hoang dã', 1),
('TAG0083', '#Nông nghiệp hữu cơ', 1),
('TAG0084', '#Nông nghiệp thông minh', 1),
('TAG0085', '#An ninh lương thực', 1),
('TAG0086', '#Công nghệ y tế', 1),
('TAG0087', '#Khám bệnh từ xa', 1),
('TAG0088', '#Sức khỏe tâm thần', 1),
('TAG0089', '#Sống khỏe', 1),
('TAG0090', '#Thể hình', 1),
('TAG0091', '#Dinh dưỡng', 1),
('TAG0092', '#Y học cổ truyền', 1),
('TAG0093', '#Thiền định', 1),
('TAG0094', '#Phát triển bản thân', 1),
('TAG0095', '#Lãnh đạo', 1),
('TAG0096', '#Quản lý', 1),
('TAG0097', '#Nhân sự', 1),
('TAG0098', '#Làm việc từ xa', 1),
('TAG0099', '#Cân bằng cuộc sống', 1),
('TAG0100', '#Phát triển nghề nghiệp', 1),
('TAG0101', '#Kỹ năng chuyên môn', 1),
('TAG0102', '#Kỹ năng mềm', 1),
('TAG0103', '#Giao tiếp', 1),
('TAG0104', '#Xây dựng đội nhóm', 1),
('TAG0105', '#Quản lý dự án', 1),
('TAG0106', '#Quản lý chất lượng', 1),
('TAG0107', '#Quản lý rủi ro', 1),
('TAG0108', '#Chuỗi cung ứng', 1),
('TAG0109', '#Vận tải logistics', 1),
('TAG0110', '#Nghiên cứu thị trường', 1),
('TAG0111', '#Quản lý thương hiệu', 1),
('TAG0112', '#Trải nghiệm khách hàng', 1),
('TAG0113', '#Chiến lược bán hàng', 1),
('TAG0114', '#Học trực tuyến', 1),
('TAG0115', '#Giáo dục từ xa', 1),
('TAG0116', '#Giáo dục STEM', 1),
('TAG0117', '#Học ngoại ngữ', 1),
('TAG0118', '#Giáo dục mầm non', 1),
('TAG0119', '#Giáo dục đại học', 1),
('TAG0120', '#Đào tạo nghề', 1),
('TAG0121', '#Giáo dục người lớn', 1),
('TAG0122', '#Giáo dục đặc biệt', 1),
('TAG0123', '#Công nghệ giáo dục', 1),
('TAG0124', '#Phương pháp nghiên cứu', 1),
('TAG0125', '#Kỹ năng học tập', 1),
('TAG0126', '#Đời sống sinh viên', 1),
('TAG0127', '#Văn hóa học đường', 1),
('TAG0128', '#Cựu sinh viên', 1),
('TAG0129', '#Quản lý trường học', 1),
('TAG0130', '#Chính sách giáo dục', 1),
('TAG0131', '#Phát triển chương trình', 1),
('TAG0132', '#Phương pháp giảng dạy', 1),
('TAG0133', '#Đánh giá giáo dục', 1),
('TAG0134', '#Phân tích học tập', 1),
('TAG0135', '#Tâm lý giáo dục', 1),
('TAG0136', '#Phát triển trẻ em', 1),
('TAG0137', '#Nuôi dạy con', 1),
('TAG0138', '#Đời sống gia đình', 1),
('TAG0139', '#Quan hệ xã hội', 1),
('TAG0140', '#Hôn nhân', 1),
('TAG0141', '#Hẹn hò', 1),
('TAG0142', '#Phong cách sống', 1),
('TAG0143', '#Sở thích', 1),
('TAG0144', '#Du lịch khám phá', 1),
('TAG0145', '#Ẩm thực vùng miền', 1),
('TAG0146', '#Văn hóa dân tộc', 1),
('TAG0147', '#Lễ hội truyền thống', 1),
('TAG0148', '#Di sản văn hóa', 1),
('TAG0149', '#Nghệ thuật dân gian', 1),
('TAG0150', '#Làng nghề truyền thống', 1);


-- Insert values into Status_Of_News
INSERT INTO Status_Of_News (Id_Status, Title_Status) 
VALUES 
('STS0001', 'Chưa duyệt'),
('STS0002', 'Chưa đạt'),
('STS0003', 'Từ chối'),
('STS0004', 'Đồng ý'),
('STS0005', 'Đã xoá');








-- test với dữ liệu ít
-- Insert values into News
INSERT INTO News (Id_SubCategory, Id_Writer, Id_Status, Id_News, Date, Comments, Premium, Views, Content, Image, Title, Meta_title, Meta_description) 
VALUES 

('SUB0001', 'WRT0001', 'STS0001', 'NEWS0001', '2024-12-08 10:30:00', 'Great article!', 1, 500, 'AI advancements are fascinating.', NULL, 'Title: post 1 sub 1', 'Meta_Title: post 1 sub 1 AI is reshaping the world', 'Phương Mỹ Chi và Phương Duyên song ca bài Đẩy xe bò của Phưo và câu hát mang âm hưởng quan họ trong bài.'),
('SUB0001', 'WRT0001', 'STS0001', 'NEWS1001', '2024-12-08 10:30:00', 'Great article!', 1, 500, 'AI advancements are fascinating.', NULL, 'Title: post 1 sub 1', 'Meta_Title: post 1 sub 1 AI is reshaping the world', 'Phương Mỹ Chi và Phương Duyên song ca bài Đẩy xe bò của Phưo và câu hát mang âm hưởng quan họ trong bài.'),



('SUB0005', 'WRT0005', 'STS0001', 'NEWS0049', '2024-12-09 00:30:00', 'Great article!', 0, 100, 'AI advancements are fascinating.', NULL, 'Title: post 1 sub 5........................', 'Meta_Title: post 1 sub 5..', 'AI is reshaping the world13.'),
('SUB0009', 'WRT0006', 'STS0001', 'NEWS0076', '2024-11-22 00:30:00', 'Latest movies to watch.', 0, 700, 'Movies you should not miss.', NULL, 'Title: post 1 sub 9', 'Meta_Title: post 1 sub 9', 'Latest movies review.'),
('SUB0009', 'WRT0006', 'STS0001', 'NEWS0077', '2024-01-22 00:30:00', 'Latest movies to watch.', 0, 1000, 'Movies you should not miss.', NULL, 'Title: post 2 sub 9', 'Meta_Title: post 2 sub 9', 'Latest movies review.'),
('SUB0013', 'WRT0007', 'STS0001', 'NEWS0092', '2024-11-07 00:30:00', 'Football matches this week.', 0, 1500, 'Exciting football matches coming up.', NULL, 'Title: post 1 sub 13', 'Meta_Title: post 1 sub 13', 'Football matches preview.'),
('SUB0017', 'WRT0008', 'STS0001', 'NEWS0108', '2024-01-23 00:30:00', 'Scholarship opportunities for students.', 0, 2300, 'Explore various scholarship options.', NULL, 'Title: post 1 sub 17', 'Meta_Title: post 1 sub 17', 'Scholarship opportunities overview.'),
('SUB0021', 'WRT0009', 'STS0001', 'NEWS0124', '2024-02-08 00:30:00', 'Family bonding activities.', 0, 3100, 'Activities to strengthen family ties.', NULL, 'Title: post 1 sub 21', 'Meta_Title: post 1 sub 21', 'Family bonding activities overview.'),
('SUB0025', 'WRT0010', 'STS0001', 'NEWS0140', '2024-12-09 00:30:00', 'Cultural diversity in Asia.', 0, 3900, 'Exploring the rich cultures of Asia.', NULL, 'Title: post 1 sub 25', 'Meta_Title: post 1 sub 25', 'Cultural diversity in Asia overview.'),
('SUB0029', 'WRT0011', 'STS0001', 'NEWS0156', '2024-11-27 00:30:00',  'Buying your first home.', 0, 4700, 'Tips for first-time homebuyers.', NULL, 'Title: post 1 sub 29', 'Meta_Title: post 1 sub 29', 'Buying your first home overview.'),
('SUB0033', 'WRT0012', 'STS0001', 'NEWS0172',  '2024-12-12 00:30:00', 'Upcoming movie releases.', 0, 5500, 'What to watch in the coming months.', NULL, 'Title: post 1 sub 33', 'Meta_Title: post 1 sub 33', 'Upcoming movie releases overview.'),
('SUB0037', 'WRT0013', 'STS0001', 'NEWS0188',  '2024-12-12 00:30:00', 'Latest criminal cases in the news.', 0, 6300, 'Overview of recent criminal cases.', NULL, 'Title: post 1 sub 37', 'Meta_Title: post 1 sub 37', 'Latest criminal cases overview.'),
('SUB0041', 'WRT0014', 'STS0001', 'NEWS0204',  '2024-12-09 00:30:16', 'Latest technology trends.', 0, 7100, 'What’s new in technology.', NULL, 'Title: post 1 sub 41', 'Meta_Title: post 1 sub 41', 'Latest technology trends overview.'),
('SUB0041', 'WRT0014', 'STS0001', 'NEWS0205',  '2024-08-09 00:30:16', 'Latest technology trends.', 0, 5100, 'What’s new in technology.', NULL, 'Title: post 2 sub 41', 'Meta_Title: post 1 sub 41', 'Latest technology trends overview.'),
('SUB0045', 'WRT0015', 'STS0001', 'NEWS0220',  '2024-11-12 00:30:00', 'Top travel destinations for 2024.', 0, 700, 'Explore the best places to visit this year.', NULL, 'Title: post 1 sub 45', 'Meta_Title: post 1 sub 45', 'Top travel destinations overview.');

-- Test với dữ liệu nhỏ
INSERT INTO News_Tag (Id_News, Id_Tag) VALUES
-- NEWS0001 (7 tags)
('NEWS0001', 'TAG0001'), -- #Chính trị
('NEWS0001', 'TAG0007'), -- #Thời sự
('NEWS0001', 'TAG0018'), -- #Quốc tế
('NEWS0001', 'TAG0039'), -- #An ninh
('NEWS0001', 'TAG0040'), -- #Quốc phòng
('NEWS0001', 'TAG0042'), -- #Ngoại giao
('NEWS0001', 'TAG0043'), -- #Hợp tác

-- NEWS0049 (5 tags)
('NEWS0049', 'TAG0089'), -- #Sống khỏe
('NEWS0049', 'TAG0090'), -- #Thể hình
('NEWS0049', 'TAG0091'), -- #Dinh dưỡng
('NEWS0049', 'TAG0012'), -- #Y tế
('NEWS0049', 'TAG0016'), -- #Đời sống

-- NEWS0049 (5 tags)
('NEWS0076', 'TAG0089'), -- #Sống khỏe
('NEWS0076', 'TAG0090'), -- #Thể hình
('NEWS0076', 'TAG0091'), -- #Dinh dưỡng
('NEWS0076', 'TAG0012'), -- #Y tế
('NEWS0076', 'TAG0016'), -- #Đời sống

-- NEWS0049 (5 tags)
('NEWS0092', 'TAG0089'), -- #Sống khỏe
('NEWS0092', 'TAG0090'), -- #Thể hình
('NEWS0092', 'TAG0091'), -- #Dinh dưỡng
('NEWS0092', 'TAG0012'), -- #Y tế
('NEWS0092', 'TAG0016'), -- #Đời sống

-- NEWS0049 (5 tags)
('NEWS0108', 'TAG0089'), -- #Sống khỏe
('NEWS0108', 'TAG0090'), -- #Thể hình
('NEWS0108', 'TAG0091'), -- #Dinh dưỡng
('NEWS0108', 'TAG0012'), -- #Y tế
('NEWS0108', 'TAG0016'), -- #Đời sống

-- NEWS0049 (5 tags)
('NEWS0124', 'TAG0089'), -- #Sống khỏe
('NEWS0124', 'TAG0090'), -- #Thể hình
('NEWS0124', 'TAG0091'), -- #Dinh dưỡng
('NEWS0124', 'TAG0012'), -- #Y tế
('NEWS0124', 'TAG0016'), -- #Đời sống

-- NEWS0049 (5 tags)
('NEWS0140', 'TAG0089'), -- #Sống khỏe
('NEWS0140', 'TAG0090'), -- #Thể hình
('NEWS0140', 'TAG0091'), -- #Dinh dưỡng
('NEWS0140', 'TAG0012'), -- #Y tế
('NEWS0140', 'TAG0016'), -- #Đời sống

-- NEWS0049 (5 tags)
('NEWS0156', 'TAG0089'), -- #Sống khỏe
('NEWS0156', 'TAG0090'), -- #Thể hình
('NEWS0156', 'TAG0091'), -- #Dinh dưỡng
('NEWS0156', 'TAG0012'), -- #Y tế
('NEWS0156', 'TAG0016'), -- #Đời sống

('NEWS0172', 'TAG0089'), -- #Sống khỏe
('NEWS0172', 'TAG0090'), -- #Thể hình

('NEWS0188', 'TAG0089'), -- #Sống khỏe
('NEWS0188', 'TAG0090'), -- #Thể hình

('NEWS0204', 'TAG0089'), -- #Sống khỏe
('NEWS0204', 'TAG0090'), -- #Thể hình

('NEWS0220', 'TAG0089'), -- #Sống khỏe
('NEWS0220', 'TAG0090'); -- #Thể hình
































-- Insert values into News
INSERT INTO News (Id_SubCategory, Id_Writer, Id_Status, Id_News, Date, Comments, Premium, Views, Content, Image, Title, Meta_title, Meta_description) 
VALUES 


-- Sub1-chính trị
('SUB0001', 'WRT0001', 'STS0001', 'NEWS0001', '2024-12-14 10:30:00', 'Great article!', 1, 500, 'AI advancements are fascinating.', NULL, 'Title: post 1 sub 1', 'Meta_Title: post 1 sub 1 AI is reshaping the worldĐi khám phá rừng Phú Quốc là tour du lịch trải nghiệm độc đáo. Trước khi đi tham quan khách sẽ được hướng dẫn.', 'Phương Mỹ Chi và Phương Duyên song ca bài Đẩy xe bò của Phưo và câu hát mang âm hưởng quan họ trong bài Phương Mỹ Chi và Phương Duyên song ca bài Đẩy xe bò của Phưo và câu hát mang âm hưởng quan họ trong bài Phương Mỹ Chi và Phương Duyên song ca bài Đẩy xe bò của Phưo và câu hát mang âm hưởng quan họ trong bài.'),
('SUB0001', 'WRT0002', 'STS0001', 'NEWS0002', '2024-12-14 10:30:00', 'Great article!', 1, 490, 'AI  fascinating.', NULL, 'Title: post 2 sub 1', 'Meta_Title: post 2 sub 1Đi khám phá rừng Phú Quốc là tour du lịch trải nghiệm độc đáo. Trước khi đi tham quan khách sẽ được hướng dẫn.', 'Liên minh Dân tộc khẳng định với cộng đồng quốc tế rằng họ đang tiếp tục hoàn thiện quá trình chuyển giao quyền lực sang một cơ quan quản lý chuyển tiếp với đầy đủ quyền hành, nhằm xây dựng một Syria dân chủ, đa nguyên và tự do'),
('SUB0001', 'WRT0003', 'STS0001', 'NEWS0003', '2024-12-13 10:30:00', 'Great sarticle!', 0, 450, 'AI a fascinating.', NULL, 'Title: post 3 sub 1', 'Meta_Title: post 3 sub 1Đi khám phá rừng Phú Quốc là tour du lịch trải nghiệm độc đáo. Trước khi đi tham quan khách sẽ được hướng dẫn.', 'AI is reshaping the world4 AI is reshaping the world4 AI is reshaping the world4 AI is reshaping the world4 bài Đẩy xe bò của Phưo và câu hát mang âm hưởng quan họ trong bài Phương Mỹ Chi và Phương Duyên song ca bài  bài Đẩy xe bò của Phưo và câu hát mang âm hưởng quan họ trong bài Phương Mỹ Chi và Phương Duyên song ca bài  AI'),
('SUB0001', 'WRT0004', 'STS0001', 'NEWS0004', '2024-12-06 10:30:00', 'Greatd article!', 0, 460, 'AI d fascinating.', NULL, 'Title: post 4 sub 1', 'Meta_Title: post 4 sub 1', 'AI is reshaping the world4.'),
('SUB0001', 'WRT0001', 'STS0001', 'NEWS0005', '2024-12-14 10:30:00', 'Great article!', 1, 470, 'AI advancements are fascinating.', NULL, 'Title: post 5 sub 1 Phân tích chiến lược tiếp thị trên TikTok: Thành công và bài học rút ra', 'Meta_Title: post 5 sub 1', 'AI is reshaping the world5.'),
('SUB0001', 'WRT0002', 'STS0001', 'NEWS0006', '2024-12-14 10:30:00', 'Great article!', 1, 480, 'AI  fascinating.', NULL, 'Title: post 6 sub 1', 'Meta_Title: post 6 sub 1', 'AI is reshaping the world6.'),
('SUB0001', 'WRT0003', 'STS0001', 'NEWS0007', '2024-12-14 10:30:00', 'Great sarticle!', 0, 440, 'AI a fascinating.', NULL, 'Title: post 7 sub 1', 'Meta_Title: post 7 sub 1', 'AI is reshaping the world7.'),
('SUB0001', 'WRT0004', 'STS0001', 'NEWS0008', '2024-11-01 10:30:00', 'Greatd article!', 0, 430, 'AI d fascinating.', NULL, 'Title: post 8 sub 1', 'Meta_Title: post 8 sub 1', 'AI is reshaping the world8.'),
('SUB0001', 'WRT0001', 'STS0001', 'NEWS0009', '2024-11-18 10:30:00', 'Great article!', 0, 430, 'AI advancements are fascinating.', NULL, 'Title: post 9 sub 1', 'Meta_Title: post 9 sub 1', 'AI is reshaping the world9.'),
('SUB0001', 'WRT0002', 'STS0001', 'NEWS0010', '2024-12-01 10:30:00', 'Great article!', 0, 6, 'AI  fascinating.', NULL, 'Title: post 10 sub 1', 'Meta_Title: post 10 sub 1', 'AI is reshaping the world10.'),
('SUB0001', 'WRT0003', 'STS0001', 'NEWS0011', '2024-11-29 10:30:00', 'Great sarticle!', 0, 420, 'AI a fascinating.', NULL, 'Title: post 11 sub 1', 'Meta_Title: post 11 sub 1', 'AI is reshaping the world11.'),
('SUB0001', 'WRT0004', 'STS0001', 'NEWS0012', '2024-12-02 10:30:00', 'Greatd article!', 0, 4, 'AI d fascinating.', NULL, 'Title: post 12 sub 1', 'Meta_Title: post 12 sub 1', 'AI is reshaping the world12.'),

('SUB0001', 'WRT0001', 'STS0001', 'NEWS0061', '2024-11-01 00:30:00', 'Great article!', 0, 501, 'AI advancements are fascinating.', NULL, 'Title: post 13 sub 1', 'Meta_Title: post 13 sub 1', 'AI is reshaping the world13.'),
('SUB0001', 'WRT0002', 'STS0001', 'NEWS0062', '2024-11-03 00:30:00', 'Great article!', 0, 234, 'AI  fascinating.', NULL, 'Title: post 14 sub 1', 'Meta_Title: post 14 sub 1', 'AI is reshaping the world14.'),
('SUB0001', 'WRT0003', 'STS0001', 'NEWS0063', '2024-11-04 00:30:00', 'Great sarticle!', 0, 345, 'AI a fascinating.', NULL, 'Title: post 15 sub 1', 'Meta_Title: post 15 sub 1', 'AI is reshaping the world15.'),
('SUB0001', 'WRT0004', 'STS0001', 'NEWS0064', '2024-11-05 00:30:00', 'Greatd article!', 0, 12, 'AI d fascinating.', NULL, 'Title: post 16 sub 1', 'Meta_Title: post 16 sub 1', 'AI is reshaping the world16.'),

-- Sub2-xã hội
('SUB0002', 'WRT0001', 'STS0001', 'NEWS0013', '2024-11-01 00:30:00', 'Great article!', 0, 500, 'AI advancements are fascinating.', NULL, 'Title: post 1 sub 2', 'Meta_Title: post 1 sub 2', 'AI is reshaping the world13.'),
('SUB0002', 'WRT0002', 'STS0001', 'NEWS0014', '2024-12-08 00:30:00', 'Great article!', 0, 495, 'AI  fascinating.', NULL, 'Title: post 2 sub 2', 'Meta_Title: post 2 sub 2 Xu hướng tiêu dùng trực tuyến tại Việt Nam: Sự phát triển và thách thức', 'AI is reshaping the world14.'),
('SUB0002', 'WRT0003', 'STS0001', 'NEWS0015', '2024-12-12 00:30:00', 'Great sarticle!', 0, 501, 'AI a fascinating.', NULL, 'Title: post 3 sub 2', 'Meta_Title: post 3 sub 2', 'Phương Mỹ Chi và Phương Duyên song ca bài Đẩy xe bò của Phưo và câu hát mang âm hưởng quan họ trong bài.'),
('SUB0002', 'WRT0004', 'STS0001', 'NEWS0016', '2024-12-15 22:10:00', 'Greatd article!', 0, 465, 'AI d fascinating.', NULL, 'Title: post 4 sub 2', 'Meta_Title: post 4 sub 2', 'AI is reshaping the world16.'),
('SUB0002', 'WRT0001', 'STS0001', 'NEWS0017', '2024-10-01 00:30:00', 'Great article!', 0, 470, 'AI advancements are fascinating.', NULL, 'Title: post 5 sub 2', 'Meta_Title: post 5 sub 2', 'AI is reshaping the world.17'),
('SUB0002', 'WRT0002', 'STS0001', 'NEWS0018', '2024-11-11 00:30:00', 'Great article!', 0, 480, 'AI  fascinating.', NULL, 'Title: post 6 sub 2', 'Meta_Title: post 6 sub 2', 'AI is reshaping the world18.'),
('SUB0002', 'WRT0003', 'STS0001', 'NEWS0019', '2024-11-02 00:30:00', 'Great sarticle!', 0, 440, 'AI a fascinating.', NULL, 'Title: post 7 sub 2', 'Meta_Title: post 7 sub 2', 'AI is reshaping the world19.'),
('SUB0002', 'WRT0004', 'STS0001', 'NEWS0020', '2024-11-02 00:30:00', 'Greatd article!', 0, 436, 'AI d fascinating.', NULL, 'Title: post 8 sub 2', 'Meta_Title: post 8 sub 2', 'AI is reshaping the world20.'),
('SUB0002', 'WRT0001', 'STS0001', 'NEWS0021', '2024-11-01 00:30:00', 'Great article!', 0, 430, 'AI advancements are fascinating.', NULL, 'Title: post 9 sub 2', 'Meta_Title: post 9 sub 2', 'AI is reshaping the world21.'),
('SUB0002', 'WRT0002', 'STS0001', 'NEWS0022', '2024-11-02 00:30:00', 'Great article!', 0, 8, 'AI  fascinating.', NULL, 'Title: post 10 sub 2', 'Meta_Title: post 10 sub 2', 'AI is reshaping the world22.'),
('SUB0002', 'WRT0003', 'STS0001', 'NEWS0023', '2024-11-02 00:30:00', 'Great sarticle!', 0, 3, 'AI a fascinating.', NULL, 'Title: post 11 sub 2', 'Meta_Title: post 11 sub 2', 'AI is reshaping the world23.'),
('SUB0002', 'WRT0004', 'STS0001', 'NEWS0024', '2024-11-02 00:30:00', 'Greatd article!', 0, 2, 'AI d fascinating.', NULL, 'Title: post 12 sub 2', 'Meta_Title: post 12 sub 2', 'AI is reshaping the world24.'),

-- Sub3-kinh tế
('SUB0003', 'WRT0001', 'STS0001', 'NEWS0025', '2021-11-01 00:30:00', 'Great article!', 0, 499, 'AI advancements are fascinating.', NULL, 'Title: post 1 sub 3', 'Meta_Title: post 1 sub 3', 'Trước đó, phát biểu tại phiên họp của ủy ban quốc hội sau khi lệnh thiết quân luật được dỡ bỏ, ông Lee đã bảo vệ Tổng thống Yoon, khẳng định rằng việc tuyên bố thiết quân luật đã được thực hiện theo quy trình và quy định hiến pháp.'),
('SUB0003', 'WRT0002', 'STS0001', 'NEWS0026', '2022-11-02 00:30:00', 'Great article!', 0, 1, 'AI  fascinating.', NULL, 'Title: post 2 sub 3', 'Meta_Title: post 2 sub 3', 'AI is reshaping the world14.'),
('SUB0003', 'WRT0003', 'STS0001', 'NEWS0027', '2024-11-02 00:30:00', 'Great sarticle!', 0, 2, 'AI a fascinating.', NULL, 'Title: post 3 sub 3', 'Meta_Title: post 3 sub 3', 'AI is reshaping the world15.'),
('SUB0003', 'WRT0004', 'STS0001', 'NEWS0028', '2024-12-14 00:15:00', 'Greatd article!', 0, 3, 'AI d fascinating.', NULL, 'Title: post 4 sub 3', 'Meta_Title: post 4 sub 3', 'AI is reshaping the world16.'),
('SUB0003', 'WRT0001', 'STS0001', 'NEWS0029', '2024-11-01 00:30:00', 'Great article!', 0, 4, 'AI advancements are fascinating.', NULL, 'Title: post 5 sub 3', 'Meta_Title: post 5 sub 3', 'AI is reshaping the world.17'),
('SUB0003', 'WRT0002', 'STS0001', 'NEWS0030', '2024-11-02 00:30:00', 'Great article!', 0, 5, 'AI  fascinating.', NULL, 'Title: post 6 sub 3', 'Meta_Title: post 6 sub 3', 'AI is reshaping the world18.'),
('SUB0003', 'WRT0003', 'STS0001', 'NEWS0031', '2024-11-02 00:30:00', 'Great sarticle!', 0, 6, 'AI a fascinating.', NULL, 'Title: post 7 sub 3', 'Meta_Title: post 7 sub 3', 'AI is reshaping the world19.'),
('SUB0003', 'WRT0004', 'STS0001', 'NEWS0032', '2024-11-02 00:30:00', 'Greatd article!', 0, 7, 'AI d fascinating.', NULL, 'Title: post 8 sub 3', 'Meta_Title: post 8 sub 3', 'AI is reshaping the world20.'),
('SUB0003', 'WRT0001', 'STS0001', 'NEWS0033', '2024-12-17 00:30:00', 'Great article!', 0, 8, 'AI advancements are fascinating.', NULL, 'Title: post 9 sub 3', 'Meta_Title: post 9 sub 3', 'AI is reshaping the world21.'),
('SUB0003', 'WRT0002', 'STS0001', 'NEWS0034', '2024-11-02 00:30:00', 'Great article!', 0, 9, 'AI  fascinating.', NULL, 'Title: post 10 sub 3', 'Meta_Title: post 10 sub 3', 'AI is reshaping the world22.'),
('SUB0003', 'WRT0003', 'STS0001', 'NEWS0035', '2024-11-02 00:30:00', 'Great sarticle!', 0, 10, 'AI a fascinating.', NULL, 'Title: post 11 sub 3', 'Meta_Title: post 11 sub 3', 'AI is reshaping the world23.'),
('SUB0003', 'WRT0004', 'STS0001', 'NEWS0036', '2024-11-02 00:30:00', 'Greatd article!', 0, 11, 'AI d fascinating.', NULL, 'Title: post 12 sub 3', 'Meta_Title: post 12 sub 3', 'AI is reshaping the world24.'),

-- Sub4-văn hoá
('SUB0004', 'WRT0001', 'STS0001', 'NEWS0037', '2024-12-06 00:30:00', 'Great article!', 0, 100000, 'AI advancements are fascinating.', NULL, 'Title: post 1 sub 4', 'Meta_Title: post 1 sub 4aaaaaaaaa!', 'asdasdasdasdasdasd'),
('SUB0004', 'WRT0002', 'STS0001', 'NEWS0038', '2024-12-16 00:30:00', 'Great article!', 0, 498, 'AI  fascinating.', NULL, 'Title: post 2 sub 4', 'Meta_Title: post 2 sub 4', 'Phương Mỹ Chi và Phương Duyên song ca bài Đẩy xe bò của Phưo và câu hát mang âm hưởng quan họ trong bài.'),
('SUB0004', 'WRT0003', 'STS0001', 'NEWS0039', '2024-12-14 00:57:00', 'Great sarticle!', 0, 101, 'AI a fascinating.', NULL, 'Title: post 3 sub 4', 'Meta_Title: post 3 sub 4', 'AI is reshaping the world15.'),
('SUB0004', 'WRT0004', 'STS0001', 'NEWS0040', '2024-11-02 00:30:00', 'Greatd article!', 0, 99, 'AI d fascinating.', NULL, 'Title: post 4 sub 4', 'Meta_Title: post 4 sub 4', 'AI is reshaping the world16.'),
('SUB0004', 'WRT0001', 'STS0001', 'NEWS0041', '2024-11-01 00:30:00', 'Great article!', 0, 70, 'AI advancements are fascinating.', NULL, 'Title: post 5 sub 4', 'Meta_Title: post 5 sub 4', 'AI is reshaping the world.17'),
('SUB0004', 'WRT0002', 'STS0001', 'NEWS0042', '2024-11-02 00:30:00', 'Great article!', 0, 80, 'AI  fascinating.', NULL, 'Title: post 6 sub 4', 'Meta_Title: post 6 sub 4', 'AI is reshaping the world18.'),
('SUB0004', 'WRT0003', 'STS0001', 'NEWS0043', '2024-12-05 00:30:00', 'Great sarticle!', 0, 40, 'AI a fascinating.', NULL, 'Title: post 7 sub 4', 'Meta_Title: post 7 sub 4 Ứng dụng AI trong thương mại điện tử: Tương lai của trải nghiệm mua sắm thương mại điện tử: Tương lai của trải nghiệm mua sắm', 'AI is reshaping the world19.'),
('SUB0004', 'WRT0004', 'STS0001', 'NEWS0044', '2024-12-05 00:30:00', 'Greatd article!', 0, 36, 'AI d fascinating.', NULL, 'Title: post 8 sub 4', 'Meta_Title: post 8 sub 4', 'AI is reshaping the world20.'),
('SUB0004', 'WRT0001', 'STS0001', 'NEWS0045', '2020-08-04 00:30:00', 'Great article!', 0, 30, 'AI advancements are fascinating.', NULL, 'Title: post 9 sub 4', 'Meta_Title: post 9 sub 4', 'AI is reshaping the world21.'),
('SUB0004', 'WRT0002', 'STS0001', 'NEWS0046', '2024-02-04 00:30:00', 'Great article!', 0, 33, 'AI  fascinating.', NULL, 'Title: post 10 sub 4', 'Meta_Title: post 10 sub 4', 'AI is reshaping the world22.'),
('SUB0004', 'WRT0003', 'STS0001', 'NEWS0047', '2024-04-02 00:30:00', 'Great sarticle!', 0, 11, 'AI a fascinating.', NULL, 'Title: post 11 sub 4', 'Meta_Title: post 11 sub 4', 'AI is reshaping the world23.'),
('SUB0004', 'WRT0004', 'STS0001', 'NEWS0048', '2024-11-02 00:30:00', 'Greatd article!', 0, 4, 'AI d fascinating.', NULL, 'Title: post 12 sub 4', 'Meta_Title: post 12 sub 4', 'AI is reshaping the world24.'),

-- Sub5
('SUB0005', 'WRT0005', 'STS0001', 'NEWS0049', '2024-12-09 00:30:00', 'Great article!', 0, 100, 'AI advancements are fascinating.', NULL, 'Title: post 1 sub 5........................', 'Meta_Title: post 1 sub 5..', 'AI is reshaping the world13.'),
('SUB0005', 'WRT0005', 'STS0001', 'NEWS0050', '2024-12-10 00:30:00', 'Great article!', 1, 9900008, 'AI  fascinating.', NULL, 'Title: post 2 sub 5', 'Meta_Title: post 2 sub 5 Đi khám phá rừng Phú Quốc là tour du lịch trải nghiệm độc đáo. Trước khi đi tham quan khách sẽ được', 'Đi khám phá rừng Phú Quốc là tour du lịch trải nghiệm độc đáo. Trước khi đi tham quan khách sẽ được hướng dẫn.Đi khám phá rừng Phú Quốc là tour du lịch trải nghiệm độc đáo. Trước khi đi tham quan khách sẽ được hướng dẫn.Đi khám phá rừng Phú Quốc là tour du lịch trải nghiệm độc đáo. Trước khi đi tham quan khách sẽ được hướng dẫn.Đi khám phá rừng Phú Quốc là tour du lịch trải nghiệm độc đáo. Trước khi đi tham quan khách sẽ được hướng dẫn. '),
('SUB0005', 'WRT0005', 'STS0001', 'NEWS0051', '2024-12-09 00:30:00', 'Great sarticle!', 1, 101, 'AI a fascinating.', NULL, 'Title: post 3 sub 5', 'Meta_Title: post 3 sub 5 Sở Du lịch Kiên Giang cho biết năm 2024, Kiên Giang ước đón hơn 9,8 tri Sở Du lịch Kiên Giang cho biết năm 2024, Kiên Giang ước đón hơn 9,8 tri', 'Sở Du lịch Kiên Giang cho biết năm 2024, Kiên Giang ước đón hơn 9,8 triệu lượt khách (tăng 15,6% so với cùng kỳ); khách quốc tế ước đón hơn 900.000 lượt, tổng thu du lịch hơn 25.000 tỉ đồng.'),
('SUB0005', 'WRT0005', 'STS0001', 'NEWS0052', '2024-12-02 00:30:00', 'Greatd article!', 1, 99, 'AI d fascinating.', NULL, 'Title: post 4 sub 5', 'Meta_Title: post 4 sub 5', 'AI is reshaping the world16.'),
('SUB0005', 'WRT0005', 'STS0001', 'NEWS0053', '2024-12-01 00:30:00', 'Great article!', 1, 70, 'AI advancements are fascinating.', NULL, 'Title: post 5 sub 5', 'Meta_Title: post 5 sub 5', 'AI is reshaping the world.17'),
('SUB0005', 'WRT0005', 'STS0001', 'NEWS0054', '2024-12-02 00:30:00', 'Great article!', 1, 7899999, 'AI  fascinating.', NULL, 'Title: post 6 sub 5', 'Meta_Title: post 6 sub 5', 'Vài thập kỷ trước, việc đến Lapland thăm ngôi nhà của ông già Noel là điều chỉ có trong mơ của nhiều trẻ em. Tuy nhiên, khi ngành hàng không phát triển, hàng trăm chuyến bay được nối đến tỉnh cực bắc của Phần Lan này. Công ty Finnavia, đơn vị điều hành các sân bay Phần Lan, cho biết trong năm ngoái có hơn 1,5 triệu du khách đến "xứ sở ông già Noel".'),
('SUB0005', 'WRT0005', 'STS0001', 'NEWS0055', '2024-12-07 00:30:00', 'Great sarticle!', 0, 40, 'AI a fascinating.', NULL, 'Title: post 7 sub 5', 'Meta_Title: post 7 sub 5', 'AI is reshaping the world19.'),
('SUB0005', 'WRT0005', 'STS0001', 'NEWS0056', '2024-12-07 00:30:00', 'Greatd article!', 0, 36, 'AI d fascinating.', NULL, 'Title: post 8 sub 5', 'Meta_Title: post 8 sub 5', 'AI is reshaping the world20.'),
('SUB0005', 'WRT0005', 'STS0001', 'NEWS0057', '2024-11-08 00:30:00', 'Great article!', 0, 30, 'AI advancements are fascinating.', NULL, 'Title: post 9 sub 5', 'Meta_Title: post 9 sub 5', 'AI is reshaping the world21.'),
('SUB0005', 'WRT0005', 'STS0001', 'NEWS0058', '2024-11-08 00:30:00', 'Great article!', 0, 33, 'AI  fascinating.', NULL, 'Title: post 10 sub 5', 'Meta_Title: post 10 sub 5', 'AI is reshaping the world22.'),
('SUB0005', 'WRT0005', 'STS0001', 'NEWS0059', '2024-11-02 00:30:00', 'Great sarticle!', 0, 11, 'AI a fascinating.', NULL, 'Title: post 11 sub 5', 'Meta_Title: post 11 sub 5', 'AI is reshaping the world23.'),
('SUB0005', 'WRT0005', 'STS0001', 'NEWS0060', '2024-11-02 00:30:00', 'Greatd article!', 0, 4, 'AI d fascinating.', NULL, 'Title: post 12 sub 5', 'Meta_Title: post 12 sub 5', 'AI is reshaping the world24.'),

-- sub6
('SUB0006', 'WRT0005', 'STS0001', 'NEWS0065', '2024-11-11 00:30:00', 'Healthy living tips!', 0, 150, 'Living a healthy life is essential.', NULL, 'Title: post 1 sub 6', 'Meta_Title: post 1 sub 6', 'Healthy living tips.'),
('SUB0006', 'WRT0005', 'STS0001', 'NEWS0066', '2024-11-12 00:30:00', 'Mental health awareness.', 0, 200, 'Mental health is crucial.', NULL, 'Title: post 2 sub 6..........', 'Meta_Title: post 2 sub 6', 'Mental health awareness.'),
('SUB0006', 'WRT0005', 'STS0001', 'NEWS0067', '2024-12-12 00:30:00', 'Family bonding activities.', 0, 250, 'Bonding with family is important.', NULL, 'Title: post 3 sub 6!!!', 'Meta_Title: post 3 sub 6 Phương Mỹ Chi và Phương Duyên song ca bài Đẩy xe bò của Phưo và câu hát mang âm hưởng quan họ trong bài Phương Mỹ Chi và Phương Duyên song ca bài Đẩy xe bò của Phưo và câu hát mang âm hưởng quan họ trong bài.', 'Phương Mỹ Chi và Phương Duyên song ca bài Đẩy xe bò của Phưo và câu hát mang âm hưởng quan họ trong bài Phương Mỹ Chi và Phương Duyên song ca bài Đẩy xe bò của Phưo và câu hát mang âm hưởng quan họ trong bài Phương Mỹ Chi và Phương Duyên song ca bài Đẩy xe bò của Phưo và câu hát mang âm hưởng quan họ trong bài.'),

-- sub7
('SUB0007', 'WRT0005', 'STS0001', 'NEWS0068', '2024-11-14 00:30:00', 'Global politics today.', 0, 300, 'Politics around the world.', NULL, 'Title: post 1 sub 7', 'Meta_Title: post 1 sub 7', 'Global politics insights.'),
('SUB0007', 'WRT0005', 'STS0001', 'NEWS0069', '2024-11-15 00:30:00', 'International relations.', 0, 350, 'Relations between countries.', NULL, 'Title: post 2 sub 7', 'Meta_Title: post 2 sub 7', 'International relations overview.Đi khám phá rừng Phú Quốc là tour du lịch trải nghiệm độc đáo. Trước khi đi tham quan khách sẽ được hướng dẫn.Đi khám phá rừng Phú Quốc là tour du lịch trải nghiệm độc đáo. Trước khi đi tham quan khách sẽ được hướng dẫn.'),
('SUB0007', 'WRT0005', 'STS0001', 'NEWS0070', '2024-11-16 00:30:00', 'Cultural exchanges.', 0, 400, 'Cultural exchanges are vital.', NULL, 'Title: post 3 sub 7', 'Meta_Title: post 3 sub 7', 'Cultural exchanges importance.'),
('SUB0007', 'WRT0005', 'STS0001', 'NEWS0071', '2024-11-17 00:30:00', 'Global economic trends.', 0, 450, 'Economics on a global scale.', NULL, 'Title: post 4 sub 7', 'Meta_Title: post 4 sub 7', 'Global economic trends analysis.'),

-- sub8
('SUB0008', 'WRT0005', 'STS0001', 'NEWS0072', '2024-11-18 00:30:00', 'Real estate market trends.', 0, 500, 'Trends in real estate.', NULL, 'Title: post 1 sub 8', 'Meta_Title: post 1 sub 8', 'Real estate market insights.'),
('SUB0008', 'WRT0005', 'STS0001', 'NEWS0073', '2024-11-19 00:30:00', 'Buying vs renting.', 0, 550, 'Should you buy or rent?', NULL, 'Title: post 2 sub 8', 'Meta_Title: post 2 sub 8', 'Buying vs renting analysis.'),
('SUB0008', 'WRT0005', 'STS0001', 'NEWS0074', '2024-11-20 00:30:00', 'Investment opportunities.', 0, 600, 'Investing in real estate.', NULL, 'Title: post 3 sub 8', 'Meta_Title: post 3 sub 8', 'Real estate investment tips.'),
('SUB0008', 'WRT0005', 'STS0001', 'NEWS0075', '2024-11-21 00:30:00', 'Home improvement tips.', 0, 650, 'Improving your home value.', NULL, 'Title: post 4 sub 8', 'Meta_Title: post 4 sub 8', 'Home improvement strategies.'),

-- sub9 
('SUB0009', 'WRT0006', 'STS0001', 'NEWS0076', '2024-11-22 00:30:00', 'Latest movies to watch.', 0, 700, 'Movies you should not miss.', NULL, 'Title: post 1 sub 9', 'Meta_Title: post 1 sub 9', 'Latest movies review.Đi khám phá rừng Phú Quốc là tour du lịch trải nghiệm độc đáo. Trước khi đi tham quan khách sẽ được hướng dẫn.Đi khám phá rừng Phú Quốc là tour du lịch trải nghiệm độc đáo. Trước khi đi tham quan khách sẽ được hướng dẫn.'),
('SUB0009', 'WRT0006', 'STS0001', 'NEWS0077', '2024-11-23 00:30:00', 'Top music hits.', 0, 750, 'Music that is trending now.', NULL, 'Title: post 2 sub 9', 'Meta_Title: post 2 sub 9', 'Top music hits analysis.'),
('SUB0009', 'WRT0006', 'STS0001', 'NEWS0078', '2024-11-24 00:30:00', 'Upcoming concerts.', 0, 800, 'Concerts you should attend.', NULL, 'Title: post 3 sub 9', 'Meta_Title: post 3 sub 9', 'Upcoming concerts overview.'),
('SUB0009', 'WRT0006', 'STS0001', 'NEWS0079', '2024-11-25 00:30:00', 'Best games of the year.', 0, 850, 'Games that made an impact.', NULL, 'Title: post 4 sub 9', 'Meta_Title: post 4 sub 9', 'Best games review.'),

-- sub10
('SUB0010', 'WRT0006', 'STS0001', 'NEWS0080', '2024-11-01 00:30:00', 'Understanding criminal law.', 0, 900, 'Criminal law explained.', NULL, 'Title: post 1 sub 10', 'Meta_Title: post 1 sub 10', 'Criminal law insights.'),
('SUB0010', 'WRT0006', 'STS0001', 'NEWS0081', '2024-11-01 00:30:00', 'Civil law basics.', 0, 950, 'Basics of civil law.', NULL, 'Title: post 2 sub 10', 'Meta_Title: post 2 sub 10', 'Civil law overview.'),
('SUB0010', 'WRT0006', 'STS0001', 'NEWS0082', '2024-11-01 00:30:00', 'Labor law essentials.', 0, 1000, 'Labor law explained.', NULL, 'Title: post 3 sub 10', 'Meta_Title: post 3 sub 10', 'Labor law essentials.'),
('SUB0010', 'WRT0006', 'STS0001', 'NEWS0083', '2024-11-01 00:30:00', 'Economic law insights.', 0, 1050, 'Understanding economic law.', NULL, 'Title: post 4 sub 10', 'Meta_Title: post 4 sub 10', 'Economic law insights.'),

-- sub11 
('SUB0011', 'WRT0006', 'STS0001', 'NEWS0084', '2024-11-02 00:30:00', 'Nutrition tips for a healthy life.', 0, 1100, 'Nutrition is key to health.', NULL, 'Title: post 1 sub 11', 'Meta_Title: post 1 sub 11', 'Nutrition tips overview.Đi khám phá rừng Phú Quốc là tour du lịch trải nghiệm độc đáo. Trước khi đi tham quan khách sẽ được hướng dẫn.Đi khám phá rừng Phú Quốc là tour du lịch trải nghiệm độc đáo. Trước khi đi tham quan khách sẽ được hướng dẫn.Đi khám phá rừng Phú Quốc là tour du lịch trải nghiệm độc đáo. Trước khi đi tham quan khách sẽ được hướng dẫn.'),
('SUB0011', 'WRT0006', 'STS0001', 'NEWS0085', '2024-11-01 00:30:00', 'Understanding diseases.', 0, 1150, 'Common diseases explained.', NULL, 'Title: post 2 sub 11', 'Meta_Title: post 2 sub 11', 'Understanding diseases overview.'),
('SUB0011', 'WRT0006', 'STS0001', 'NEWS0086', '2023-01-01 00:30:00', 'Exercise for health.', 0, 1200, 'Importance of exercise.', NULL, 'Title: post 3 sub 11', 'Meta_Title: post 3 sub 11', 'Exercise for health overview.'),
('SUB0011', 'WRT0006', 'STS0001', 'NEWS0087', '2023-01-02 00:30:00', 'Mental health awareness.', 0, 1250, 'Mental health is crucial.', NULL, 'Title: post 4 sub 11', 'Meta_Title: post 4 sub 11', 'Mental health awareness overview.'),

-- sub12 
('SUB0012', 'WRT0006', 'STS0001', 'NEWS0088', '2024-11-03 00:30:00', 'Traveling within the country.', 0, 1300, 'Domestic travel tips.', NULL, 'Title: post 1 sub 12', 'Meta_Title: post 1 sub 12', 'Domestic travel insights.'),
('SUB0012', 'WRT0006', 'STS0001', 'NEWS0089', '2024-12-07 00:30:00', 'International travel tips.', 0, 1350, 'Traveling abroad.', NULL, 'Title: post 2 sub 12', 'Meta_Title: post 2 sub 12', 'International travel overview.'),
('SUB0012', 'WRT0006', 'STS0001', 'NEWS0090', '2024-12-05 00:30:00', 'Culinary experiences.', 0, 1400, 'Food experiences while traveling.', NULL, 'Title: post 3 sub 12', 'Meta_Title: post 3 sub 12', 'Culinary experiences overview.'),
('SUB0012', 'WRT0006', 'STS0001', 'NEWS0091', '2024-11-06 00:30:00', 'Cultural experiences.', 0, 1450, 'Cultural experiences while traveling.', NULL, 'Title: post 4 sub 12', 'Meta_Title: post 4 sub 12', 'Cultural experiences overview.'),

-- sub 13
('SUB0013', 'WRT0007', 'STS0001', 'NEWS0092', '2024-11-07 00:30:00', 'Football matches this week.', 0, 1500, 'Exciting football matches coming up.', NULL, 'Title: post 1 sub 13', 'Meta_Title: post 1 sub 13', 'Football matches preview.'),
('SUB0013', 'WRT0007', 'STS0001', 'NEWS0093', '2024-12-08 00:30:00', 'Volleyball championships.', 0, 1550, 'Volleyball championships are heating up.', NULL, 'Title: post 2 sub 13', 'Meta_Title: post 2 sub 13', 'Volleyball championships overview.'),
('SUB0013', 'WRT0007', 'STS0001', 'NEWS0094', '2024-12-09 00:30:00', 'Athletics events this month.', 0, 1600, 'Athletics events to watch.', NULL, 'Title: post 3 sub 13', 'Meta_Title: post 3 sub 13', 'Athletics events preview.'),
('SUB0013', 'WRT0007', 'STS0001', 'NEWS0095', '2024-01-10 00:30:00', 'Badminton tournaments.', 0, 1650, 'Upcoming badminton tournaments.', NULL, 'Title: post 4 sub 13', 'Meta_Title: post 4 sub 13', 'Badminton tournaments overview.'),

-- sub14 
('SUB0014', 'WRT0007', 'STS0001', 'NEWS0096', '2024-12-11 00:30:00', 'Volleyball training tips.', 0, 1700, 'Tips for improving your volleyball skills.', NULL, 'Title: post 1 sub 14', 'Meta_Title: post 1 sub 14', 'Volleyball training tips overview.'),
('SUB0014', 'WRT0007', 'STS0001', 'NEWS0097', '2024-12-12 00:30:00', 'Best volleyball players of the year.', 0, 1750, 'Highlighting top players.', NULL, 'Title: post 2 sub 14', 'Meta_Title: post 2 sub 14', 'Top volleyball players review.'),
('SUB0014', 'WRT0007', 'STS0001', 'NEWS0098', '2024-11-13 00:30:00', 'Volleyball match highlights.', 0, 1800, 'Highlights from recent matches.', NULL, 'Title: post 3 sub 14', 'Meta_Title: post 3 sub 14', 'Volleyball match highlights overview.'),
('SUB0014', 'WRT0007', 'STS0001', 'NEWS0099', '2024-11-14 00:30:00', 'Upcoming volleyball events.', 0, 1850, 'Events to look forward to.', NULL, 'Title: post 4 sub 14', 'Meta_Title: post 4 sub 14', 'Upcoming volleyball events preview.'),

-- sub15
('SUB0015', 'WRT0007', 'STS0001', 'NEWS0100', '2024-11-15 00:30:00', 'Athletics training programs.', 0, 1900, 'Best training programs for athletes.', NULL, 'Title: post 1 sub 15', 'Meta_Title: post 1 sub 15', 'Athletics training programs overview.'),
('SUB0015', 'WRT0007', 'STS0001', 'NEWS0101', '2024-11-16 00:30:00', 'Top athletes to watch.', 0, 1950, 'Highlighting top athletes.', NULL, 'Title: post 2 sub 15', 'Meta_Title: post 2 sub 15', 'Top athletes review.'),
('SUB0015', 'WRT0007', 'STS0001', 'NEWS0102', '2024-11-17 00:30:00', 'Athletics events recap.', 0, 2000, 'Recap of recent events.', NULL, 'Title: post 3 sub 15', 'Meta_Title: post 3 sub 15', 'Athletics events recap overview.'),
('SUB0015', 'WRT0007', 'STS0001', 'NEWS0103', '2024-12-12 00:30:00', 'Upcoming athletics competitions.', 0, 2050, 'Competitions to look forward to.', NULL, 'Title: post 4 sub 15', 'Meta_Title: post 4 sub 15', 'Upcoming athletics competitions preview.'),

-- sub16
('SUB0016', 'WRT0007', 'STS0001', 'NEWS0104', '2024-01-19 00:30:00', 'Badminton training techniques.', 0, 2100, 'Techniques to improve your game.', NULL, 'Title: post 1 sub 16', 'Meta_Title: post 1 sub 16', 'Badminton training techniques overview.'),
('SUB0016', 'WRT0007', 'STS0001', 'NEWS0105', '2024-01-20 00:30:00', 'Best badminton players.', 0, 2150, 'Highlighting the best players.', NULL, 'Title: post 2 sub 16', 'Meta_Title: post 2 sub 16', 'Best badminton players review.'),
('SUB0016', 'WRT0007', 'STS0001', 'NEWS0106', '2024-12-12 00:30:00', 'Badminton match highlights.', 0, 2200, 'Highlights from recent matches.', NULL, 'Title: post 3 sub 16', 'Meta_Title: post 3 sub 16', 'Badminton match highlights overview.'),
('SUB0016', 'WRT0007', 'STS0001', 'NEWS0107', '2024-11-12 00:30:00', 'Upcoming badminton tournaments.', 0, 2250, 'Tournaments to look forward to.', NULL, 'Title: post 4 sub 16', 'Meta_Title: post 4 sub 16', 'Upcoming badminton tournaments preview.'),

-- Subcategory: SUB0017 (Học bổng)
('SUB0017', 'WRT0008', 'STS0001', 'NEWS0108', '2024-01-23 00:30:00', 'Scholarship opportunities for students.', 0, 2300, 'Explore various scholarship options.', NULL, 'Title: post 1 sub 17', 'Meta_Title: post 1 sub 17', 'Scholarship opportunities overview.'),
('SUB0017', 'WRT0008', 'STS0001', 'NEWS0109', '2024-12-12 00:30:00', 'How to apply for scholarships.', 0, 2350, 'Tips for applying successfully.', NULL, 'Title: post 2 sub 17', 'Meta_Title: post 2 sub 17', 'How to apply for scholarships overview.'),
('SUB0017', 'WRT0008', 'STS0001', 'NEWS0110', '2024-11-25 00:30:00', 'Scholarship success stories.', 0, 2400, 'Inspiring stories from scholarship recipients.', NULL, 'Title: post 3 sub 17', 'Meta_Title: post 3 sub 17', 'Scholarship success stories overview.'),
('SUB0017', 'WRT0008', 'STS0001', 'NEWS0111', '2024-11-26 00:30:00', 'Common scholarship application mistakes.', 0, 2450, 'Avoid these pitfalls when applying.', NULL, 'Title: post 4 sub 17', 'Meta_Title: post 4 sub 17', 'Common scholarship application mistakes overview.'),

-- Subcategory: SUB0018 (Tuyển sinh)
('SUB0018', 'WRT0008', 'STS0001', 'NEWS0112', '2024-01-27 00:30:00', 'Enrollment process for universities.', 0, 2500, 'Step-by-step guide to enrollment.', NULL, 'Title: post 1 sub 18', 'Meta_Title: post 1 sub 18', 'Enrollment process overview.'),
('SUB0018', 'WRT0008', 'STS0001', 'NEWS0113', '2024-12-11 00:30:00', 'Important dates for enrollment.', 0, 2550, 'Key dates to remember.', NULL, 'Title: post 2 sub 18', 'Meta_Title: post 2 sub 18', 'Important dates for enrollment overview.'),
('SUB0018', 'WRT0008', 'STS0001', 'NEWS0114', '2024-12-12 00:30:00', 'Tips for a successful enrollment.', 0, 2600, 'How to ensure a smooth enrollment process.', NULL, 'Title: post 3 sub 18', 'Meta_Title: post 3 sub 18', 'Tips for successful enrollment overview.'),
('SUB0018', 'WRT0008', 'STS0001', 'NEWS0115', '2024-01-30 00:30:00', 'Common enrollment mistakes.', 0, 2650, 'Avoid these common mistakes.', NULL, 'Title: post 4 sub 18', 'Meta_Title: post 4 sub 18', 'Common enrollment mistakes overview.'),

-- Subcategory: SUB0019 (Đào tạo)
('SUB0019', 'WRT0008', 'STS0001', 'NEWS0116', '2024-01-31 00:30:00', 'Training programs for professionals.', 0, 2700, 'Explore various training options.', NULL, 'Title: post 1 sub 19', 'Meta_Title: post 1 sub 19', 'Training programs overview.'),
('SUB0019', 'WRT0008', 'STS0001', 'NEWS0117', '2024-12-11 00:30:00', 'How to choose the right training program.', 0, 2750, 'Tips for selecting the best program.', NULL, 'Title: post 2 sub 19', 'Meta_Title: post 2 sub 19', 'Choosing the right training program overview.'),
('SUB0019', 'WRT0008', 'STS0001', 'NEWS0118', '2024-11-02 00:30:00', 'Success stories from training participants.', 0, 2800, 'Inspiring stories from trainees.', NULL, 'Title: post 3 sub 19', 'Meta_Title: post 3 sub 19', 'Training success stories overview.'),
('SUB0019', 'WRT0008', 'STS0001', 'NEWS0119', '2024-12-03 00:30:00', 'Common training pitfalls to avoid.', 0, 2850, 'Avoid these common mistakes.', NULL, 'Title: post 4 sub 19', 'Meta_Title: post 4 sub 19', 'Common training pitfalls overview.'),

-- Subcategory: SUB0020 (Nghiên cứu)
('SUB0020', 'WRT0008', 'STS0001', 'NEWS0120', '2024-11-04 00:30:00', 'Research opportunities for students.', 0, 2900, 'Explore various research options.', NULL, 'Title: post 1 sub 20', 'Meta_Title: post 1 sub 20', 'Research opportunities overview.'),
('SUB0020', 'WRT0008', 'STS0001', 'NEWS0121', '2024-11-05 00:30:00', 'How to conduct effective research.', 0, 2950, 'Tips for conducting research.', NULL, 'Title: post 2 sub 20', 'Meta_Title: post 2 sub 20', 'Conducting effective research overview.'),
('SUB0020', 'WRT0008', 'STS0001', 'NEWS0122', '2024-12-06 00:30:00', 'Research success stories.', 0, 3000, 'Inspiring stories from researchers.', NULL, 'Title: post 3 sub 20', 'Meta_Title: post 3 sub 20', 'Research success stories overview.'),
('SUB0020', 'WRT0008', 'STS0001', 'NEWS0123', '2024-12-07 00:30:00', 'Common research mistakes.', 0, 3050, 'Avoid these common pitfalls.', NULL, 'Title: post 4 sub 20', 'Meta_Title: post 4 sub 20', 'Common research mistakes overview.'),

-- Subcategory: SUB0021 (Gia đình)
('SUB0021', 'WRT0009', 'STS0001', 'NEWS0124', '2024-02-08 00:30:00', 'Family bonding activities.', 0, 3100, 'Activities to strengthen family ties.', NULL, 'Title: post 1 sub 21', 'Meta_Title: post 1 sub 21', 'Family bonding activities overview.'),
('SUB0021', 'WRT0009', 'STS0001', 'NEWS0125', '2024-02-09 00:30:00', 'Tips for a happy family life.', 0, 3150, 'Advice for maintaining family happiness.', NULL, 'Title: post 2 sub 21', 'Meta_Title: post 2 sub 21', 'Happy family life tips overview.'),
('SUB0021', 'WRT0009', 'STS0001', 'NEWS0126', '2024-02-10 00:30:00', 'Managing family finances.', 0, 3200, 'Financial tips for families.', NULL, 'Title: post 3 sub 21', 'Meta_Title: post 3 sub 21', 'Managing family finances overview.'),
('SUB0021', 'WRT0009', 'STS0001', 'NEWS0127', '2024-12-11 00:30:00', 'Family health and wellness.', 0, 3250, 'Health tips for the whole family.', NULL, 'Title: post 4 sub 21', 'Meta_Title: post 4 sub 21', 'Family health and wellness overview.'),

-- Subcategory: SUB0022 (Sức khỏe)
('SUB0022', 'WRT0009', 'STS0001', 'NEWS0128', '2024-02-12 00:30:00', 'Healthy eating habits.', 0, 3300, 'Tips for a balanced diet.', NULL, 'Title: post 1 sub 22', 'Meta_Title: post 1 sub 22', 'Healthy eating habits overview.'),
('SUB0022', 'WRT0009', 'STS0001', 'NEWS0129', '2024-02-13 00:30:00', 'Exercise routines for families.', 0, 3350, 'Fun exercises to do together.', NULL, 'Title: post 2 sub 22', 'Meta_Title: post 2 sub 22', 'Family exercise routines overview.'),
('SUB0022', 'WRT0009', 'STS0001', 'NEWS0130', '2024-12-11 00:30:00', 'Mental health awareness.', 0, 3400, 'Importance of mental health.', NULL, 'Title: post 3 sub 22', 'Meta_Title: post 3 sub 22', 'Mental health awareness overview.'),
('SUB0022', 'WRT0009', 'STS0001', 'NEWS0131', '2024-02-15 00:30:00', 'Preventive healthcare tips.', 0, 3450, 'How to stay healthy.', NULL, 'Title: post 4 sub 22', 'Meta_Title: post 4 sub 22', 'Preventive healthcare tips overview.'),

-- Subcategory: SUB0023 (Làm đẹp)
('SUB0023', 'WRT0009', 'STS0001', 'NEWS0132', '2024-02-16 00:30:00', 'Skincare routines for all ages.', 0, 3500, 'Tips for healthy skin.', NULL, 'Title: post 1 sub 23', 'Meta_Title: post 1 sub 23', 'Skincare routines overview.'),
('SUB0023', 'WRT0009', 'STS0001', 'NEWS0133', '2024-12-04 00:30:00', 'Makeup tips for beginners.', 0, 3550, 'Easy makeup techniques.', NULL, 'Title: post 2 sub 23', 'Meta_Title: post 2 sub 23', 'Makeup tips overview.'),
('SUB0023', 'WRT0009', 'STS0001', 'NEWS0134', '2024-12-07 00:30:00', 'Hair care tips.', 0, 3600, 'How to maintain healthy hair.', NULL, 'Title: post 3 sub 23', 'Meta_Title: post 3 sub 23', 'Hair care tips overview.'),
('SUB0023', 'WRT0009', 'STS0001', 'NEWS0135', '2024-02-19 00:30:00', 'Nail care and designs.', 0, 3650, 'Trendy nail designs and care tips.', NULL, 'Title: post 4 sub 23', 'Meta_Title: post 4 sub 23', 'Nail care and designs overview.'),

-- Subcategory: SUB0024 (Tâm sự)
('SUB0024', 'WRT0009', 'STS0001', 'NEWS0136', '2024-02-20 00:30:00', 'Sharing personal experiences.', 0, 3700, 'The importance of sharing.', NULL, 'Title: post 1 sub 24', 'Meta_Title: post 1 sub 24', 'Sharing personal experiences overview.'),
('SUB0024', 'WRT0009', 'STS0001', 'NEWS0137', '2024-12-01 00:30:00', 'Dealing with stress.', 0, 3750, 'Tips for managing stress.', NULL, 'Title: post 2 sub 24', 'Meta_Title: post 2 sub 24', 'Dealing with stress overview.'),
('SUB0024', 'WRT0009', 'STS0001', 'NEWS0138', '2024-12-09 00:30:00', 'Building self-confidence.', 0, 3800, 'Ways to boost your confidence.', NULL, 'Title: post 3 sub 24', 'Meta_Title: post 3 sub 24', 'Building self-confidence overview.'),
('SUB0024', 'WRT0009', 'STS0001', 'NEWS0139', '2024-02-23 00:30:00', 'Finding balance in life.', 0, 3850, 'Tips for a balanced life.', NULL, 'Title: post 4 sub 24', 'Meta_Title: post 4 sub 24', 'Finding balance in life overview.'),

-- Subcategory: SUB0025 (Châu Á)
('SUB0025', 'WRT0010', 'STS0001', 'NEWS0140', '2024-12-09 00:30:00', 'Cultural diversity in Asia.', 0, 3900, 'Exploring the rich cultures of Asia.', NULL, 'Title: post 1 sub 25', 'Meta_Title: post 1 sub 25', 'Cultural diversity in Asia overview.'),
('SUB0025', 'WRT0010', 'STS0001', 'NEWS0141', '2024-02-24 00:30:00', 'Travel destinations in Asia.', 0, 3950, 'Top places to visit in Asia.', NULL, 'Title: post 2 sub 25', 'Meta_Title: post 2 sub 25', 'Travel destinations in Asia overview.'),
('SUB0025', 'WRT0010', 'STS0001', 'NEWS0142', '2024-11-25 00:30:00', 'Asian cuisine highlights.', 0, 4000, 'Delicious dishes from Asia.', NULL, 'Title: post 3 sub 25', 'Meta_Title: post 3 sub 25', 'Asian cuisine highlights overview.'),
('SUB0025', 'WRT0010', 'STS0001', 'NEWS0143', '2024-11-26 00:30:00', 'Festivals celebrated in Asia.', 0, 4050, 'Festivals that showcase Asian culture.', NULL, 'Title: post 4 sub 25', 'Meta_Title: post 4 sub 25', 'Festivals in Asia overview.'),

-- Subcategory: SUB0026 (Châu Âu)
('SUB0026', 'WRT0010', 'STS0001', 'NEWS0144', '2024-11-27 00:30:00', 'Historical landmarks in Europe.', 0, 4100, 'Exploring Europe’s rich history.', NULL, 'Title: post 1 sub 26', 'Meta_Title: post 1 sub 26', 'Historical landmarks in Europe overview.'),
('SUB0026', 'WRT0010', 'STS0001', 'NEWS0145', '2024-11-27 00:30:00', 'European art and architecture.', 0, 4150, 'A look at Europe’s artistic heritage.', NULL, 'Title: post 2 sub 26', 'Meta_Title: post 2 sub 26', 'European art and architecture overview.'),
('SUB0026', 'WRT0010', 'STS0001', 'NEWS0146', '2024-02-28 00:30:00', 'Culinary delights in Europe.', 0, 4200, 'Tasting the best of European cuisine.', NULL, 'Title: post 3 sub 26', 'Meta_Title: post 3 sub 26', 'Culinary delights in Europe overview.'),
('SUB0026', 'WRT0010', 'STS0001', 'NEWS0147', '2024-11-01 00:30:00', 'European traditions and customs.', 0, 4250, 'Understanding the cultural practices of Europe.', NULL, 'Title: post 4 sub 26', 'Meta_Title: post 4 sub 26', 'European traditions overview.'),

-- Subcategory: SUB0027 (Châu Mỹ)
('SUB0027', 'WRT0010', 'STS0001', 'NEWS0148', '2024-02-27 00:30:00', 'Natural wonders of America.', 0, 4300, 'Exploring the breathtaking landscapes.', NULL, 'Title: post 1 sub 27', 'Meta_Title: post 1 sub 27', 'Natural wonders of America overview.'),
('SUB0027', 'WRT0010', 'STS0001', 'NEWS0149', '2024-03-02 00:30:00', 'Cultural festivals in America.', 0, 4350, 'Celebrating diversity through festivals.', NULL, 'Title: post 2 sub 27', 'Meta_Title: post 2 sub 27', 'Cultural festivals in America overview.'),
('SUB0027', 'WRT0010', 'STS0001', 'NEWS0150', '2024-03-03 00:30:00', 'American cuisine specialties.', 0, 4400, 'Tasting the flavors of America.', NULL, 'Title: post 3 sub 27', 'Meta_Title: post 3 sub 27', 'American cuisine specialties overview.'),
('SUB0027', 'WRT0010', 'STS0001', 'NEWS0151', '2024-03-04 00:30:00', 'Historical sites in America.', 0, 4450, 'Visiting significant historical landmarks.', NULL, 'Title: post 4 sub 27', 'Meta_Title: post 4 sub 27', 'Historical sites in America overview.'),

-- Subcategory: SUB0028 (Châu Phi)
('SUB0028', 'WRT0010', 'STS0001', 'NEWS0152', '2024-12-14 23:30:00', 'Wildlife and nature in Africa.', 0, 4500, 'Exploring Africa’s rich biodiversity.', NULL, 'Title: post 1 sub 28', 'Meta_Title: post 1 sub 28', 'Wildlife and nature in Africa overview.'),
('SUB0028', 'WRT0010', 'STS0001', 'NEWS0153', '2024-12-05 00:30:00', 'Cultural heritage of Africa.', 0, 4550, 'Understanding the diverse cultures.', NULL, 'Title: post 2 sub 28', 'Meta_Title: post 2 sub 28', 'Cultural heritage of Africa overview.'),
('SUB0028', 'WRT0010', 'STS0001', 'NEWS0154', '2024-12-06 00:30:00', 'African cuisine and flavors.', 0, 4600, 'Tasting the unique dishes of Africa.', NULL, 'Title: post 3 sub 28', 'Meta_Title: post 3 sub 28', 'African cuisine overview.'),
('SUB0028', 'WRT0010', 'STS0001', 'NEWS0155', '2024-12-07 00:30:00', 'Festivals and celebrations in Africa.', 0, 4650, 'Experiencing the vibrant festivals.', NULL, 'Title: post 4 sub 28', 'Meta_Title: post 4 sub 28', 'Festivals in Africa overview.'),

-- Subcategory: SUB0029 (Nhà ở)
('SUB0029', 'WRT0011', 'STS0001', 'NEWS0156', '2024-11-27 00:30:00',  'Buying your first home.', 0, 4700, 'Tips for first-time homebuyers.', NULL, 'Title: post 1 sub 29', 'Meta_Title: post 1 sub 29', 'Buying your first home overview.'),
('SUB0029', 'WRT0011', 'STS0001', 'NEWS0157',  '2024-11-27 00:30:00', 'Home maintenance tips.', 0, 4750, 'Keeping your home in top shape.', NULL, 'Title: post 2 sub 29', 'Meta_Title: post 2 sub 29', 'Home maintenance tips overview.'),
('SUB0029', 'WRT0011', 'STS0001', 'NEWS0158',  '2024-12-09 00:30:00', 'Interior design ideas.', 0, 4800, 'Creative ways to decorate your home.', NULL, 'Title: post 3 sub 29', 'Meta_Title: post 3 sub 29', 'Interior design ideas overview.'),
('SUB0029', 'WRT0011', 'STS0001', 'NEWS0159',  '2024-12-09 00:31:00', 'Home security tips.', 0, 4850, 'How to keep your home safe.', NULL, 'Title: post 4 sub 29', 'Meta_Title: post 4 sub 29', 'Home security tips overview.'),

-- Subcategory: SUB0030 (Văn phòng)
('SUB0030', 'WRT0011', 'STS0001', 'NEWS0160',  '2024-11-27 00:30:00', 'Setting up a home office.', 0, 4900, 'Tips for creating a productive workspace.', NULL, 'Title: post 1 sub 30', 'Meta_Title: post 1 sub 30', 'Setting up a home office overview.'),
('SUB0030', 'WRT0011', 'STS0001', 'NEWS0161',  '2024-11-27 00:30:00', 'Office organization tips.', 0, 4950, 'How to keep your office organized.', NULL, 'Title: post 2 sub 30', 'Meta_Title: post 2 sub 30', 'Office organization tips overview.'),
('SUB0030', 'WRT0011', 'STS0001', 'NEWS0162',  '2024-11-27 00:30:00', 'Choosing the right office equipment.', 0, 5000, 'Essential tools for your office.', NULL, 'Title: post 3 sub 30', 'Meta_Title: post 3 sub 30', 'Choosing office equipment overview.'),
('SUB0030', 'WRT0011', 'STS0001', 'NEWS0163',  '2024-12-12 00:30:00', 'Work-life balance in the office.', 0, 5050, 'Maintaining balance while working.', NULL, 'Title: post 4 sub 30', 'Meta_Title: post 4 sub 30', 'Work-life balance overview.'),

-- Subcategory: SUB0031 (Đầu tư)
('SUB0031', 'WRT0011', 'STS0001', 'NEWS0164',  '2024-12-09 00:30:00', 'Investment strategies for beginners.', 0, 5100, 'How to start investing wisely.', NULL, 'Title: post 1 sub 31', 'Meta_Title: post 1 sub 31', 'Investment strategies overview.'),
('SUB0031', 'WRT0011', 'STS0001', 'NEWS0165',  '2024-12-12 00:30:00', 'Understanding stocks and bonds.', 0, 5150, 'Basics of stock and bond investments.', NULL, 'Title: post 2 sub 31', 'Meta_Title: post 2 sub 31', 'Stocks and bonds overview.'),
('SUB0031', 'WRT0011', 'STS0001', 'NEWS0166',  '2024-12-12 00:30:00', 'Real estate investment tips.', 0, 5200, 'How to invest in real estate.', NULL, 'Title: post 3 sub 31', 'Meta_Title: post 3 sub 31', 'Real estate investment tips overview.'),
('SUB0031', 'WRT0011', 'STS0001', 'NEWS0167',  '2024-12-08 00:30:00', 'Diversifying your investment portfolio.', 0, 5250, 'Importance of diversification.', NULL, 'Title: post 4 sub 31', 'Meta_Title: post 4 sub 31', 'Diversifying your portfolio overview.'),

-- Subcategory: SUB0032 (Pháp lý)
('SUB0032', 'WRT0011', 'STS0001', 'NEWS0168',  '2024-12-12 00:30:00', 'Understanding legal contracts.', 0, 5300, 'Basics of contracts and agreements.', NULL, 'Title: post 1 sub 32', 'Meta_Title: post 1 sub 32', 'Understanding legal contracts overview.'),
('SUB0032', 'WRT0011', 'STS0001', 'NEWS0169',  '2024-12-12 00:30:00', 'Legal rights and responsibilities.', 0, 5350, 'Know your rights and duties.', NULL, 'Title: post 2 sub 32', 'Meta_Title: post 2 sub 32', 'Legal rights overview.'),
('SUB0032', 'WRT0011', 'STS0001', 'NEWS0170',  '2024-12-12 00:30:00', 'How to handle legal disputes.', 0, 5400, 'Steps to resolve conflicts legally.', NULL, 'Title: post 3 sub 32', 'Meta_Title: post 3 sub 32', 'Handling legal disputes overview.'),
('SUB0032', 'WRT0011', 'STS0001', 'NEWS0171',  '2024-12-12 00:30:00', 'Finding a good lawyer.', 0, 5450, 'Tips for choosing the right legal representation.', NULL, 'Title: post 4 sub 32', 'Meta_Title: post 4 sub 32', 'Finding a good lawyer overview.'),

-- Subcategory: SUB0033 (Phim ảnh)
('SUB0033', 'WRT0012', 'STS0001', 'NEWS0172',  '2024-12-12 00:30:00', 'Upcoming movie releases.', 0, 5500, 'What to watch in the coming months.', NULL, 'Title: post 1 sub 33', 'Meta_Title: post 1 sub 33 Upcoming movie releases overview Upcoming movie releases overview Upcoming movie releases overview Upcoming movie releases overview', 'Upcoming movie releases overviPhương Mỹ Chi và Phương Duyên song ca bài Đẩy xe bò của Phưo và câu hát mang âm hưởng quan họ trong bàie releases overview. Upcoming movie releases overview. Upcoming movie releases overview. Upcoming movie releases overview.'),
('SUB0033', 'WRT0012', 'STS0001', 'NEWS0173',  '2024-12-12 00:30:00', 'Top movies of the year.', 0, 5550, 'A look at the best films released this year.', NULL, 'Title: post 2 sub 33', 'Meta_Title: post 2 sub 33', 'Top movies of the year overview.'),
('SUB0033', 'WRT0012', 'STS0001', 'NEWS0174',  '2024-12-12 00:30:00', 'Film reviews and critiques.', 0, 5600, 'In-depth reviews of popular films.', NULL, 'Title: post 3 sub 33', 'Meta_Title: post 3 sub 33', 'Film reviews overview.'),
('SUB0033', 'WRT0012', 'STS0001', 'NEWS0175',  '2024-12-12 00:30:00', 'Behind the scenes of filmmaking.', 0, 5650, 'Insights into the filmmaking process.', NULL, 'Title: post 4 sub 33', 'Meta_Title: post 4 sub 33', 'Behind the scenes overview.'),

-- Subcategory: SUB0034 (Ca nhạc)
('SUB0034', 'WRT0012', 'STS0001', 'NEWS0176',  '2024-12-12 00:30:00', 'Latest music releases.', 0, 5700, 'What’s new in the music world.', NULL, 'Title: post 1 sub 34', 'Meta_Title: post 1 sub 34', 'Latest music releases overview.'),
('SUB0034', 'WRT0012', 'STS0001', 'NEWS0177',  '2024-12-12 00:30:00', 'Top music charts.', 0, 5750, 'The most popular songs right now.', NULL, 'Title: post 2 sub 34', 'Meta_Title: post 2 sub 34', 'Top music charts overview.'),
('SUB0034', 'WRT0012', 'STS0001', 'NEWS0178',  '2024-12-12 00:30:00', 'Concerts and live performances.', 0, 5800, 'Upcoming concerts to attend.', NULL, 'Title: post 3 sub 34', 'Meta_Title: post 3 sub 34', 'Concerts and live performances overview.'),
('SUB0034', 'WRT0012', 'STS0001', 'NEWS0179',  '2024-12-12 00:30:00', 'Interviews with artists.', 0, 5850, 'Exclusive interviews with musicians.', NULL, 'Title: post 4 sub 34', 'Meta_Title: post 4 sub 34', 'Interviews with artists overview.'),

-- Subcategory: SUB0035 (Gameshow)
('SUB0035', 'WRT0012', 'STS0001', 'NEWS0180',  '2024-12-11 00:30:00', 'Popular gameshows on TV.', 0, 5900, 'What to watch on your screen.', NULL, 'Title: post 1 sub 35', 'Meta_Title: post 1 sub 35', 'Popular gameshows overview.'),
('SUB0035', 'WRT0012', 'STS0001', 'NEWS0181',  '2024-12-01 00:30:00', 'Behind the scenes of gameshows.', 0, 5950, 'How gameshows are produced.', NULL, 'Title: post 2 sub 35', 'Meta_Title: post 2 sub 35', 'Behind the scenes overview.'),
('SUB0035', 'WRT0012', 'STS0001', 'NEWS0182',  '2024-12-12 00:30:00', 'Interviews with gameshow hosts.', 0, 6000, 'Insights from your favorite hosts.', NULL, 'Title: post 3 sub 35', 'Meta_Title: post 3 sub 35', 'Interviews with hosts overview.'),
('SUB0035', 'WRT0012', 'STS0001', 'NEWS0183',  '2024-12-12 00:30:00', 'Gameshow trivia and fun facts.', 0, 6050, 'Interesting facts about gameshows.', NULL, 'Title: post 4 sub 35', 'Meta_Title: post 4 sub 35', 'Gameshow trivia overview.'),

-- Subcategory: SUB0036 (Sân khấu)
('SUB0036', 'WRT0012', 'STS0001', 'NEWS0184',  '2024-12-12 00:30:00', 'Upcoming theater productions.', 0, 123456100, 'What’s on stage this season.', NULL, 'Title: post 1 sub 36', 'Meta_Title: post 1 sub 36', 'Upcoming theater productions overview.'),
('SUB0036', 'WRT0012', 'STS0001', 'NEWS0185',  '2024-12-12 00:30:00', 'Reviews of recent performances.', 0, 6150, 'Critiques of the latest shows.', NULL, 'Title: post 2 sub 36', 'Meta_Title: post 2 sub 36', 'Reviews of performances overview.'),
('SUB0036', 'WRT0012', 'STS0001', 'NEWS0186',  '2024-12-12 00:30:00', 'Interviews with theater actors.', 0, 6200, 'Insights from the stage.', NULL, 'Title: post 3 sub 36', 'Meta_Title: post 3 sub 36', 'Interviews with actors overview.'),
('SUB0036', 'WRT0012', 'STS0001', 'NEWS0187',  '2024-12-12 00:30:00', 'Theater history and evolution.', 0, 6250, 'A look at the history of theater.', NULL, 'Title: post 4 sub 36', 'Meta_Title: post 4 sub 36', 'Theater history overview.'),

-- Subcategory: SUB0037 (Hình sự)
('SUB0037', 'WRT0013', 'STS0001', 'NEWS0188',  '2024-12-12 00:30:00', 'Latest criminal cases in the news.', 0, 6300, 'Overview of recent criminal cases.', NULL, 'Title: post 1 sub 37', 'Meta_Title: post 1 sub 37', 'Latest criminal cases overview.'),
('SUB0037', 'WRT0013', 'STS0001', 'NEWS0189',  '2024-12-01 00:30:00', 'Understanding criminal law.', 0, 6350, 'Basics of criminal law explained.', NULL, 'Title: post 2 sub 37', 'Meta_Title: post 2 sub 37', 'Understanding criminal law overview.'),
('SUB0037', 'WRT0013', 'STS0001', 'NEWS0190',  '2024-12-12 00:30:00', 'Interviews with law enforcement.', 0, 6400, 'Insights from police officers.', NULL, 'Title: post 3 sub 37', 'Meta_Title: post 3 sub 37', 'Interviews with law enforcement overview.'),
('SUB0037', 'WRT0013', 'STS0001', 'NEWS0191',  '2024-12-12 00:30:00', 'Crime prevention tips.', 0, 6450, 'How to stay safe and prevent crime.', NULL, 'Title: post 4 sub 37', 'Meta_Title: post 4 sub 37', 'Crime prevention tips overview.'),

-- Subcategory: SUB0038 (Dân sự)
('SUB0038', 'WRT0013', 'STS0001', 'NEWS0192',  '2024-12-12 00:30:00', 'Civil law basics.', 0, 6500, 'Understanding civil law and its applications.', NULL, 'Title: post 1 sub 38', 'Meta_Title: post 1 sub 38', 'Civil law basics overview.'),
('SUB0038', 'WRT0013', 'STS0001', 'NEWS0193',  '2024-12-01 00:30:00', 'Common civil disputes.', 0, 6550, 'Overview of typical civil disputes.', NULL, 'Title: post 2 sub 38', 'Meta_Title: post 2 sub 38', 'Common civil disputes overview.'),
('SUB0038', 'WRT0013', 'STS0001', 'NEWS0194',  '2024-12-12 00:30:00', 'How to resolve civil disputes.', 0, 6600, 'Methods for resolving civil issues.', NULL, 'Title: post 3 sub 38', 'Meta_Title: post 3 sub 38', 'Resolving civil disputes overview.'),
('SUB0038', 'WRT0013', 'STS0001', 'NEWS0195',  '2024-12-12 00:30:00', 'Legal rights in civil matters.', 0, 6650, 'Understanding your rights in civil law.', NULL, 'Title: post 4 sub 38', 'Meta_Title: post 4 sub 38', 'Legal rights in civil matters overview.'),

-- Subcategory: SUB0039 (Lao động)
('SUB0039', 'WRT0013', 'STS0001', 'NEWS0196',  '2024-12-12 00:30:00', 'Labor laws and regulations.', 0, 6700, 'Overview of labor laws.', NULL, 'Title: post 1 sub 39', 'Meta_Title: post 1 sub 39', 'Labor laws overview.'),
('SUB0039', 'WRT0013', 'STS0001', 'NEWS0197',  '2024-12-12 00:30:00', 'Employee rights and protections.', 0, 6750, 'Understanding employee rights.', NULL, 'Title: post 2 sub 39', 'Meta_Title: post 2 sub 39', 'Employee rights overview.'),
('SUB0039', 'WRT0013', 'STS0001', 'NEWS0198',  '2024-12-02 00:30:00', 'Workplace safety regulations.', 0, 6800, 'Ensuring safety at work.', NULL, 'Title: post 3 sub 39', 'Meta_Title: post 3 sub 39', 'Workplace safety overview.'),
('SUB0039', 'WRT0013', 'STS0001', 'NEWS0199',  '2024-12-12 00:30:00', 'How to handle workplace disputes.', 0, 6850, 'Resolving conflicts in the workplace.', NULL, 'Title: post 4 sub 39', 'Meta_Title: post 4 sub 39', 'Handling workplace disputes overview.'),

-- Subcategory: SUB0040 (Kinh tế)
('SUB0040', 'WRT0013', 'STS0001', 'NEWS0200',  '2024-12-12 00:30:00', 'Current economic trends.', 0, 6900, 'Overview of the current economy.', NULL, 'Title: post 1 sub 40', 'Meta_Title: post 1 sub 40', 'Current economic trends overview.'),
('SUB0040', 'WRT0013', 'STS0001', 'NEWS0201',  '2024-12-02 00:30:00', 'Understanding inflation.', 0, 6950, 'What is inflation and its effects.', NULL, 'Title: post 2 sub 40', 'Meta_Title: post 2 sub 40', 'Understanding inflation overview.'),
('SUB0040', 'WRT0013', 'STS0001', 'NEWS0202',  '2024-12-12 00:30:00', 'Investment opportunities in the economy.', 0, 7000, 'Where to invest in the current market.', NULL, 'Title: post 3 sub 40', 'Meta_Title: post 3 sub 40', 'Investment opportunities overview.'),
('SUB0040', 'WRT0013', 'STS0001', 'NEWS0203',  '2024-12-12 00:30:00', 'Economic policies and their impact.', 0, 7050, 'How policies affect the economy.', NULL, 'Title: post 4 sub 40', 'Meta_Title: post 4 sub 40', 'Economic policies overview.'),

-- Subcategory: SUB0041 (Công nghệ)
('SUB0041', 'WRT0014', 'STS0001', 'NEWS0204',  '2024-12-09 00:30:16', 'Latest technology trends.', 0, 7100, 'What’s new in technology.', NULL, 'Title: post 1 sub 41', 'Meta_Title: post 1 sub 41', 'Latest technology trends overview.'),
('SUB0041', 'WRT0014', 'STS0001', 'NEWS0205',  '2024-12-09 00:30:15', 'Innovations in artificial intelligence.', 0, 7150, 'Exploring AI advancements.', NULL, 'Title: post 2 sub 41', 'Meta_Title: post 2 sub 41', 'Innovations in AI overview.'),
('SUB0041', 'WRT0014', 'STS0001', 'NEWS0206',  '2024-12-09 00:30:14', 'Impact of technology on society.', 0, 7200, 'How technology shapes our lives.', NULL, 'Title: post 3 sub 41', 'Meta_Title: post 3 sub 41', 'Impact of technology overview.'),
('SUB0041', 'WRT0014', 'STS0001', 'NEWS0207',  '2024-12-09 00:30:13', 'Future of technology.', 0, 7250, 'What to expect in the tech world.', NULL, 'Title: post 4 sub 41', 'Meta_Title: post 4 sub 41', 'Future of technology overview.'),

-- Subcategory: SUB0042 (Giáo dục)
('SUB0042', 'WRT0014', 'STS0001', 'NEWS0208',  '2024-11-17 00:30:12', 'Trends in education.', 0, 999999300, 'What’s changing in education.', NULL, 'Title: post 1 sub 42', 'Meta_Title: post 1 sub 42', 'Trends in education overview.'),
('SUB0042', 'WRT0014', 'STS0001', 'NEWS0209',  '2024-12-14 00:30:11', 'Online learning platforms.', 0, 7350, 'Best platforms for online education.', NULL, 'Title: post 2 sub 42', 'Meta_Title: post 2 sub 42Online learning platforms overview.Online learning platforms overview.Online learning platforms overview. Online learning platforms overview.', 'Online learning platforms overview.Online learning platforms overview.Online learning platforms overview.Online learning platforms overview.Online learning platforms overview.'),
('SUB0042', 'WRT0014', 'STS0001', 'NEWS0210',  '2024-12-09 00:30:10', 'Importance of lifelong learning.', 0, 7400, 'Why continuous education matters.', NULL, 'Title: post 3 sub 42', 'Meta_Title: post 3 sub 42', 'Importance of lifelong learning overview.'),
('SUB0042', 'WRT0014', 'STS0001', 'NEWS0211',  '2024-12-09 00:30:09', 'Educational resources for students.', 0, 7450, 'Resources to enhance learning.', NULL, 'Title: post 4 sub 42', 'Meta_Title: post 4 sub 42', 'Educational resources overview.'),

-- Subcategory: SUB0043 (Sức khỏe tâm thần)
('SUB0043', 'WRT0014', 'STS0001', 'NEWS0212',  '2024-12-09 00:30:08', 'Understanding mental health.', 0, 7500, 'Basics of mental health awareness.', NULL, 'Title: post 1 sub 43', 'Meta_Title: post 1 sub 43', 'Understanding mental health overview.'),
('SUB0043', 'WRT0014', 'STS0001', 'NEWS0213',  '2024-12-09 00:30:07', 'Coping strategies for stress.', 0, 7550, 'How to manage stress effectively.', NULL, 'Title: post 2 sub 43', 'Meta_Title: post 2 sub 43', 'Coping strategies for stress overview.'),
('SUB0043', 'WRT0014', 'STS0001', 'NEWS0214',  '2024-12-09 00:30:06', 'Importance of therapy.', 0, 7600, 'Benefits of seeking professional help.', NULL, 'Title: post 3 sub 43', 'Meta_Title: post 3 sub 43', 'Importance of therapy overview.'),
('SUB0043', 'WRT0014', 'STS0001', 'NEWS0215',  '2024-12-09 00:30:05', 'Mental health resources.', 0, 7650, 'Where to find help and support.', NULL, 'Title: post 4 sub 43', 'Meta_Title: post 4 sub 43', 'Mental health resources overview.'),

-- Subcategory: SUB0044 (Thể thao)
('SUB0044', 'WRT0014', 'STS0001', 'NEWS0216',  '2024-12-09 00:30:04', 'Latest sports news.', 0, 7700, 'What’s happening in the sports world.', NULL, 'Title: post 1 sub 44', 'Meta_Title: post 1 sub 44', 'Latest sports news overview.'),
('SUB0044', 'WRT0014', 'STS0001', 'NEWS0217',  '2024-12-09 00:30:03', 'Top athletes to watch.', 0, 7750, 'Highlighting the best athletes.', NULL, 'Title: post 2 sub 44', 'Meta_Title: post 2 sub 44 Top athletes to watch overview. athletes to watc Top athletes to watch overview. athletes to watc', 'Top athletes to watch overview. athletes to watch overview. athletes to watch overview. athletes to watch overview. athletes to watch overview. athletes to watch overview. athletes to watch overview.'),
('SUB0044', 'WRT0014', 'STS0001', 'NEWS0218',  '2024-02-09 00:30:02', 'Upcoming sports events.', 0, 7800, 'Don’t miss these events.', NULL, 'Title: post 3 sub 44', 'Meta_Title: post 3 sub 44', 'Upcoming sports events overview.'),
('SUB0044', 'WRT0014', 'STS0001', 'NEWS0219',  '2024-12-09 00:30:01', 'Sports training tips.', 0, 7850, 'How to improve your game.', NULL, 'Title: post 4 sub 44', 'Meta_Title: post 4 sub 44', 'Sports training tips overview.'),

-- Subcategory: SUB0045 (Du lịch)
('SUB0045', 'WRT0015', 'STS0001', 'NEWS0220',  '2024-11-12 00:30:00', 'Top travel destinations for 2024.', 0, 700, 'Explore the best places to visit this year.', NULL, 'Title: post 1 sub 45', 'Meta_Title: post 1 sub 45', 'Top travel destinations overview.'),
('SUB0045', 'WRT0015', 'STS0001', 'NEWS0221',  '2024-11-12 00:30:00', 'Travel tips for budget travelers.', 0, 750, 'How to travel without breaking the bank.', NULL, 'Title: post 2 sub 45', 'Meta_Title: post 2 sub 45', 'Budget travel tips overview.'),
('SUB0045', 'WRT0015', 'STS0001', 'NEWS0222',  '2024-11-12 00:30:00', 'Cultural experiences around the world.', 0, 800, 'Immerse yourself in local cultures.', NULL, 'Title: post 3 sub 45', 'Meta_Title: post 3 sub 45', 'Cultural experiences overview.'),
('SUB0045', 'WRT0015', 'STS0001', 'NEWS0223',  '2024-11-12 00:30:00', 'Travel safety tips.', 0, 8050, 'How to stay safe while traveling.', NULL, 'Title: post 4 sub 45', 'Meta_Title: post 4 sub 45', 'Travel safety tips overview.'),

-- Subcategory: SUB0046 (Ẩm thực)
('SUB0046', 'WRT0015', 'STS0001', 'NEWS0224',  '2024-12-12 00:30:00', 'Popular food trends in 2024.', 0, 8100, 'What’s trending in the culinary world.', NULL, 'Title: post 1 sub 46', 'Meta_Title: post 1 sub 46 Food trends overview Food trends overview Food trends overview Food trends overview', 'Food trends overview Food trds overview Food trends overview Food trends overview Food trends overview Food trends overview Foodends overview Food trends overview Food trends overview Food trends overview Food trends overview Food trends overview.'),
('SUB0046', 'WRT0015', 'STS0001', 'NEWS0225',  '2024-11-12 00:30:00', 'Healthy eating habits.', 0, 8150, 'Tips for maintaining a balanced diet.', NULL, 'Title: post 2 sub 46', 'Meta_Title: post 2 sub 46', 'Healthy eating habits overview.'),
('SUB0046', 'WRT0015', 'STS0001', 'NEWS0226',  '2024-11-12 00:30:00', 'Cooking tips for beginners.', 0, 8200, 'Easy recipes and cooking techniques.', NULL, 'Title: post 3 sub 46', 'Meta_Title: post 3 sub 46', 'Cooking tips overview.'),
('SUB0046', 'WRT0015', 'STS0001', 'NEWS0227',  '2024-11-12 00:30:00', 'Exploring international cuisines.', 0, 820, 'A journey through global flavors.', NULL, 'Title: post 4 sub 46', 'Meta_Title: post 4 sub 46', 'International cuisines overview.'),

-- Subcategory: SUB0047 (Thời trang)
('SUB0047', 'WRT0015', 'STS0001', 'NEWS0228',  '2024-11-12 00:30:00', 'Fashion trends for 2024.', 0, 8300, 'What’s in style this year.', NULL, 'Title: post 1 sub 47', 'Meta_Title: post 1 sub 47', 'Fashion trends overview.'),
('SUB0047', 'WRT0015', 'STS0001', 'NEWS0229',  '2024-11-02 00:30:00', 'Sustainable fashion choices.', 0, 8350, 'How to shop sustainably.', NULL, 'Title: post 2 sub 47', 'Meta_Title: post 2 sub 47', 'Sustainable fashion overview.'),
('SUB0047', 'WRT0015', 'STS0001', 'NEWS0230',  '2024-11-12 00:35:00', 'Accessorizing your outfits.', 0, 8400, 'Tips for choosing the right accessories.', NULL, 'Title: post 3 sub 47 post 3 sub 47 post 3 sub 47 post 3 sub 47 post 3 sub 47 ' , 'Meta_Title: post 3 sub 47 Lorem ipsum dolor sit amet consectetur adipisicing elit. Incidunt suscipit commodi nam odio laudantium officia, voluptates autem unde, iste veniam atque doloribus asperiores reiciendis alias dolore. Qui distinctio voluptaswverview.', 'Lorem ipsum dolor sit amet consectetur adipisicing elit. Incidunt suscipit commodi nam odio laudantium officia, voluptates autem unde, iste veniam atque doloribus asperiores reiciendis alias dolore. Qui distinctio voluptas ratione.'),
('SUB0047', 'WRT0015', 'STS0001', 'NEWS0231',  '2024-11-12 00:30:00', 'Fashion tips for different body types.', 0, 8450, 'How to dress for your body shape.', NULL, 'Title: post 4 sub 47', 'Meta_Title: post 4 sub 47', 'Fashion tips overview.'),

-- Subcategory: SUB0048 (Làm đẹp)
('SUB0048', 'WRT0015', 'STS0001', 'NEWS0232',  '2024-11-12 00:30:00', 'Skincare routines for all skin types.', 0, 800, 'How to care for your skin.', NULL, 'Title: post 1 sub 48', 'Meta_Title: post 1 sub 48', 'Skincare routines overview.'),
('SUB0048', 'WRT0015', 'STS0001', 'NEWS0233',  '2024-11-12 00:30:00', 'Makeup tips for beginners.', 0, 8550, 'Easy makeup techniques to try.', NULL, 'Title: post 2 sub 48', 'Meta_Title: post 2 sub 48', 'Makeup tips overview.'),
('SUB0048', 'WRT0015', 'STS0001', 'NEWS0234',  '2024-11-12 00:30:00', 'Hair care tips for healthy hair.', 0, 8600, 'How to maintain beautiful hair.', NULL, 'Title: post 3 sub 48', 'Meta_Title: post 3 sub 48', 'Hair care tips overview.'),
('SUB0048', 'WRT0015', 'STS0001', 'NEWS0235',  '2024-11-12 00:30:00', 'Nail care and designs.', 0, 8650, 'Trendy nail designs and care tips.', NULL, 'Title: post 4 sub 48', 'Meta_Title: post 4 sub 48', 'Nail care and designs overview.');




-- Insert values into Comment
INSERT INTO Comment (Id_Comment, Id_User, Id_News, Time, Comment) 
VALUES
('CMT000001', 'USR0001', 'NEWS0001', '2024-12-15 09:23:45', 'Bài viết rất hay! Thông tin rất bổ ích.'),
('CMT000002', 'USR0002', 'NEWS0001', '2024-12-15 10:45:12', 'Tôi đã học được nhiều điều từ bài viết này. Cảm ơn!'),
('CMT000003', 'USR0003', 'NEWS0002', '2024-02-14 14:17:33', 'Quan điểm về sự phát triển của AI thật thú vị.'),
('CMT000004', 'USR0004', 'NEWS0002', '2024-02-14 15:22:56', 'Tôi hoàn toàn đồng ý với những điểm đã nêu.'),
('CMT000005', 'USR0001', 'NEWS0003', '2024-02-13 11:45:23', 'Đây là một bài đọc rất hấp dẫn!'),
('CMT000006', 'USR0002', 'NEWS0003', '2024-02-13 12:34:56', 'Tôi nghĩ AI sẽ thay đổi thế giới.'),
('CMT000007', 'USR0003', 'NEWS0004', '2024-02-12 16:45:12', 'Những hiểu biết tuyệt vời! Mong chờ thêm nhiều bài viết nữa.'),
('CMT000008', 'USR0004', 'NEWS0004', '2024-02-12 17:23:45', 'Chủ đề này rất phù hợp với thời điểm hiện tại.'),
('CMT000009', 'USR0001', 'NEWS0005', '2024-02-11 08:56:34', 'Tôi đánh giá cao độ sâu của bài viết này.'),
('CMT000010', 'USR0002', 'NEWS0005', '2024-02-11 09:12:45', 'Viết rất hay! Tôi đã thích đọc bài này.'),
('CMT000011', 'USR0003', 'NEWS0006', '2024-02-10 13:45:23', 'AI thật sự thú vị, làm tốt lắm!'),
('CMT000012', 'USR0004', 'NEWS0006', '2024-02-10 14:23:56', 'Tôi thích cách bạn giải thích chủ đề này.'),
('CMT000013', 'USR0001', 'NEWS0007', '2024-02-09 10:34:12', 'Bài viết này rất sáng tỏ.'),
('CMT000014', 'USR0002', 'NEWS0007', '2024-02-09 11:45:34', 'Tôi thấy điều này rất hữu ích, cảm ơn!'),
('CMT000015', 'USR0003', 'NEWS0008', '2024-12-08 15:23:45', 'Bài viết xuất sắc! Tiếp tục phát huy nhé.'),
('CMT000016', 'USR0004', 'NEWS0008', '2024-12-08 16:12:23', 'Tôi đã học được điều gì đó mới hôm nay.'),
('CMT000017', 'USR0001', 'NEWS0009', '2024-02-07 09:45:56', 'Đây là một bài đọc cần thiết cho mọi người!'),
('CMT000018', 'USR0002', 'NEWS0009', '2024-02-07 10:23:12', 'Tôi đánh giá cao nghiên cứu phía sau bài viết này.'),
('CMT000019', 'USR0003', 'NEWS0001', '2024-02-06 14:56:34', 'Rất rõ ràng và súc tích, cảm ơn bạn!'),
('CMT000020', 'USR0004', 'NEWS0002', '2024-02-06 15:34:45', 'Tôi không thể chờ đợi để xem điều gì tiếp theo trong loạt bài này.'),
('CMT000021', 'USR0005', 'NEWS0010', '2024-02-05 11:23:56', 'Một bài viết rất chi tiết và sâu sắc!'),
('CMT000022', 'USR0006', 'NEWS0011', '2024-02-05 12:45:23', 'Tôi rất thích cách tiếp cận của tác giả về vấn đề này.'),
('CMT000023', 'USR0007', 'NEWS0012', '2024-02-04 16:34:12', 'Thông tin rất bổ ích, giúp tôi hiểu rõ hơn về chủ đề.'),
('CMT000024', 'USR0008', 'NEWS0013', '2024-02-04 17:12:45', 'Góc nhìn thú vị và mới mẻ, rất đáng để suy ngẫm.'),
('CMT000025', 'USR0009', 'NEWS0014', '2024-12-03 09:45:34', 'Tôi hoàn toàn đồng tình với những điều được nêu ra.'),
('CMT000026', 'USR0010', 'NEWS0015', '2024-12-03 10:23:56', 'Bài viết này thực sự đã mở mang tầm nhìn cho tôi.'),
('CMT000027', 'USR0001', 'NEWS0016', '2024-12-02 13:56:23', 'Rất ấn tượng với độ chuyên sâu của bài nghiên cứu.'),
('CMT000028', 'USR0002', 'NEWS0017', '2024-02-02 14:34:45', 'Tôi đã học được nhiều điều mới mẻ từ bài viết này.'),
('CMT000029', 'USR0003', 'NEWS0018', '2024-02-01 10:12:56', 'Cách trình bày rõ ràng và dễ hiểu, tuyệt vời!'),
('CMT000030', 'USR0004', 'NEWS0019', '2024-02-01 11:45:23', 'Một góc nhìn rất thuyết phục và logic.'),
('CMT000031', 'USR0005', 'NEWS0020', '2024-01-31 15:23:45', 'Tôi rất cảm phục sự chuyên nghiệp của tác giả.'),
('CMT000032', 'USR0006', 'NEWS0021', '2024-01-31 16:12:34', 'Thông tin này thực sự rất hữu ích cho công việc của tôi.'),
('CMT000033', 'USR0007', 'NEWS0022', '2024-01-30 09:34:56', 'Một bài viết đáng để suy ngẫm và nghiên cứu sâu hơn.'),
('CMT000034', 'USR0008', 'NEWS0023', '2024-01-30 10:45:23', 'Tôi rất thích cách tiếp cận sáng tạo này.'),
('CMT000035', 'USR0009', 'NEWS0024', '2024-01-29 14:56:45', 'Thật sự là một nguồn thông tin chất lượng!'),
('CMT000036', 'USR0010', 'NEWS0025', '2024-01-29 15:34:12', 'Góc nhìn chuyên sâu và đầy tâm huyết.'),
('CMT000037', 'USR0001', 'NEWS0026', '2024-01-28 11:23:56', 'Bài viết này đã giúp tôi hiểu rõ hơn về vấn đề.'),
('CMT000038', 'USR0002', 'NEWS0027', '2024-01-28 12:45:34', 'Rất cảm ơn tác giả đã chia sẻ kiến thức chuyên môn.'),
('CMT000039', 'USR0003', 'NEWS0028', '2024-01-27 16:12:45', 'Một nghiên cứu rất có giá trị và ý nghĩa.'),
('CMT000040', 'USR0004', 'NEWS0029', '2024-01-27 17:34:23', 'Tôi rất ấn tượng với độ chi tiết của bài viết.'),
('CMT000041', 'USR0005', 'NEWS0030', '2024-01-26 09:45:56', 'Thông tin này thực sự rất cập nhật và hữu ích.'),
('CMT000042', 'USR0006', 'NEWS0031', '2024-01-26 10:23:34', 'Một góc nhìn rất mới mẻ và sáng tạo.'),
('CMT000043', 'USR0007', 'NEWS0032', '2024-01-25 14:56:12', 'Tôi đã học được rất nhiều từ bài viết này.'),
('CMT000044', 'USR0008', 'NEWS0033', '2024-01-25 15:34:45', 'Rất cảm ơn về những thông tin chuyên sâu.'),
('CMT000045', 'USR0009', 'NEWS0034', '2024-01-24 11:12:23', 'Một bài viết thực sự đáng để suy ngẫm.'),
('CMT000046', 'USR0010', 'NEWS0035', '2024-01-24 12:45:56', 'Tôi rất thích cách trình bày logic và rõ ràng.'),
('CMT000047', 'USR0001', 'NEWS0036', '2024-01-23 16:34:45', 'Thông tin này thực sự rất bổ ích cho tôi.'),
('CMT000048', 'USR0002', 'NEWS0037', '2024-01-23 17:12:34', 'Một nghiên cứu chuyên nghiệp và sâu sắc.'),
('CMT000049', 'USR0003', 'NEWS0038', '2024-01-22 09:56:23', 'Tôi rất ấn tượng với những phân tích chi tiết.'),
('CMT000050', 'USR0004', 'NEWS0039', '2024-01-22 10:34:56', 'Góc nhìn này thực sự rất thuyết phục.'),
('CMT000051', 'USR0005', 'NEWS0040', '2024-01-21 14:45:12', 'Một bài viết rất đáng để đọc và suy ngẫm.'),
('CMT000052', 'USR0006', 'NEWS0041', '2024-01-21 15:23:45', 'Tôi hoàn toàn đồng tình với những nhận định.'),
('CMT000053', 'USR0007', 'NEWS0042', '2024-01-20 11:34:56', 'Thông tin này giúp tôi mở rộng hiểu biết.'),
('CMT000054', 'USR0008', 'NEWS0043', '2024-01-20 12:12:34', 'Rất cảm ơn về những góc nhìn sâu sắc.'),
('CMT000055', 'USR0009', 'NEWS0044', '2024-01-19 16:45:23', 'Một bài viết thực sự chuyên nghiệp.'),
('CMT000056', 'USR0010', 'NEWS0045', '2024-01-19 17:23:56', 'Tôi rất trân trọng sự chân thực của tác giả.'),
('CMT000057', 'USR0001', 'NEWS0046', '2024-01-18 09:12:45', 'Thông tin này thực sự rất giá trị.'),
('CMT000058', 'USR0002', 'NEWS0047', '2024-01-18 10:34:12', 'Một nghiên cứu đầy tâm huyết và chuyên môn.'),
('CMT000059', 'USR0003', 'NEWS0048', '2024-01-17 14:56:34', 'Tôi rất ấn tượng với cách tiếp cận mới mẻ.'),
('CMT000060', 'USR0004', 'NEWS0049', '2024-01-17 15:45:23', 'Góc nhìn này thực sự rất sáng tạo.'),
('CMT000061', 'USR0005', 'NEWS0050', '2024-01-16 11:23:56', 'Một bài viết đáng để học hỏi và nghiên cứu.'),
('CMT000062', 'USR0006', 'NEWS0051', '2024-01-16 12:45:34', 'Tôi rất cảm phục sự chuyên nghiệp.'),
('CMT000063', 'USR0007', 'NEWS0052', '2024-01-15 16:12:45', 'Thông tin này giúp tôi hiểu sâu hơn.'),
('CMT000064', 'USR0008', 'NEWS0053', '2024-01-15 17:34:23', 'Rất cảm ơn về những phân tích sâu sắc.'),
('CMT000065', 'USR0009', 'NEWS0054', '2024-01-14 09:45:56', 'Một bài viết thực sự đáng để suy ngẫm.'),
('CMT000066', 'USR0010', 'NEWS0055', '2024-01-14 10:23:34', 'Tôi rất thích cách trình bày khoa học.'),
('CMT000067', 'USR0001', 'NEWS0056', '2024-12-01 10:00:00', 'Thông tin này thực sự rất bổ ích.'),
('CMT000068', 'USR0002', 'NEWS0057', '2024-12-01 10:05:00', 'Một nghiên cứu với độ chi tiết ấn tượng.'),
('CMT000069', 'USR0003', 'NEWS0058', '2024-12-01 10:10:00', 'Tôi rất ấn tượng với những nhận định.'),
('CMT000070', 'USR0004', 'NEWS0059', '2024-12-01 10:15:00', 'Góc nhìn này thực sự rất thuyết phục.'),
('CMT000071', 'USR0005', 'NEWS0060', '2024-12-01 10:20:00', 'Một bài viết rất chuyên nghiệp và sâu sắc.'),
('CMT000072', 'USR0006', 'NEWS0061', '2024-12-01 10:25:00', 'Tôi hoàn toàn đồng tình với những phân tích.'),
('CMT000073', 'USR0007', 'NEWS0062', '2024-12-01 10:30:00', 'Thông tin này giúp tôi mở rộng tầm nhìn.'),
('CMT000074', 'USR0008', 'NEWS0063', '2024-12-01 10:35:00', 'Rất cảm ơn về những góc nhìn sáng tạo.'),
('CMT000075', 'USR0009', 'NEWS0064', '2024-12-01 10:40:00', 'Một bài viết thực sự đáng để nghiên cứu.'),
('CMT000076', 'USR0010', 'NEWS0001', '2024-12-01 10:45:00', 'Tôi rất trân trọng sự chân thực và logic.'),
('CMT000077', 'USR0001', 'NEWS0002', '2024-12-01 10:50:00', 'Thông tin này thực sự rất giá trị.'),
('CMT000078', 'USR0002', 'NEWS0003', '2024-12-01 10:55:00', 'Một nghiên cứu đầy tâm huyết và chuyên môn.'),
('CMT000079', 'USR0003', 'NEWS0004', '2024-12-01 11:00:00', 'Tôi rất ấn tượng với cách tiếp cận mới mẻ.'),
('CMT000080', 'USR0004', 'NEWS0005', '2024-12-01 11:05:00', 'Góc nhìn này thực sự rất sáng tạo.'),
('CMT000081', 'USR0005', 'NEWS0006', '2024-12-01 11:10:00', 'Một bài viết đáng để học hỏi và suy ngẫm.'),
('CMT000082', 'USR0006', 'NEWS0007', '2024-12-01 11:15:00', 'Tôi rất cảm phục sự chuyên nghiệp.'),
('CMT000083', 'USR0007', 'NEWS0008', '2024-12-01 11:20:00', 'Thông tin này giúp tôi hiểu sâu hơn.'),
('CMT000084', 'USR0008', 'NEWS0009', '2024-12-01 11:25:00', 'Rất cảm ơn về những phân tích sâu sắc.'),
('CMT000085', 'USR0009', 'NEWS0010', '2024-12-01 11:30:00', 'Một bài viết thực sự đáng để suy ngẫm.'),
('CMT000086', 'USR0010', 'NEWS0011', '2024-12-01 11:35:00', 'Tôi rất thích cách trình bày khoa học.'),
('CMT000087', 'USR0001', 'NEWS0012', '2024-12-01 11:40:00', 'Thông tin này thực sự rất bổ ích.'),
('CMT000088', 'USR0002', 'NEWS0013', '2024-12-01 11:45:00', 'Một nghiên cứu với độ chi tiết ấn tượng.'),
('CMT000089', 'USR0003', 'NEWS0014', '2024-12-01 11:50:00', 'Tôi rất ấn tượng với những nhận định.'),
('CMT000090', 'USR0004', 'NEWS0015', '2024-11-01 11:55:00', 'Góc nhìn này thực sự rất thuyết phục.'),
('CMT000091', 'USR0005', 'NEWS0016', '2024-11-01 12:00:00', 'Một bài viết rất chuyên nghiệp và sâu sắc.'),
('CMT000092', 'USR0006', 'NEWS0017', '2024-11-01 12:05:00', 'Tôi hoàn toàn đồng tình với những phân tích.'),
('CMT000093', 'USR0007', 'NEWS0018', '2024-11-01 12:10:00', 'Thông tin này giúp tôi mở rộng tầm nhìn.'),
('CMT000094', 'USR0008', 'NEWS0019', '2024-11-01 12:15:00', 'Rất cảm ơn về những góc nhìn sáng tạo.'),
('CMT000095', 'USR0009', 'NEWS0020', '2024-11-01 12:20:00', 'Một bài viết thực sự đáng để nghiên cứu.'),
('CMT000096', 'USR0010', 'NEWS0021', '2024-11-01 12:25:00', 'Tôi rất trân trọng sự chân thực và logic.'),
('CMT000097', 'USR0001', 'NEWS0022', '2024-11-01 12:30:00', 'Thông tin này thực sự rất giá trị.'),
('CMT000098', 'USR0002', 'NEWS0023', '2024-11-01 12:35:00', 'Một nghiên cứu đầy tâm huyết và chuyên môn.'),
('CMT000099', 'USR0003', 'NEWS0024', '2024-11-01 12:40:00', 'Tôi rất ấn tượng với cách tiếp cận mới mẻ.'),
('CMT000100', 'USR0004', 'NEWS0025', '2024-11-01 12:45:00', 'Góc nhìn này thực sự rất sáng tạo.');

-- Insert values into Editor_Check_News
INSERT INTO Editor_Check_News (Id_Editor, Id_News, Reason, Date_feedback) 
VALUES 
('EDT0001', 'NEWS0001', 'Needs revision on formatting.', '2024-11-10'),
('EDT0001', 'NEWS0002', 'Needs more references.', '2024-11-12'),
('EDT0001', 'NEWS0003', 'Add more examples for clarity.', '2024-11-15'),
('EDT0002', 'NEWS0004', 'Check fofr spelling errors.', '2024-11-20'),
('EDT0003', 'NEWS0004', 'Chefck ', '2024-11-20'),
('EDT0004', 'NEWS0004', 'Chesck ', '2024-11-20');

-- Insert values into News_Tag
INSERT INTO News_Tag (Id_News, Id_Tag) VALUES

-- NEWS0001 (7 tags)
('NEWS0001', 'TAG0001'), -- #Chính trị
('NEWS0001', 'TAG0007'), -- #Thời sự
('NEWS0001', 'TAG0018'), -- #Quốc tế
('NEWS0001', 'TAG0039'), -- #An ninh
('NEWS0001', 'TAG0040'), -- #Quốc phòng
('NEWS0001', 'TAG0042'), -- #Ngoại giao
('NEWS0001', 'TAG0043'), -- #Hợp tác

-- NEWS0002 (6 tags)
('NEWS0002', 'TAG0002'), -- #Kinh tế
('NEWS0002', 'TAG0017'), -- #Kinh doanh
('NEWS0002', 'TAG0029'), -- #Bất động sản
('NEWS0002', 'TAG0030'), -- #Tài chính
('NEWS0002', 'TAG0031'), -- #Chứng khoán
('NEWS0002', 'TAG0045'), -- #Đầu tư

-- NEWS0003 (8 tags)
('NEWS0003', 'TAG0003'), -- #Thể thao
('NEWS0003', 'TAG0006'), -- #Bóng đá
('NEWS0003', 'TAG0089'), -- #Sống khỏe
('NEWS0003', 'TAG0090'), -- #Thể hình
('NEWS0003', 'TAG0091'), -- #Dinh dưỡng
('NEWS0003', 'TAG0094'), -- #Phát triển bản thân
('NEWS0003', 'TAG0099'), -- #Cân bằng cuộc sống
('NEWS0003', 'TAG0142'), -- #Phong cách sống

-- NEWS0004 (5 tags)
('NEWS0004', 'TAG0004'), -- #Giáo dục
('NEWS0004', 'TAG0114'), -- #Học trực tuyến
('NEWS0004', 'TAG0119'), -- #Giáo dục đại học
('NEWS0004', 'TAG0123'), -- #Công nghệ giáo dục
('NEWS0004', 'TAG0130'), -- #Chính sách giáo dục

-- NEWS0005 (9 tags)
('NEWS0005', 'TAG0005'), -- #Công nghệ
('NEWS0005', 'TAG0051'), -- #Trí tuệ nhân tạo
('NEWS0005', 'TAG0052'), -- #Học máy
('NEWS0005', 'TAG0054'), -- #Internet vạn vật
('NEWS0005', 'TAG0055'), -- #Điện toán đám mây
('NEWS0005', 'TAG0056'), -- #An ninh mạng
('NEWS0005', 'TAG0057'), -- #Dữ liệu lớn
('NEWS0005', 'TAG0063'), -- #Ứng dụng di động
('NEWS0005', 'TAG0064'), -- #Phát triển web

-- NEWS0006 (7 tags)
('NEWS0006', 'TAG0008'), -- #Du lịch
('NEWS0006', 'TAG0024'), -- #Ẩm thực
('NEWS0006', 'TAG0144'), -- #Du lịch khám phá
('NEWS0006', 'TAG0145'), -- #Ẩm thực vùng miền
('NEWS0006', 'TAG0146'), -- #Văn hóa dân tộc
('NEWS0006', 'TAG0147'), -- #Lễ hội truyền thống
('NEWS0006', 'TAG0148'), -- #Di sản văn hóa

-- NEWS0007 (6 tags)
('NEWS0007', 'TAG0009'), -- #Văn hóa
('NEWS0007', 'TAG0019'), -- #Nghệ thuật
('NEWS0007', 'TAG0146'), -- #Văn hóa dân tộc
('NEWS0007', 'TAG0148'), -- #Di sản văn hóa
('NEWS0007', 'TAG0149'), -- #Nghệ thuật dân gian
('NEWS0007', 'TAG0150'), -- #Làng nghề truyền thống

-- NEWS0008 (8 tags)
('NEWS0008', 'TAG0010'), -- #Giải trí
('NEWS0008', 'TAG0020'), -- #Âm nhạc
('NEWS0008', 'TAG0021'), -- #Điện ảnh
('NEWS0008', 'TAG0022'), -- #Game
('NEWS0008', 'TAG0023'), -- #Sách
('NEWS0008', 'TAG0025'), -- #Thời trang
('NEWS0008', 'TAG0142'), -- #Phong cách sống
('NEWS0008', 'TAG0143'), -- #Sở thích

-- NEWS0009 (7 tags)
('NEWS0009', 'TAG0011'), -- #Khoa học
('NEWS0009', 'TAG0051'), -- #Trí tuệ nhân tạo
('NEWS0009', 'TAG0052'), -- #Học máy
('NEWS0009', 'TAG0053'), -- #Người máy
('NEWS0009', 'TAG0066'), -- #Khoa học dữ liệu
('NEWS0009', 'TAG0067'), -- #Thực tế ảo
('NEWS0009', 'TAG0068'), -- #Thực tế tăng cường

-- NEWS0010 (6 tags)
('NEWS0010', 'TAG0012'), -- #Y tế
('NEWS0010', 'TAG0086'), -- #Công nghệ y tế
('NEWS0010', 'TAG0087'), -- #Khám bệnh từ xa
('NEWS0010', 'TAG0088'), -- #Sức khỏe tâm thần
('NEWS0010', 'TAG0091'), -- #Dinh dưỡng
('NEWS0010', 'TAG0092'),  -- #Y học cổ truyền

('NEWS0011', 'TAG0013'), -- #Môi trường
('NEWS0011', 'TAG0075'), -- #Biến đổi khí hậu
('NEWS0011', 'TAG0076'), -- #Phát triển bền vững
('NEWS0011', 'TAG0077'), -- #Công nghệ xanh
('NEWS0011', 'TAG0078'), -- #Quản lý rác thải
('NEWS0011', 'TAG0079'), -- #Tái chế
('NEWS0011', 'TAG0080'), -- #Đa dạng sinh học
('NEWS0011', 'TAG0081'), -- #Bảo tồn đại dương

-- NEWS0012 (7 tags)
('NEWS0012', 'TAG0014'), -- #Xã hội
('NEWS0012', 'TAG0016'), -- #Đời sống
('NEWS0012', 'TAG0138'), -- #Đời sống gia đình
('NEWS0012', 'TAG0139'), -- #Quan hệ xã hội
('NEWS0012', 'TAG0140'), -- #Hôn nhân
('NEWS0012', 'TAG0141'), -- #Hẹn hò
('NEWS0012', 'TAG0142'), -- #Phong cách sống

-- NEWS0013 (6 tags)
('NEWS0013', 'TAG0015'), -- #Pháp luật
('NEWS0013', 'TAG0039'), -- #An ninh
('NEWS0013', 'TAG0040'), -- #Quốc phòng
('NEWS0013', 'TAG0056'), -- #An ninh mạng
('NEWS0013', 'TAG0107'), -- #Quản lý rủi ro
('NEWS0013', 'TAG0001'), -- #Chính trị

-- NEWS0014 (8 tags)
('NEWS0014', 'TAG0017'), -- #Kinh doanh
('NEWS0014', 'TAG0045'), -- #Đầu tư
('NEWS0014', 'TAG0046'), -- #Thương mại
('NEWS0014', 'TAG0059'), -- #Công nghệ tài chính
('NEWS0014', 'TAG0060'), -- #Thương mại điện tử
('NEWS0014', 'TAG0110'), -- #Nghiên cứu thị trường
('NEWS0014', 'TAG0111'), -- #Quản lý thương hiệu
('NEWS0014', 'TAG0113'), -- #Chiến lược bán hàng
('NEWS0014', 'TAG0018'), -- #Quốc tế
('NEWS0014', 'TAG0001'), -- #Chính trị
('NEWS0014', 'TAG0042'), -- #Ngoại giao
('NEWS0014', 'TAG0043'), -- #Hợp tác
('NEWS0014', 'TAG0007'), -- #Thời sự
('NEWS0014', 'TAG0039'), -- #An ninh
('NEWS0014', 'TAG0040'), -- #Quốc phòng
('NEWS0014', 'TAG0041'), -- #Biển đảo
('NEWS0014', 'TAG0076'), -- #Phát triển bền vững


-- NEWS0015 (9 tags)
('NEWS0015', 'TAG0018'), -- #Quốc tế
('NEWS0015', 'TAG0001'), -- #Chính trị
('NEWS0015', 'TAG0042'), -- #Ngoại giao
('NEWS0015', 'TAG0043'), -- #Hợp tác
('NEWS0015', 'TAG0007'), -- #Thời sự
('NEWS0015', 'TAG0039'), -- #An ninh
('NEWS0015', 'TAG0040'), -- #Quốc phòng
('NEWS0015', 'TAG0041'), -- #Biển đảo
('NEWS0015', 'TAG0076'), -- #Phát triển bền vững

-- NEWS0016 (5 tags)
('NEWS0016', 'TAG0019'), -- #Nghệ thuật
('NEWS0016', 'TAG0020'), -- #Âm nhạc
('NEWS0016', 'TAG0021'), -- #Điện ảnh
('NEWS0016', 'TAG0149'), -- #Nghệ thuật dân gian
('NEWS0016', 'TAG0009'), -- #Văn hóa

-- NEWS0017 (7 tags)
('NEWS0017', 'TAG0022'), -- #Game
('NEWS0017', 'TAG0005'), -- #Công nghệ
('NEWS0017', 'TAG0063'), -- #Ứng dụng di động
('NEWS0017', 'TAG0067'), -- #Thực tế ảo
('NEWS0017', 'TAG0068'), -- #Thực tế tăng cường
('NEWS0017', 'TAG0143'), -- #Sở thích
('NEWS0017', 'TAG0010'), -- #Giải trí

-- NEWS0018 (6 tags)
('NEWS0018', 'TAG0023'), -- #Sách
('NEWS0018', 'TAG0094'), -- #Phát triển bản thân
('NEWS0018', 'TAG0125'), -- #Kỹ năng học tập
('NEWS0018', 'TAG0004'), -- #Giáo dục
('NEWS0018', 'TAG0019'), -- #Nghệ thuật
('NEWS0018', 'TAG0009'), -- #Văn hóa

-- NEWS0019 (8 tags)
('NEWS0019', 'TAG0024'), -- #Ẩm thực
('NEWS0019', 'TAG0145'), -- #Ẩm thực vùng miền
('NEWS0019', 'TAG0008'), -- #Du lịch
('NEWS0019', 'TAG0144'), -- #Du lịch khám phá
('NEWS0019', 'TAG0146'), -- #Văn hóa dân tộc
('NEWS0019', 'TAG0147'), -- #Lễ hội truyền thống
('NEWS0019', 'TAG0009'), -- #Văn hóa
('NEWS0019', 'TAG0142'), -- #Phong cách sống

-- NEWS0020 (7 tags)
('NEWS0020', 'TAG0025'), -- #Thời trang
('NEWS0020', 'TAG0142'), -- #Phong cách sống
('NEWS0020', 'TAG0010'), -- #Giải trí
('NEWS0020', 'TAG0019'), -- #Nghệ thuật
('NEWS0020', 'TAG0111'), -- #Quản lý thương hiệu
('NEWS0020', 'TAG0112'), -- #Trải nghiệm khách hàng
('NEWS0020', 'TAG0060'),  -- #Thương mại điện tử

-- NEWS0021 (6 tags)
('NEWS0021', 'TAG0026'), -- #Công nghiệp
('NEWS0021', 'TAG0077'), -- #Công nghệ xanh
('NEWS0021', 'TAG0076'), -- #Phát triển bền vững
('NEWS0021', 'TAG0108'), -- #Chuỗi cung ứng
('NEWS0021', 'TAG0109'), -- #Vận tải logistics
('NEWS0021', 'TAG0002'), -- #Kinh tế

-- NEWS0022 (8 tags)
('NEWS0022', 'TAG0027'), -- #Nông nghiệp
('NEWS0022', 'TAG0083'), -- #Nông nghiệp hữu cơ
('NEWS0022', 'TAG0084'), -- #Nông nghiệp thông minh
('NEWS0022', 'TAG0085'), -- #An ninh lương thực
('NEWS0022', 'TAG0076'), -- #Phát triển bền vững
('NEWS0022', 'TAG0013'), -- #Môi trường
('NEWS0022', 'TAG0054'), -- #Internet vạn vật
('NEWS0022', 'TAG0002'), -- #Kinh tế

-- NEWS0023 (7 tags)
('NEWS0023', 'TAG0028'), -- #Giao thông
('NEWS0023', 'TAG0074'), -- #Xe điện
('NEWS0023', 'TAG0070'), -- #Thành phố thông minh
('NEWS0023', 'TAG0077'), -- #Công nghệ xanh
('NEWS0023', 'TAG0013'), -- #Môi trường
('NEWS0023', 'TAG0075'), -- #Biến đổi khí hậu
('NEWS0023', 'TAG0005'), -- #Công nghệ

-- NEWS0024 (9 tags)
('NEWS0024', 'TAG0029'), -- #Bất động sản
('NEWS0024', 'TAG0045'), -- #Đầu tư
('NEWS0024', 'TAG0002'), -- #Kinh tế
('NEWS0024', 'TAG0017'), -- #Kinh doanh
('NEWS0024', 'TAG0030'), -- #Tài chính
('NEWS0024', 'TAG0070'), -- #Thành phố thông minh
('NEWS0024', 'TAG0076'), -- #Phát triển bền vững
('NEWS0024', 'TAG0110'), -- #Nghiên cứu thị trường
('NEWS0024', 'TAG0107'), -- #Quản lý rủi ro

-- NEWS0025 (6 tags)
('NEWS0025', 'TAG0030'), -- #Tài chính
('NEWS0025', 'TAG0031'), -- #Chứng khoán
('NEWS0025', 'TAG0032'), -- #Tiền tệ
('NEWS0025', 'TAG0059'), -- #Công nghệ tài chính
('NEWS0025', 'TAG0069'), -- #Tiền điện tử
('NEWS0025', 'TAG0002'), -- #Kinh tế

-- NEWS0026 (7 tags)
('NEWS0026', 'TAG0033'), -- #Xuất nhập khẩu
('NEWS0026', 'TAG0046'), -- #Thương mại
('NEWS0026', 'TAG0108'), -- #Chuỗi cung ứng
('NEWS0026', 'TAG0109'), -- #Vận tải logistics
('NEWS0026', 'TAG0002'), -- #Kinh tế
('NEWS0026', 'TAG0017'), -- #Kinh doanh
('NEWS0026', 'TAG0018'), -- #Quốc tế

-- NEWS0027 (8 tags)
('NEWS0027', 'TAG0034'), -- #Lao động
('NEWS0027', 'TAG0035'), -- #Việc làm
('NEWS0027', 'TAG0098'), -- #Làm việc từ xa
('NEWS0027', 'TAG0099'), -- #Cân bằng cuộc sống
('NEWS0027', 'TAG0100'), -- #Phát triển nghề nghiệp
('NEWS0027', 'TAG0101'), -- #Kỹ năng chuyên môn
('NEWS0027', 'TAG0102'), -- #Kỹ năng mềm
('NEWS0027', 'TAG0014'), -- #Xã hội

-- NEWS0028 (5 tags)
('NEWS0028', 'TAG0036'), -- #Khởi nghiệp
('NEWS0028', 'TAG0058'), -- #Khởi nghiệp sáng tạo
('NEWS0028', 'TAG0037'), -- #Đổi mới
('NEWS0028', 'TAG0038'), -- #Sáng tạo
('NEWS0028', 'TAG0017'), -- #Kinh doanh

-- NEWS0029 (7 tags)
('NEWS0029', 'TAG0039'), -- #An ninh
('NEWS0029', 'TAG0040'), -- #Quốc phòng
('NEWS0029', 'TAG0056'), -- #An ninh mạng
('NEWS0029', 'TAG0001'), -- #Chính trị
('NEWS0029', 'TAG0007'), -- #Thời sự
('NEWS0029', 'TAG0018'), -- #Quốc tế
('NEWS0029', 'TAG0041'), -- #Biển đảo

-- NEWS0030 (6 tags)
('NEWS0030', 'TAG0042'), -- #Ngoại giao
('NEWS0030', 'TAG0043'), -- #Hợp tác
('NEWS0030', 'TAG0001'), -- #Chính trị
('NEWS0030', 'TAG0018'), -- #Quốc tế
('NEWS0030', 'TAG0007'), -- #Thời sự
('NEWS0030', 'TAG0076'),  -- #Phát triển bền vững

-- NEWS0031 (7 tags)
('NEWS0031', 'TAG0044'), -- #Phát triển
('NEWS0031', 'TAG0076'), -- #Phát triển bền vững
('NEWS0031', 'TAG0070'), -- #Thành phố thông minh
('NEWS0031', 'TAG0077'), -- #Công nghệ xanh
('NEWS0031', 'TAG0005'), -- #Công nghệ
('NEWS0031', 'TAG0002'), -- #Kinh tế
('NEWS0031', 'TAG0017'), -- #Kinh doanh

-- NEWS0032 (8 tags)
('NEWS0032', 'TAG0045'), -- #Đầu tư
('NEWS0032', 'TAG0030'), -- #Tài chính
('NEWS0032', 'TAG0031'), -- #Chứng khoán
('NEWS0032', 'TAG0059'), -- #Công nghệ tài chính
('NEWS0032', 'TAG0069'), -- #Tiền điện tử
('NEWS0032', 'TAG0002'), -- #Kinh tế
('NEWS0032', 'TAG0017'), -- #Kinh doanh
('NEWS0032', 'TAG0107'), -- #Quản lý rủi ro

-- NEWS0033 (6 tags)
('NEWS0033', 'TAG0046'), -- #Thương mại
('NEWS0033', 'TAG0060'), -- #Thương mại điện tử
('NEWS0033', 'TAG0061'), -- #Tiếp thị số
('NEWS0033', 'TAG0111'), -- #Quản lý thương hiệu
('NEWS0033', 'TAG0112'), -- #Trải nghiệm khách hàng
('NEWS0033', 'TAG0113'), -- #Chiến lược bán hàng

-- NEWS0034 (9 tags)
('NEWS0034', 'TAG0047'), -- #Dịch vụ
('NEWS0034', 'TAG0112'), -- #Trải nghiệm khách hàng
('NEWS0034', 'TAG0113'), -- #Chiến lược bán hàng
('NEWS0034', 'TAG0102'), -- #Kỹ năng mềm
('NEWS0034', 'TAG0103'), -- #Giao tiếp
('NEWS0034', 'TAG0104'), -- #Xây dựng đội nhóm
('NEWS0034', 'TAG0096'), -- #Quản lý
('NEWS0034', 'TAG0017'), -- #Kinh doanh
('NEWS0034', 'TAG0110'), -- #Nghiên cứu thị trường

-- NEWS0035 (7 tags)
('NEWS0035', 'TAG0048'), -- #Truyền thông
('NEWS0035', 'TAG0049'), -- #Báo chí
('NEWS0035', 'TAG0050'), -- #Mạng xã hội
('NEWS0035', 'TAG0061'), -- #Tiếp thị số
('NEWS0035', 'TAG0062'), -- #Tối ưu công cụ tìm kiếm
('NEWS0035', 'TAG0111'), -- #Quản lý thương hiệu
('NEWS0035', 'TAG0007'), -- #Thời sự

-- NEWS0036 (8 tags)
('NEWS0036', 'TAG0051'), -- #Trí tuệ nhân tạo
('NEWS0036', 'TAG0052'), -- #Học máy
('NEWS0036', 'TAG0053'), -- #Người máy
('NEWS0036', 'TAG0054'), -- #Internet vạn vật
('NEWS0036', 'TAG0005'), -- #Công nghệ
('NEWS0036', 'TAG0066'), -- #Khoa học dữ liệu
('NEWS0036', 'TAG0011'), -- #Khoa học
('NEWS0036', 'TAG0037'), -- #Đổi mới

-- NEWS0037 (5 tags)
('NEWS0037', 'TAG0055'), -- #Điện toán đám mây
('NEWS0037', 'TAG0056'), -- #An ninh mạng
('NEWS0037', 'TAG0057'), -- #Dữ liệu lớn
('NEWS0037', 'TAG0005'), -- #Công nghệ
('NEWS0037', 'TAG0011'), -- #Khoa học

-- NEWS0038 (7 tags)
('NEWS0038', 'TAG0058'), -- #Khởi nghiệp sáng tạo
('NEWS0038', 'TAG0036'), -- #Khởi nghiệp
('NEWS0038', 'TAG0037'), -- #Đổi mới
('NEWS0038', 'TAG0038'), -- #Sáng tạo
('NEWS0038', 'TAG0017'), -- #Kinh doanh
('NEWS0038', 'TAG0094'), -- #Phát triển bản thân
('NEWS0038', 'TAG0100'), -- #Phát triển nghề nghiệp

-- NEWS0039 (6 tags)
('NEWS0039', 'TAG0059'), -- #Công nghệ tài chính
('NEWS0039', 'TAG0069'), -- #Tiền điện tử
('NEWS0039', 'TAG0030'), -- #Tài chính
('NEWS0039', 'TAG0002'), -- #Kinh tế
('NEWS0039', 'TAG0005'), -- #Công nghệ
('NEWS0039', 'TAG0017'), -- #Kinh doanh

-- NEWS0040 (8 tags)
('NEWS0040', 'TAG0060'), -- #Thương mại điện tử
('NEWS0040', 'TAG0061'), -- #Tiếp thị số
('NEWS0040', 'TAG0062'), -- #Tối ưu công cụ tìm kiếm
('NEWS0040', 'TAG0112'), -- #Trải nghiệm khách hàng
('NEWS0040', 'TAG0113'), -- #Chiến lược bán hàng
('NEWS0040', 'TAG0017'), -- #Kinh doanh
('NEWS0040', 'TAG0005'), -- #Công nghệ
('NEWS0040', 'TAG0110'),  -- #Nghiên cứu thị trường

-- NEWS0041 (7 tags)
('NEWS0041', 'TAG0063'), -- #Ứng dụng di động
('NEWS0041', 'TAG0064'), -- #Phát triển web
('NEWS0041', 'TAG0065'), -- #Thiết kế trải nghiệm
('NEWS0041', 'TAG0005'), -- #Công nghệ
('NEWS0041', 'TAG0112'), -- #Trải nghiệm khách hàng
('NEWS0041', 'TAG0037'), -- #Đổi mới
('NEWS0041', 'TAG0038'), -- #Sáng tạo

-- NEWS0042 (6 tags)
('NEWS0042', 'TAG0066'), -- #Khoa học dữ liệu
('NEWS0042', 'TAG0057'), -- #Dữ liệu lớn
('NEWS0042', 'TAG0051'), -- #Trí tuệ nhân tạo
('NEWS0042', 'TAG0052'), -- #Học máy
('NEWS0042', 'TAG0005'), -- #Công nghệ
('NEWS0042', 'TAG0011'), -- #Khoa học

-- NEWS0043 (8 tags)
('NEWS0043', 'TAG0067'), -- #Thực tế ảo
('NEWS0043', 'TAG0068'), -- #Thực tế tăng cường
('NEWS0043', 'TAG0022'), -- #Game
('NEWS0043', 'TAG0005'), -- #Công nghệ
('NEWS0043', 'TAG0010'), -- #Giải trí
('NEWS0043', 'TAG0065'), -- #Thiết kế trải nghiệm
('NEWS0043', 'TAG0037'), -- #Đổi mới
('NEWS0043', 'TAG0038'), -- #Sáng tạo

-- NEWS0044 (9 tags)
('NEWS0044', 'TAG0071'), -- #Năng lượng tái tạo
('NEWS0044', 'TAG0072'), -- #Năng lượng mặt trời
('NEWS0044', 'TAG0073'), -- #Năng lượng gió
('NEWS0044', 'TAG0074'), -- #Xe điện
('NEWS0044', 'TAG0075'), -- #Biến đổi khí hậu
('NEWS0044', 'TAG0076'), -- #Phát triển bền vững
('NEWS0044', 'TAG0077'), -- #Công nghệ xanh
('NEWS0044', 'TAG0013'), -- #Môi trường
('NEWS0044', 'TAG0005'), -- #Công nghệ

-- NEWS0045 (7 tags)
('NEWS0045', 'TAG0078'), -- #Quản lý rác thải
('NEWS0045', 'TAG0079'), -- #Tái chế
('NEWS0045', 'TAG0013'), -- #Môi trường
('NEWS0045', 'TAG0075'), -- #Biến đổi khí hậu
('NEWS0045', 'TAG0076'), -- #Phát triển bền vững
('NEWS0045', 'TAG0077'), -- #Công nghệ xanh
('NEWS0045', 'TAG0070'), -- #Thành phố thông minh

-- NEWS0046 (6 tags)
('NEWS0046', 'TAG0080'), -- #Đa dạng sinh học
('NEWS0046', 'TAG0081'), -- #Bảo tồn đại dương
('NEWS0046', 'TAG0082'), -- #Bảo vệ động vật hoang dã
('NEWS0046', 'TAG0013'), -- #Môi trường
('NEWS0046', 'TAG0075'), -- #Biến đổi khí hậu
('NEWS0046', 'TAG0076'), -- #Phát triển bền vững

-- NEWS0047 (8 tags)
('NEWS0047', 'TAG0083'), -- #Nông nghiệp hữu cơ
('NEWS0047', 'TAG0084'), -- #Nông nghiệp thông minh
('NEWS0047', 'TAG0085'), -- #An ninh lương thực
('NEWS0047', 'TAG0027'), -- #Nông nghiệp
('NEWS0047', 'TAG0013'), -- #Môi trường
('NEWS0047', 'TAG0076'), -- #Phát triển bền vững
('NEWS0047', 'TAG0054'), -- #Internet vạn vật
('NEWS0047', 'TAG0005'), -- #Công nghệ

-- NEWS0048 (7 tags)
('NEWS0048', 'TAG0086'), -- #Công nghệ y tế
('NEWS0048', 'TAG0087'), -- #Khám bệnh từ xa
('NEWS0048', 'TAG0088'), -- #Sức khỏe tâm thần
('NEWS0048', 'TAG0012'), -- #Y tế
('NEWS0048', 'TAG0005'), -- #Công nghệ
('NEWS0048', 'TAG0051'), -- #Trí tuệ nhân tạo
('NEWS0048', 'TAG0054'), -- #Internet vạn vật

-- NEWS0049 (5 tags)
('NEWS0049', 'TAG0089'), -- #Sống khỏe
('NEWS0049', 'TAG0090'), -- #Thể hình
('NEWS0049', 'TAG0091'), -- #Dinh dưỡng
('NEWS0049', 'TAG0012'), -- #Y tế
('NEWS0049', 'TAG0016'), -- #Đời sống

-- NEWS0050 (6 tags)
('NEWS0050', 'TAG0092'), -- #Y học cổ truyền
('NEWS0050', 'TAG0093'), -- #Thiền định
('NEWS0050', 'TAG0089'), -- #Sống khỏe
('NEWS0050', 'TAG0091'), -- #Dinh dưỡng
('NEWS0050', 'TAG0012'), -- #Y tế
('NEWS0050', 'TAG0016'),  -- #Đời sống

-- NEWS0051 (8 tags)
('NEWS0051', 'TAG0094'), -- #Phát triển bản thân
('NEWS0051', 'TAG0095'), -- #Lãnh đạo
('NEWS0051', 'TAG0096'), -- #Quản lý
('NEWS0051', 'TAG0102'), -- #Kỹ năng mềm
('NEWS0051', 'TAG0103'), -- #Giao tiếp
('NEWS0051', 'TAG0104'), -- #Xây dựng đội nhóm
('NEWS0051', 'TAG0100'), -- #Phát triển nghề nghiệp
('NEWS0051', 'TAG0016'), -- #Đời sống

-- NEWS0052 (7 tags)
('NEWS0052', 'TAG0097'), -- #Nhân sự
('NEWS0052', 'TAG0098'), -- #Làm việc từ xa
('NEWS0052', 'TAG0099'), -- #Cân bằng cuộc sống
('NEWS0052', 'TAG0034'), -- #Lao động
('NEWS0052', 'TAG0035'), -- #Việc làm
('NEWS0052', 'TAG0100'), -- #Phát triển nghề nghiệp
('NEWS0052', 'TAG0014'), -- #Xã hội

-- NEWS0053 (9 tags)
('NEWS0053', 'TAG0105'), -- #Quản lý dự án
('NEWS0053', 'TAG0106'), -- #Quản lý chất lượng
('NEWS0053', 'TAG0107'), -- #Quản lý rủi ro
('NEWS0053', 'TAG0095'), -- #Lãnh đạo
('NEWS0053', 'TAG0096'), -- #Quản lý
('NEWS0053', 'TAG0102'), -- #Kỹ năng mềm
('NEWS0053', 'TAG0103'), -- #Giao tiếp
('NEWS0053', 'TAG0104'), -- #Xây dựng đội nhóm
('NEWS0053', 'TAG0017'), -- #Kinh doanh

-- NEWS0054 (6 tags)
('NEWS0054', 'TAG0108'), -- #Chuỗi cung ứng
('NEWS0054', 'TAG0109'), -- #Vận tải logistics
('NEWS0054', 'TAG0033'), -- #Xuất nhập khẩu
('NEWS0054', 'TAG0046'), -- #Thương mại
('NEWS0054', 'TAG0002'), -- #Kinh tế
('NEWS0054', 'TAG0017'), -- #Kinh doanh

-- NEWS0055 (7 tags)
('NEWS0055', 'TAG0110'), -- #Nghiên cứu thị trường
('NEWS0055', 'TAG0111'), -- #Quản lý thương hiệu
('NEWS0055', 'TAG0112'), -- #Trải nghiệm khách hàng
('NEWS0055', 'TAG0113'), -- #Chiến lược bán hàng
('NEWS0055', 'TAG0017'), -- #Kinh doanh
('NEWS0055', 'TAG0061'), -- #Tiếp thị số
('NEWS0055', 'TAG0060'), -- #Thương mại điện tử

-- NEWS0056 (8 tags)
('NEWS0056', 'TAG0114'), -- #Học trực tuyến
('NEWS0056', 'TAG0115'), -- #Giáo dục từ xa
('NEWS0056', 'TAG0123'), -- #Công nghệ giáo dục
('NEWS0056', 'TAG0004'), -- #Giáo dục
('NEWS0056', 'TAG0005'), -- #Công nghệ
('NEWS0056', 'TAG0125'), -- #Kỹ năng học tập
('NEWS0056', 'TAG0132'), -- #Phương pháp giảng dạy
('NEWS0056', 'TAG0133'), -- #Đánh giá giáo dục

-- NEWS0057 (6 tags)
('NEWS0057', 'TAG0116'), -- #Giáo dục STEM
('NEWS0057', 'TAG0004'), -- #Giáo dục
('NEWS0057', 'TAG0005'), -- #Công nghệ
('NEWS0057', 'TAG0011'), -- #Khoa học
('NEWS0057', 'TAG0123'), -- #Công nghệ giáo dục
('NEWS0057', 'TAG0130'), -- #Chính sách giáo dục

-- NEWS0058 (7 tags)
('NEWS0058', 'TAG0117'), -- #Học ngoại ngữ
('NEWS0058', 'TAG0004'), -- #Giáo dục
('NEWS0058', 'TAG0114'), -- #Học trực tuyến
('NEWS0058', 'TAG0125'), -- #Kỹ năng học tập
('NEWS0058', 'TAG0094'), -- #Phát triển bản thân
('NEWS0058', 'TAG0100'), -- #Phát triển nghề nghiệp
('NEWS0058', 'TAG0018'), -- #Quốc tế

-- NEWS0059 (5 tags)
('NEWS0059', 'TAG0118'), -- #Giáo dục mầm non
('NEWS0059', 'TAG0136'), -- #Phát triển trẻ em
('NEWS0059', 'TAG0137'), -- #Nuôi dạy con
('NEWS0059', 'TAG0004'), -- #Giáo dục
('NEWS0059', 'TAG0016'), -- #Đời sống

-- NEWS0060 (8 tags)
('NEWS0060', 'TAG0119'), -- #Giáo dục đại học
('NEWS0060', 'TAG0126'), -- #Đời sống sinh viên
('NEWS0060', 'TAG0127'), -- #Văn hóa học đường
('NEWS0060', 'TAG0128'), -- #Cựu sinh viên
('NEWS0060', 'TAG0004'), -- #Giáo dục
('NEWS0060', 'TAG0130'), -- #Chính sách giáo dục
('NEWS0060', 'TAG0100'), -- #Phát triển nghề nghiệp
('NEWS0060', 'TAG0094'),  -- #Phát triển bản thân

-- NEWS0061 (7 tags)
('NEWS0061', 'TAG0138'), -- #Đời sống gia đình
('NEWS0061', 'TAG0139'), -- #Quan hệ xã hội
('NEWS0061', 'TAG0140'), -- #Hôn nhân
('NEWS0061', 'TAG0137'), -- #Nuôi dạy con
('NEWS0061', 'TAG0016'), -- #Đời sống
('NEWS0061', 'TAG0014'), -- #Xã hội
('NEWS0061', 'TAG0099'), -- #Cân bằng cuộc sống

-- NEWS0062 (6 tags)
('NEWS0062', 'TAG0144'), -- #Du lịch khám phá
('NEWS0062', 'TAG0145'), -- #Ẩm thực vùng miền
('NEWS0062', 'TAG0146'), -- #Văn hóa dân tộc
('NEWS0062', 'TAG0008'), -- #Du lịch
('NEWS0062', 'TAG0009'), -- #Văn hóa
('NEWS0062', 'TAG0024'), -- #Ẩm thực

-- NEWS0063 (8 tags)
('NEWS0063', 'TAG0147'), -- #Lễ hội truyền thống
('NEWS0063', 'TAG0148'), -- #Di sản văn hóa
('NEWS0063', 'TAG0149'), -- #Nghệ thuật dân gian
('NEWS0063', 'TAG0150'), -- #Làng nghề truyền thống
('NEWS0063', 'TAG0009'), -- #Văn hóa
('NEWS0063', 'TAG0019'), -- #Nghệ thuật
('NEWS0063', 'TAG0146'), -- #Văn hóa dân tộc
('NEWS0063', 'TAG0008'), -- #Du lịch

-- NEWS0064 (7 tags)
('NEWS0064', 'TAG0142'), -- #Phong cách sống
('NEWS0064', 'TAG0143'), -- #Sở thích
('NEWS0064', 'TAG0025'), -- #Thời trang
('NEWS0064', 'TAG0024'), -- #Ẩm thực
('NEWS0064', 'TAG0008'), -- #Du lịch
('NEWS0064', 'TAG0016'), -- #Đời sống
('NEWS0064', 'TAG0010');  -- #Giải trí













-- Insert values into User  Default; user này dùng chung cho các Writer Default và Editor Default
-- Writer Default và Editor Default tham chiếu tới User này
INSERT INTO User (Id_User, Name, Birthday, Email, Password) 
VALUES 
('USR0000', 'Default', '1990-01-01', 'default@example.com', 'password123');


-- Thêm Writer Default
-- Khi xoá 1 Writer, Id_Writer trong News không thể đổi thành "Default"
-- Vì Id_Writer trong News là thuộc tính tham chiếu tới bảng Writer, chứ ko phải thuộc tính riêng biệt của News. 
-- Nên là thay vào đó, mình tạo 1 Writer có tên Default, khi xoá thì thay đổi Id_writer trong News thành thằng Writer Default
INSERT INTO Writer (Id_Writer, Id_User, Id_Category, Pen_Name) 
VALUES 
('DEFAULT', 'USR0000', 'CAT0000', 'Pen_Name_Default'); 


-- Trigger xoá 1 Writer thì trong News, Id_Writer sẽ thành Default
-- Còn nếu xoá News thì ko có ảnh hưởng gì tới Writer cả
DELIMITER $$

CREATE TRIGGER Before_Delete_Writer
BEFORE DELETE ON Writer
FOR EACH ROW
BEGIN
    UPDATE News
    SET Id_Writer = 'DEFAULT'
    WHERE Id_Writer = OLD.Id_Writer;
END$$

DELIMITER ;




-- Thêm Editor Default
-- Khi xoá 1 Editor, Id_Editor trong Editor_Check_News không thể đổi thành "Default" 
-- vì Id_Editor trong Editor_Check_News là thuộc tính tham chiếu tới bảng khác chứ không phải thuộc tính riêng biệt của bảng Editor_Check_News
-- Nên là thay vào đó, mình tạo 1 Editor có tên Default, khi xoá thì thay đổi Id_Editor trong Editor_Check_News thành thằng Editor Default
INSERT INTO Editor (Id_Editor, Id_User, Id_Category, Date_register) 
VALUES 
('DEFAULT', 'USR0000', 'CAT0000', '2024-12-08 10:30:00'); 


-- Trigger khi xoá 1 Editor thì danh sách Editor_Check_News các cột Id_Editor đó sẽ thành Default . Ví dụ:
-- Id_Editor    | Id_News        ------->   Id_Editor    | Id_News  
-- EDT001       | NEWS001		 	   						default      | NEWS001
-- --------------
-- Còn nếu xoá News thì trong danh sách Editor_Check_News, các hàng chứ Id_News đó sẽ xoá.  Ví dụ:
-- Id_Editor    | Id_News        ------->   Id_Editor    | Id_News  
-- EDT001       | NEWS001		 	   						             | 
-- Ở bảng Editor_Check_News nó sẽ mất cả Id_Editor và Id_News. Thực tế nó chỉ xoá cái bài viết News thôi, chứ ko ko xoá Editor đó,. 
-- Trong bảng này nó mất Id_Editor là chỉ mất trong cái danh sách bảng Editor_Check_News này thôi
-- Chứ trong bảng Editor nó vẫn còn thằng Editor đó
DELIMITER $$

CREATE TRIGGER Before_Delete_Editor
BEFORE DELETE ON Editor
FOR EACH ROW
BEGIN
    UPDATE Editor_Check_News
    SET Id_Editor = 'DEFAULT'
    WHERE Id_Editor = OLD.Id_Editor;
END$$

DELIMITER ;




-- Khi xoá 1 News, nó sẽ chuyển vào Kho rác List_Deleted_News, các thông tin được giữ nguyên
-- riêng Id_Status sẽ cập nhật thành "Đã xoá" ('STS005', 'Đã xoá')
DELIMITER //

CREATE TRIGGER After_News_Delete
AFTER DELETE ON News
FOR EACH ROW
BEGIN
    INSERT INTO List_Deleted_News (
        Id_SubCategory,
        Id_Writer,
        Id_Status,
        Id_News,
        Date,
        Comments,
        Premium,
        Views,
        Content,
        Image,
        Title,
        Meta_title,
        Meta_description
    )
    VALUES (
        OLD.Id_SubCategory,
        OLD.Id_Writer,
        'STS0005',
        OLD.Id_News,
        OLD.Date,
        OLD.Comments,
        OLD.Premium,
        OLD.Views,
        OLD.Content,
        OLD.Image,
        OLD.Title,
        OLD.Meta_title,
        OLD.Meta_description
    );
END //

DELIMITER ;


-- Mấy command dưới đây chỉ là chạy ví dụ test pla pla thôi, đừng quan tâm. 
-- DELETE FROM Writer WHERE Id_Writer = 'WRT001';
-- DELETE FROM Writer WHERE Id_Writer = 'WRT002';
-- SELECT * FROM Writer WHERE Id_Writer = 'WRT001';
-- SELECT * FROM Writer WHERE Id_Writer = 'DEFAULT';
-- SELECT * FROM News WHERE Id_Writer = 'DEFAULT';
-- SELECT * FROM News WHERE Id_News = 'NEWS001';
-- SHOW TRIGGERS;


-- SELECT * FROM User
-- SELECT * FROM News
-- SELECT * FROM Writer
-- SELECT * FROM Editor
-- SELECT * FROM Editor_Check_News
-- DELETE FROM Editor WHERE Id_Editor = 'EDT001';
-- DELETE FROM News WHERE Id_News = 'NEWS001';


-- DELETE FROM News WHERE Id_News = 'NEWS001';
-- SELECT * FROM List_Deleted_News
-- SELECT * FROM News
-- delete from User where Id_User = 'USR003';










