//
//  UIView+Image.swift
//  essaiInstagrid
//
//  Created by DAUBERCIES on 03/05/2021.
//

import UIKit

/// Save all the StackView as an image
extension UIView {
    var image: UIImage {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        return renderer.image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
    }
}
