const { Router } = require('express');
const {runQuery, closeConnect} =  require('../database/config');
const { response, request } = require('express');
const {isExist} = require('../helpers/db-validatos');
const {searchCaracteres,searchNumber, removeEstado} = require('../helpers/info-validator');
const router = Router();

const checkInfoDetalle =  (req = request, res = response, next) =>{
    let {compra, producto, cantidad, precio} = req.body;

    if(!compra || !producto || !cantidad || !precio){
        return res.status(400).json({msg : "content is missing"});
    }
    next();
}

const handleProductoName = async(req = request, res = response, next) =>{
    let {producto}  = req.body;
    try {
        let data = await runQuery(`exec BuscProducto_Nombre @NOM = '${producto}' `);
       
        if(data === undefined || data.recordset[0] === undefined){
            return res.status(404).end();
         };
         req.body.producto = data.recordset[0].Cod_Producto;
         next();
    } catch (error) {
        
    }
    
}

router.post('/', checkInfoDetalle, handleProductoName, (req, res) => {

    let {compra, producto, cantidad, precio} = req.body;
    runQuery(`exec In_DetalleCompra @IDC = '${compra}', @CODR = '${producto}', @CANT = '${cantidad}', @PREC = '${precio}'`).then( data =>{
        if(data === undefined || data.recordset[0] === undefined){
            return res.status(404).end(); 
         }  
         res.json(data.recordset)
    })
});




module.exports = router;