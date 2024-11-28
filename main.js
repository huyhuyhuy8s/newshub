import express from 'express'
import { engine } from 'express-handlebars'
import { dirname } from 'path'
import { fileURLToPath } from 'url';
import { MarkdownBlock, MarkdownSpan, MarkdownElement } from "md-block";

const app = express();

app.engine('hbs', engine({
    extname: 'hbs',
}));
app.set('view engine', 'hbs');


app.get('/', function (req, res) {
    // res.send('Hello world');/
    res.render('home', {
        // layout: false,
    });
});

app.get('/test', function (req, res) {
    // res.send('Hello world');/
    res.render('test', {
        // layout: false,
    });
});


const __dirname = dirname(fileURLToPath(import.meta.url));
app.get('/test', function (req, res) {
    res.sendFile(__dirname + '/test.html')
});

app.listen(3000, function (req, res) {
    console.log('server started on http://localhost:3000');
});