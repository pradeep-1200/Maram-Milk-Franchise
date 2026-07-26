import { Request, Response, NextFunction } from 'express';
import * as dpService from './delivery-persons.service';
import { createDpSchema, updateDpSchema } from './delivery-persons.validation';
import { uploadFile } from '../../utils/storage';

export const listDeliveryPersons = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const search = req.query.search as string;
    const dps = await dpService.getDeliveryPersons(search);
    res.json(dps);
  } catch (error) {
    next(error);
  }
};

export const getDeliveryPerson = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const dp = await dpService.getDeliveryPersonById(req.params.id as string);
    if (!dp) {
      return res.status(404).json({ error: { message: 'Delivery Person not found', code: 'NOT_FOUND' } });
    }
    res.json(dp);
  } catch (error) {
    next(error);
  }
};

export const createDeliveryPerson = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const validatedData = createDpSchema.parse(req.body);
    const newDp = await dpService.createDeliveryPerson(validatedData);
    res.status(201).json(newDp);
  } catch (error: any) {
    if (error.name === 'ZodError') {
      return res.status(400).json({ error: { message: 'Validation failed', code: 'VALIDATION_ERROR', details: error.errors } });
    }
    next(error);
  }
};

export const updateDeliveryPerson = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const validatedData = updateDpSchema.parse(req.body);
    const updatedDp = await dpService.updateDeliveryPerson(req.params.id as string, validatedData);
    res.json(updatedDp);
  } catch (error: any) {
    if (error.name === 'ZodError') {
      return res.status(400).json({ error: { message: 'Validation failed', code: 'VALIDATION_ERROR', details: error.errors } });
    }
    next(error);
  }
};

export const deleteDeliveryPerson = async (req: Request, res: Response, next: NextFunction) => {
  try {
    const deletedDp = await dpService.deleteDeliveryPerson(req.params.id as string);
    res.json(deletedDp);
  } catch (error) {
    next(error);
  }
};

const handleFileUpload = async (req: Request, res: Response, next: NextFunction, fieldName: 'photoUrl' | 'aadharCopyUrl' | 'licenseCopyUrl') => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: { message: 'No file uploaded', code: 'BAD_REQUEST' } });
    }

    const dpId = req.params.id as string;
    const folder = `delivery-persons/${dpId}`;
    const filename = `${fieldName}_${Date.now()}`;
    
    const secureUrl = await uploadFile(req.file.buffer, folder, filename);

    // Update the record with the new URL
    const updatedDp = await dpService.updateDeliveryPerson(dpId, { [fieldName]: secureUrl });
    
    res.json({ url: secureUrl, deliveryPerson: updatedDp });
  } catch (error) {
    next(error);
  }
};

export const uploadPhoto = (req: Request, res: Response, next: NextFunction) => handleFileUpload(req, res, next, 'photoUrl');
export const uploadAadhar = (req: Request, res: Response, next: NextFunction) => handleFileUpload(req, res, next, 'aadharCopyUrl');
export const uploadLicense = (req: Request, res: Response, next: NextFunction) => handleFileUpload(req, res, next, 'licenseCopyUrl');
