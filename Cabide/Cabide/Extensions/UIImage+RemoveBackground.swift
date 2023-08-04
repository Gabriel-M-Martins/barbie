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
        guard let cgImage = self.cgImage else { return nil }
        let width = Int(self.size.width)
        let height = Int(self.size.height)
        let bitmapData = CFDataCreateMutable(nil, width * height * 4)
        guard let bitmapContext = CGContext(data: CFDataGetMutableBytePtr(bitmapData),
                                            width: width,
                                            height: height,
                                            bitsPerComponent: 8,
                                            bytesPerRow: width * 4,
                                            space: CGColorSpaceCreateDeviceRGB(),
                                            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
        else { return nil }
        
        bitmapContext.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        let data = CFDataGetBytePtr(bitmapData)
        
        var minX = width
        var maxX = 0
        var minY = height
        var maxY = 0
        
        for x in 0..<width {
            for y in 0..<height {
                let pixel = data![(x+y*width)*4 + 3]
                if pixel > 0 {
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
            return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
        }
    }
    
    func croppedToOpaque() -> UIImage? {
        guard let opaqueBounds = self.opaqueBounds else { return nil }
        let opaqueRect = CGRect(x: opaqueBounds.origin.x,
                                y: self.size.height - opaqueBounds.origin.y - opaqueBounds.size.height,
                                width: opaqueBounds.size.width,
                                height: opaqueBounds.size.height)
        guard let cgImage = self.cgImage?.cropping(to: opaqueRect) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}
