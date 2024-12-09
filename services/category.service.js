import db from '../utils/db.js';


export default {
    // Thêm hàm findById
    async findById(categoryId) {
        try {
            const category = await db('Category')
                .where('Id_Category', categoryId)
                .andWhere('Status', 1)
                .first();

            // Lấy subcategories của category này
            if (category) {
                const subcategories = await db('SubCategory')
                    .where('Id_Category', categoryId)
                    .select('*');
                category.SubCategories = subcategories;
            }

            return category;
        } catch (error) {
            console.error('Database error:', error);
            throw error;
        }
    },

    async findAllActive() {
        try {
            const results = await db('Category')
                .leftJoin('SubCategory', 'Category.Id_Category', 'SubCategory.Id_Category')
                .select(
                    'Category.Id_Category',
                    'Category.Name',
                    'Category.Status',
                    'SubCategory.Id_SubCategory',
                    'SubCategory.Name as SubCategoryName' // Đặt alias rõ ràng
                )
                .where('Category.Status', 1)
                .orderBy('Category.Id_Category');

            const categories = [];
            let currentCategory = null;

            results.forEach(row => {
                if (!currentCategory || currentCategory.Id_Category !== row.Id_Category) {
                    currentCategory = {
                        Id_Category: row.Id_Category,
                        Name: row.Name,
                        Status: row.Status,
                        SubCategories: []
                    };
                    categories.push(currentCategory);
                }

                if (row.Id_SubCategory) {
                    currentCategory.SubCategories.push({
                        Id_SubCategory: row.Id_SubCategory,
                        Name: row.SubCategoryName // Sử dụng tên đã được alias
                    });
                }
            });

            return categories;
        } catch (error) {
            console.error('Database error:', error);
            throw error;
        }
    },

   

    // tối 9/12/2024
    async getNewsByCategory(categoryId) {
        try {
            // Tính thời điểm 7 ngày trước
            const sevenDaysAgo = new Date();
            sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);

            const news = await db('News as n')
                .join('SubCategory as s', 'n.Id_SubCategory', 's.Id_SubCategory')
                .join('Category as c', 's.Id_Category', 'c.Id_Category')
                .where({
                    'c.Id_Category': categoryId,
                    'c.Status': 1,
                    'n.Id_Status': 'STS0001'  // Status đã xuất bản
                })
                // .andWhere('n.Date', '>=', oneMonthAgo) // Thêm điều kiện lọc theo thời gian
                .andWhere('n.Date', '>=', sevenDaysAgo) // Thêm điều kiện lọc theo thời gian
                .select(
                    'n.Id_News',
                    'n.Title',
                    'n.Meta_title',
                    'n.Meta_description',
                    'n.Date',
                    'n.Image',
                    'n.Views'
                )
                .orderBy('n.Views', 'desc');

            console.log('News found:', news.length);
            return news;
        } catch (error) {
            console.error('Database error:', error);
            throw error;
        }

    },

    async getTopSubCategoriesByViews(categoryId) {
        try {
            // Tính thời điểm 1 tháng trước
            const oneMonthAgo = new Date();
            oneMonthAgo.setMonth(oneMonthAgo.getMonth() - 1);

            // Lấy top 3 subcategories
            const topSubcategories = await db('SubCategory as s')
                .join('News as n', 's.Id_SubCategory', 'n.Id_SubCategory')
                .where('s.Id_Category', categoryId)
                .andWhere('n.Id_Status', 'STS0001')
                .andWhere('n.Date', '>=', oneMonthAgo)
                .groupBy('s.Id_SubCategory', 's.Name')
                .select(
                    's.Id_SubCategory',
                    's.Name as SubCategoryName',
                    db.raw('SUM(n.Views) as TotalViews')
                )
                .orderBy('TotalViews', 'desc')
                .limit(3);

            // Lấy bài viết cho mỗi subcategory
            for (let sub of topSubcategories) {
                // Lấy bài viết nổi bật nhất (top 1)
                const highlightPost = await db('News')
                    .where({
                        'Id_SubCategory': sub.Id_SubCategory,
                        'Id_Status': 'STS0001'
                    })
                    .andWhere('Date', '>=', oneMonthAgo)
                    .select('Id_News', 'Meta_title', 'Image', 'Date')
                    .orderBy('Views', 'desc')
                    .first();

                // Lấy 3 bài viết tiếp theo
                const otherPosts = await db('News')
                    .where({
                        'Id_SubCategory': sub.Id_SubCategory,
                        'Id_Status': 'STS0001'
                    })
                    .andWhere('Date', '>=', oneMonthAgo)
                    .select('Id_News', 'Meta_title', 'Image', 'Date')
                    .orderBy('Views', 'desc')
                    .offset(1)
                    .limit(3);

                sub.highlightPost = highlightPost;
                sub.otherPosts = otherPosts;
            }

            return topSubcategories;
        } catch (error) {
            console.error('Database error:', error);
            throw error;
        }
    },

    async getRecentNewsByCategory(categoryId) {
        try {
            const news = await db('News as n')
                .join('SubCategory as s', 'n.Id_SubCategory', 's.Id_SubCategory')
                .join('Category as c', 's.Id_Category', 'c.Id_Category')
                .where({
                    'c.Id_Category': categoryId,
                    'n.Id_Status': 'STS0001'
                })
                .select(
                    'n.Id_News',
                    'n.Title',
                    'n.Meta_title',
                    'n.Meta_description',
                    'n.Date',
                    's.Name as SubCategoryName'
                )
                .orderBy('n.Date', 'desc');

            return news;
        } catch (error) {
            console.error('Database error:', error);
            throw error;
        }
    }
}