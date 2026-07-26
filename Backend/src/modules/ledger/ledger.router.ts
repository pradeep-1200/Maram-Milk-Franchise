import { Router } from 'express';
import * as ledgerController from './ledger.controller';
import { authGuard } from '../../middleware/authGuard';

const ledgerRouter = Router();

ledgerRouter.use(authGuard);
ledgerRouter.get('/', ledgerController.getLedger);
ledgerRouter.post('/', ledgerController.createTransaction);

export default ledgerRouter;
