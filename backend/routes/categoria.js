const { Router } = require('express');
const {runQuery, closeConnect} =  require('../database/config');
const { response, request } = require('express');
const {isExist} = require('../helpers/db-validatos');
const {searchCaracteres,searchNumber} = require('../helpers/info-validator');
const router = Router();




const checkInfoCategoria = (req = request, res = response, next) => {

    let {categoria} =  req.body;
    
    if(!categoria){
        return res.status(400).json({
            msg: 'Content missing'
        })
    }
  
        next();
      
}

const handleWithName = (req = request, res = response, next) => {

    let categoria = req.params.nombre;

    if(searchCaracteres(categoria)){
       return runQuery(`exec Bus_CategoriaN @Categoria = '${categoria}';`).then( data =>{
            if(data === undefined || data.recordset === undefined){
                return res.status(404).end(); 
             }
              if(data.recordset[0].Estado === false){
               return  res.status(403).end();
             }            
                res.json(data.recordset)        
                     
        })
    } 

    next();

     
}

router.get('/', (req, res) => {

    runQuery(`select id, categoria, descripcion, Estado from Categoria`).then( data =>{

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

router.get('/:nombre', handleWithName, (req, res) => {

    let id = req.params.nombre;

    runQuery(`exec Bus_CategoriaId @id = '${id}';`).then( data =>{
       
        if(data === undefined || data.recordset === undefined){
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
})

router.post('/', checkInfoCategoria, (req, res) => {

    let {categoria, description} = req.body;
     
    runQuery(`exec In_Categoria @Categoria = '${categoria}', @Description = '${description}';`)
    .then( data => {
        res.json(data.recordset);        
    })
    .catch(err=>{
        console.log(err)
        res.status(500).end();
    });
});

router.put('/:id', (req, res) => {

    let id  = req.params.id
    let {categoria, descripcion} = req.body;

    isExist(`exec Bus_CategoriaId @id = '${id}'`)
    .then(result => {

        if(result){
           
           return runQuery(`exec Act_Categoria @id = '${id}', @Categoria = '${categoria}', @descripcion = '${descripcion}'`)
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

router.delete('/:id', (req, res) => {

    let id  = req.params.id

    isExist(`exec Bus_CategoriaId @id = '${id}'`).then(result => {

        if(result){

           return runQuery(`exec delet_Categoria @id = '${id}'`)
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
});

module.exports = router;

