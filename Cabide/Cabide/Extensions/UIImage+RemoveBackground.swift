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
