import { Request, Response, NextFunction } from 'express';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { prisma } from '../../config/db';
import { env } from '../../config/env';

export const login = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) {
      return res.status(400).json({ error: { message: 'Email and password are required', code: 'BAD_REQUEST' } });
    }

    const manager = await prisma.manager.findUnique({ where: { email } });
    if (!manager) {
      return res.status(401).json({ error: { message: 'Invalid credentials', code: 'UNAUTHORIZED' } });
    }

    const isMatch = await bcrypt.compare(password, manager.passwordHash);
    if (!isMatch) {
      return res.status(401).json({ error: { message: 'Invalid credentials', code: 'UNAUTHORIZED' } });
    }

    const token = jwt.sign(
      { managerId: manager.id, role: manager.role },
      env.JWT_SECRET,
      { expiresIn: env.JWT_EXPIRES_IN as any }
    );

    res.json({
      token,
      manager: {
        name: manager.name,
        role: manager.role,
        branchName: manager.branchName,
      },
    });
  } catch (error) {
    next(error);
  }
};

export const logout = (req: Request, res: Response) => {
  res.json({ message: 'Logged out successfully' });
};
