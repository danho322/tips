//
//  SettingsViewController.swift
//  tips
//
//  Created by Daniel on 12/31/14.
//  Copyright (c) 2014 WorthlessApps. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var tipSlider: UISlider!
    
    var prevIndex = 0;
    
    let viewController = ViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var defaultIndex = viewController.defaultIndex()
        prevIndex = defaultIndex;
        var percentagesCount = Float(viewController.tipPercentages.count)
        var sliderPercentage = Float(defaultIndex) / percentagesCount
        var sliderOffset = 1.0 / (2 * percentagesCount)
        tipSlider.value = sliderPercentage + sliderOffset
        updateTipLabel(defaultIndex, animate: false)
    }
    
    func indexForValue(value : Float) -> Int {
        var index = 2
        if (value < 0.33) {
            index = 0
        }
        else if (value < 0.66) {
            index = 1
        }
        return index
    }
    
    func updateTipLabel(index: Int, animate: Bool) {
        var labelString = viewController.percentageStringForIndex(index)
        tipLabel.text = labelString
        
        if (animate) {
            UIView.animateWithDuration(0.1,
                animations: {
                    self.tipLabel.transform = CGAffineTransformMakeScale(1.5, 1.5)
                },
                completion: {
                    (finished: Bool) in
                    if (finished)
                    {
                        UIView.animateWithDuration(0.2,
                            animations: {
                                self.tipLabel.transform = CGAffineTransformMakeScale(1, 1)
                        })
                    }
            })

        }
    }
    
    @IBAction func onSlide(sender: AnyObject) {
        var sliderValue = tipSlider.value;
        var index = indexForValue(sliderValue)
        updateTipLabel(index, animate: index != prevIndex)
        prevIndex = index
    }
    
    @IBAction func onSlideFinished(sender: AnyObject) {
        var sliderValue = tipSlider.value;
        var defaultIndex = indexForValue(sliderValue)
        
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(defaultIndex, forKey:viewController.defaultKey)
        defaults.synchronize()
    }
    
    @IBAction func onBackTap(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
