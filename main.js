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
            console.log('toLowerCase input:', str);
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
            console.log('eq comparing:', v1, v2);
            return v1 === v2;
        },
        formatDate(date) {
            return moment(date).format('MMMM DD, YYYY');
        },
        formatTimeAgo(date) {
            return moment(date).fromNow();
        }

    },
}));

// Thêm middleware để load categories
app.use(async function (req, res, next) {
    try {
        const categories = await categoryService.findAllActive();

        // Tạo một bản sao của categories để xử lý log
        const categoriesForLog = categories.map(category => ({
            Name: category.Name,
            Status: category.Status[0],
            // Chuyển SubCategories thành string trên cùng một hàng
            SubCategories: `[${category.SubCategories.map(sub => 
                `{${sub.Name}}`
            ).join(', ')}]`
        }));
        console.log('Categories loadedddd:', categoriesForLog);

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


app.get('/test-categories', (req, res) => {
    console.log('lcCategories in test route:', res.locals.lcCategories);
    res.json(res.locals.lcCategories);
});


// Routes

app.get('/', function (req, res) {
    if (!req.session.auth) {
        return res.redirect('/account/login');
    }
    res.render('home', {
        layout: 'main',
        user: req.session.authUser
    });
});

//test thử vào category
// app.get('/', function (req, res) {
//     if (!req.session.auth) {
//         return res.redirect('/account/login');
//     }
//     res.render('vwCategory/category', {
//         layout: 'main',
//         user: req.session.authUser
//     });
// });




app.use('/category', categoryRouter);
app.use('/account', accountRouter);


// Server setup
app.listen(3000, () => {
    console.log('Server started on http://localhost:3000');
});



