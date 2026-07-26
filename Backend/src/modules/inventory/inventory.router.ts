import { Router } from 'express';
import * as inventoryController from './inventory.controller';
import { authGuard } from '../../middleware/authGuard';

const inventoryRouter = Router();

inventoryRouter.use(authGuard);

inventoryRouter.get('/', inventoryController.getInventory);
inventoryRouter.put('/', inventoryController.updateInventory);
inventoryRouter.post('/admin-stock', inventoryController.addAdminStock);
// TEMPORARY_MANUAL_STOCK_ENTRY
inventoryRouter.put('/manager-stock', inventoryController.setManagerStock);

export default inventoryRouter;
