import db from '../utils/db.js';

const searchService = {
    async searchNews(query) {
        try {
            const results = await db('News as n')
                .join('News_Tag as nt', 'n.Id_News', 'nt.Id_News')
                .join('Tag as t', 'nt.Id_Tag', 't.Id_Tag')
                .whereRaw('MATCH(n.title, n.content, n.Meta_title, n.Meta_description) AGAINST(? IN BOOLEAN MODE)', [query])
                .orWhere('t.Name', 'LIKE', `%${query}%`)
                .select('n.*')
                .distinct()
                .orderByRaw('MATCH(n.title, n.content, n.Meta_title, n.Meta_description) AGAINST(? IN BOOLEAN MODE) DESC', [query]); // Sắp xếp theo độ liên quan
            return results;
        } catch (error) {
            console.error('Database error:', error);
            throw error;
        }
    },
   



    async getAllCategories() {
        return await db('Category')
            .where('Status', 1) // Lấy tất cả các category có Status = 1
            .select('*'); // Chọn tất cả các trường
    },
    async getAllTags() {
        return await db('Tag').select('*'); // Lấy tất cả các tags
    },
    async getSubCategories() {
        return await db('SubCategory').select('*');
    },

    async getTagsByNewsId(newsId) {
        try {
            const tags = await db('News_Tag as nt')
                .join('Tag as t', 'nt.Id_Tag', 't.Id_Tag')
                .where('nt.Id_News', newsId)
                .select('t.Name'); // Lấy tên tag
            return tags;
        } catch (error) {
            console.error('Database error:', error);
            throw error;
        }
    },
    async getSubCategoriesByCategoryId(categoryId) {
        try {
            const subcategories = await db('SubCategory')
                .where('Id_Category', categoryId)
                .select('*'); // Lấy tất cả các subcategory có Id_Category tương ứng
            return subcategories;
        } catch (error) {
            console.error('Database error:', error);
            throw error;
        }
    },
    async searchNewsByFilters(category, subcategory, tags, startDate, endDate) {
        try {
            const query = db('News as n')
                .join('SubCategory as sc', 'n.Id_SubCategory', 'sc.Id_SubCategory') // Join với bảng SubCategory
                .join('News_Tag as nt', 'n.Id_News', 'nt.Id_News')
                .join('Tag as t', 'nt.Id_Tag', 't.Id_Tag')
                .join('Category as c', 'sc.Id_Category', 'c.Id_Category'); // Join với bảng Category

            // Lọc theo category nếu có
            if (category) {
                query.where('c.Id_Category', category); // Sử dụng Id_Category từ bảng Category
            }

            // Lọc theo subcategory nếu có
            if (subcategory) {
                query.where('n.Id_SubCategory', subcategory);
            }

            // Lọc theo tag nếu có
            if (tags) {
                query.where('t.Id_Tag', tags);
            }

            // Lọc theo ngày nếu có
            if (startDate) {
                query.where('n.Date', '>=', startDate);
            }
            if (endDate) {
                query.where('n.Date', '<=', endDate);
            }
            query.where('n.Id_Status', 'STS0001'); // Điều kiện Status
            // Thực thi truy vấn và trả về kết quả
            const results = await query.select('n.*').distinct().limit(15); // Thêm distinct để loại bỏ bản sao
            //console.log('Query Results:', results); // Log kết quả
            return results;
        } catch (error) {
            console.error('Error searching news by filters:', error);
            throw error; // Ném lại lỗi để xử lý ở nơi gọi phương thức này
        }
    },

};

export default searchService;
