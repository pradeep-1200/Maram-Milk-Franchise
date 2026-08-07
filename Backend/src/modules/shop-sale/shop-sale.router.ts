import { Router } from 'express';
import * as shopSaleController from './shop-sale.controller';
import { authGuard } from '../../middleware/authGuard';

const shopSaleRouter = Router();

shopSaleRouter.use(authGuard);

shopSaleRouter.get('/', shopSaleController.getShopSales);
shopSaleRouter.post('/', shopSaleController.createShopSale);

export default shopSaleRouter;
