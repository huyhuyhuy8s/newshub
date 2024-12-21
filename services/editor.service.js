import db from '../utils/db.js';

const editorService = {
    async findPostPerMonth() {
        try {
            const result = await db('editor').count('Id_News as total');
            return result[0].total
        }
        catch (error) {
            console.error("Lỗi khi đếm số lượng bản ghi:", error);
        }
    },
}
export default editorService