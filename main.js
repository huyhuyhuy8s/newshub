import express from 'express'
import { engine } from 'express-handlebars'
import { dirname } from 'path'
import { fileURLToPath } from 'url';
import path from 'path';
import LoginRoute from './routes/Login.route.js';
import RegisterRoute from './routes/Register.route.js';

const app = express();

const __dirname = dirname(fileURLToPath(import.meta.url));

// Cấu hình engine Handlebars
app.engine('hbs', engine({
    extname: 'hbs',
}));
app.set('view engine', 'hbs');

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

app.get('/register/otp',(req,res) => {
    res.sendFile(path.join(__dirname, 'views/Login/otp.html'))
})

app.get('/home', (req, res) => {
    res.sendFile(path.join(__dirname, 'views/Home/home.html'));
});

// Khởi động server
app.listen(3000, function () {
    console.log('Server started on http://localhost:3000');
});
