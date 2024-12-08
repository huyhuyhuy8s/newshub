// import express from 'express'
// import { engine } from 'express-handlebars'
// import { dirname, join } from 'path'
// import { fileURLToPath } from 'url';
// // import { MarkdownBlock, MarkdownSpan, MarkdownElement } from "md-block";
// import session from 'express-session';

// const app = express();
// app.set('trust proxy', 1) // trust first proxy
// app.use(session({
//     secret: 'keyboard cat',
//     resave: false,
//     saveUninitialized: true,
//     cookie: {}
// }))

// app.use(express.urlencoded({
//     extended: true
// }));

// import hbs_section from 'express-handlebars-sections';
// app.engine('hbs', engine({
//     extname: 'hbs',
//     helpers: {
//         format_number(value) {
//             return numeral(value).format('0,0') + ' vnd';
//         },
//         fillHtmlContent: hbs_section()
//     }
// }));
// app.set('view engine', 'hbs');
// app.set('views', './views');

// // use /static folder to public for client
// // app.use('/static', express.static('static'));
// const __dirname = dirname(fileURLToPath(import.meta.url));
// app.use(express.static(__dirname + '/static'));
// app.use(express.static(__dirname + '/imgs'));
// // console.log(join("main;:", __dirname, '/static'));
// // console.log(__dirname);

// // middleware
// // app.use(async function (req, res, next) {
// //     const list = await categoryService.findAll();
// //     res.locals.lcCategories = list;
// //     next();
// // });


// app.get('/', function (req, res) {
//     res.render('home', {
//         // layout: false,
//     });
// });

// // import categoryRouter from './routes/category.route.js';
// // import accountRouter from './routes/account.route.js';
// // import { isAuth, isAdmin } from './middleware/auth.node.js';

// // app.use('/category', categoryRouter);
// app.use('/account', accountRouter);

// import accountRouter from './routes/account.route.js';

// app.use('/account', accountRouter);

// app.listen(3000, function (req, res) {
//     console.log('server started on http://localhost:3000');
// });

import express from 'express';
import { engine } from 'express-handlebars';
import { dirname, join } from 'path';
import { fileURLToPath } from 'url';
import session from 'express-session';
import numeral from 'numeral';
import hbs_section from 'express-handlebars-sections';
import accountRouter from './routes/account.route.js';
import categoryService from './services/category.service.js';

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
        }

    },
}));

// Thêm middleware để load categories
app.use(async function (req, res, next) {
    try {
        const categories = await categoryService.findAllActive();
        console.log('Categories loaded:', categories); // Debug log
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


app.get('/test-categories', (req, res) => {
    console.log('lcCategories in test route:', res.locals.lcCategories);
    res.json(res.locals.lcCategories);
});


// Routes
// app.get('/', (req, res) => {
//     res.render('home');
// });

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
app.get('/', function (req, res) {
    if (!req.session.auth) {
        return res.redirect('/account/login');
    }
    res.render('vwCategory/category', {
        layout: 'main',
        user: req.session.authUser
    });
});



app.use('/account', accountRouter);

// Server setup
app.listen(3000, () => {
    console.log('Server started on http://localhost:3000');
});



