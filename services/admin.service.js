import db from '../utils/db.js';

const adminService = {
    async getTotalNewsCount() {
        try {
            const result = await db('News').count('Id_News as total');
            return result[0].total
        }
        catch (error) {
            console.error("Lỗi khi đếm số lượng bản ghi:", error);
        }
    },
    async getTotalUserCount() {
        try {
            const result = await db('User').count('Id_User as total');
            //console.log(`Tổng số lượng người dùng: ${result[0].total}`);
            return result[0].total
        }
        catch (error) {
            console.error("Lỗi khi đếm số lượng người dùng:", error);
        }
    },
    async getTotalStaffCount() {
        try {
            const totalAdmin = await db('Administrator').count('Id_User as totalAdmin')
            const totalEditor = await db('Editor').count('Id_User as totalEditor')
            const totalWriter = await db('Writer').count('Id_User as totalWriter')
            const totalStaff = totalAdmin[0].totalAdmin + totalEditor[0].totalEditor + totalWriter[0].totalWriter;
            return totalStaff
        }
        catch (error) {
            console.error("Lỗi khi đếm số lượng người dùng:", error);
        }
    },
    async getTotalAcceptNewsCount() {
        try {
            const result = await db('News')
                .where('Id_Status', 'STS0004')
                .count('Id_News as total');

            //console.log(`Tổng số lượng bản ghi có Id_Status = 'STS0004': ${result[0].total}`);
            return result[0].total
        } catch (error) {
            console.error("Lỗi khi đếm số lượng:", error);
        }
    },
    async getTotalNotAcceptNewCount() {
        try {
            const result = await db('News')
                .where('Id_Status', 'STS0001')
                .count('Id_News as total');
            return result[0].total
        } catch (error) {
            console.error("Lỗi khi đếm số lượng:", error);
        }
    },
    async getTotalNotRefuseNewCount() {
        try {
            const result = await db('News')
                .where('Id_Status', 'STS0003')
                .count('Id_News as total');
            return result[0].total
        } catch (error) {
            console.error("Lỗi khi đếm số lượng:", error);
        }
    },
    async getTotalViewsByCategory() {
        try {
            const result = await db('Category')
                .leftJoin('SubCategory', 'Category.Id_Category', 'SubCategory.Id_Category')
                .leftJoin('News', 'SubCategory.Id_SubCategory', 'News.Id_SubCategory')
                .select('Category.Name')
                .sum('News.Views as totalViews')
                .groupBy('Category.Id_Category');

            //console.log("Tổng Views theo Category:", result);
            return result
        } catch (error) {
            console.error("Lỗi khi lấy tổng Views:", error);
        }
    },
    async getViewsByCategoryAndQuater() {

        try {

            return db('Category')
                .leftJoin('SubCategory', 'Category.Id_Category', 'SubCategory.Id_Category')
                .leftJoin('News', 'SubCategory.Id_SubCategory', 'News.Id_SubCategory')
                .select('Category.Name as CategoryName')
                .sum({
                    Q1: db.raw(`CASE WHEN QUARTER(News.Date) = 1 THEN News.Views ELSE 0 END`),
                    Q2: db.raw(`CASE WHEN QUARTER(News.Date) = 2 THEN News.Views ELSE 0 END`),
                    Q3: db.raw(`CASE WHEN QUARTER(News.Date) = 3 THEN News.Views ELSE 0 END`),
                    Q4: db.raw(`CASE WHEN QUARTER(News.Date) = 4 THEN News.Views ELSE 0 END`)
                })
                .where('Category.Status', 1)
                .groupBy('Category.Id_Category', 'Category.Name');
        }
        catch (error) {
            console.error("Lỗi khi lấy tổng Views theo quý:", error);
        }

    },
    async getViewsbyCategory() {
        try {
            const result = await db('Category')
                .leftJoin('SubCategory', 'Category.Id_Category', 'SubCategory.Id_Category')
                .leftJoin('News', 'SubCategory.Id_SubCategory', 'News.Id_SubCategory')
                .select('Category.Name as CategoryName')
                .sum('News.Views as TotalViews')
                .where('Category.Status', 1)
                .groupBy('Category.Id_Category', 'Category.Name');

            return result
        } catch (error) {
            console.error("Lỗi khi lấy tổng Views theo Category:", error);

        }
    },
    async getUserInfor() {
        try {
            const result = await db('User')
                .select(
                    'User.Id_User',
                    'User.Name',
                    'User.Birthday',
                    'User.Email',
                    db.raw(`
      CASE 
        WHEN Editor.Id_Editor IS NOT NULL THEN 'Editor'
        WHEN Writer.Id_Writer IS NOT NULL THEN 'Writer'
        WHEN Subcriber.Id_Subcriber IS NOT NULL THEN 'Subscriber'
        ELSE 'User'
      END AS Role
    `)
                )
                .leftJoin('Editor', 'User.Id_User', 'Editor.Id_User')
                .leftJoin('Writer', 'User.Id_User', 'Writer.Id_User')
                .leftJoin('Subcriber', 'User.Id_User', 'Subcriber.Id_User')
            return result;
        }
        catch (error) {
            console.error("Lỗi khi lấy tổng Infor User:", error);
        }
    },
    async getUserInforById(id_user) {

        try {
            const result = await db('User')
                .select(
                    'User.Id_User',
                    'User.Name',
                    'User.Birthday',
                    'User.Email',
                    db.raw(`
      CASE 
        WHEN Editor.Id_Editor IS NOT NULL THEN 'Editor'
        WHEN Writer.Id_Writer IS NOT NULL THEN 'Writer'
        WHEN Subcriber.Id_Subcriber IS NOT NULL THEN 'Subscriber'
        ELSE 'User'
      END AS Role
    `),
    db.raw(`
        CASE 
          WHEN Writer.Id_Writer IS NOT NULL THEN Writer.Pen_Name
          ELSE NULL
        END AS Pen_Name
      `)
                )
                .leftJoin('Editor', 'User.Id_User', 'Editor.Id_User')
                .leftJoin('Writer', 'User.Id_User', 'Writer.Id_User')
                .leftJoin('Subcriber', 'User.Id_User', 'Subcriber.Id_User')
                .where('User.Id_User', id_user) // Thêm điều kiện để lấy thông tin cho một người dùng cụ thể
                .first(); // Sử dụng `.first()` để lấy kết quả đầu tiên (một bản ghi duy nhất)


            return result;
        } catch (err) {
            console.error(err);
        }

    },
    async addUsertoSubcriber(entity){
        try {
                    const lastSubcriber = await db('Subcriber')
                        .orderBy('Id_Subcriber', 'desc')
                        .first();
        
                    // Tạo ID mới
                    let newId;
                    if (!lastSubcriber) {
                        // Nếu chưa có user nào
                        newId = 'SUBC0001';
                    } else {
                        // Lấy số từ ID cuối cùng và tăng lên 1
                        const lastNumber = parseInt(lastSubcriber.Id_Subcriber.slice(4));
                        newId = `SUBC${String(lastNumber + 1).padStart(4, '0')}`;
                    }
        
                    // Gán ID mới vào entity

                    // Thêm user mới vào database
                    const ids = await db('Subcriber').insert(entity);
                    return ids[0];
                } catch (error) {
                    console.error(' error:', error);
                    throw error;
                }
    }
}
export default adminService