import express from "express";
import * as AuthController from "../controllers/authController";
import * as UserController from "../controllers/userController";
import { authenticate } from "../middleware/authenticate";
const router = express.Router();

router.post("/register", AuthController.register);
router.post("/login", AuthController.login);
router.patch("/activities/:id/toggle", UserController.toggleActivityCompleted);
router.get("/activities", authenticate, UserController.getActivitiesForUser);

export default router;
