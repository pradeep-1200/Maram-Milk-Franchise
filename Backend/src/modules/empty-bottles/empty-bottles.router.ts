import { Router } from 'express';
import * as emptyBottleController from './empty-bottles.controller';
import { authGuard } from '../../middleware/authGuard';

const emptyBottlesRouter = Router();

emptyBottlesRouter.use(authGuard);

emptyBottlesRouter.get('/', emptyBottleController.getEmptyBottles);
emptyBottlesRouter.put('/:routeId', emptyBottleController.updateEmptyBottle);

export default emptyBottlesRouter;
