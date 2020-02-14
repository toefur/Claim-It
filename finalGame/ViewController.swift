//
//  ViewController.swift
//  finalGame
//
//  Created by Chris and Paige on 4/28/19.
//  Copyright © 2019 C&P Games. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var adjustmentLabel: UILabel!
    
    var countdown: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        beginTimer()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func beginTimer() {
        countdown = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let board = appDelegate.board
        scoreLabel.text = "\(board.score)"
        if (board.adjustment > 0) {
            adjustmentLabel.text = "+\(board.adjustment)"
            adjustmentLabel.textColor = Color.green.instance
        }
        else {
            adjustmentLabel.text = "\(board.adjustment)"
            adjustmentLabel.textColor = Color.red.instance
        }

        if (board.isPaused()) {
            adjustmentLabel.isHidden = false
            return
        }
        adjustmentLabel.isHidden = true
        board.time -= 0.1
        /* rounding to miliseconds, code borrowed from here:
         * https://stackoverflow.com/a/27341001 */
        board.time = Double(round(10*board.time)/10)
        timerLabel.text = "\(board.time)"
        if board.time <= 5 {
            timerLabel.textColor = Color.red.instance
        }
        else {
            timerLabel.textColor = Color.green.instance
        }
        if board.time <= 0 {
            countdown.invalidate()
            countdown = nil
            performSegue(withIdentifier: "gameOverSegue", sender: nil)
        }
    }
}
