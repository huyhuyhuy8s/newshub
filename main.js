import express from 'express';
import { engine } from 'express-handlebars';
import { dirname, join } from 'path';
import { fileURLToPath } from 'url';
import session from 'express-session';
import numeral from 'numeral';
import hbs_section from 'express-handlebars-sections';
import accountRouter from './routes/account.route.js';
import categoryService from './services/category.service.js';
import categoryRouter from './routes/category.route.js';
import detailNewsRouter from './routes/detailnews.route.js';
import homeRouter from './routes/home.route.js';
import searchnewsRouter from './routes/searchnews.route.js';
import inforUserRouter from './routes/inforuser.route.js';
import adminRouter from './routes/admin.route.js';
import editorRouter from './routes/editor.route.js';
import writerRouter from './routes/writer.route.js';
import moment from 'moment';


const app = express();
const __dirname = dirname(fileURLToPath(import.meta.url));
// Session configuration
app.set('trust proxy', 1);
app.use(session({
    secret: 'keyboard cat',
    resave: false,
    saveUninitialized: false,
    cookie: {
        secure: false,
        httpOnly: true,
        maxAge: 3600000,
    },
}));
app.use(express.json()); // This allows Express to parse JSON request bodies
// Middleware
app.use(express.urlencoded({ extended: true }));
app.use(express.static(__dirname + '/static'));
app.use('/imgs', express.static(join(__dirname, 'imgs')));
// Handlebars configuration
app.engine('hbs', engine({
    extname: 'hbs',
    defaultLayout: 'main',
    layoutsDir: join(__dirname, 'views/layouts'),
    partialsDir: join(__dirname, 'views/partials'),
    helpers: {
        format_number(value) {
            return numeral(value).format('0,0') + ' vnd';
        },
        fillHtmlContent: hbs_section(),




        toLowerCase(str) {
            // console.log('toLowerCase input:', str);
            if (!str) return '';
            const result = str.toLowerCase().replace(/\s+/g, '-');
            // console.log('toLowerCase output:', result);
            return result;
        },
        formatName(str) {
            // console.log('formatName input:', str);
            if (!str) return '';
            return str;
        },
        eq(v1, v2) {
            // console.log('eq comparing:', v1, v2);
            return v1 === v2;
        },
        formatDate: (date) => {
            const d = new Date(date);
            const day = d.getDate().toString().padStart(2, '0');
            const month = (d.getMonth() + 1).toString().padStart(2, '0');
            const year = d.getFullYear();
            return `Ngày đăng: ${day}/${month}/${year}`;
        },

        formatDateInfor: (date) => {
            const d = new Date(date);
            const year = d.getFullYear();
            const month = (d.getMonth() + 1).toString().padStart(2, '0'); // Thêm 1 vì tháng bắt đầu từ 0
            const day = d.getDate().toString().padStart(2, '0');
            return `${year}-${month}-${day}`; // Định dạng theo YYYY-MM-DD
        },

        // nếu title dài trên 50 ký tự thì sẽ cắt bớt và thêm "..."
        truncateText: (text, length) => {
            if (text.length !== null) {
                if (text.length <= length) return text;
                return text.substring(0, length) + '...';
            }
        },

        // helper mới để tính thời gian
        timeAgo: (date) => {
            const now = new Date();
            const postDate = new Date(date);
            const diffTime = Math.abs(now - postDate);
            const diffDays = Math.floor(diffTime / (1000 * 60 * 60 * 24));

            if (diffDays === 0) {
                const diffHours = Math.floor(diffTime / (1000 * 60 * 60));
                if (diffHours === 0) {
                    const diffMinutes = Math.floor(diffTime / (1000 * 60));
                    return `${diffMinutes} phút trước`;
                }
                return `${diffHours} giờ trước`;
            }

            // Thêm logic xử lý tháng
            if (diffDays >= 30) {
                const diffMonths = Math.floor(diffDays / 30);
                if (diffMonths === 1) {
                    return '1 tháng trước';
                }
                if (diffMonths < 12) {
                    return `${diffMonths} tháng trước`;
                }
                // Nếu trên 12 tháng thì hiển thị năm
                const diffYears = Math.floor(diffMonths / 12);
                if (diffYears === 1) {
                    return '1 năm trước';
                }
                return `${diffYears} năm trước`;
            }

            return `${diffDays} ngày trước`;
        },
        // formatCountDaysRegisterAccount: function(dateString) {
        //     const dateRegister = new Date(dateString);
        //     const today = new Date();
        //     const diffTime = Math.abs(today - dateRegister);
        //     const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
        //     return diffDays;
        // },
        formatCountDaysRegisterAccount: function (dateRegisterString, dateExpiredString) {
            const dateRegister = new Date(dateRegisterString);
            const dateExpired = new Date(dateExpiredString);
            const today = new Date();

            let diffDays;

            if (dateExpired > today) {
                // Nếu ngày hết hạn sau ngày hiện tại
                const diffTime = Math.abs(today - dateRegister);
                diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); // Tính số ngày từ ngày đăng ký đến hôm nay
            } else {
                // Nếu ngày hết hạn trước ngày hiện tại
                const diffTime = Math.abs(dateExpired - dateRegister);
                diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); // Tính số ngày từ ngày đăng ký đến ngày hết hạn
            }

            return diffDays;
        },
        formatDayExpiredAccount: function (dateString) {
            const d = new Date(dateString);
            const day = d.getDate().toString().padStart(2, '0');
            const month = (d.getMonth() + 1).toString().padStart(2, '0'); // Thêm 1 vì tháng bắt đầu từ 0
            const year = d.getFullYear();
            const hours = d.getHours().toString().padStart(2, '0');
            const minutes = d.getMinutes().toString().padStart(2, '0');
            return `${day}/${month}/${year} ${hours}:${minutes}`; // Định dạng theo dd/mm/yyyy hh:mm
        }
    },
}));

// Thêm middleware để load categories
app.use(async function (req, res, next) {
    try {
        const categories = await categoryService.findAllActive();

        // // Tạo một bản sao của categories để xử lý log
        // const categoriesForLog = categories.map(category => ({
        //     Name: category.Name,
        //     Status: category.Status[0],
        //     // Chuyển SubCategories thành string trên cùng một hàng
        //     SubCategories: `[${category.SubCategories.map(sub =>
        //         `{${sub.Name}}`
        //     ).join(', ')}]`
        // }));
        // console.log('Categories loadedddd:', categoriesForLog);

        if (!categories || categories.length === 0) {
            console.log('No categories found');
        }
        res.locals.lcCategories = categories;
        next();
    } catch (err) {
        console.error('Failed to load categories:', err);
        next(err);
    }
});

app.set('view engine', 'hbs');
app.set('views', join(__dirname, 'views'));

//  middleware để xử lý auth cho toàn bộ ứng dụng
app.use(function (req, res, next) {
    res.locals.auth = req.session.auth;
    res.locals.authUser = req.session.authUser; // Thống nhất dùng authUser
    next();
});


app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use('/account', accountRouter);

app.use('/', homeRouter);
app.use('/category', categoryRouter);
app.use('/account', accountRouter);
app.use('/news', detailNewsRouter);
app.use('/search', searchnewsRouter);
app.use('/inforuser', inforUserRouter);
app.use('/dashboard', adminRouter);
app.use('/editor', editorRouter);
app.use('/writer', writerRouter);


// Server setup
app.listen(3000, () => {
    console.log('Server started on http://localhost:3000');
});