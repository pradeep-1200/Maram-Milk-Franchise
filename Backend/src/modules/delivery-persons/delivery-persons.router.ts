import { Router } from 'express';
import * as dpController from './delivery-persons.controller';
import { authGuard } from '../../middleware/authGuard';
import { upload } from '../../middleware/upload';

const dpRouter = Router();

// All routes require auth
dpRouter.use(authGuard);

dpRouter.get('/', dpController.listDeliveryPersons);
dpRouter.post('/', dpController.createDeliveryPerson);
dpRouter.get('/:id', dpController.getDeliveryPerson);
dpRouter.put('/:id', dpController.updateDeliveryPerson);
dpRouter.delete('/:id', dpController.deleteDeliveryPerson);

// File uploads (expecting form-data with key 'file')
dpRouter.post('/:id/photo', upload.single('file'), dpController.uploadPhoto);
dpRouter.post('/:id/aadhar', upload.single('file'), dpController.uploadAadhar);
dpRouter.post('/:id/license', upload.single('file'), dpController.uploadLicense);

export default dpRouter;
