
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
('USR0001', 'John Doe', '1990-01-01', 'jozz111hn.doe@example.com', 'password123'),

-- editor
('USR0002', 'Jane Smith', '1995-05-05', 'janq222e.smith@example.com', 'password123'),
('USR0003', 'Mike Brown', '1988-08-08', 'mikq33e.brown@example.com', 'password123'),
('USR0004', 'Emily Davis', '1992-02-02', 'emaily44.davis@example.com', 'password123'),
('USR0005', 'John Doe', '1990-01-01', 'jd56ohn.doe@example.com', 'password123'),


-- writer
('USR0006', 'Jane Smith', '1995-05-05', 'jafne.smith@example.com', 'password123'),
('USR0007', 'Mike Brown', '1988-08-08', 'minske.brown@example.com', 'password123'),
('USR0008', 'Emily Davis', '1992-02-02', 'emil33by.davis@example.com', 'password123'),
('USR0009', 'Emily Davis', '1992-02-02', 'emi33333vly.davis@example.com', 'password123'),

-- Subcriber
('USR0010', 'Emily Davis', '1992-02-02', 'emivggly.davis@example.com', 'password123'),
('USR0011', 'Emily Davis', '1992-02-02', 'emilngfcy.davis@example.com', 'password123');


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
('TAG0001', '#Technology', 1),
('TAG0002', '#Health', 1),
('TAG0003', '#AI', 1),
('TAG0004', '#Blockchain', 1);

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
('SUB0001', 'WRT0001', 'STS0001', 'NEWS0001', '2024-11-01', 'Great article!', 1, 500, 'AI advancements are fascinating.', NULL, 'Title: post 1 sub 1', 'Meta_Title: post 1 sub 1', 'Phương Mỹ Chi và Phương Duyên song ca bài Đẩy xe bò của Phương Mỹ Chi tại lễ hội. Bên cạnh Phương Mỹ Chi vốn luôn hát live tốt, Phương Duyên cũng gây ấn tượng với những nốt cao và câu hát mang âm hưởng quan họ trong bài.'),
('SUB0001', 'WRT0002', 'STS0001', 'NEWS0002', '2024-11-02', 'Great article!', 1, 490, 'AI  fascinating.', NULL, 'Title: post 2 sub 1', 'Meta_Title: post 2 sub 1', 'Liên minh Dân tộc khẳng định với cộng đồng quốc tế rằng họ đang tiếp tục hoàn thiện quá trình chuyển giao quyền lực sang một cơ quan quản lý chuyển tiếp với đầy đủ quyền hành, nhằm xây dựng một Syria dân chủ, đa nguyên và tự do'),
('SUB0001', 'WRT0003', 'STS0001', 'NEWS0003', '2024-11-02', 'Great sarticle!', 0, 450, 'AI a fascinating.', NULL, 'Title: post 3 sub 1', 'Meta_Title: post 3 sub 1', 'AI is reshaping the world4 AI is reshaping the world4 AI is reshaping the world4 AI is reshaping the world4 AI'),
('SUB0001', 'WRT0004', 'STS0001', 'NEWS0004', '2024-11-02', 'Greatd article!', 0, 460, 'AI d fascinating.', NULL, 'Title: post 4 sub 1', 'Meta_Title: post 4 sub 1', 'AI is reshaping the world4.'),
('SUB0001', 'WRT0001', 'STS0001', 'NEWS0005', '2024-11-01', 'Great article!', 1, 470, 'AI advancements are fascinating.', NULL, 'Title: post 5 sub 1', 'Meta_Title: post 5 sub 1', 'AI is reshaping the world5.'),
('SUB0001', 'WRT0002', 'STS0001', 'NEWS0006', '2024-11-02', 'Great article!', 1, 480, 'AI  fascinating.', NULL, 'Title: post 6 sub 1', 'Meta_Title: post 6 sub 1', 'AI is reshaping the world6.'),
('SUB0001', 'WRT0003', 'STS0001', 'NEWS0007', '2024-11-02', 'Great sarticle!', 0, 440, 'AI a fascinating.', NULL, 'Title: post 7 sub 1', 'Meta_Title: post 7 sub 1', 'AI is reshaping the world7.'),
('SUB0001', 'WRT0004', 'STS0001', 'NEWS0008', '2024-11-02', 'Greatd article!', 0, 430, 'AI d fascinating.', NULL, 'Title: post 8 sub 1', 'Meta_Title: post 8 sub 1', 'AI is reshaping the world8.'),
('SUB0001', 'WRT0001', 'STS0001', 'NEWS0009', '2024-11-01', 'Great article!', 0, 430, 'AI advancements are fascinating.', NULL, 'Title: post 9 sub 1', 'Meta_Title: post 9 sub 1', 'AI is reshaping the world9.'),
('SUB0001', 'WRT0002', 'STS0001', 'NEWS0010', '2024-11-02', 'Great article!', 0, 430, 'AI  fascinating.', NULL, 'Title: post 10 sub 1', 'Meta_Title: post 10 sub 1', 'AI is reshaping the world10.'),
('SUB0001', 'WRT0003', 'STS0001', 'NEWS0011', '2024-11-02', 'Great sarticle!', 0, 420, 'AI a fascinating.', NULL, 'Title: post 11 sub 1', 'Meta_Title: post 11 sub 1', 'AI is reshaping the world11.'),
('SUB0001', 'WRT0004', 'STS0001', 'NEWS0012', '2024-11-02', 'Greatd article!', 0, 400, 'AI d fascinating.', NULL, 'Title: post 12 sub 1', 'Meta_Title: post 12 sub 1', 'AI is reshaping the world12.'),

-- Sub2
('SUB0002', 'WRT0001', 'STS0001', 'NEWS0013', '2024-11-01', 'Great article!', 0, 500, 'AI advancements are fascinating.', NULL, 'Title: post 1 sub 2', 'Meta_Title: post 1 sub 2', 'AI is reshaping the world13.'),
('SUB0002', 'WRT0002', 'STS0001', 'NEWS0014', '2024-11-02', 'Great article!', 0, 495, 'AI  fascinating.', NULL, 'Title: post 2 sub 2', 'Meta_Title: post 2 sub 2', 'AI is reshaping the world14.'),
('SUB0002', 'WRT0003', 'STS0001', 'NEWS0015', '2024-11-02', 'Great sarticle!', 0, 455, 'AI a fascinating.', NULL, 'Title: post 3 sub 2', 'Meta_Title: post 3 sub 2', 'AI is reshaping the world15.'),
('SUB0002', 'WRT0004', 'STS0001', 'NEWS0016', '2024-11-02', 'Greatd article!', 0, 465, 'AI d fascinating.', NULL, 'Title: post 4 sub 2', 'Meta_Title: post 4 sub 2', 'AI is reshaping the world16.'),
('SUB0002', 'WRT0001', 'STS0001', 'NEWS0017', '2024-11-01', 'Great article!', 0, 470, 'AI advancements are fascinating.', NULL, 'Title: post 5 sub 2', 'Meta_Title: post 5 sub 2', 'AI is reshaping the world.17'),
('SUB0002', 'WRT0002', 'STS0001', 'NEWS0018', '2024-11-02', 'Great article!', 0, 480, 'AI  fascinating.', NULL, 'Title: post 6 sub 2', 'Meta_Title: post 6 sub 2', 'AI is reshaping the world18.'),
('SUB0002', 'WRT0003', 'STS0001', 'NEWS0019', '2024-11-02', 'Great sarticle!', 0, 440, 'AI a fascinating.', NULL, 'Title: post 7 sub 2', 'Meta_Title: post 7 sub 2', 'AI is reshaping the world19.'),
('SUB0002', 'WRT0004', 'STS0001', 'NEWS0020', '2024-11-02', 'Greatd article!', 0, 436, 'AI d fascinating.', NULL, 'Title: post 8 sub 2', 'Meta_Title: post 8 sub 2', 'AI is reshaping the world20.'),
('SUB0002', 'WRT0001', 'STS0001', 'NEWS0021', '2024-11-01', 'Great article!', 0, 430, 'AI advancements are fascinating.', NULL, 'Title: post 9 sub 2', 'Meta_Title: post 9 sub 2', 'AI is reshaping the world21.'),
('SUB0002', 'WRT0002', 'STS0001', 'NEWS0022', '2024-11-02', 'Great article!', 0, 8, 'AI  fascinating.', NULL, 'Title: post 10 sub 2', 'Meta_Title: post 10 sub 2', 'AI is reshaping the world22.'),
('SUB0002', 'WRT0003', 'STS0001', 'NEWS0023', '2024-11-02', 'Great sarticle!', 0, 3, 'AI a fascinating.', NULL, 'Title: post 11 sub 2', 'Meta_Title: post 11 sub 2', 'AI is reshaping the world23.'),
('SUB0002', 'WRT0004', 'STS0001', 'NEWS0024', '2024-11-02', 'Greatd article!', 0, 2, 'AI d fascinating.', NULL, 'Title: post 12 sub 2', 'Meta_Title: post 12 sub 2', 'AI is reshaping the world24.'),

-- Sub3
('SUB0003', 'WRT0001', 'STS0001', 'NEWS0025', '2024-11-01', 'Great article!', 0, 499, 'AI advancements are fascinating.', NULL, 'Title: post 1 sub 3', 'Meta_Title: post 1 sub 3', 'Trước đó, phát biểu tại phiên họp của ủy ban quốc hội sau khi lệnh thiết quân luật được dỡ bỏ, ông Lee đã bảo vệ Tổng thống Yoon, khẳng định rằng việc tuyên bố thiết quân luật đã được thực hiện theo quy trình và quy định hiến pháp.'),
('SUB0003', 'WRT0002', 'STS0001', 'NEWS0026', '2024-11-02', 'Great article!', 0, 1, 'AI  fascinating.', NULL, 'Title: post 2 sub 3', 'Meta_Title: post 2 sub 3', 'AI is reshaping the world14.'),
('SUB0003', 'WRT0003', 'STS0001', 'NEWS0027', '2024-11-02', 'Great sarticle!', 0, 2, 'AI a fascinating.', NULL, 'Title: post 3 sub 3', 'Meta_Title: post 3 sub 3', 'AI is reshaping the world15.'),
('SUB0003', 'WRT0004', 'STS0001', 'NEWS0028', '2024-11-02', 'Greatd article!', 0, 3, 'AI d fascinating.', NULL, 'Title: post 4 sub 3', 'Meta_Title: post 4 sub 3', 'AI is reshaping the world16.'),
('SUB0003', 'WRT0001', 'STS0001', 'NEWS0029', '2024-11-01', 'Great article!', 0, 4, 'AI advancements are fascinating.', NULL, 'Title: post 5 sub 3', 'Meta_Title: post 5 sub 3', 'AI is reshaping the world.17'),
('SUB0003', 'WRT0002', 'STS0001', 'NEWS0030', '2024-11-02', 'Great article!', 0, 5, 'AI  fascinating.', NULL, 'Title: post 6 sub 3', 'Meta_Title: post 6 sub 3', 'AI is reshaping the world18.'),
('SUB0003', 'WRT0003', 'STS0001', 'NEWS0031', '2024-11-02', 'Great sarticle!', 0, 6, 'AI a fascinating.', NULL, 'Title: post 7 sub 3', 'Meta_Title: post 7 sub 3', 'AI is reshaping the world19.'),
('SUB0003', 'WRT0004', 'STS0001', 'NEWS0032', '2024-11-02', 'Greatd article!', 0, 7, 'AI d fascinating.', NULL, 'Title: post 8 sub 3', 'Meta_Title: post 8 sub 3', 'AI is reshaping the world20.'),
('SUB0003', 'WRT0001', 'STS0001', 'NEWS0033', '2024-11-01', 'Great article!', 0, 8, 'AI advancements are fascinating.', NULL, 'Title: post 9 sub 3', 'Meta_Title: post 9 sub 3', 'AI is reshaping the world21.'),
('SUB0003', 'WRT0002', 'STS0001', 'NEWS0034', '2024-11-02', 'Great article!', 0, 9, 'AI  fascinating.', NULL, 'Title: post 10 sub 3', 'Meta_Title: post 10 sub 3', 'AI is reshaping the world22.'),
('SUB0003', 'WRT0003', 'STS0001', 'NEWS0035', '2024-11-02', 'Great sarticle!', 0, 10, 'AI a fascinating.', NULL, 'Title: post 11 sub 3', 'Meta_Title: post 11 sub 3', 'AI is reshaping the world23.'),
('SUB0003', 'WRT0004', 'STS0001', 'NEWS0036', '2024-11-02', 'Greatd article!', 0, 11, 'AI d fascinating.', NULL, 'Title: post 12 sub 3', 'Meta_Title: post 12 sub 3', 'AI is reshaping the world24.'),

-- Sub4
('SUB0004', 'WRT0001', 'STS0001', 'NEWS0037', '2024-11-01', 'Great article!', 0, 100, 'AI advancements are fascinating.', NULL, 'Title: post 1 sub 4', 'Meta_Title: post 1 sub 4', 'AI is reshaping the world13.'),
('SUB0004', 'WRT0002', 'STS0001', 'NEWS0038', '2024-11-02', 'Great article!', 0, 498, 'AI  fascinating.', NULL, 'Title: post 2 sub 4', 'Meta_Title: post 2 sub 4', 'Ông Lee từ chức chỉ một ngày sau khi đảng đối lập chính đề xuất kiến nghị luận tội đối với chính ông, dự kiến bỏ phiếu vào ngày 10-12.'),
('SUB0004', 'WRT0003', 'STS0001', 'NEWS0039', '2024-11-02', 'Great sarticle!', 0, 101, 'AI a fascinating.', NULL, 'Title: post 3 sub 4', 'Meta_Title: post 3 sub 4', 'AI is reshaping the world15.'),
('SUB0004', 'WRT0004', 'STS0001', 'NEWS0040', '2024-11-02', 'Greatd article!', 0, 99, 'AI d fascinating.', NULL, 'Title: post 4 sub 4', 'Meta_Title: post 4 sub 4', 'AI is reshaping the world16.'),
('SUB0004', 'WRT0001', 'STS0001', 'NEWS0041', '2024-11-01', 'Great article!', 0, 70, 'AI advancements are fascinating.', NULL, 'Title: post 5 sub 4', 'Meta_Title: post 5 sub 4', 'AI is reshaping the world.17'),
('SUB0004', 'WRT0002', 'STS0001', 'NEWS0042', '2024-11-02', 'Great article!', 0, 80, 'AI  fascinating.', NULL, 'Title: post 6 sub 4', 'Meta_Title: post 6 sub 4', 'AI is reshaping the world18.'),
('SUB0004', 'WRT0003', 'STS0001', 'NEWS0043', '2024-11-02', 'Great sarticle!', 0, 40, 'AI a fascinating.', NULL, 'Title: post 7 sub 4', 'Meta_Title: post 7 sub 4', 'AI is reshaping the world19.'),
('SUB0004', 'WRT0004', 'STS0001', 'NEWS0044', '2024-11-02', 'Greatd article!', 0, 36, 'AI d fascinating.', NULL, 'Title: post 8 sub 4', 'Meta_Title: post 8 sub 4', 'AI is reshaping the world20.'),
('SUB0004', 'WRT0001', 'STS0001', 'NEWS0045', '2024-11-01', 'Great article!', 0, 30, 'AI advancements are fascinating.', NULL, 'Title: post 9 sub 4', 'Meta_Title: post 9 sub 4', 'AI is reshaping the world21.'),
('SUB0004', 'WRT0002', 'STS0001', 'NEWS0046', '2024-11-02', 'Great article!', 0, 33, 'AI  fascinating.', NULL, 'Title: post 10 sub 4', 'Meta_Title: post 10 sub 4', 'AI is reshaping the world22.'),
('SUB0004', 'WRT0003', 'STS0001', 'NEWS0047', '2024-11-02', 'Great sarticle!', 0, 11, 'AI a fascinating.', NULL, 'Title: post 11 sub 4', 'Meta_Title: post 11 sub 4', 'AI is reshaping the world23.'),
('SUB0004', 'WRT0004', 'STS0001', 'NEWS0048', '2024-11-02', 'Greatd article!', 0, 4, 'AI d fascinating.', NULL, 'Title: post 12 sub 4', 'Meta_Title: post 12 sub 4', 'AI is reshaping the world24.'),

-- Sub5
('SUB0005', 'WRT0001', 'STS0001', 'NEWS0049', '2024-11-01', 'Great article!', 0, 100, 'AI advancements are fascinating.', NULL, 'Title: post 1 sub 5', 'Meta_Title: post 1 sub 5', 'AI is reshaping the world13.'),
('SUB0005', 'WRT0002', 'STS0001', 'NEWS0050', '2024-11-02', 'Great article!', 0, 498, 'AI  fascinating.', NULL, 'Title: post 2 sub 5', 'Meta_Title: post 2 sub 5', 'Đi khám phá rừng Phú Quốc là tour du lịch trải nghiệm độc đáo. Trước khi đi tham quan khách sẽ được hướng dẫn viên tư vấn hết tất cả các kỹ năng đi rừng và mua bảo hiểm du lịch đảm bảo an toàn. '),
('SUB0005', 'WRT0003', 'STS0001', 'NEWS0051', '2024-11-02', 'Great sarticle!', 0, 101, 'AI a fascinating.', NULL, 'Title: post 3 sub 5', 'Meta_Title: post 3 sub 5', 'Sở Du lịch Kiên Giang cho biết năm 2024, Kiên Giang ước đón hơn 9,8 triệu lượt khách (tăng 15,6% so với cùng kỳ); khách quốc tế ước đón hơn 900.000 lượt, tổng thu du lịch hơn 25.000 tỉ đồng.'),
('SUB0005', 'WRT0004', 'STS0001', 'NEWS0052', '2024-11-02', 'Greatd article!', 0, 99, 'AI d fascinating.', NULL, 'Title: post 4 sub 5', 'Meta_Title: post 4 sub 5', 'AI is reshaping the world16.'),
('SUB0005', 'WRT0001', 'STS0001', 'NEWS0053', '2024-11-01', 'Great article!', 0, 70, 'AI advancements are fascinating.', NULL, 'Title: post 5 sub 5', 'Meta_Title: post 5 sub 5', 'AI is reshaping the world.17'),
('SUB0005', 'WRT0002', 'STS0001', 'NEWS0054', '2024-11-02', 'Great article!', 0, 80, 'AI  fascinating.', NULL, 'Title: post 6 sub 5', 'Meta_Title: post 6 sub 5', 'Vài thập kỷ trước, việc đến Lapland thăm ngôi nhà của ông già Noel là điều chỉ có trong mơ của nhiều trẻ em. Tuy nhiên, khi ngành hàng không phát triển, hàng trăm chuyến bay được nối đến tỉnh cực bắc của Phần Lan này. Công ty Finnavia, đơn vị điều hành các sân bay Phần Lan, cho biết trong năm ngoái có hơn 1,5 triệu du khách đến "xứ sở ông già Noel".'),
('SUB0005', 'WRT0003', 'STS0001', 'NEWS0055', '2024-11-02', 'Great sarticle!', 0, 40, 'AI a fascinating.', NULL, 'Title: post 7 sub 5', 'Meta_Title: post 7 sub 5', 'AI is reshaping the world19.'),
('SUB0005', 'WRT0004', 'STS0001', 'NEWS0056', '2024-11-02', 'Greatd article!', 0, 36, 'AI d fascinating.', NULL, 'Title: post 8 sub 5', 'Meta_Title: post 8 sub 5', 'AI is reshaping the world20.'),
('SUB0005', 'WRT0001', 'STS0001', 'NEWS0057', '2024-11-01', 'Great article!', 0, 30, 'AI advancements are fascinating.', NULL, 'Title: post 9 sub 5', 'Meta_Title: post 9 sub 5', 'AI is reshaping the world21.'),
('SUB0005', 'WRT0002', 'STS0001', 'NEWS0058', '2024-11-02', 'Great article!', 0, 33, 'AI  fascinating.', NULL, 'Title: post 10 sub 5', 'Meta_Title: post 10 sub 5', 'AI is reshaping the world22.'),
('SUB0005', 'WRT0003', 'STS0001', 'NEWS0059', '2024-11-02', 'Great sarticle!', 0, 11, 'AI a fascinating.', NULL, 'Title: post 11 sub 5', 'Meta_Title: post 11 sub 5', 'AI is reshaping the world23.'),
('SUB0005', 'WRT0004', 'STS0001', 'NEWS0060', '2024-11-02', 'Greatd article!', 0, 4, 'AI d fascinating.', NULL, 'Title: post 12 sub 5', 'Meta_Title: post 12 sub 5', 'AI is reshaping the world24.');


-- Insert values into Comment
INSERT INTO Comment (Id_Comment, Id_User, Id_News, Comment) 
VALUES 
('CMT0001', 'USR0001', 'NEWS0001', 'I found this article very insightful.'),
('CMT0002', 'USR0002', 'NEWS0001', 'I found this art'),
('CMT0003', 'USR0003', 'NEWS0002', 'Great read!'),
('CMT0004', 'USR0003', 'NEWS0003', 'I found this art');

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
INSERT INTO News_Tag (Id_News, Id_Tag) 
VALUES 
('NEWS0001', 'TAG0001'),
('NEWS0001', 'TAG0003'),
('NEWS0002', 'TAG0002'),
('NEWS0002', 'TAG0004');









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










