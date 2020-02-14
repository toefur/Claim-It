//
//  GameView.swift
//  finalGame
//
//  Created by Chris and Paige on 4/28/19.
//  Copyright © 2019 C&P Games. All rights reserved.
//

import Foundation
import UIKit

class GameView: UIView {
    let tiles: Int = 15

    var grid: [[CGRect]] = []
    @IBAction func handleTap(_ sender : UIGestureRecognizer) {
        if (sender.state == .ended) {
            let tapPoint = sender.location(in: self)
            let gridSize = (self.bounds.width < self.bounds.height) ? self.bounds.width : self.bounds.height
            let gridOrigin = CGPoint(x: (self.bounds.width - gridSize)/2, y: (self.bounds.height - gridSize)/2)
            let delta: CGFloat = gridSize/CGFloat(tiles)
            let col = Int((tapPoint.x - gridOrigin.x)/delta)
            let row = Int((tapPoint.y - gridOrigin.y)/delta)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let board = appDelegate.board

            if (0 <= col && col < tiles && 0 <= row && row < tiles) {
                sender.isEnabled = false
                board.select(row: row, col: col)
                board.pause()

                self.setNeedsDisplay()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    board.loadLevel()
                    self.setNeedsDisplay()
                    board.unpause()
                    sender.isEnabled = true
                }
            }
            else {
                sender.isEnabled = true
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let gridSize = (self.bounds.width < self.bounds.height) ? self.bounds.width : self.bounds.height
        let delta = gridSize/CGFloat(tiles)

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let board = appDelegate.board
        
        if (grid == []) {
            for r in 0 ..< tiles {
                var row: [CGRect] = []
                for c in 0 ..< tiles {
                    /* create the rectangles that will be drawn */
                    /* the 1.02 scalar is to fix a sizing issue where gaps form between tiles */
                    row.append(CGRect(origin: CGPoint(x: CGFloat(c)*delta, y: CGFloat(r)*delta), size: CGSize(width: delta*1.02, height: delta*1.02)))
                }
                grid.append(row)
            }
        }
        for r in 0 ..< tiles {
            for c in 0 ..< tiles {
                board.getColorAt(row: r, col: c).instance.setFill()
                let rect = grid[r][c]
                context?.fill(rect)
            }
        }
    }
}
