const { Router } = require('express');
const {runQuery, closeConnect} =  require('../database/config');
const { response, request } = require('express');
const {isExist} = require('../helpers/db-validatos');
const {searchCaracteres,searchNumber, removeEstado, validPrice} = require('../helpers/info-validator');
const router = Router();


const checkIdProducto = (req= request, res = response, next) => {
    let id = req.params.id;
    if(id.length !== 4){
        return res.status(400).json({msg:"The id must be 4 chacarteres"});
    }
    next();
}

const checkInfoProducto = (req = request, res = response, next) => {
    let {id, nombre, precio, descripcion, proveedor, categoria} = req.body;

    if(!id || !nombre || !precio || !proveedor || !categoria){
        return res.status(400).json({msg : "content is missing"});
    }

    if(id.length !== 4){
        return res.status(400).json({msg : "codigos must be 4 chacarteres "});
    }
    if(!validPrice(precio.toString())){
        return res.status(400).json({msg : "the price must be a number "});
    }

    next();
}

const handleProveedorName = async(req = request, res = response, next) =>{
    let {proveedor} = req.body;
    try {
        let data = await runQuery(`exec Bus_ProveedorN @Nombre = '${proveedor}'`);
        if(data === undefined || data.recordset[0] === undefined){
            return res.status(404).end();
         }
         req.body.proveedor = data.recordset[0].codigo;
         next();
    } catch (error) {
        
    }
    

}

const handleCategoriaName = async (req=request, res=response, next) => {
    let {categoria} = req.body;
   if(typeof categoria === 'number'){
    next();
    return
   };
    
    let nombreCategoria = searchCaracteres(categoria);
    try {   
    
    if(nombreCategoria){
        let data = await runQuery(`exec Bus_CategoriaN @Categoria = '${categoria}'`);
        if(data === undefined || data.recordset[0] === undefined){
            return res.status(404).end();
         }
         req.body.categoria = data.recordset[0].id;
         next();
         return;
    }
    
        next();
    } catch (error) {
        console.log("errorqui")
    }
}

router.post('/', checkInfoProducto, handleCategoriaName,handleProveedorName, (req, res) => {
    let {id, nombre, precio, descripcion, proveedor, categoria} = req.body;

    runQuery(`exec In_Producto @Cod_Producto ='${id}' , @NOM='${nombre}', @Precio='${precio}', @Descripcion = '${descripcion}', @Cod_Proveedor='${proveedor}', @id_categoria = ${categoria};`)
    .then( data => {
        res.json(data.recordset);        
    })
    .catch(err=>{
        console.log(err)
        res.status(500).end();
    });

    
});

router.get('/', (req, res) => {

    runQuery(`select Cod_Producto as id, nombre , precio, Producto.descripcion , exist , Categoria.categoria, Proveedor.NombreProv as proveedor, Producto.Estado from Producto inner join Proveedor on Producto.Cod_Proveedor=Proveedor.Cod_Proveedor inner join Categoria on Producto.Id_Categoria = Categoria.id ;`)
    .then( data =>{

        if(data === undefined || !data.recordset){
           return  res.status(404).end(); 
        }

        let array = data.recordset.filter((item)=> item.Estado === true)
        res.json(array)
        
    })
    .catch(err=>{
        console.log(err)
        res.status(500).end();
    } );
});


router.get('/:id', checkIdProducto, (req, res) => {
    let id = req.params.id;
    runQuery(`exec Bus_ProductoC @Codigo = '${id}';`)
    .then( data =>{

        if(data === undefined || !data.recordset){
           return  res.status(404).end(); 
        }

        res.json(data.recordset)
        
    })
    .catch(err=>{
        console.log(err)
        res.status(500).end();
    } );

});


router.put('/:id',checkIdProducto, checkInfoProducto,handleProveedorName,handleCategoriaName, (req, res)=>{

    let id = req.params.id;
    let { nombre, precio, descripcion, proveedor, categoria} = req.body;

    isExist(`exec Bus_ProductoC @Codigo = '${id}';`)
    .then(result => {

        if(result){
           
           return runQuery(`exec Act_Producto @Cod_Producto ='${id}' , @NOM='${nombre}', @Precio='${precio}', @Descripcion = '${descripcion}', @Cod_Proveedor='${proveedor}', @id_categoria = ${categoria};`)
            .then(data =>{
                res.json(data.recordset);
            })
        }
       
        res.status(404).end();
        
    })
    .catch(err=>{
        console.log(err)
        res.status(500).end();
    });
});


router.delete('/:id', checkIdProducto, (req, res) => {

    let id = req.params.id;

    isExist(`exec Bus_ProductoC @Codigo = '${id}';`)
    .then(result => {

        if(result){
           
           return runQuery(`exec delet_Producto @codigo = '${id}';`)
            .then(data =>{
                res.status(204).end();
            })
        }
       
        res.status(404).end();
        
    })
    .catch(err=>{
        console.log(err)
        res.status(500).end();
    });
})


module.exports = router;