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
import searchRouter from './routes/search.route.js';
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

// Middleware
app.use(express.json()); // hỗ trợ phần comment
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

        // nếu title dài trên 50 ký tự thì sẽ cắt bớt và thêm "..."
        truncateText: (text, length) => {
            if (text.length <= length) return text;
            return text.substring(0, length) + '...';
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

//  middleware để xử lý auth cho toàn bộ ứng dụng
app.use(function (req, res, next) {
    res.locals.auth = req.session.auth;
    res.locals.authUser = req.session.authUser; // Thống nhất dùng authUser
    next();
});

app.set('view engine', 'hbs');
app.set('views', join(__dirname, 'views'));

// Cấu hình views
app.set('views', __dirname + '/views');

// Cấu hình static files
app.use('/Login', express.static(__dirname + '/views/Login'));
app.use('/Home', express.static(__dirname + '/views/Home'));
app.use('/ChuyenMuc', express.static(__dirname + '/views/ChuyenMuc'));


// Middleware

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Gắn route login
app.use('/api', LoginRoute);

// Gắn route cho đăng ký
app.use('/api/register', RegisterRoute);


app.use(express.static(path.join(__dirname, 'views'))); // Thêm views vào thư mục tĩnh

app.get('/register', (req, res) => {
    res.sendFile(path.join(__dirname, 'views/Login/register.html'));
});


app.get('/login', (req, res) => {
    res.sendFile(path.join(__dirname, 'views/Login/login.html'));
});

app.get('/register/otp', (req, res) => {
    res.sendFile(path.join(__dirname, 'views/Login/otp.html'))
})

app.get('/home', (req, res) => {
    res.sendFile(path.join(__dirname, 'views/Home/home.html'));
});

// Khởi động server
app.listen(3000, function () {
    console.log('Server started on http://localhost:3000');
});
