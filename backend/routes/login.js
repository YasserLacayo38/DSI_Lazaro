const { Router } = require('express');
const {runQuery} =  require('../database/config');
const { response, request } = require('express');
const {isExist} = require('../helpers/db-validatos');
const jwt = require('jsonwebtoken');
const router = Router();
const bcrypt = require('bcrypt');

const checkInfoUser = (req=request, res=response, next) => {

    let {correo, contrasena} = req.body;

    if(!correo || !contrasena ){
       return res.status(400).json({msg:'content is missing'});
    }
    

    next();
    
}

const userExist = (req, res, next) =>{
    let {correo} = req.body;

    isExist(`exec Bus_ClienteId @correo = '${correo}';`)
    .then(result => {
        if(!result){
            return res.status(404).end();
            
         }
             
        next();
    })
}

router.post('/', checkInfoUser, userExist, (req, res) => {

    let {correo, contrasena} = req.body;

    runQuery(`select correo, nombre, contrasena from cliente where correo = '${correo}'`)
    .then( data => {
        if(data === undefined || data.recordset === undefined){
            return res.status(404).end();
         }

        return data.recordset
    })
    .then( data => {
        
        return bcrypt.compare(contrasena, data[0].contrasena).then( result => {
            if(result){
                
                return  data[0];
            }
            return res.status(404).end();

        }).then(data =>{

      
               let userForToken = {
                    correo: data.correo,
                    nombre: data.nombre}; 
        
                let token = jwt.sign(userForToken, process.env.SECRET);
                res.json({token,
                        correo: data.correo,
                        nombre: data.nombre});
            });
        
      
    })
    .catch(err=>{
        console.log(err)
        res.status(500).end();
    });;

});

module.exports = router;




