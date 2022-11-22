const { Router } = require('express');
const {runQuery, closeConnect} =  require('../database/config');
const { response, request } = require('express');
const {isExist} = require('../helpers/db-validatos');
const {searchCaracteres,searchNumber, removeEstado} = require('../helpers/info-validator');
const router = Router();


const checkCodigoProveedor = (req = request, res = response, next) => {
    let codigo = req.params.id
    if(codigo.length !== 4){
        return res.status(400).end();
    }
    next();
}


const checkInfoProveedor = (req=request, res=response, next) => {

    let {id, nombre, telefono, pais} = req.body;

    if(!id || !nombre || !telefono || !pais){
       return res.status(400).json({msg:'content is missing'});
    }
    
    if(id.length !==4 || telefono.length !== 8){
        return res.status(400).json({msg:'content of propety is not allowed '});
    }

    if(!searchNumber(telefono)){
        return res.status(400).json({msg:'The phone should be only numbers '});
    } 
        
    next();
    
}

const handlePaisName = async (req=request, res=response, next) => {
    let {pais} = req.body;
   if(typeof pais === 'number'){
    next();
    return
   };
    
    let nombrePais = searchCaracteres(pais);
    try {   
    
    if(nombrePais){
        let data = await runQuery(`exec Busc_PaisN @nombre = '${pais}'`);
        if(data === undefined || data.recordset[0] === undefined){
            return res.status(404).end();
         }
         req.body.pais = data.recordset[0].id;
         next();
         return;
    }
    
        next();
    } catch (error) {
        console.log("errorqui")
    }
}

router.post('/', checkInfoProveedor, (req, res) => {
    let {id, nombre, direccion, telefono, pais} = req.body;
    runQuery(`exec In_Proveedor @Cod_Prov ='${id}' ,@NombreProv = '${nombre}', @Direccion='${direccion}', @TelCProv = '${telefono}', @Id_Pais='${pais}';`)
    .then( data => {

        if(data === undefined || data.recordset[0] === undefined){
           return res.status(404).end();
        }

        res.json(data.recordset);
    })
    .catch(err=>{
        console.log(err)
        res.status(500).end();
    });
});

router.get('/', (req, res) => {
    runQuery(`select Cod_Proveedor AS id ,NombreProv as nombre, direccion, TelCProv as telefono, Pais.NombreP as pais, Estado from Proveedor inner join Pais on Proveedor.id_Pais = Pais.id_Pais;`)
    .then( data => {

        if(data === undefined || data.recordset === undefined){
            return res.status(404).end();
         }

         let array = data.recordset.filter((item)=> item.Estado === true)
         //console.log(removeEstado(data.recordset));
         res.json(array)
    })
    .catch(err=>{
        console.log(err)
        res.status(500).end();
    });
});

router.get('/:id', checkCodigoProveedor, (req, res) => {

    let id = req.params.id

    runQuery(`exec Bus_ProveedorC @Codigo = '${id}';`).then( data =>{
       
        if(data === undefined || data.recordset[0] === undefined){
           return res.status(404).end(); 
        }  
         
         if(data.recordset[0].Estado === false){
           return res.status(403).end();
        } 

        res.json(data.recordset)        
             
    })
    .catch(err=>{
        console.log(err)
        res.status(500).end();
    } );
});


router.put('/:id',checkCodigoProveedor, checkInfoProveedor, handlePaisName, (req, res) => {
    
    let { nombre, direccion, telefono, pais} = req.body;
    let id = req.params.id;

    isExist(`exec Bus_ProveedorC @Codigo = '${id}';`)
    .then(result => {

        if(result){
           
           return runQuery(`exec Act_Proveedor @Cod_Prov ='${id}' ,@NombreProv = '${nombre}', @Direccion='${direccion}', @TelCProv = '${telefono}', @Id_Pais='${pais}';`)
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


router.delete('/:id', checkCodigoProveedor, (req, res) => {

    let proveedor = req.params.id;

    isExist(`exec Bus_ProveedorC @Codigo = '${proveedor}';`)
    .then(result => {

        if(result){
           
           return runQuery(`exec delet_Proveedor @Cod_Proveedor = '${proveedor}';`)
            .then(data =>{
                res.status(204).end();
            })
        }
       
        res.status(404).end();
        
    })
    .catch(err=>{
        console.log(err)
        res.status(500).end();
    });;
});

module.exports = router;