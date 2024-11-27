
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
    Id_User VARCHAR(100) PRIMARY KEY,
    Name VARCHAR(100),
    Birthday DATE NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Password VARCHAR(100) NOT NULL
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
    Title VARCHAR(100) NOT NULL,
    Meta_title VARCHAR(100) NOT NULL,
    Meta_description TEXT NOT NULL,
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
    Meta_description TEXT NOT NULL
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
('CAT000', 'default', 0),
('CAT001', 'Technology', 1),
('CAT002', 'Health', 1),
('CAT003', 'Education', 1),
('CAT004', 'Entertainment', 1);

-- Insert values into SubCategory
INSERT INTO SubCategory (Id_SubCategory, Id_Category, Name) 
VALUES 
('SUB001', 'CAT001', 'AI'),
('SUB002', 'CAT001', 'Blockchain'),
('SUB003', 'CAT002', 'Nutrition'),
('SUB004', 'CAT002', 'Mental Health');

-- Insert values into User
INSERT INTO User (Id_User, Name, Birthday, Email, Password) 
VALUES 
-- admin
('USR001', 'John Doe', '1990-01-01', 'jozz111hn.doe@example.com', 'password123'),

-- editor
('USR002', 'Jane Smith', '1995-05-05', 'janq222e.smith@example.com', 'password123'),
('USR003', 'Mike Brown', '1988-08-08', 'mikq33e.brown@example.com', 'password123'),
('USR004', 'Emily Davis', '1992-02-02', 'emaily44.davis@example.com', 'password123'),
('USR005', 'John Doe', '1990-01-01', 'jd56ohn.doe@example.com', 'password123'),


-- writer
('USR006', 'Jane Smith', '1995-05-05', 'jafne.smith@example.com', 'password123'),
('USR007', 'Mike Brown', '1988-08-08', 'minske.brown@example.com', 'password123'),
('USR008', 'Emily Davis', '1992-02-02', 'emil33by.davis@example.com', 'password123'),
('USR009', 'Emily Davis', '1992-02-02', 'emi33333vly.davis@example.com', 'password123'),

-- Subcriber
('USR0010', 'Emily Davis', '1992-02-02', 'emivggly.davis@example.com', 'password123'),
('USR0011', 'Emily Davis', '1992-02-02', 'emilngfcy.davis@example.com', 'password123');


-- Insert values into Administrator
INSERT INTO Administrator (Id_Administrator, Id_User) 
VALUES 
('ADM001', 'USR001');

-- Insert values into Editor
INSERT INTO Editor (Id_Editor, Id_User, Id_Category) 
VALUES 
('EDT001', 'USR002', 'CAT001'),
('EDT002', 'USR003', 'CAT001'),
('EDT003', 'USR004', 'CAT001'),  -- Editor 3
('EDT004', 'USR005', 'CAT001');  -- Editor 4

-- Insert values into Writer
INSERT INTO Writer (Id_Writer, Id_User, Id_Category) 
VALUES 
('WRT001', 'USR006', 'CAT001'),
('WRT002', 'USR007', 'CAT001'),
('WRT003', 'USR008', 'CAT001'),
('WRT004', 'USR009', 'CAT001');

-- Insert values into Subcriber
INSERT INTO Subcriber (Id_Subcriber, Id_User, Date_register) 
VALUES 
('SUBC001', 'USR0010', '2024-01-01'),
('SUBC002', 'USR0011', '2024-01-29');

-- Insert values into Tag
INSERT INTO Tag (Id_Tag, Name, Status) 
VALUES 
('TAG001', '#Technology', 1),
('TAG002', '#Health', 1),
('TAG003', '#AI', 1),
('TAG004', '#Blockchain', 1);

-- Insert values into Status_Of_News
INSERT INTO Status_Of_News (Id_Status, Title_Status) 
VALUES 
('STS001', 'Chưa duyệt'),
('STS002', 'Chưa đạt'),
('STS003', 'Từ chối'),
('STS004', 'Đồng ý'),
('STS005', 'Đã xoá');

-- Insert values into News
INSERT INTO News (Id_SubCategory, Id_Writer, Id_Status, Id_News, Date, Comments, Premium, Views, Content, Image, Title, Meta_title, Meta_description) 
VALUES 
('SUB001', 'WRT001', 'STS001', 'NEWS001', '2024-11-01', 'Great article!', 1, 500, 'AI advancements are fascinating.', NULL, 'AI Advancements', 'AI-Trend-2024', 'AI is reshaping the world.'),
('SUB001', 'WRT002', 'STS001', 'NEWS002', '2024-11-02', 'Great article!', 1, 300, 'AI  fascinating.', NULL, 'AI Advancements', 'AI-Trend-2024', 'AI is reshaping the world.'),
('SUB001', 'WRT003', 'STS001', 'NEWS003', '2024-11-02', 'Great sarticle!', 0, 400, 'AI a fascinating.', NULL, 'AI Advancements', 'AI-Trend-2024', 'AI is reshaping the world.'),
('SUB001', 'WRT004', 'STS001', 'NEWS004', '2024-11-02', 'Greatd article!', 0, 400, 'AI d fascinating.', NULL, 'AI Advancements', 'AI-Trend-2024', 'AI is reshaping the world.');

-- Insert values into Comment
INSERT INTO Comment (Id_Comment, Id_User, Id_News, Comment) 
VALUES 
('CMT001', 'USR001', 'NEWS001', 'I found this article very insightful.'),
('CMT002', 'USR002', 'NEWS001', 'I found this art'),
('CMT003', 'USR003', 'NEWS002', 'Great read!'),
('CMT004', 'USR003', 'NEWS003', 'I found this art');

-- Insert values into Editor_Check_News
INSERT INTO Editor_Check_News (Id_Editor, Id_News, Reason, Date_feedback) 
VALUES 
('EDT001', 'NEWS001', 'Needs revision on formatting.', '2024-11-10'),
('EDT001', 'NEWS002', 'Needs more references.', '2024-11-12'),
('EDT001', 'NEWS003', 'Add more examples for clarity.', '2024-11-15'),
('EDT002', 'NEWS004', 'Check fofr spelling errors.', '2024-11-20'),
('EDT003', 'NEWS004', 'Chefck ', '2024-11-20'),
('EDT004', 'NEWS004', 'Chesck ', '2024-11-20');

-- Insert values into News_Tag
INSERT INTO News_Tag (Id_News, Id_Tag) 
VALUES 
('NEWS001', 'TAG001'),
('NEWS001', 'TAG003'),
('NEWS002', 'TAG002'),
('NEWS002', 'TAG004');









-- Insert values into User  Default; user này dùng chung cho các Writer Default và Editor Default
-- Writer Default và Editor Default tham chiếu tới User này
INSERT INTO User (Id_User, Name, Birthday, Email, Password) 
VALUES 
('USR000', 'Default', '1990-01-01', 'default@example.com', 'password123');


-- Thêm Writer Default
-- Khi xoá 1 Writer, Id_Writer trong News không thể đổi thành "Default"
-- Vì Id_Writer trong News là thuộc tính tham chiếu tới bảng Writer, chứ ko phải thuộc tính riêng biệt của News. 
-- Nên là thay vào đó, mình tạo 1 Writer có tên Default, khi xoá thì thay đổi Id_writer trong News thành thằng Writer Default
INSERT INTO Writer (Id_Writer, Id_User, Id_Category) 
VALUES 
('DEFAULT', 'USR000', 'CAT000'); 


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
('DEFAULT', 'USR000', 'CAT000'); 


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
        'STS005',
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










