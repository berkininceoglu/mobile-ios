//
//  ViewController.swift
//  BMI Calculator
//
//  Created by Angela Yu on 21/08/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightSlider: UISlider!
    @IBOutlet weak var weightSlider: UISlider!
    
    var bmiValue : Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func sliderChanged(_ sender: UISlider) {
        if(sender.tag == 1){
            heightLabel.text = NSString(format: "%.2f", sender.value) as String + "m"
        }else{
            weightLabel.text = NSString(format: "%.0f", sender.value) as String + "Kg"
        }
    }
    @IBAction func calculatePressed(_ sender: UIButton) {
        let height = heightSlider.value
        let weight = weightSlider.value
        
        bmiValue = weight / pow(height, 2)
        print(bmiValue)
        
        performSegue(withIdentifier: "goToResult", sender: self)
    }
    
    func getBMIValue() -> String{
        return NSString(format: "%.2f", bmiValue) as String
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToResult"){
            let destinationVC = segue.destination as! ResultViewController
            //as! = force downcast
            destinationVC.bmiValue = getBMIValue()
        }
    }
    
}

