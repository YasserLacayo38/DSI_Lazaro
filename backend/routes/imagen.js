const { Router } = require('express');
const multer =  require('multer');
const router = Router();
const path =  require('path');
const { response, request } = require('express');


const diskstorage = multer.diskStorage({
    destination: path.join(__dirname,'../images'),
    filaname: (req =request, file, cb) => {
       
        cb(null, "mimamamemima" );
    }
});

const fileUpload = multer({
    storage: diskstorage
}).single('image');

router.post('/', fileUpload ,(req, res) => {
    console.log(req.file);
    res.json();
});

module.exports = router;