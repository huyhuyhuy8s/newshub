import db from '../utils/db.js';
import moment from 'moment';

const writerService = {
    async findStatus(id_status) {
        try {
            return await db('status_of_news').where('Id_Status', id_status).first();
        }
        catch (error) {
            console.error("status not found", error);
        }
    },
    async findWriter(id_user) {
        try {
            const writer = await db('writer').where('Id_User', id_user).first();
            return writer ? writer.Id_Writer : null;;
        }
        catch (error) {
            console.error("Khong tim thay writer");
        }
    },
    async addData(news) {
        try {
            const lastNews = await db('News')
                .orderBy('Id_News', 'desc')
                .first();

            // Tạo ID mới
            let newId;
            if (!lastNews) {
                newId = 'NEWS0001';
            } else {
                const lastNumber = parseInt(lastNews.Id_News.slice(4));
                newId = `NEWS${String(lastNumber + 1).padStart(4, '0')}`;
            }

            news.Id_News = newId;
            const currentDate = moment();
            news.Date = currentDate.toDate();
            news.Views = 0;

            // console.log(news);
            // console.log(news.Content);
            const ret = await db('News').insert(news);
            // console.log(ret.Content);
            // console.log(ret, 'succ');
        }
        catch (error) {
            console.error(error);
        }
    },
    async findAllPost(id_writer) {
        console.log(id_writer);
        return await db("News").where('Id_Writer', id_writer);
    }
}
export default writerService