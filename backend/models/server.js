const express = require('express');
const cors = require('cors');

const startServer = ()=>{

    const PORT = process.env.PORT;
    let app = express();
    let pathCategoria = '/api/categoria';
    let pathPais = '/api/pais';
    let pathProveedor = '/api/proveedor';
    let pathProducto = '/api/producto';
    let pathCliente = '/api/cliente';
    let pathLogin = '/api/login';
    let pathImage = '/api/imagen';
    let pathCompra = '/api/compra';
    let pathDetalleCompra = '/api/detalleCompra'
    app.use( cors() );
    app.use( express.json() );
    app.use(express.static('build'));

    app.use(pathCategoria, require('../routes/categoria'))
    app.use(pathPais, require('../routes/pais'))
    app.use(pathProveedor, require('../routes/proveedor'))
    app.use(pathProducto, require('../routes/producto'))
    app.use(pathCliente, require('../routes/cliente'))
    app.use(pathLogin, require('../routes/login'))
    app.use(pathImage, require('../routes/imagen'))
    app.use(pathCompra, require('../routes/compra'));
    app.use(pathDetalleCompra, require('../routes/detalleCompra'));


    

    app.listen( PORT, ()=>{
        console.log(`Puerto corriendo en ${PORT}` );
    })
}


module.exports = startServer;
