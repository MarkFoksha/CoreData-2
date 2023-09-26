//
//  ImageTransformer.swift
//  CoreData-2
//
//  Created by Марк Фокша on 26.09.2023.
//

import UIKit

class ImageTransformer: ValueTransformer {
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let image = value as? UIImage else { return nil }
        
        let imageData = image.pngData()
        return imageData
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let imageData = value as? Data else { return nil }
        let image = UIImage(data: imageData)
        
        return image
    }
}
