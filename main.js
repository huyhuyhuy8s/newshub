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
import { isAdmin, isEditor, isWriter } from './auth/auth.js';

import writerService from './services/writer.service.js';

import jwt from 'jsonwebtoken';
import cors from 'cors';
import moment from 'moment';

const privateKey = `
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAzcUruljbK9cWCYdPnTyAjn7IfpJB0SBNnRAQcLBjfh9MSZIH
C0tLGq4I22vxKO2jIwialdLhxxiG34fqNjruyzyWt+AIBPsgiuQZF86WUeao8HM0
FfSryNLHkFgwUxevULmzz7kNzHj3mOsPquDt7WJpOnd4jmASB7shaWsAKuVy+RNG
8GC5zeXgOqZXY54iXeTxjomBrNl6MSxT+GXLPkhC4/2B253HbCNmGHszHW1JtVwM
K2o1YAn9ZpcpywV9WYfyFgJk2JluITgrasLy3WWLKNKdlRHjE6+NcS+C68Coia6R
RW3m7ymFVIoyZF8S8rU/45ZdYv47qpisIZL6FQIDAQABAoIBABwBS0fD4yRu1A18
8H12aAq8v53WWwXSzy1iq9Iid5AJQ3E54iKL309kw0jVwo8u9IaGm79rYZYexPB0
R5CU6b4YY2zoHT9MTGwKyk1+rN+9tF1xWHPqhlzBLy76ia0taotiktHhHjsndY9G
4q1/inJF9AtkijBaa+nIcq4txWqQ7F8I2aOdY+3yVxGPkDf0STyPmxYeRQWpCVlq
n5RhxY6EtpGQu3j/GmtrEXC1GcfOK3z6XB7k4pll4zwmWAcT2TiVVDSGsKPU5t3e
oEzeU0PmihUCgxhgZqH1WAN8zr81Rb3PlXVr3iws5XVXtbdasLN3yMF/4xkkBkj5
0waJFBsCgYEA6SWJ03gauI7xGXTotXuQDKILPOCK+CIAQeJIQcMFeO1CMLsAWPjq
OsZDGK++TdxRaWjq/tihVHY0mQmzXRO1DNlK9oKBXDrVzKmiuSKdCNVf0qEpeJg5
B4/oePwKafJaRzEIyATgKI3IgG6vpNIlJEPN1dvtDBLK5efaCXUVVgcCgYEA4fCp
iLIBR1a93uYKRVg/aq3kTn9CMjxHBBZ3F8ps91cACovbE3QdFgLW732z8OyOg7gA
6e10f1JDW1InQbRKMDoE9tDibSCKMasWlRizlEtju2JgDdCPsq1SwUH9f2EncKfs
21kczUoWBOfFmXdK/l0mLVykNL2QEhGrctyXSAMCgYB/kyfgzCaq+KSbDmrL66n+
D6lgjWndrxU+9+gb+/ABpKoEaj8dcE8TDCvo1Tmn9zehG2UDQFy/D9NmLnW0J7V5
K2mmi/DnG9ajn+tHrNYK4F8HrWI49+q05Z0KnrfAE3os3Hr2oBxcdIDTLj30TX0/
Y869CBOk+J+HwB+B70xWfwKBgQCQLN5CGDSwrS1j+y86qOFu1aAGZzZ6j/RRK3S7
fbSi8KVaFXyqoUGeNhmpoXEdoBYg/1216IyaYogQ0g+y4bUlqSBZz1ltgYItx5sV
cTnGu4Tcoh3hMuE/h1JzeASnL/vW65E9N1Qlu8zpPGzfTTxRrGccMy2lagFxRk09
cn4muQKBgQDGSb5UtBGRB9GfpcUXsHFP7QNahM2by0wMM9+Vn4fx6ee6VVQhMrec
Q9uHmZfgVSPTGgcilQKoHx+eVkL1hqgkKFNCZEoGof7S7dXdg66bGHnt43SS0On6
lZPJ/Io4TlC0n383SKWq1xsUlezcOQjFCgbhi4YL9Wadt3uv190QXA==
-----END RSA PRIVATE KEY-----
`;

const app = express();
app.use(cors());
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
// This allows Express to parse JSON request bodies
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ limit: '50mb', extended: true }));
// Middleware
// app.use(express.urlencoded({ extended: true }));
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

        formatDateAndTime: (date) => {
            const d = new Date(date);
            const day = d.getDate().toString().padStart(2, '0');
            const month = (d.getMonth() + 1).toString().padStart(2, '0');
            const year = d.getFullYear();
            const hours = d.getHours().toString().padStart(2, '0');
            const minutes = d.getMinutes().toString().padStart(2, '0');
            return `${day}/${month}/${year} ${hours}:${minutes}`; // Định dạng theo dd/mm/yyyy hh:mm
        },

        formatTitleStatus: (id_status) => {
            return writerService.findStatus(id_status).Title_Status;
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
        formatCountDaysRegisterAccountEditorAndWriter: function (dateString) {
            const dateRegister = new Date(dateString);
            const today = new Date();
            const diffTime = Math.abs(today - dateRegister);
            const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
            return diffDays;
        },

        formatCountDaysExpiredAccountEditorAndWriter: function (dateString) {
            const dateRegister = new Date(dateString);
            const expirationDate = new Date(dateRegister);
            expirationDate.setFullYear(expirationDate.getFullYear() + 1); // Cộng thêm 1 năm

            // Định dạng ngày theo dd/mm/yyyy
            const day = expirationDate.getDate().toString().padStart(2, '0');
            const month = (expirationDate.getMonth() + 1).toString().padStart(2, '0'); // Thêm 1 vì tháng bắt đầu từ 0
            const year = expirationDate.getFullYear();

            return `${day}/${month}/${year}`; // Trả về định dạng ngày hết hạn
        },


        formatCountDaysRegisterAndExpirationSubcriber: function (dateRegisterString, dateExpiredString) {
            const dateRegister = new Date(dateRegisterString);
            const dateExpired = new Date(dateExpiredString);
            const today = new Date();

            // Tính số ngày giữa ngày đăng ký và ngày hết hạn
            const diffTime = Math.abs(dateExpired - dateRegister);
            const totalDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

            // Kiểm tra nếu ngày hiện tại nằm giữa ngày đăng ký và ngày hết hạn
            if (today >= dateRegister && today <= dateExpired) {
                const diffCurrentToRegister = Math.ceil(Math.abs(today - dateRegister) / (1000 * 60 * 60 * 24));
                return diffCurrentToRegister; // Trả về số ngày từ ngày đăng ký đến ngày hiện tại
            }

            return totalDays; // Trả về tổng số ngày giữa ngày đăng ký và ngày hết hạn
        },
        formatDayExpiredAccount: function (dateString) {
            const d = new Date(dateString);
            const day = d.getDate().toString().padStart(2, '0');
            const month = (d.getMonth() + 1).toString().padStart(2, '0'); // Thêm 1 vì tháng bắt đầu từ 0
            const year = d.getFullYear();
            const hours = d.getHours().toString().padStart(2, '0');
            const minutes = d.getMinutes().toString().padStart(2, '0');
            return `${day}/${month}/${year} ${hours}:${minutes}`; // Định dạng theo dd/mm/yyyy hh:mm
        },
        formatDateNewsManagementAdmin: (date) => {
            const d = new Date(date);
            const day = d.getDate().toString().padStart(2, '0');
            const month = (d.getMonth() + 1).toString().padStart(2, '0');
            const year = d.getFullYear();
            return `${day}/${month}/${year}`;
        },
        //helper chọn role
        if_eq: function (a, b, options) {
            if (a == b) {
                return options.fn(this);  // Nếu giá trị của a và b bằng nhau, render block của helper
            } else {
                return options.inverse(this);  // Nếu không, render block ngược lại
            }
        },


        formatUpdateDateOfArticleInEditor: (date) => {
            if (!date) return '';
            return moment(date).format('YYYY-MM-DD'); // Định dạng ngày theo định dạng YYYY-MM-DD
        }


    },
}));


app.post('/jwt', (req, res) => {
    // NOTE: Before you proceed with the TOKEN, verify your users' session or access.
    const payload = {
        sub: '123', // Unique user id string
        name: 'John Doe', // Full name of user

        // Optional custom user root path
        // 'https://claims.tiny.cloud/drive/root': '/johndoe',

        exp: Math.floor(Date.now() / 1000) + (60 * 10) // 10 minutes expiration
    };

    try {
        const token = jwt.sign(payload, privateKey, { algorithm: 'RS256' });
        res.set('content-type', 'application/json');
        res.status(200);
        res.send(JSON.stringify({
            token: token
        }));
    } catch (e) {
        res.status(500);
        res.send(e.message);
    }
});

// Thêm middleware để load categories
app.use(async function (req, res, next) {
    try {
        const categories = await categoryService.findAllActive();

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




// app.get('/', function (req, res) {
//     if (!req.session.auth) {
//         return res.redirect('/account/login');
//     }
//     res.render('home', {
//         layout: 'main',
//         user: req.session.authUser
//     });
// });

app.use('/account', accountRouter);

app.use('/', homeRouter);
app.use('/category', categoryRouter);
app.use('/account', accountRouter);
app.use('/news', detailNewsRouter);
app.use('/search', searchnewsRouter);
app.use('/inforuser', inforUserRouter);

// app.use('/admin', adminRouter);
app.use('/admin', isAdmin, adminRouter); // 20/12
app.use('/writer', isWriter, writerRouter);
app.use('/editor', isEditor, editorRouter);


// Server setup
app.listen(3000, () => {
    console.log('Server started on http://localhost:3000');
});
