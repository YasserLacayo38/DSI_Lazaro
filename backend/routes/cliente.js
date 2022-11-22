const { Router } = require('express');
const {runQuery, closeConnect} =  require('../database/config');
const { response, request } = require('express');
const {isExist} = require('../helpers/db-validatos');
const {searchCaracteres,searchNumber, removeEstado, validPrice} = require('../helpers/info-validator');
const router = Router();
const bcrypt = require('bcrypt');


const saltRounds = 10;

const checkInfocliente = (req=request, res=response, next) => {

    let {correo, contrasena, nombre, apellido, edad, direccion, telefono} = req.body;

    if(!correo || !contrasena || !telefono || !nombre || !apellido || !edad || !telefono){
       return res.status(400).json({msg:'content is missing'});
    }
    
    if(telefono.length !== 8){
        return res.status(400).json({msg:'content of propety is not allowed '});
    }

    if(!searchNumber(telefono)){
        return res.status(400).json({msg:'The phone should be only numbers '});
    } 

    if(!searchNumber(edad)){
        return res.status(400).json({msg:'The phone should be only numbers '});
    } 
    next();
    
}



router.post('/', checkInfocliente, (req, res) => {

    let {correo, contrasena, nombre, apellido, edad, direccion, telefono} = req.body;

    bcrypt.hash(contrasena, saltRounds)
    .then(hash => {

           return runQuery(`exec In_Cliente @Correo ='${correo}',@contrasena = '${hash}', @Nombre= '${nombre}',@Apellido= '${apellido}', @edad = '${edad}', @Direccion ='${direccion}', @Tel = '${telefono}'`)
            
           

    })
    .then( data =>{
       
        if(data === undefined || data.recordset === undefined){
            return res.status(404).end();
         }

        return res.json(data.recordset)
    })
    .catch(err=>{
        console.log(err)
        res.status(500).end();
    });
   



});

router.get('/', (req, res) => {
    runQuery(`select correo, nombre, apellido, edad, direccion, TelCC as telefono from cliente;`)
    .then( data => {

        if(data === undefined || data.recordset === undefined){
            return res.status(404).end();
         }

         res.json(data.recordset)
    })
    .catch(err=>{
        console.log(err)
        res.status(500).end();
    });
});

router.get('/:correo', (req, res) =>{

    let correo = req.params.correo;

    runQuery(`exec Bus_ClienteId @correo = '${correo}';`)
    .then( data => {

        if(data === undefined || data.recordset === undefined){
            return res.status(404).end();
         }

         res.json(data.recordset)
    })
    .catch(err=>{
        console.log(err)
        res.status(500).end();
    });

})


router.put('/:correo',checkInfocliente, (req, res) =>{
    let correo = req.params.correo;
    let {contrasena, nombre, apellido, edad, direccion, telefono} = req.body;


    isExist(`exec Bus_ClienteId @correo = '${correo}';`)
    .then(result => {
        if(result){
           
            return  bcrypt.hash(contrasena, saltRounds)
         }
        
        return res.status(404).end();
    })
    .then(hash => {

           return runQuery(`exec Act_Cliente @Correo ='${correo}',@contrasena = '${hash}', @Nombre= '${nombre}',@Apellido= '${apellido}', @edad = '${edad}', @Direccion ='${direccion}', @Tel = '${telefono}'`)

    })
    .then( data =>{
       
        if(data === undefined || data.recordset === undefined){
            return res.status(404).end();
         }

        return res.json(data.recordset)
    })
    .catch(err=>{
        console.log(err)
        res.status(500).end();
    });
})


module.exports = router;
