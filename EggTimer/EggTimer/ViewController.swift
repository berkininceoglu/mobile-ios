//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let eggTimes = ["Soft": 5, "Medium": 7, "Hard": 12]
    //
    
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        let hardness = sender.currentTitle!
        
        var time = eggTimes[hardness]!
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            print(time)
            time -= 1
            if time == -1 {
                    timer.invalidate()
                }
        }
    }

    
    
}