import { Request, Response, NextFunction } from 'express';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { prisma } from '../../config/db';
import { env } from '../../config/env';
import { uploadFile } from '../../utils/storage';

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
        photoUrl: manager.photoUrl,
      },
    });
  } catch (error) {
    next(error);
  }
};

export const logout = (req: Request, res: Response) => {
  res.json({ message: 'Logged out successfully' });
};

export const getMe = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const manager = (req as any).manager;
    if (!manager) {
      return res.status(401).json({ error: { message: 'Unauthorized', code: 'UNAUTHORIZED' } });
    }
    res.json({
      manager: {
        name: manager.name,
        role: manager.role,
        branchName: manager.branchName,
        photoUrl: manager.photoUrl,
      },
    });
  } catch (error) {
    next(error);
  }
};

export const uploadPhoto = async (req: Request, res: Response, next: NextFunction) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: { message: 'No file uploaded', code: 'BAD_REQUEST' } });
    }
    if (!req.file.mimetype.startsWith('image/')) {
      return res.status(400).json({ error: { message: 'Only image files are allowed', code: 'BAD_REQUEST' } });
    }

    const manager = (req as any).manager;
    if (!manager) {
      return res.status(401).json({ error: { message: 'Unauthorized', code: 'UNAUTHORIZED' } });
    }

    const folder = `managers/${manager.id}`;
    const filename = `photoUrl_${Date.now()}`;
    
    const secureUrl = await uploadFile(req.file.buffer, folder, filename);

    await prisma.manager.update({
      where: { id: manager.id },
      data: { photoUrl: secureUrl },
    });
    
    res.json({ url: secureUrl });
  } catch (error) {
    next(error);
  }
};
