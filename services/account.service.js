import db from '../utils/db.js';
import bcrypt from 'bcryptjs';
import nodemailer from 'nodemailer';
import randomstring from 'randomstring';
export default {
    async add(entity) {
        try {
            // Hash password trước khi lưu
            const salt = bcrypt.genSaltSync(10);
            entity.Password = bcrypt.hashSync(entity.Password, salt);

            // Thêm user mới vào database
            const ids = await db('User').insert(entity);
            return ids[0];
        } catch (error) {
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
    }




}