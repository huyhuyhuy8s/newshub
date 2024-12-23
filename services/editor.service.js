import db from '../utils/db.js';
import moment from 'moment'

const editorService = {
    async countNewsStatusByUserId(Id_user, date) {
        try {
            
            const result = await db('News')
            .join('SubCategory', 'News.Id_SubCategory', 'SubCategory.Id_SubCategory')
            .join('Category', 'SubCategory.Id_Category', 'Category.Id_Category')
            .join('Editor', 'Category.Id_Category', 'Editor.Id_Category')
            .join('Status_Of_News', 'News.Id_Status', 'Status_Of_News.Id_Status')
            .where('Editor.Id_User', Id_user)
            .andWhere(db.raw('DATE(News.Date) = ?', [date]))  // filter by the specific date
            .select('Status_Of_News.Title_Status as title_status')
            .count('News.Id_News as count')
            .groupBy('Status_Of_News.Title_Status')  // Group by status
            .orderBy('title_status');  // Order by status or as needed
      
          // If there are no results for a specific title_status, we manually return that as 0
          const statusList =  ['Đồng ý', 'Chưa duyệt', 'Chưa đạt','Đã xoá'];; // Example of all possible status values
          const countMap = result.reduce((acc, row) => {
            acc[row.title_status] = row.count;
            return acc;
          }, {});
          const finalResult = statusList.map(status => ({
            title_status: status,
            count: countMap[status] || 0
          }));
                const entity = {
                    date: date,
                    statuses: finalResult
                  };
                  return entity;
        }
        catch (error) {
            console.error('Error in countNewsStatusByUserId:', error);
            throw error;
        }
    }

}
export default editorService