import express, { Application, Request, Response } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import { errorHandler } from './middleware/errorHandler';
import authRouter from './modules/auth/auth.router';
import dpRouter from './modules/delivery-persons/delivery-persons.router';
import attendanceRouter from './modules/attendance/attendance.router';
import routesRouter from './modules/routes/routes.router';
import inventoryRouter from './modules/inventory/inventory.router';
import dispatchRouter from './modules/dispatch/dispatch.router';
import emptyBottlesRouter from './modules/empty-bottles/empty-bottles.router';
import ledgerRouter from './modules/ledger/ledger.router';
import reportsRouter from './modules/reports/reports.router';

const app: Application = express();

// Middleware
app.use(helmet());
app.use(cors()); // Allow all origins by default for mobile app
app.use(morgan('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Health Check Endpoint
app.get('/health', (req: Request, res: Response) => {
  res.json({ status: 'ok' });
});

// API Routes
app.use('/api/v1/auth', authRouter);
app.use('/api/v1/delivery-persons', dpRouter);
app.use('/api/v1/attendance', attendanceRouter);
app.use('/api/v1/routes', routesRouter);
app.use('/api/v1/inventory', inventoryRouter);
app.use('/api/v1/dispatch', dispatchRouter);
app.use('/api/v1/empty-bottles', emptyBottlesRouter);
app.use('/api/v1/ledger', ledgerRouter);
app.use('/api/v1/reports', reportsRouter);

// Centralized Error Handling (must be last)
app.use(errorHandler);

export default app;
