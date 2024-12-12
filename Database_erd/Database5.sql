
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
    Id_Category VARCHAR(100) NOT NULL,
    FOREIGN KEY (Id_User) REFERENCES User(Id_User) ON DELETE CASCADE ON UPDATE CASCADE,
		FOREIGN KEY (Id_Category) REFERENCES Category(Id_Category) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Subcriber (
    Id_Subcriber VARCHAR(100) PRIMARY KEY,
    Id_User VARCHAR(100) UNIQUE NOT NULL,
    Date_register DATETIME NOT NULL,
		Date_expired DATETIME, 
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
    Meta_title VARCHAR(200) NOT NULL,
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
INSERT INTO User (Id_User, Name, Birthday, Email, Password) 
VALUES 
-- admin
('USR0001', 'Công Thuận', '1990-01-01', 'jozz111hn.doe@example.com', 'password123'),

-- editor
('USR0002', 'Minh Thư', '1995-05-05', 'janq222e.smith@example.com', 'password123'),
('USR0003', 'Phương Huy', '1988-08-08', 'mikq33e.brown@example.com', 'password123'),
('USR0004', 'Duy Trì', '1992-02-02', 'emaily44.davis@example.com', 'password123'),
('USR0005', 'Minh Louis Vuitton', '1990-01-01', 'jd56ohn.doe@example.com', 'password123'),


-- writer
('USR0006', 'Chán đời', '1995-05-05', 'jafne.smith@example.com', 'password123'),
('USR0007', 'Cá sấu', '1988-08-08', 'minske.brown@example.com', 'password123'),
('USR0008', 'Thỏ 7màu', '1992-02-02', 'emil33by.davis@example.com', 'password123'),
('USR0009', 'Jack97', '1992-02-02', 'emi33333vly.davis@example.com', 'password123'),

-- Subcriber
('USR0010', 'Riverside', '1992-02-02', 'emivggly.davis@example.com', 'password123'),
('USR0011', 'Bcon Plaza', '1992-02-02', 'emilngfcy.davis@example.com', 'password123');


-- Insert values into Administrator
INSERT INTO Administrator (Id_Administrator, Id_User) 
VALUES 
('ADM0001', 'USR0001');

-- Insert values into Editor
INSERT INTO Editor (Id_Editor, Id_User, Id_Category) 
VALUES 
('EDT0001', 'USR0002', 'CAT0001'),
('EDT0002', 'USR0003', 'CAT0001'),
('EDT0003', 'USR0004', 'CAT0001'),  -- Editor 3
('EDT0004', 'USR0005', 'CAT0001');  -- Editor 4

-- Insert values into Writer
INSERT INTO Writer (Id_Writer, Id_User, Id_Category) 
VALUES 
('WRT0001', 'USR0006', 'CAT0001'),
('WRT0002', 'USR0007', 'CAT0001'),
('WRT0003', 'USR0008', 'CAT0001'),
('WRT0004', 'USR0009', 'CAT0001');

-- Insert values into Subcriber
INSERT INTO Subcriber (Id_Subcriber, Id_User, Date_register) 
VALUES 
('SUBC0001', 'USR0010', '2024-01-01'),
('SUBC0002', 'USR0011', '2024-01-29');

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

-- Insert values into News
INSERT INTO News (Id_SubCategory, Id_Writer, Id_Status, Id_News, Date, Comments, Premium, Views, Content, Image, Title, Meta_title, Meta_description) 
VALUES 
-- Sub1-chính trị
('SUB0001', 'WRT0001', 'STS0001', 'NEWS0001', '2024-12-08 10:30:00', 'Great article!', 1, 500, 'AI advancements are fascinating.', NULL, 'Title: post 1 sub 1', 'Meta_Title: post 1 sub 1 AI is reshaping the world', 'Phương Mỹ Chi và Phương Duyên song ca bài Đẩy xe bò của Phưo và câu hát mang âm hưởng quan họ trong bài.cộng đồng quốc tế rằng họ đang tiếp tục hoàn thiện uyển tiếp với đầy đủ quyền hành, nhằm xây dựng một Sy'),
('SUB0001', 'WRT0002', 'STS0001', 'NEWS0002', '2024-12-07 10:30:00', 'Great article!', 1, 490, 'AI  fascinating.', NULL, 'Title: post 2 sub 1', 'Meta_Title: post 2 sub 1', 'Liên minh Dân tộc khẳng định với cộng đồng quốc tế rằng họ đang tiếp tục hoàn thiện quá trình chuyển giao quyền lực sang một cơ quan quản lý chuyển tiếp với đầy đủ quyền hành, nhằm xây dựng một Syria dân chủ, đa nguyên và tự do'),
('SUB0001', 'WRT0003', 'STS0001', 'NEWS0003', '2024-12-06 10:30:00', 'Great sarticle!', 0, 450, 'AI a fascinating.', NULL, 'Title: post 3 sub 1', 'Meta_Title: post 3 sub 1', 'AI is reshaping the world4 AI is reshaping the world4 AI is reshaping the world4 AI is reshaping the world4 AI'),
('SUB0001', 'WRT0004', 'STS0001', 'NEWS0004', '2024-12-06 10:30:00', 'Greatd article!', 0, 460, 'AI d fascinating.', NULL, 'Title: post 4 sub 1', 'Meta_Title: post 4 sub 1', 'AI is reshaping the world4.'),
('SUB0001', 'WRT0001', 'STS0001', 'NEWS0005', '2024-12-06 10:30:00', 'Great article!', 1, 470, 'AI advancements are fascinating.', NULL, 'Title: post 5 sub 1 Phân tích chiến lược tiếp thị trên TikTok: Thành công và bài học rút ra', 'Meta_Title: post 5 sub 1', 'AI is reshaping the world5.'),
('SUB0001', 'WRT0002', 'STS0001', 'NEWS0006', '2024-12-02 10:30:00', 'Great article!', 1, 480, 'AI  fascinating.', NULL, 'Title: post 6 sub 1', 'Meta_Title: post 6 sub 1', 'AI is reshaping the world6.'),
('SUB0001', 'WRT0003', 'STS0001', 'NEWS0007', '2024-12-02 10:30:00', 'Great sarticle!', 0, 440, 'AI a fascinating.', NULL, 'Title: post 7 sub 1', 'Meta_Title: post 7 sub 1', 'AI is reshaping the world7.'),
('SUB0001', 'WRT0004', 'STS0001', 'NEWS0008', '2024-11-26 10:30:00', 'Greatd article!', 0, 430, 'AI d fascinating.', NULL, 'Title: post 8 sub 1', 'Meta_Title: post 8 sub 1', 'AI is reshaping the world8.'),
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
('SUB0002', 'WRT0003', 'STS0001', 'NEWS0015', '2024-12-07 00:30:00', 'Great sarticle!', 0, 501, 'AI a fascinating.', NULL, 'Title: post 3 sub 2', 'Meta_Title: post 3 sub 2', 'AI is reshaping the world15 Khám phá các xu hướng mua sắm trực tuyến tại Việt Nam, phân tích sự tăng trưởng vượt bậc cùng những cơ hội và thách thức đối với doanh nghiệp'),
('SUB0002', 'WRT0004', 'STS0001', 'NEWS0016', '2024-11-18 00:30:00', 'Greatd article!', 0, 465, 'AI d fascinating.', NULL, 'Title: post 4 sub 2', 'Meta_Title: post 4 sub 2', 'AI is reshaping the world16.'),
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
('SUB0003', 'WRT0004', 'STS0001', 'NEWS0028', '2024-12-10 00:15:00', 'Greatd article!', 0, 3, 'AI d fascinating.', NULL, 'Title: post 4 sub 3', 'Meta_Title: post 4 sub 3', 'AI is reshaping the world16.'),
('SUB0003', 'WRT0001', 'STS0001', 'NEWS0029', '2024-11-01 00:30:00', 'Great article!', 0, 4, 'AI advancements are fascinating.', NULL, 'Title: post 5 sub 3', 'Meta_Title: post 5 sub 3', 'AI is reshaping the world.17'),
('SUB0003', 'WRT0002', 'STS0001', 'NEWS0030', '2024-11-02 00:30:00', 'Great article!', 0, 5, 'AI  fascinating.', NULL, 'Title: post 6 sub 3', 'Meta_Title: post 6 sub 3', 'AI is reshaping the world18.'),
('SUB0003', 'WRT0003', 'STS0001', 'NEWS0031', '2024-11-02 00:30:00', 'Great sarticle!', 0, 6, 'AI a fascinating.', NULL, 'Title: post 7 sub 3', 'Meta_Title: post 7 sub 3', 'AI is reshaping the world19.'),
('SUB0003', 'WRT0004', 'STS0001', 'NEWS0032', '2024-11-02 00:30:00', 'Greatd article!', 0, 7, 'AI d fascinating.', NULL, 'Title: post 8 sub 3', 'Meta_Title: post 8 sub 3', 'AI is reshaping the world20.'),
('SUB0003', 'WRT0001', 'STS0001', 'NEWS0033', '2024-11-01 00:30:00', 'Great article!', 0, 8, 'AI advancements are fascinating.', NULL, 'Title: post 9 sub 3', 'Meta_Title: post 9 sub 3', 'AI is reshaping the world21.'),
('SUB0003', 'WRT0002', 'STS0001', 'NEWS0034', '2024-11-02 00:30:00', 'Great article!', 0, 9, 'AI  fascinating.', NULL, 'Title: post 10 sub 3', 'Meta_Title: post 10 sub 3', 'AI is reshaping the world22.'),
('SUB0003', 'WRT0003', 'STS0001', 'NEWS0035', '2024-11-02 00:30:00', 'Great sarticle!', 0, 10, 'AI a fascinating.', NULL, 'Title: post 11 sub 3', 'Meta_Title: post 11 sub 3', 'AI is reshaping the world23.'),
('SUB0003', 'WRT0004', 'STS0001', 'NEWS0036', '2024-11-02 00:30:00', 'Greatd article!', 0, 11, 'AI d fascinating.', NULL, 'Title: post 12 sub 3', 'Meta_Title: post 12 sub 3', 'AI is reshaping the world24.'),

-- Sub4-văn hoá
('SUB0004', 'WRT0001', 'STS0001', 'NEWS0037', '2024-12-06 00:30:00', 'Great article!', 0, 100000, 'AI advancements are fascinating.', NULL, 'Title: post 1 sub 4', 'Meta_Title: post 1 sub 4 Phân tích những yếu tố thúc đẩy và cản trở việc áp dụng chuyển đổi.!', 'AI is reshaping the world13.Phân tích những yếu tố thúc đẩy và cản trở việc áp dụng chuyển đổi số trong giáo dục đại học, cùng các giải pháp cải tiến chất lượng đào tạo.'),
('SUB0004', 'WRT0002', 'STS0001', 'NEWS0038', '2024-12-10 00:30:00', 'Great article!', 0, 498, 'AI  fascinating.', NULL, 'Title: post 2 sub 4', 'Meta_Title: post 2 sub 4', 'Ông Lee từ chức chỉ một ngày sau khi đảng đối lập chính đề xuất kiến nghị luận tội đối với chính ông, dự kiến bỏ phiếu vào ngày 10-12.'),
('SUB0004', 'WRT0003', 'STS0001', 'NEWS0039', '2024-12-10 00:57:00', 'Great sarticle!', 0, 101, 'AI a fascinating.', NULL, 'Title: post 3 sub 4', 'Meta_Title: post 3 sub 4', 'AI is reshaping the world15.'),
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
('SUB0005', 'WRT0001', 'STS0001', 'NEWS0049', '2024-12-10 00:30:00', 'Great article!', 0, 100, 'AI advancements are fascinating.', NULL, 'Title: post 1 sub 5', 'Meta_Title: post 1 sub 5', 'AI is reshaping the world13.'),
('SUB0005', 'WRT0002', 'STS0001', 'NEWS0050', '2024-12-08 00:30:00', 'Great article!', 1, 9900008, 'AI  fascinating.', NULL, 'Title: post 2 sub 5', 'Meta_Title: post 2 sub 5', 'Đi khám phá rừng Phú Quốc là tour du lịch trải nghiệm độc đáo. Trước khi đi tham quan khách sẽ được hướng dẫn viên tư vấn hết tất cả các kỹ năng đi rừng và mua bảo hiểm du lịch đảm bảo an toàn. '),
('SUB0005', 'WRT0003', 'STS0001', 'NEWS0051', '2024-12-09 00:30:00', 'Great sarticle!', 1, 101, 'AI a fascinating.', NULL, 'Title: post 3 sub 5', 'Meta_Title: post 3 sub 5', 'Sở Du lịch Kiên Giang cho biết năm 2024, Kiên Giang ước đón hơn 9,8 triệu lượt khách (tăng 15,6% so với cùng kỳ); khách quốc tế ước đón hơn 900.000 lượt, tổng thu du lịch hơn 25.000 tỉ đồng.'),
('SUB0005', 'WRT0004', 'STS0001', 'NEWS0052', '2024-12-02 00:30:00', 'Greatd article!', 1, 99, 'AI d fascinating.', NULL, 'Title: post 4 sub 5', 'Meta_Title: post 4 sub 5', 'AI is reshaping the world16.'),
('SUB0005', 'WRT0001', 'STS0001', 'NEWS0053', '2024-12-01 00:30:00', 'Great article!', 1, 70, 'AI advancements are fascinating.', NULL, 'Title: post 5 sub 5', 'Meta_Title: post 5 sub 5', 'AI is reshaping the world.17'),
('SUB0005', 'WRT0002', 'STS0001', 'NEWS0054', '2024-12-02 00:30:00', 'Great article!', 1, 7899999, 'AI  fascinating.', NULL, 'Title: post 6 sub 5', 'Meta_Title: post 6 sub 5', 'Vài thập kỷ trước, việc đến Lapland thăm ngôi nhà của ông già Noel là điều chỉ có trong mơ của nhiều trẻ em. Tuy nhiên, khi ngành hàng không phát triển, hàng trăm chuyến bay được nối đến tỉnh cực bắc của Phần Lan này. Công ty Finnavia, đơn vị điều hành các sân bay Phần Lan, cho biết trong năm ngoái có hơn 1,5 triệu du khách đến "xứ sở ông già Noel".'),
('SUB0005', 'WRT0003', 'STS0001', 'NEWS0055', '2024-12-07 00:30:00', 'Great sarticle!', 0, 40, 'AI a fascinating.', NULL, 'Title: post 7 sub 5', 'Meta_Title: post 7 sub 5', 'AI is reshaping the world19.'),
('SUB0005', 'WRT0004', 'STS0001', 'NEWS0056', '2024-12-07 00:30:00', 'Greatd article!', 0, 36, 'AI d fascinating.', NULL, 'Title: post 8 sub 5', 'Meta_Title: post 8 sub 5', 'AI is reshaping the world20.'),
('SUB0005', 'WRT0001', 'STS0001', 'NEWS0057', '2024-11-08 00:30:00', 'Great article!', 0, 30, 'AI advancements are fascinating.', NULL, 'Title: post 9 sub 5', 'Meta_Title: post 9 sub 5', 'AI is reshaping the world21.'),
('SUB0005', 'WRT0002', 'STS0001', 'NEWS0058', '2024-11-08 00:30:00', 'Great article!', 0, 33, 'AI  fascinating.', NULL, 'Title: post 10 sub 5', 'Meta_Title: post 10 sub 5', 'AI is reshaping the world22.'),
('SUB0005', 'WRT0003', 'STS0001', 'NEWS0059', '2024-11-02 00:30:00', 'Great sarticle!', 0, 11, 'AI a fascinating.', NULL, 'Title: post 11 sub 5', 'Meta_Title: post 11 sub 5', 'AI is reshaping the world23.'),
('SUB0005', 'WRT0004', 'STS0001', 'NEWS0060', '2024-11-02 00:30:00', 'Greatd article!', 0, 4, 'AI d fascinating.', NULL, 'Title: post 12 sub 5', 'Meta_Title: post 12 sub 5', 'AI is reshaping the world24.');


-- Insert values into Comment
INSERT INTO Comment (Id_Comment, Id_User, Id_News, Time, Comment) 
VALUES
('CMT0001', 'USR0001', 'NEWS0001', '2024-12-15 09:23:45', 'Bài viết rất hay! Thông tin rất bổ ích.'),
('CMT0002', 'USR0002', 'NEWS0001', '2024-12-15 10:45:12', 'Tôi đã học được nhiều điều từ bài viết này. Cảm ơn!'),
('CMT0003', 'USR0003', 'NEWS0002', '2024-02-14 14:17:33', 'Quan điểm về sự phát triển của AI thật thú vị.'),
('CMT0004', 'USR0004', 'NEWS0002', '2024-02-14 15:22:56', 'Tôi hoàn toàn đồng ý với những điểm đã nêu.'),
('CMT0005', 'USR0001', 'NEWS0003', '2024-02-13 11:45:23', 'Đây là một bài đọc rất hấp dẫn!'),
('CMT0006', 'USR0002', 'NEWS0003', '2024-02-13 12:34:56', 'Tôi nghĩ AI sẽ thay đổi thế giới.'),
('CMT0007', 'USR0003', 'NEWS0004', '2024-02-12 16:45:12', 'Những hiểu biết tuyệt vời! Mong chờ thêm nhiều bài viết nữa.'),
('CMT0008', 'USR0004', 'NEWS0004', '2024-02-12 17:23:45', 'Chủ đề này rất phù hợp với thời điểm hiện tại.'),
('CMT0009', 'USR0001', 'NEWS0005', '2024-02-11 08:56:34', 'Tôi đánh giá cao độ sâu của bài viết này.'),
('CMT0010', 'USR0002', 'NEWS0005', '2024-02-11 09:12:45', 'Viết rất hay! Tôi đã thích đọc bài này.'),
('CMT0011', 'USR0003', 'NEWS0006', '2024-02-10 13:45:23', 'AI thật sự thú vị, làm tốt lắm!'),
('CMT0012', 'USR0004', 'NEWS0006', '2024-02-10 14:23:56', 'Tôi thích cách bạn giải thích chủ đề này.'),
('CMT0013', 'USR0001', 'NEWS0007', '2024-02-09 10:34:12', 'Bài viết này rất sáng tỏ.'),
('CMT0014', 'USR0002', 'NEWS0007', '2024-02-09 11:45:34', 'Tôi thấy điều này rất hữu ích, cảm ơn!'),
('CMT0015', 'USR0003', 'NEWS0008', '2024-12-08 15:23:45', 'Bài viết xuất sắc! Tiếp tục phát huy nhé.'),
('CMT0016', 'USR0004', 'NEWS0008', '2024-12-08 16:12:23', 'Tôi đã học được điều gì đó mới hôm nay.'),
('CMT0017', 'USR0001', 'NEWS0009', '2024-02-07 09:45:56', 'Đây là một bài đọc cần thiết cho mọi người!'),
('CMT0018', 'USR0002', 'NEWS0009', '2024-02-07 10:23:12', 'Tôi đánh giá cao nghiên cứu phía sau bài viết này.'),
('CMT0019', 'USR0003', 'NEWS0001', '2024-02-06 14:56:34', 'Rất rõ ràng và súc tích, cảm ơn bạn!'),
('CMT0020', 'USR0004', 'NEWS0002', '2024-02-06 15:34:45', 'Tôi không thể chờ đợi để xem điều gì tiếp theo trong loạt bài này.'),
('CMT0021', 'USR0005', 'NEWS0010', '2024-02-05 11:23:56', 'Một bài viết rất chi tiết và sâu sắc!'),
('CMT0022', 'USR0006', 'NEWS0011', '2024-02-05 12:45:23', 'Tôi rất thích cách tiếp cận của tác giả về vấn đề này.'),
('CMT0023', 'USR0007', 'NEWS0012', '2024-02-04 16:34:12', 'Thông tin rất bổ ích, giúp tôi hiểu rõ hơn về chủ đề.'),
('CMT0024', 'USR0008', 'NEWS0013', '2024-02-04 17:12:45', 'Góc nhìn thú vị và mới mẻ, rất đáng để suy ngẫm.'),
('CMT0025', 'USR0009', 'NEWS0014', '2024-12-03 09:45:34', 'Tôi hoàn toàn đồng tình với những điều được nêu ra.'),
('CMT0026', 'USR0010', 'NEWS0015', '2024-12-03 10:23:56', 'Bài viết này thực sự đã mở mang tầm nhìn cho tôi.'),
('CMT0027', 'USR0001', 'NEWS0016', '2024-12-02 13:56:23', 'Rất ấn tượng với độ chuyên sâu của bài nghiên cứu.'),
('CMT0028', 'USR0002', 'NEWS0017', '2024-02-02 14:34:45', 'Tôi đã học được nhiều điều mới mẻ từ bài viết này.'),
('CMT0029', 'USR0003', 'NEWS0018', '2024-02-01 10:12:56', 'Cách trình bày rõ ràng và dễ hiểu, tuyệt vời!'),
('CMT0030', 'USR0004', 'NEWS0019', '2024-02-01 11:45:23', 'Một góc nhìn rất thuyết phục và logic.'),
('CMT0031', 'USR0005', 'NEWS0020', '2024-01-31 15:23:45', 'Tôi rất cảm phục sự chuyên nghiệp của tác giả.'),
('CMT0032', 'USR0006', 'NEWS0021', '2024-01-31 16:12:34', 'Thông tin này thực sự rất hữu ích cho công việc của tôi.'),
('CMT0033', 'USR0007', 'NEWS0022', '2024-01-30 09:34:56', 'Một bài viết đáng để suy ngẫm và nghiên cứu sâu hơn.'),
('CMT0034', 'USR0008', 'NEWS0023', '2024-01-30 10:45:23', 'Tôi rất thích cách tiếp cận sáng tạo này.'),
('CMT0035', 'USR0009', 'NEWS0024', '2024-01-29 14:56:45', 'Thật sự là một nguồn thông tin chất lượng!'),
('CMT0036', 'USR0010', 'NEWS0025', '2024-01-29 15:34:12', 'Góc nhìn chuyên sâu và đầy tâm huyết.'),
('CMT0037', 'USR0001', 'NEWS0026', '2024-01-28 11:23:56', 'Bài viết này đã giúp tôi hiểu rõ hơn về vấn đề.'),
('CMT0038', 'USR0002', 'NEWS0027', '2024-01-28 12:45:34', 'Rất cảm ơn tác giả đã chia sẻ kiến thức chuyên môn.'),
('CMT0039', 'USR0003', 'NEWS0028', '2024-01-27 16:12:45', 'Một nghiên cứu rất có giá trị và ý nghĩa.'),
('CMT0040', 'USR0004', 'NEWS0029', '2024-01-27 17:34:23', 'Tôi rất ấn tượng với độ chi tiết của bài viết.'),
('CMT0041', 'USR0005', 'NEWS0030', '2024-01-26 09:45:56', 'Thông tin này thực sự rất cập nhật và hữu ích.'),
('CMT0042', 'USR0006', 'NEWS0031', '2024-01-26 10:23:34', 'Một góc nhìn rất mới mẻ và sáng tạo.'),
('CMT0043', 'USR0007', 'NEWS0032', '2024-01-25 14:56:12', 'Tôi đã học được rất nhiều từ bài viết này.'),
('CMT0044', 'USR0008', 'NEWS0033', '2024-01-25 15:34:45', 'Rất cảm ơn về những thông tin chuyên sâu.'),
('CMT0045', 'USR0009', 'NEWS0034', '2024-01-24 11:12:23', 'Một bài viết thực sự đáng để suy ngẫm.'),
('CMT0046', 'USR0010', 'NEWS0035', '2024-01-24 12:45:56', 'Tôi rất thích cách trình bày logic và rõ ràng.'),
('CMT0047', 'USR0001', 'NEWS0036', '2024-01-23 16:34:45', 'Thông tin này thực sự rất bổ ích cho tôi.'),
('CMT0048', 'USR0002', 'NEWS0037', '2024-01-23 17:12:34', 'Một nghiên cứu chuyên nghiệp và sâu sắc.'),
('CMT0049', 'USR0003', 'NEWS0038', '2024-01-22 09:56:23', 'Tôi rất ấn tượng với những phân tích chi tiết.'),
('CMT0050', 'USR0004', 'NEWS0039', '2024-01-22 10:34:56', 'Góc nhìn này thực sự rất thuyết phục.'),
('CMT0051', 'USR0005', 'NEWS0040', '2024-01-21 14:45:12', 'Một bài viết rất đáng để đọc và suy ngẫm.'),
('CMT0052', 'USR0006', 'NEWS0041', '2024-01-21 15:23:45', 'Tôi hoàn toàn đồng tình với những nhận định.'),
('CMT0053', 'USR0007', 'NEWS0042', '2024-01-20 11:34:56', 'Thông tin này giúp tôi mở rộng hiểu biết.'),
('CMT0054', 'USR0008', 'NEWS0043', '2024-01-20 12:12:34', 'Rất cảm ơn về những góc nhìn sâu sắc.'),
('CMT0055', 'USR0009', 'NEWS0044', '2024-01-19 16:45:23', 'Một bài viết thực sự chuyên nghiệp.'),
('CMT0056', 'USR0010', 'NEWS0045', '2024-01-19 17:23:56', 'Tôi rất trân trọng sự chân thực của tác giả.'),
('CMT0057', 'USR0001', 'NEWS0046', '2024-01-18 09:12:45', 'Thông tin này thực sự rất giá trị.'),
('CMT0058', 'USR0002', 'NEWS0047', '2024-01-18 10:34:12', 'Một nghiên cứu đầy tâm huyết và chuyên môn.'),
('CMT0059', 'USR0003', 'NEWS0048', '2024-01-17 14:56:34', 'Tôi rất ấn tượng với cách tiếp cận mới mẻ.'),
('CMT0060', 'USR0004', 'NEWS0049', '2024-01-17 15:45:23', 'Góc nhìn này thực sự rất sáng tạo.'),
('CMT0061', 'USR0005', 'NEWS0050', '2024-01-16 11:23:56', 'Một bài viết đáng để học hỏi và nghiên cứu.'),
('CMT0062', 'USR0006', 'NEWS0051', '2024-01-16 12:45:34', 'Tôi rất cảm phục sự chuyên nghiệp.'),
('CMT0063', 'USR0007', 'NEWS0052', '2024-01-15 16:12:45', 'Thông tin này giúp tôi hiểu sâu hơn.'),
('CMT0064', 'USR0008', 'NEWS0053', '2024-01-15 17:34:23', 'Rất cảm ơn về những phân tích sâu sắc.'),
('CMT0065', 'USR0009', 'NEWS0054', '2024-01-14 09:45:56', 'Một bài viết thực sự đáng để suy ngẫm.'),
('CMT0066', 'USR0010', 'NEWS0055', '2024-01-14 10:23:34', 'Tôi rất thích cách trình bày khoa học.'),
('CMT0067', 'USR0001', 'NEWS0056', '2024-12-01 10:00:00', 'Thông tin này thực sự rất bổ ích.'),
('CMT0068', 'USR0002', 'NEWS0057', '2024-12-01 10:05:00', 'Một nghiên cứu với độ chi tiết ấn tượng.'),
('CMT0069', 'USR0003', 'NEWS0058', '2024-12-01 10:10:00', 'Tôi rất ấn tượng với những nhận định.'),
('CMT0070', 'USR0004', 'NEWS0059', '2024-12-01 10:15:00', 'Góc nhìn này thực sự rất thuyết phục.'),
('CMT0071', 'USR0005', 'NEWS0060', '2024-12-01 10:20:00', 'Một bài viết rất chuyên nghiệp và sâu sắc.'),
('CMT0072', 'USR0006', 'NEWS0061', '2024-12-01 10:25:00', 'Tôi hoàn toàn đồng tình với những phân tích.'),
('CMT0073', 'USR0007', 'NEWS0062', '2024-12-01 10:30:00', 'Thông tin này giúp tôi mở rộng tầm nhìn.'),
('CMT0074', 'USR0008', 'NEWS0063', '2024-12-01 10:35:00', 'Rất cảm ơn về những góc nhìn sáng tạo.'),
('CMT0075', 'USR0009', 'NEWS0064', '2024-12-01 10:40:00', 'Một bài viết thực sự đáng để nghiên cứu.'),
('CMT0076', 'USR0010', 'NEWS0001', '2024-12-01 10:45:00', 'Tôi rất trân trọng sự chân thực và logic.'),
('CMT0077', 'USR0001', 'NEWS0002', '2024-12-01 10:50:00', 'Thông tin này thực sự rất giá trị.'),
('CMT0078', 'USR0002', 'NEWS0003', '2024-12-01 10:55:00', 'Một nghiên cứu đầy tâm huyết và chuyên môn.'),
('CMT0079', 'USR0003', 'NEWS0004', '2024-12-01 11:00:00', 'Tôi rất ấn tượng với cách tiếp cận mới mẻ.'),
('CMT0080', 'USR0004', 'NEWS0005', '2024-12-01 11:05:00', 'Góc nhìn này thực sự rất sáng tạo.'),
('CMT0081', 'USR0005', 'NEWS0006', '2024-12-01 11:10:00', 'Một bài viết đáng để học hỏi và suy ngẫm.'),
('CMT0082', 'USR0006', 'NEWS0007', '2024-12-01 11:15:00', 'Tôi rất cảm phục sự chuyên nghiệp.'),
('CMT0083', 'USR0007', 'NEWS0008', '2024-12-01 11:20:00', 'Thông tin này giúp tôi hiểu sâu hơn.'),
('CMT0084', 'USR0008', 'NEWS0009', '2024-12-01 11:25:00', 'Rất cảm ơn về những phân tích sâu sắc.'),
('CMT0085', 'USR0009', 'NEWS0010', '2024-12-01 11:30:00', 'Một bài viết thực sự đáng để suy ngẫm.'),
('CMT0086', 'USR0010', 'NEWS0011', '2024-12-01 11:35:00', 'Tôi rất thích cách trình bày khoa học.'),
('CMT0087', 'USR0001', 'NEWS0012', '2024-12-01 11:40:00', 'Thông tin này thực sự rất bổ ích.'),
('CMT0088', 'USR0002', 'NEWS0013', '2024-12-01 11:45:00', 'Một nghiên cứu với độ chi tiết ấn tượng.'),
('CMT0089', 'USR0003', 'NEWS0014', '2024-12-01 11:50:00', 'Tôi rất ấn tượng với những nhận định.'),
('CMT0090', 'USR0004', 'NEWS0015', '2024-11-01 11:55:00', 'Góc nhìn này thực sự rất thuyết phục.'),
('CMT0091', 'USR0005', 'NEWS0016', '2024-11-01 12:00:00', 'Một bài viết rất chuyên nghiệp và sâu sắc.'),
('CMT0092', 'USR0006', 'NEWS0017', '2024-11-01 12:05:00', 'Tôi hoàn toàn đồng tình với những phân tích.'),
('CMT0093', 'USR0007', 'NEWS0018', '2024-11-01 12:10:00', 'Thông tin này giúp tôi mở rộng tầm nhìn.'),
('CMT0094', 'USR0008', 'NEWS0019', '2024-11-01 12:15:00', 'Rất cảm ơn về những góc nhìn sáng tạo.'),
('CMT0095', 'USR0009', 'NEWS0020', '2024-11-01 12:20:00', 'Một bài viết thực sự đáng để nghiên cứu.'),
('CMT0096', 'USR0010', 'NEWS0021', '2024-11-01 12:25:00', 'Tôi rất trân trọng sự chân thực và logic.'),
('CMT0097', 'USR0001', 'NEWS0022', '2024-11-01 12:30:00', 'Thông tin này thực sự rất giá trị.'),
('CMT0098', 'USR0002', 'NEWS0023', '2024-11-01 12:35:00', 'Một nghiên cứu đầy tâm huyết và chuyên môn.'),
('CMT0099', 'USR0003', 'NEWS0024', '2024-11-01 12:40:00', 'Tôi rất ấn tượng với cách tiếp cận mới mẻ.'),
('CMT0100', 'USR0004', 'NEWS0025', '2024-11-01 12:45:00', 'Góc nhìn này thực sự rất sáng tạo.');

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
INSERT INTO Writer (Id_Writer, Id_User, Id_Category) 
VALUES 
('DEFAULT', 'USR0000', 'CAT0000'); 


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
INSERT INTO Editor (Id_Editor, Id_User, Id_Category) 
VALUES 
('DEFAULT', 'USR0000', 'CAT0000'); 


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










