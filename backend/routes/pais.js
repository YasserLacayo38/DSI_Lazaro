const { Router } = require('express');
const {runQuery, closeConnect} =  require('../database/config');
const { response, request } = require('express');
const router = Router();
const {isExist} = require('../helpers/db-validatos');
const {searchCaracteres,searchNumber} = require('../helpers/info-validator');


const validarParametro = (req= request, res = response, next) => {
    let id = req.params.id;
    console.log(searchNumber(id));
    if(!searchNumber(id)){
        return res.status(400).end();
    }

    next();
    
}
const namePais= (req=request, res=response, next) => {
    let {nombre} =  req.body;
    if(!nombre){
        return res.status(400).json({
            msg: 'Content missing'
        })
    }
    
    next();
      
}

router.post('/', namePais, (req, res) => {
    let {nombre} =  req.body;
    runQuery(`exec In_Pais @NombreP = '${nombre}'`).then( data =>{
        res.json(data.recordset);
    });

   
});

router.get('/', (req, res)=>{
    runQuery(`select * from Pais`).then( data =>{

        if(data === undefined || !data.recordset){
            return res.status(404).end(); 
        }

        res.json(data.recordset)
    });
});


router.get('/:id', validarParametro, (req, res) => {
    let id = req.params.id;

    runQuery(`exec BuscPais @id = '${id}';`).then( data =>{

        if(data === undefined || data.recordset === undefined){
            return res.status(404).end(); 
        }

        res.json(data.recordset)        
               
    })
})



module.exports = router;