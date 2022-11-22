

const searchCaracteres = (str) =>{
    let onlyCaracteres = true
    for (let caracter of str) {
        let value = caracter.codePointAt(0);
        if( 48<= value && value <=57) {onlyCaracteres = false};
        
    }
    return onlyCaracteres;
}

const searchNumber = (str) =>{
    let onlyNumbers = true
    for (let caracter of str) {
        let value = caracter.codePointAt(0);
        if(  value < 47 ||  value > 58) {onlyNumbers = false};
        
    }

    return onlyNumbers;
}

const validPrice = (str) => {
    let isPrice = true
    for (let caracter of str) {
        let value = caracter.codePointAt(0);
        if(value === 46) continue;
        if(  value < 48 ||  value > 57) {onlyNumbers = false}
        
    }
    return isPrice;
}
const removeEstado = (array) => {
    let arrayData = array.filter((item)=> item.Estado === true);
    let newArray = arrayData.map( (item) => {
        let {Estado, ...restObj} = item;
        return restObj;
    });
    return newArray;
}
module.exports={
    searchCaracteres, 
    searchNumber,
    removeEstado,
    validPrice
}