import { Router } from 'express';
import { submitManagerInventory, getManagerInventory } from './manager-inventory.controller';
import { authGuard } from '../../middleware/authGuard';

const router = Router();

router.use(authGuard);

router.post('/', submitManagerInventory);
router.get('/', getManagerInventory);

export default router;
