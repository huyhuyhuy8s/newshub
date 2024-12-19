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
}
export default writerService