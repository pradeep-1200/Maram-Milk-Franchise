import { Router } from 'express';
import { login, logout } from './auth.controller';

const authRouter = Router();

authRouter.post('/login', login);
authRouter.post('/logout', logout);

export default authRouter;
