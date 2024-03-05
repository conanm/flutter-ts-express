import express from "express";
import routes from "./routes/userRoutes";

const app = express();
const port = 3000;

app.use(express.json());
app.use("/", routes);

app.listen(port, () => {
  console.log(`Express is listening at http://localhost:${port}`);
});
