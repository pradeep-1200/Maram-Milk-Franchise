import { Router } from 'express';
import * as reportsController from './reports.controller';
import { authGuard } from '../../middleware/authGuard';

const reportsRouter = Router();

reportsRouter.use(authGuard);
reportsRouter.get('/dp-performance', reportsController.getDpPerformance);

export default reportsRouter;
