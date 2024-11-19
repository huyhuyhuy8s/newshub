
-- 1. Xóa bảng liên kết và phụ thuộc trước
DROP TABLE IF EXISTS News_Tag;
DROP TABLE IF EXISTS Editor_Check_News;
DROP TABLE IF EXISTS Comment;

-- 2. Xóa bảng News và các bảng liên quan
DROP TABLE IF EXISTS News;
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


CREATE TABLE Category (
    Id_Category VARCHAR(100) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Status BIT NOT NULL
);

CREATE TABLE SubCategory (
    Id_SubCategory VARCHAR(100) PRIMARY KEY,
    Id_Category VARCHAR(100) NOT NULL,
    Name VARCHAR(100) NOT NULL,
    FOREIGN KEY (Id_Category) REFERENCES Category(Id_Category) ON DELETE CASCADE ON UPDATE CASCADE
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
    FOREIGN KEY (Id_User) REFERENCES User(Id_User),
		FOREIGN KEY (Id_Category) REFERENCES Category(Id_Category) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Writer (
    Id_Writer VARCHAR(100) PRIMARY KEY,
    Id_User VARCHAR(100) UNIQUE NOT NULL,
    Id_Category VARCHAR(100) NOT NULL,
    FOREIGN KEY (Id_User) REFERENCES User(Id_User),
		FOREIGN KEY (Id_Category) REFERENCES Category(Id_Category) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Subcriber (
    Id_Subcriber VARCHAR(100) PRIMARY KEY,
    Id_User VARCHAR(100) UNIQUE NOT NULL,
    Duration INT, -- Thời hạn đăng ký tính bằng ngày
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

    Id_SubCategory VARCHAR(100) NOT NULL,
		Id_Writer VARCHAR(100) NOT NULL,
-- 		Id_Editor VARCHAR(100) NOT NULL,
		Id_Status VARCHAR(100) NOT NULL,
		
		Id_News VARCHAR(100) PRIMARY KEY,
    Date DATE NOT NULL,
    Comments TEXT,
		Premium BIT,
    Views INT,
    Content TEXT,
    Image LONGBLOB NOT NULL,
    Title VARCHAR(100) NOT NULL,
    Meta_title VARCHAR(100) NOT NULL,
    Meta_description TEXT NOT NULL,
    FOREIGN KEY (Id_SubCategory) REFERENCES SubCategory(Id_SubCategory) ON DELETE CASCADE ON UPDATE CASCADE, -- khi 1 subcatelogy bị xoá, thì news có subcatelogy đó sẽ bị xoá theo
		FOREIGN KEY (Id_Writer) REFERENCES Writer(Id_Writer) ON DELETE CASCADE ON UPDATE CASCADE,
-- 		FOREIGN KEY (Id_Editor) REFERENCES Editor(Id_Editor),
		FOREIGN KEY (Id_Status) REFERENCES Status_Of_News(Id_Status)
   
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
		Id_Editor VARCHAR(100) NOT NULL,
		Id_News VARCHAR(100) NOT NULL, 
		Reason VARCHAR(100) NOT NULL, 
		Date_feedback DATE,
		FOREIGN KEY (Id_Editor) REFERENCES Editor(Id_Editor) ON UPDATE CASCADE, -- thêm trigger nếu xoá id_editor thì id_editor của news đó giữ lại id_editor cập nhật cuối cùng
		FOREIGN KEY (Id_News) REFERENCES News(Id_News) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE News_Tag (
    Id_News VARCHAR(100) NOT NULL,
    Id_Tag VARCHAR(100) NOT NULL,
    FOREIGN KEY (Id_News) REFERENCES News(Id_News),
    FOREIGN KEY (Id_Tag) REFERENCES Tag(Id_Tag)
);







