//
//  ViewController.swift
//  tips
//
//  Created by Daniel on 12/31/14.
//  Copyright (c) 2014 WorthlessApps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var splitTotalLabel: UILabel!
    @IBOutlet weak var splitNumberLabel: UILabel!
    @IBOutlet weak var splitSlider: UISlider!
    
    let tipPercentages = [0.18, 0.2, 0.22]
    let defaultKey = "percentage_index"
    let splitMax = 9
    var initialSplitLabelX = CGFloat(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initialSplitLabelX = splitNumberLabel.frame.origin.x
        
        tipLabel.text = "$0.00"
        totalLabel.text = "$0.00"
        splitSlider.value = 0
        
        onSplitSliderValueChanged(self)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tipControl.selectedSegmentIndex = defaultIndex()
        onEditingChanged(self)
    
        billField.becomeFirstResponder()
    }
    
    func defaultIndex() -> Int {
        var defaults = NSUserDefaults.standardUserDefaults()
        var intValue = defaults.integerForKey(defaultKey)
        return intValue
    }
    
    func percentageStringForIndex(index: Int) -> String {
        if (index >= tipPercentages.count) {
            return "Error"
        }
        var percentage = tipPercentages[index]
        percentage = percentage * 100
        var percentString = String(format: "%g", percentage)
        return "\(percentString)%"
    }
    
    func currentSplitTotalNum() -> Int {
        var floatValue = Float(splitMax) * splitSlider.value
        var modifiedIntValue = Int(floatValue) + 1
        return modifiedIntValue
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        var tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        
        var billAmount = (billField.text as NSString).doubleValue
        var tip = billAmount * tipPercentage
        var total = billAmount + tip
        var splitTotal = Float(total) / Float(currentSplitTotalNum())
    
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        splitTotalLabel.text = String(format: "$%.2f", splitTotal)
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func onSettingsTap(sender: AnyObject) {
        performSegueWithIdentifier("settingsSegue", sender: self)
    }
    
    @IBAction func onSplitSliderValueChanged(sender: AnyObject) {
        var peopleNum = currentSplitTotalNum()
        var peopleString = "people"
        if (peopleNum == 1) {
            peopleString = "person"
        }
        
        splitNumberLabel.text = String(format: "%d %@", peopleNum, peopleString)
        onEditingChanged(self)
        
        var xPos = Float(initialSplitLabelX) + Float(splitSlider.frame.size.width - 30) * splitSlider.value
        self.splitNumberLabel.center = CGPointMake(CGFloat(xPos), splitNumberLabel.center.y)
    }
}

