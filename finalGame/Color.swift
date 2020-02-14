//
//  Color.swift
//  finalGame
//
//  Created by Chris and Paige on 4/28/19.
//  Copyright © 2019 C&P Games. All rights reserved.
//

import Foundation
import UIKit

/* the following extension to UIColor was modified from:
 * https://www.hackingwithswift.com/example-code/uicolor/how-to-convert-a-hex-color-to-a-uicolor
 */
extension UIColor {
    public convenience init(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        self.init(red: 1, green: 1, blue: 1, alpha: 0.5)
        return
    }
}

enum Color: Int, CaseIterable {
    case
        orange,
        blue,
        darkblue,
        yellow,
        gray,
        red,
        green

    var next: Color {
        return Color.allCases[(self.rawValue + 1) % Color.allCases.count]
    }
        
    var instance: UIColor {
        switch self {
            case .blue: return UIColor(hex: "#57B8FFFF")
            case .darkblue: return UIColor(hex: "#217683FF")
            case .yellow: return UIColor(hex: "#FBB13CFF")
            case .orange: return UIColor.orange
            case .gray: return UIColor.gray
            case .red: return UIColor(hex: "#FE6847FF")
            case .green: return UIColor(hex: "#72B546FF")
        }
    }
}
