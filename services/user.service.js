import db from '../utils/db.js';

export default {
    add(entity) {
        return db('user').insert(entity);
    },

    findByEmail(email) {
        return db('user').where('email', email).first();
    }
}