//
//  GameBoard.swift
//  finalGame
//
//  Created by Chris and Paige on 4/28/19.
//  Copyright © 2019 C&P Games. All rights reserved.
//

import Foundation

class GameBoard {
    var paused: Bool = false
    var time: Double = 10.0
    var score: Int = 0
    var adjustment: Double = 0
    var totalTime: Double = 10.0
    let penalty: Double = -1.0
    let bonus: Double = 0.5
    
    struct ColorCount: Comparable {
        var color: Color
        var count: Int
        
        init(color: Color) {
            self.color = color
            self.count = 0
        }
        
        static func > (lhs: GameBoard.ColorCount, rhs: GameBoard.ColorCount) -> Bool {
            if lhs.count > rhs.count {
                return true
            }
            else {
                return false
            }
        }
        static func < (lhs: GameBoard.ColorCount, rhs: GameBoard.ColorCount) -> Bool {
            if lhs.count < rhs.count {
                return true
            }
            else {
                return false
            }
        }

    }
    lazy var simpleLevels = getLevels("simple")
    lazy var hardLevels = getLevels("hard")
    
    class GameTile {
        var color: Color
        
        init() {
            color = Color.gray
        }
        
        func getColor() -> Color {
            return color
        }
        
        func setColorTo(color: Color) {
            self.color = color
        }
        
        func nextColor() {
            setColorTo(color: color.next)
        }
    }
    
    let tiles: Int = 15
    
    var board: [[GameTile]]
    var colorCount: [ColorCount]

    init() {
        let width: Int = tiles
        let height: Int = tiles

        board = []
        for _ in 0 ..< height {
            var row: [GameTile] = []
            for _ in 0 ..< width {
                row.append(GameTile())
            }
            board.append(row)
        }
        colorCount = []
        for c in Color.allCases {
            colorCount.append(ColorCount(color: c))
        }
        
        self.loadLevel()
    }
    
    func getColorAt(row: Int, col: Int) -> Color {
        return board[row][col].getColor()
    }
    
    func nextColorAt(row: Int, col: Int) {
        board[row][col].nextColor()
    }
    
    func doCount() {
        for i in 0 ..< Color.allCases.count {
            colorCount[i].count = 0
        }
        
        for row in board {
            for tile in row {
                for i in 0 ..< Color.allCases.count {
                    if (colorCount[i].color == tile.color) {
                        colorCount[i].count += 1
                    }
                }
            }
        }
        colorCount.sort(by: >)
    }
    
    func select(row: Int, col: Int) {
        let color = board[row][col].getColor()
        doCount()
        var place: Int = 0
        for i in 0 ..< colorCount.count {
            if (colorCount[i].color == color) {
                place = i
                if (place == 0) {
                    score += 1
                    adjustment = bonus
                }
                else {
                    adjustment = penalty
                }
                time += adjustment
                totalTime += adjustment
                break
            }
        }
        for row in board {
            for tile in row {
                if (tile.color == colorCount[0].color) {
                    tile.color = Color.green
                }
                else if (tile.color == colorCount[place].color) {
                    tile.color = Color.red
                }
                else {
                    tile.color = Color.gray
                }
            }
        }
    }
    func getLevels(_ name : String) -> [String] {
        guard let url = Bundle.main.url(forResource: name, withExtension: "plist")
            else { return [] }
        guard let data = try? Data(contentsOf: url) else {return [] }
        guard let array = try? PropertyListDecoder().decode([String].self, from: data)
            else { return [] }
        return array
    }
    
    func getRandomLevel(_ plist : String) -> String {
        if (plist == "simple") {
            return simpleLevels.randomElement()!
        }
        return hardLevels.randomElement()!
    }
    
    func loadLevel() {
        let lvl = getRandomLevel("simple")
        var i = 0
        let num = Color.allCases.count - 3
        let rand = Int.random(in: 0 ..< (num))
        for char in lvl {
            let row = i / 15
            let column = i % 15
            let tile = board[row][column]
            let c = (Int(String(char))! + rand) % num
            tile.setColorTo(color: Color.allCases[c])
            i += 1
        }
    }
    
    func isPaused() -> Bool {
        return paused
    }
    func pause() {
        paused = true
    }
    func unpause() {
        paused = false
    }
    func reset() {
        paused = false
        time = 10.0
        score = 0
        adjustment = 0
        totalTime = 10.0
    }
    func getTotalTime() -> Double {
        return totalTime + time
    }
}
