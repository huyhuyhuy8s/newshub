import express from 'express'
import { engine } from 'express-handlebars'
import { dirname, join } from 'path'
import { fileURLToPath } from 'url';
// import { MarkdownBlock, MarkdownSpan, MarkdownElement } from "md-block";
import session from 'express-session';

const app = express();
app.set('trust proxy', 1) // trust first proxy
app.use(session({
    secret: 'keyboard cat',
    resave: false,
    saveUninitialized: true,
    cookie: {}
}))

app.use(express.urlencoded({
    extended: true
}));

import hbs_section from 'express-handlebars-sections';
app.engine('hbs', engine({
    extname: 'hbs',
    helpers: {
        format_number(value) {
            return numeral(value).format('0,0') + ' vnd';
        },
        fillHtmlContent: hbs_section()
    }
}));
app.set('view engine', 'hbs');
app.set('views', './views');

// use /static folder to public for client
// app.use('/static', express.static('static'));
const __dirname = dirname(fileURLToPath(import.meta.url));
app.use(express.static(__dirname + '/static'));
app.use(express.static(__dirname + '/imgs'));
// console.log(join("main;:", __dirname, '/static'));
// console.log(__dirname);

// middleware
// app.use(async function (req, res, next) {
//     const list = await categoryService.findAll();
//     res.locals.lcCategories = list;
//     next();
// });

app.get('/', function (req, res) {
    // res.send('Hello world');/
    res.render('home', {
        // layout: false,
    });
});

// import categoryRouter from './routes/category.route.js';
import accountRouter from './routes/account.route.js';
// import { isAuth, isAdmin } from './middleware/auth.node.js';

// app.use('/category', categoryRouter);
app.use('/account', accountRouter);

app.listen(3000, function (req, res) {
    console.log('server started on http://localhost:3000');
});