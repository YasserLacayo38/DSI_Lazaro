const sql = require('mssql')

// run a query against the global connection pool
function runQuery(query) {
  const sqlConfig = {
    user: process.env.USER_BD || 'sa',
    password: process.env. PASSWORD_BD || '1234',
    database: process.DATABASE_BD || 'SuperMercado',
    server: process.SERVER_BD || 'DESKTOP-C9PO0NO',
   // pool: {max: 10,min: 0,idleTimeoutMillis: 30000},
    options: {
      encrypt: false, // for azure
      trustServerCertificate: true // change to true for local dev / self-signed certs
    }
  };

  // sql.connect() will return the existing global pool if it exists or create a new one if it doesn't
  return sql.connect(sqlConfig).then((pool) => {
    return pool.query(query)
  })
};

function closeConnect(){
    sql.close();
}

module.exports={runQuery, closeConnect};