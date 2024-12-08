import db from '../utils/db.js';

// export default {
//     async findAllActive() {
//         try {
//             const results = await db('Category')
//                 .where('Status', 1)
//                 .orderBy('Id_Category');

//             // console.log('Categories from database:', results);
//             return results;
//         } catch (error) {
//             console.error('Database error:', error);
//             throw error;
//         }
//     }
// }
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

    async getNewsByCategory(categoryId) {
        try {
            const news = await db('News as n')
                .join('SubCategory as s', 'n.Id_SubCategory', 's.Id_SubCategory')
                .join('Category as c', 's.Id_Category', 'c.Id_Category')
                .where({
                    'c.Id_Category': categoryId,
                    'c.Status': 1,
                    'n.Id_Status': 'STS0001'  // Status đã xuất bản
                })
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
    }


}