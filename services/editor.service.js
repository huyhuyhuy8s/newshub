import db from '../utils/db.js';
import moment from 'moment';

const editorService = {
    async findEditor(id_user) {
        try {
            const result = await db('Editor').where('Id_User', id_user).first();
            return result.Id_Editor;
        }
        catch (error) {
            console.error("Lỗi khi tìm kiếm editor:", error);
        }
    },
    async findAllPost(editorId) {
        try {
            const editor = await db('Editor').where('Id_Editor', editorId).first();
            if (!editor) return [];

            const { Id_Category } = editor;

            const subCategories = await db('SubCategory').where('Id_Category', Id_Category).select('Id_SubCategory');

            const posts = await db('News')
                .join('Writer', 'News.Id_Writer', '=', 'Writer.Id_Writer')
                .whereIn('Id_SubCategory', subCategories.map(sub => sub.Id_SubCategory))
                .select('News.*', 'Writer.Pen_Name');

            const formattedPosts = posts.map(post => ({
                ...post,
                Premium: post.Premium.equals(Buffer.from([1]))
            }));

            return formattedPosts;
        } catch (error) {
            console.error("Lỗi khi tìm kiếm bài viết của editor:", error);
            return [];
        }
    },

    async findNewsById(id_news) {
        try {
            const result = await db('News')
                .join('Writer', 'News.Id_Writer', '=', 'Writer.Id_Writer')
                .where('News.Id_News', id_news)
                .select('News.*', 'Writer.Pen_Name')
                .first();

            if (result) {
                result.Premium = result.Premium.equals(Buffer.from([1]));
                return result;
            } else {
                return null;
            }
        } catch (error) {
            console.error("Lỗi khi tìm kiếm bài viết:", error);
        }
    },
    async updateNewsPremium(id_news, newPremiumValue) {
        try {
            await db('News')
                .where('Id_News', id_news)
                .update({ Premium: newPremiumValue }); 
        } catch (error) {
            console.error("Lỗi khi cập nhật trạng thái Premium:", error);
        }
    },



    async findPostPerMonth() {
        try {
            const result = await db('editor').count('Id_News as total');
            return result[0].total
        }
        catch (error) {
            console.error("Lỗi khi đếm số lượng bản ghi:", error);
        }
    },
    async getRejectedArticles() {
        try {
            const result = await db('News')
                .join('Editor_Check_News', 'News.Id_News', '=', 'Editor_Check_News.Id_News')
                .join('Writer', 'News.Id_Writer', '=', 'Writer.Id_Writer') 
                .select('News.*', 'Editor_Check_News.Reason', 'Writer.Pen_Name')
                .where('News.Id_Status', 'STS0004'); 
            return result;
        } catch (error) {
            console.error("Lỗi khi lấy bài viết bị từ chối:", error);
            throw error;
        }
    },
    async addRejectionReason(id_news, reason, id_editor, date_feedback) {
        try {
            await db('Editor_Check_News').insert({
                Id_News: id_news,
                Reason: reason,
                Id_Editor: id_editor,
                Date_feedback: date_feedback,
            });
        } catch (error) {
            console.error("Lỗi khi thêm lý do từ chối:", error);
            throw error;
        }
    },
    
    async updateNewsStatus(id_news, new_status) {
        try {
            await db('News')
                .where('Id_News', id_news)
                .update({ Id_Status: new_status }); 
        } catch (error) {
            console.error("Lỗi khi cập nhật trạng thái bài viết:", error);
            throw error;
        }
    },




    async getWritersWithStatusCount(editorId) {
        try {
            const editor = await db('Editor').select('Id_Category').where('Id_Editor', editorId).first();
            
            if (!editor) {
                throw new Error('Editor không tồn tại');
            }
    
            const result = await db('Writer')
                .leftJoin('News', 'Writer.Id_Writer', '=', 'News.Id_Writer')
                .select('Writer.Id_Writer', 'Writer.Pen_Name')
                .count({ approved: db.raw('CASE WHEN News.Id_Status = "STS0001" THEN 1 END') })
                .count({ pending: db.raw('CASE WHEN News.Id_Status = "STS0002" THEN 1 END') })
                .count({ not_passed: db.raw('CASE WHEN News.Id_Status = "STS0003" THEN 1 END') })
                .count({ rejected: db.raw('CASE WHEN News.Id_Status = "STS0004" THEN 1 END') })
                .where('Writer.Id_Category', editor.Id_Category) // Lọc Writer theo Id_Category của Editor
                .groupBy('Writer.Id_Writer', 'Writer.Pen_Name');
    
            return result;
        } catch (error) {
            console.error("Lỗi khi lấy thông tin Writer:", error);
            throw error;
        }
    },
    async getUserById(id_user) {
        try {
            const user = await db('User')
                .where('Id_User', id_user)
                .first(); 

            if (!user) {
                throw new Error('Người dùng không tồn tại');
            }

            return user; 
        } catch (error) {
            console.error("Lỗi khi lấy thông tin người dùng:", error);
            throw error; 
        }
    },
    async updateUser(id_user, updatedUser) {
        try {
            await db('User')
                .where('Id_User', id_user)
                .update(updatedUser); 
        } catch (error) {
            console.error("Lỗi khi cập nhật thông tin người dùng:", error);
            throw error; 
        }
    },
    async updateNewsDate(id_news, date) {
        try {
            await db('News')
                .where('Id_News', id_news)
                .update({ Date: moment(date).format('YYYY-MM-DD HH:mm:ss') }); // Cập nhật ngày
        } catch (error) {
            console.error("Lỗi khi cập nhật ngày bài viết:", error);
            throw error; // Ném lỗi để xử lý ở route
        }
    }


}
export default editorService