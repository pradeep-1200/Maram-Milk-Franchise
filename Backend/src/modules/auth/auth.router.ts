import { Router } from 'express';
import { login, logout, getMe, uploadPhoto } from './auth.controller';
import { authGuard } from '../../middleware/authGuard';
import { upload } from '../../middleware/upload';

const authRouter = Router();

authRouter.post('/login', login);
authRouter.post('/logout', logout);
authRouter.get('/me', authGuard, getMe);
authRouter.post('/photo', authGuard, upload.single('file'), uploadPhoto);

export default authRouter;
