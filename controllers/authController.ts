import { Request, Response } from "express";
import * as AuthService from "../services/authService";

export const register = async (req: Request, res: Response) => {
  try {
    const user = await AuthService.register(
      req.body.username,
      req.body.email,
      req.body.password
    );
    res.status(201).json(user);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const login = async (req: Request, res: Response) => {
  try {
    const token = await AuthService.login(req.body.email, req.body.password);
    res.json({ token });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
