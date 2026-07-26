import { Router } from 'express';
import * as dispatchController from './dispatch.controller';
import { authGuard } from '../../middleware/authGuard';

const dispatchRouter = Router();

dispatchRouter.use(authGuard);
dispatchRouter.get('/summary', dispatchController.getDispatchSummary);

export default dispatchRouter;
