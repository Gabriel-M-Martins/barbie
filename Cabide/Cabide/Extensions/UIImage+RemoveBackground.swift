//
//  UIImage+RemoveBackground.swift
//  Cabide
//
//  Created by Eduardo Filot Brum on 26/07/23.
//

import UIKit
import CoreML

extension UIImage {
    func removeBackground() -> UIImage? {
        guard let model = getRemoveBackgroundModel() else { return nil }
        
        let width: CGFloat = 1024
        let height: CGFloat = 1024
        let resizedImage = resized(to: CGSize(width: height, height: height), scale: 1)
        
        guard
            let pixelBuffer = resizedImage.pixelBuffer(width: Int(width), height: Int(height)),
            let outputPredictionImage = try? model.prediction(x_1: pixelBuffer)
        else { return nil }
        
        let outputCIImage = CIImage(cvPixelBuffer: outputPredictionImage.activation_out)
        
        guard let maskImage = outputCIImage.removeWhitePixels(),
              let maskBlurImage = maskImage.applyBlurEffect() else { return nil }
        
        guard let resizedCIImage = CIImage(image: resizedImage),
              let compositedImage = resizedCIImage.composite(with: maskBlurImage) else { return nil }
        let finalImage = UIImage(ciImage: compositedImage).resized(to: CGSize(width: size.width, height: size.height))
        
        return finalImage
    }
    
    private func getRemoveBackgroundModel() -> RemoveBackgroundModel? {
        do {
            let config = MLModelConfiguration()
            return try RemoveBackgroundModel(configuration: config)
        } catch {
            return nil
        }
    }
}

extension UIImage {
    var opaqueBounds: CGRect? {
//        guard let cgImage = self.cgImage else { return nil }
//        let width = Int(self.size.width)
//        let height = Int(self.size.height)
//        let bitmapData = CFDataCreateMutable(nil, width * height * 4)
//        guard let bitmapContext = CGContext(data: CFDataGetMutableBytePtr(bitmapData),
//                                            width: width,
//                                            height: height,
//                                            bitsPerComponent: 8,
//                                            bytesPerRow: width * 4,
//                                            space: CGColorSpaceCreateDeviceRGB(),
//                                            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
//        else { return nil }
//
//        bitmapContext.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
//        let data = CFDataGetBytePtr(bitmapData)
//
//        var minX = width
//        var maxX = 0
//        var minY = height
//        var maxY = 0
//
//        for x in 0..<width {
//            for y in 0..<height {
//                let pixel = data![(x+y*width)*4 + 3]
//                if pixel > 0 {
//                    minX = min(x, minX)
//                    maxX = max(x, maxX)
//                    minY = min(y, minY)
//                    maxY = max(y, maxY)
//                }
//            }
//        }
//
//        if minX > maxX || minY > maxY {
//            return nil
//        } else {
//            return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
//        }
        
        guard let cgImage = self.cgImage else { return nil }

        let width = cgImage.width
        let height = cgImage.height
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let bitmapInfo: UInt32 = CGImageAlphaInfo.premultipliedLast.rawValue
        let context = CGContext(data: nil,
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: bytesPerRow,
                                space: colorSpace,
                                bitmapInfo: bitmapInfo)!

        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        guard let pixelData = context.data else { return nil }
        var minX = width
        var maxX = 0
        var minY = height
        var maxY = 0

        let buffer = pixelData.bindMemory(to: UInt32.self, capacity: width * height)
        for y in 0..<height {
            for x in 0..<width {
                let pixel = buffer[y * width + x]
                let alpha = (pixel >> 24) & 0xFF

                if alpha > 0 {
                    minX = min(x, minX)
                    maxX = max(x, maxX)
                    minY = min(y, minY)
                    maxY = max(y, maxY)
                }
            }
        }

        if minX > maxX || minY > maxY {
            return nil
        } else {
            return CGRect(x: minX, y: minY, width: maxX - minX + 1, height: maxY - minY + 1)
        }
    }
    
    func croppedToOpaque() -> UIImage? {
        guard let opaqueBounds = self.opaqueBounds else { return nil }
        let opaqueRect = CGRect(x: opaqueBounds.origin.x,
                                y: opaqueBounds.origin.y,
                                width: opaqueBounds.size.width,
                                height: opaqueBounds.size.height)
        guard let cgImage = self.cgImage?.cropping(to: opaqueRect) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}
