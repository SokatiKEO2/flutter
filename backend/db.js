const sql = require('mssql');
require('dotenv').config();

const config = {
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  server: process.env.DB_SERVER,
  database: process.env.DB_NAME,
  options: {
    instanceName: "SQLEXPRESS01",
    enableArithAbort:true,
    trustedConnection:true,
    encrypt: true,
    trustServerCertificate: true,
  }
};

const pool = new sql.ConnectionPool(config);
const poolConnect = pool.connect();

module.exports = {
  connect: ()=>sql.connect(config),
  sql,
};
