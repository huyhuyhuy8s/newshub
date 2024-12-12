import db from '../utils/db.js';

const newsService = {
    async findById(newsId) {
        try {
            const news = await db('News as n')
                .join('SubCategory as s', 'n.Id_SubCategory', 's.Id_SubCategory')
                .join('Category as c', 's.Id_Category', 'c.Id_Category')
                //.join('Writer as w', 'n.Id_Writer', 'w.Id_Writer')
                .where('n.Id_News', newsId)
                .select(
                    'n.*',
                    's.Name as SubCategoryName',
                    'c.Name as CategoryName'
                   // 'w.Name as WriterName'
                )
                .first();
            
            return news;
        } catch (error) {
            console.error('Database error:', error);
            throw error;
        }
    },

    async getNewsTags(newsId) {
        try {
            const tags = await db('News_Tag as nt')
                .join('Tag as t', 'nt.Id_Tag', 't.Id_Tag')
                .where('nt.Id_News', newsId)
                .select('t.Name as TagName');
            return tags;
        } catch (error) {
            console.error('Database error:', error);
            throw error;
        }
    }
};

export default newsService;
