import db from '../utils/db.js';

export default {
    findAll() {
     
        return db('Category')
            .where('Status', 1)  
            .select('Id_Category', 'Name', 'Status');  
    }
};