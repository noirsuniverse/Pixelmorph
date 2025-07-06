//
//  UImageExtensions.swift
//  PixelMorph
//
//  Created by Mohamed Abdullahi on 18/08/2024.
//
import UIKit
import ImageIO
import MobileCoreServices
import AVFoundation // Import to use AVFileType

extension UIImage {
    func heifRepresentation() -> Data? {
        guard let cgImage = self.cgImage else { return nil }
        let mutableData = NSMutableData()
        guard let imageDestination = CGImageDestinationCreateWithData(mutableData as CFMutableData, AVFileType.heic as CFString, 1, nil) else {
            return nil
        }
        
        CGImageDestinationAddImage(imageDestination, cgImage, nil)
        
        if CGImageDestinationFinalize(imageDestination) {
            return mutableData as Data
        } else {
            return nil
        }
    }
    
    func tiffData() -> Data? {
            guard let cgImage = self.cgImage else { return nil }
            let data = NSMutableData()
            let uti = UTType.tiff.identifier as CFString
            guard let destination = CGImageDestinationCreateWithData(data, uti, 1, nil) else { return nil }
            CGImageDestinationAddImage(destination, cgImage, nil)
            return CGImageDestinationFinalize(destination) ? data as Data : nil
        }

    func heicData() -> Data? {
            guard let cgImage = self.cgImage else { return nil }
            let data = NSMutableData()
            guard let destination = CGImageDestinationCreateWithData(data, AVFileType.heic as CFString, 1, nil) else { return nil }
            CGImageDestinationAddImage(destination, cgImage, nil)
            CGImageDestinationFinalize(destination)
            return data as Data
        }
    
    func bmpData() -> Data? {
            guard let cgImage = self.cgImage else { return nil }
            let width = Int(self.size.width)
            let height = Int(self.size.height)
            let bitmapInfo = cgImage.bitmapInfo
            let colorSpace = cgImage.colorSpace ?? CGColorSpaceCreateDeviceRGB()
            
            guard let context = CGContext(
                data: nil,
                width: width,
                height: height,
                bitsPerComponent: cgImage.bitsPerComponent,
                bytesPerRow: cgImage.bytesPerRow,
                space: colorSpace,
                bitmapInfo: bitmapInfo.rawValue
            ) else { return nil }
            
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
            return context.data.flatMap { Data(bytes: $0, count: width * height * 4) }
        }
}



