import { v2 as cloudinary } from 'cloudinary';
import streamifier from 'streamifier';
import { env } from '../config/env';

// Configure Cloudinary
if (env.CLOUDINARY_CLOUD_NAME && env.CLOUDINARY_API_KEY && env.CLOUDINARY_API_SECRET) {
  cloudinary.config({
    cloud_name: env.CLOUDINARY_CLOUD_NAME,
    api_key: env.CLOUDINARY_API_KEY,
    api_secret: env.CLOUDINARY_API_SECRET,
  });
}

export const uploadFile = (buffer: Buffer, folder: string, filename?: string): Promise<string> => {
  return new Promise((resolve, reject) => {
    if (!env.CLOUDINARY_CLOUD_NAME) {
      console.warn('Storage is not configured. Returning mock URL.');
      return resolve(`https://mock-storage.local/${folder}/${filename || Date.now()}`);
    }

    const stream = cloudinary.uploader.upload_stream(
      { folder, public_id: filename },
      (error, result) => {
        if (result) {
          resolve(result.secure_url);
        } else {
          reject(error);
        }
      }
    );

    streamifier.createReadStream(buffer).pipe(stream);
  });
};
