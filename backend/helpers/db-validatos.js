const {runQuery, closeConnect} =  require('../database/config');

const isExist = (query) => {

    return runQuery(query).then( data =>{
        if(data === undefined || data.recordset === undefined) {
            return false;
        } 
            return true;
        
    });
}

module.exports ={
    isExist
}