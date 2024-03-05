import express from "express";
import routes from "./routes/userRoutes";
const cors = require("cors");
const app = express();
const port = 3000;

// AFAIK i need this for localhost/flutter
app.use(cors());
app.use(express.json());
app.use("/", routes);

app.listen(port, () => {
  console.log(`Express is listening at http://localhost:${port}`);
});
