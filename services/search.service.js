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
    }
};

export default searchService;
