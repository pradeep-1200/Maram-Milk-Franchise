import { Router } from 'express';
import * as routesController from './routes.controller';
import { authGuard } from '../../middleware/authGuard';

const routesRouter = Router();

routesRouter.use(authGuard);

routesRouter.get('/', routesController.getRoutes);
routesRouter.put('/:routeId/allocation', routesController.updateAllocation);

export default routesRouter;
