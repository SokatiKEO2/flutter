const express = require("express");
const cors = require("cors");
const dotenv = require('dotenv');
const sql = require("mssql");
dotenv.config();

const app = express();
app.use(express.json());
app.use(cors());
app.use(express.urlencoded({
    extended: true
}));
const {connect} = require("./db.js")

connect().then((connection)=>{
    console.log("Connected to DB")
}).catch((error)=>{
    console.log("DB connection failed")
    console.log(error)
})

const productData = [];

app.listen(2000, () => {
  console.log("Server running on http://localhost:2000");
});
// Start server

//post api
app.post("/products", async (req, res) => {
  const { productName, price, stock } = req.body;

  try {
    const pool = await connect();
    await pool.request()
      .input('productName', sql.NVarChar, productName)
      .input('price', sql.Decimal(10, 2), price)
      .input('stock', sql.Int, stock)
      .query(`INSERT INTO Products (productName, price, stock) VALUES (@productName, @price, @stock)`);

    res.status(200).send({
      status_code: 200,
      message: "Product added successfully",
      product: { productName, price, stock }
    });
  } catch (error) {
    console.error("Insert error", error);
    res.status(500).send({ message: "Failed to add product" });
  }
});

//get api
app.get("/products", async (req, res) => {
  try {
    const pool = await connect();
    const result = await pool.request().query("SELECT * FROM Products");

    res.status(200).send({
      status_code: 200,
      products: result.recordset
    });
  } catch (error) {
    console.error("Fetch error:", error);
    res.status(500).send({
      status_code: 500,
      message: "Failed to fetch products",
      error: error.message
    });
  }
});

//get by id
app.get("/products/:id", async (req, res) => {
  const id = parseInt(req.params.id);

  try {
    const pool = await connect();
    const result = await pool.request()
      .input("id", sql.Int, id)
      .query("SELECT * FROM Products WHERE productId = @id");

    if (result.recordset.length > 0) {
      res.status(200).send({
        status_code: 200,
        product: result.recordset[0]
      });
    } else {
      res.status(404).send({
        status_code: 404,
        message: "Product not found"
      });
    }
  } catch (error) {
    console.error("Fetch by ID error:", error);
    res.status(500).send({
      status_code: 500,
      message: "Failed to fetch product",
      error: error.message
    });
  }
});




//update api
app.put("/products/:id", async (req, res) => {
  const id = parseInt(req.params.id);
  const { productName, price, stock } = req.body;

  try {
    const pool = await connect();
    const result = await pool.request()
      .input("id", sql.Int, id)
      .input("productName", sql.NVarChar, productName)
      .input("price", sql.Decimal(10, 2), price)
      .input("stock", sql.Int, stock)
      .query(`
        UPDATE Products
        SET productName = @productName, price = @price, stock = @stock
        WHERE productId = @id
      `);

    res.status(200).send({
      status: "success",
      message: "Product updated",
      data: { productId: id, productName, price, stock }
    });
  } catch (error) {
    console.error("Update error:", error);
    res.status(500).send({ status: "error", message: "Update failed", error: error.message });
  }
});


//delete api
app.delete("/products/:id", async (req, res) => {
  const id = parseInt(req.params.id);

  try {
    const pool = await connect();
    await pool.request()
      .input("id", sql.Int, id)
      .query("DELETE FROM Products WHERE productId = @id");

    res.status(200).send({
      status: "success",
      message: `Product with ID ${id} deleted`
    });
  } catch (error) {
    console.error("Delete error:", error);
    res.status(500).send({
      status: "error",
      message: "Failed to delete product",
      error: error.message
    });
  }
});

