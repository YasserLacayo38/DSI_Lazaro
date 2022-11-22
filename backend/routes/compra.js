const { Router } = require('express');
const {runQuery, closeConnect} =  require('../database/config');
const { response, request } = require('express');
const {isExist} = require('../helpers/db-validatos');
const {searchCaracteres,searchNumber, removeEstado} = require('../helpers/info-validator');
const router = Router();

router.post('/', (req, res) => {
    runQuery(`exec In_Compra`).then( data =>{
        if(data === undefined || data.recordset[0] === undefined){
            return res.status(404).end(); 
         }  
         res.json(data.recordset)
    })
});


router.get('/', (req, res) => {
    runQuery(`select IdCompra as id, FechaC as fecha, total from Compra`).then( data =>{
         res.json(data.recordset)
    })
});

router.get('/:id', (req, res) => {
    let id = req.params.id;
    runQuery(`select DetalleCompra.IdCompra as compra, FechaC as fecha, total, DetalleCompra.Cod_Producto as idProducto, Producto.nombre as producto, DetalleCompra.preciocompra as precio, DetalleCompra.subtotal, DetalleCompra.cantidad from Compra inner join DetalleCompra on Compra.IdCompra = DetalleCompra.IdCompra inner join Producto on Producto.Cod_Producto = DetalleCompra.Cod_Producto where Compra.IdCompra = '${id}'`)
    .then( data =>{
        console.log();
        let dataChanged = {
            compra: data.recordset[0].compra,
            fecha: data.recordset[0].fecha,
            total : data.recordset[0].total,
          
            productos : data.recordset.map(item => {return {idProducto: item.idProducto,   
                                                            producto: item.producto, 
                                                            precio: item.precio,
                                                            cantidad: data.recordset[0].cantidad, 
                                                            subtotal: item.subtotal}})
        }
         res.json(dataChanged);
    })
});


module.exports = router;