//
//  GameOverViewController.swift
//  finalGame
//
//  Created by Chris & Paige on 4/30/19.
//  Copyright © 2019 C&P Games. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {
    @IBOutlet var totalTimeLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let board = appDelegate.board

        totalTimeLabel.text = "\(board.getTotalTime())"
        scoreLabel.text = "\(board.score)"
        board.reset()
    }
    
}
