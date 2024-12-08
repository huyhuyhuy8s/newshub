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
    }
}