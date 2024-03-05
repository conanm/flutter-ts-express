import express from "express";
import * as AuthController from "../controllers/authController";
import * as UserController from "../controllers/userController";
const router = express.Router();

router.post("/register", AuthController.register);
router.post("/login", AuthController.login);
router.patch("/activities/:id/toggle", UserController.toggleActivityCompleted);
router.get("/activities", UserController.getActivitiesForUser);

export default router;
