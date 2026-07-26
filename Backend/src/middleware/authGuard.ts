import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { env } from '../config/env';
import { prisma } from '../config/db';

export const authGuard = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ error: { message: 'Missing or invalid token', code: 'UNAUTHORIZED' } });
    }

    const token = authHeader.split(' ')[1];
    const decoded = jwt.verify(token, env.JWT_SECRET) as { managerId: string; role: string };

    const manager = await prisma.manager.findUnique({ where: { id: decoded.managerId } });
    if (!manager) {
      return res.status(401).json({ error: { message: 'Invalid token', code: 'UNAUTHORIZED' } });
    }

    // Attach manager to request
    (req as any).manager = manager;
    next();
  } catch (error) {
    return res.status(401).json({ error: { message: 'Invalid or expired token', code: 'UNAUTHORIZED' } });
  }
};
