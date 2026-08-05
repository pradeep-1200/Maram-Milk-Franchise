import { Request, Response, NextFunction } from 'express';
import { z } from 'zod';
import { prisma } from '../../config/db';

const logSchema = z.object({
  product: z.string(),
  quantity: z.number().nonnegative(),
});

const submitLogsSchema = z.object({
  date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/),
  logs: z.array(logSchema),
});

export const submitManagerInventory = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { date, logs } = submitLogsSchema.parse(req.body);
    const managerId = (req as any).manager?.id;
    if (!managerId) {
      return res.status(401).json({ message: 'Unauthorized' });
    }
    
    const results = await prisma.$transaction(
      logs.map((log) =>
        prisma.managerInventoryLog.upsert({
          where: {
            date_product_managerId: {
              date,
              product: log.product,
              managerId,
            },
          },
          update: {
            quantity: log.quantity,
          },
          create: {
            date,
            product: log.product,
            quantity: log.quantity,
            managerId,
          },
        })
      )
    );
    
    res.json(results);
  } catch (error) {
    next(error);
  }
};

export const getManagerInventory = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const date = z.string().regex(/^\d{4}-\d{2}-\d{2}$/).parse(req.query.date);
    const managerId = (req as any).manager?.id;
    if (!managerId) {
      return res.status(401).json({ message: 'Unauthorized' });
    }
    
    const results = await prisma.managerInventoryLog.findMany({
      where: { date, managerId },
    });
    res.json(results);
  } catch (error) {
    next(error);
  }
};
