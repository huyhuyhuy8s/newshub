import db from '../utils/db.js';

const writerService = {
    // async findPostPerMonth() {
    //     try {
    //         const result = await db('Editor').count('Id_News as total');
    //         return result[0].total
    //     }
    //     catch (error) {
    //         console.error("Lỗi khi đếm số lượng bản ghi:", error);
    //     }
    // },
    async findWriter(id_user) {
        try {
            const writer = await db('writer').where('Id_User', id_user).first();
            return writer ? writer.Id_Writer : null;;
        }
        catch (error) {
            console.error("Khong tim thay writer");
        }
    },
    // async addData(news) {
    //     try {
    //         let value = {
    //             a: news,

    //         }
    //         db('news').insert()
    //         return "add data successed";
    //     }
    //     catch { }
    // }
    async countNewsStatusByUserId(Id_user, date) {
        try {

            const result = await db('News')
                .join('Writer', 'News.Id_Writer', 'Writer.Id_Writer')
                .join('Status_Of_News', 'News.Id_Status', 'Status_Of_News.Id_Status')
                .where('Writer.Id_User', Id_user)
                .andWhere(db.raw('DATE(News.Date) = ?', [date]))  // filter by the specific date
                .select('Status_Of_News.Title_Status as title_status')
                .count('News.Id_News as count')
                .groupBy('Status_Of_News.Title_Status')  // Group by status
                .orderBy('title_status');  // Order by status or as needed
            // If there are no results for a specific title_status, we manually return that as 0
            const statusList = ['Đồng ý', 'Chưa duyệt', 'Chưa đạt', 'Đã xoá'];; // Example of all possible status values
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
export default writerService