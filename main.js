import express from 'express';
import { engine } from 'express-handlebars';
import { dirname, join } from 'path';
import { fileURLToPath } from 'url';
import session from 'express-session';
import numeral from 'numeral';
import hbs_section from 'express-handlebars-sections';
import accountRouter from './routes/account.route.js';


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
    },
}));
app.set('view engine', 'hbs');
app.set('views', join(__dirname, 'views'));

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


app.use('/account', accountRouter);

// Server setup
app.listen(3000, () => {
    console.log('Server started on http://localhost:3000');
});



