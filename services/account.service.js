import db from '../utils/db.js';
import bcrypt from 'bcryptjs';
import nodemailer from 'nodemailer';
import randomstring from 'randomstring';
import moment from 'moment'
export default {
    async add(entity) {
        try {
            const lastUser = await db('User')
                .orderBy('Id_User', 'desc')
                .first();

            // Tạo ID mới
            let newId;
            if (!lastUser) {
                newId = 'USR0001'; // Nếu chưa có user nào
            } else {
                const lastNumber = parseInt(lastUser.Id_User.slice(3)); // Lấy số từ ID cuối cùng
                newId = `USR${String(lastNumber + 1).padStart(4, '0')}`; // Tạo ID mới
            }
            // Hash password trước khi lưu
            const salt = bcrypt.genSaltSync(10);
            entity.Password = bcrypt.hashSync(entity.Password, salt);

            entity.Id_User = newId;
            entity.Date_register = new Date(); // Lấy thời gian hiện tại
            // Thêm user mới vào database
            const ids = await db('User').insert(entity);
            return ids[0];
        }
        catch (error) {
            console.error('Registration error:', error);
            throw error;
        }
    },
    async validateUser(email, password) {
        try {
            // Tìm user theo email
            const user = await db('User')
                .where('Email', email)
                .first();

            // Nếu không tìm thấy user
            if (!user) {
                return {
                    error: true,
                    message: 'Tài khoản không tồn tại!'
                };
            }

            // Kiểm tra password
            const match = bcrypt.compareSync(password, user.Password);
            if (!match) {
                return {
                    error: true,
                    message: 'Mật khẩu không chính xác!'
                };
            }

            // Nếu đúng, trả về thông tin user (trừ password)
            delete user.Password;
            return {
                error: false,
                user: user
            };

        } catch (error) {
            console.error('Login validation error:', error);
            throw error;
        }
    },
    generateOTP() {
        return randomstring.generate({ length: 6, charset: 'numeric' })
    },

    sendOTP(email, otp) {
        const mailOptions = {
            from: 'bacviplata123@gmail.com',
            to: email,
            subject: 'OTP Verification',
            text: `Your OTP  for verification is:${otp}`
        };

        let transporter = nodemailer.createTransport({
            service: 'gmail',
            auth: {
                user: 'bacviplata123@gmail.com',
                pass: 'hfbx xjjm dblz nlli'
            }

        })

        transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
                console.log('Error is:', error)
            }
            else {
                console.log('OTP email sent succesfully', info.respone)
            }
        })
    },

    // 20/12
    async getSubscriberInfoByUserId(userId) {
        try {
            const subscriber = await db('Subcriber')
                .where('Id_User', userId)
                .first(); // Lấy thông tin subscriber đầu tiên

            return subscriber; // Trả về thông tin subscriber nếu tồn tại, nếu không sẽ trả về null
        } catch (error) {
            console.error('Error fetching subscriber info:', error);
            throw error;
        }
    },

    async getUserRoles(userId) {
        try {
            const roles = {
                isAdmin: false,
                isEditor: false,
                isWriter: false,
                adminId: null,
                editorId: null,
                writerId: null,
            };

            // Kiểm tra Admin
            const admin = await db('Administrator')
                .where('Id_User', userId)
                .first();
            if (admin) {
                roles.isAdmin = true;
                roles.adminId = admin.Id_Administrator; // Lưu Id_Admin
            }

            // Kiểm tra Editor
            const editor = await db('Editor')
                .where('Id_User', userId)
                .first();
            if (editor) {
                roles.isEditor = true;
                roles.editorId = editor.Id_Editor; // Lưu Id_Editor
            }

            // Kiểm tra Writer
            const writer = await db('Writer')
                .where('Id_User', userId)
                .first();
            if (writer) {
                roles.isWriter = true;
                roles.writerId = writer.Id_Writer; // Lưu Id_Writer
            }

            return roles; // Trả về đối tượng chứa các quyền
        } catch (error) {
            console.error('Error fetching user roles:', error);
            throw error;
        }
    },
    async findOrCreateGoogleUser(googleProfile) {
        const { emails, displayName } = googleProfile;
        const email = emails[0].value;
        // tìm thử có trong db chưa

        let user = await db('User').where('Email', email).first();

        if (!user) {

            const name = displayName;
            // set password mặc định
            const password = 'password123'
            const salt = bcrypt.genSaltSync(10);
            const hashPassword = bcrypt.hashSync(password, salt);

            //user = await db('users').where({ id: userId }).first();
            const lastUser = await db('User')
                .orderBy('Id_User', 'desc')
                .first();

            // Tạo ID mới
            let newId;
            if (!lastUser) {
                newId = 'USR0001'; // Nếu chưa có user nào
            } else {
                const lastNumber = parseInt(lastUser.Id_User.slice(3)); // Lấy số từ ID cuối cùng
                newId = `USR${String(lastNumber + 1).padStart(4, '0')}`; // Tạo ID mới
            }

            const entity = {
                Name: name,
                Email: email,
                Password: hashPassword,
                Birthday: moment().subtract(26, 'years').format('YYYY-MM-DD'),
                Id_User: 'USR' + Math.floor(Math.random() * 10000).toString().padStart(4, '0')
            };

            entity.Id_User = newId;
            entity.Date_register = new Date(); // Lấy thời gian hiện tại
            // Lưu vào database
            //await registerService.add(entity);
            const ids = await db('User').insert(entity);
            return entity

        }
        return user;
    },

}