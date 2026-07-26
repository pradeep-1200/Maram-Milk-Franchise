import { Router } from 'express';
import * as attendanceController from './attendance.controller';
import { authGuard } from '../../middleware/authGuard';

const attendanceRouter = Router();

// All routes require auth
attendanceRouter.use(authGuard);

attendanceRouter.get('/', attendanceController.getAttendance);
attendanceRouter.post('/bulk', attendanceController.updateBulkAttendance);
attendanceRouter.put('/:dpId', attendanceController.updateSingleAttendance);

export default attendanceRouter;
