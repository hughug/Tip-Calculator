//
//  ViewController.swift
//  Tip Caculator
//
//  Created by 陈抱一 on 12/15/16.
//  Copyright © 2016 抱一. All rights reserved.
//

import UIKit
import Foundation

extension UITextField{
    
    func addDoneButtonToKeyboard(myAction:Selector?){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: myAction)
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
}

// Function for tip calculation
class TipCalculator {
    
    let rawtotal: Double
    let taxPct: Double
    let people: Double
    let tipPct: Double
    
    init(rawtotal:Double, taxPct:Double, tipPct:Double, people:Double) {
        self.rawtotal = rawtotal
        self.taxPct   = taxPct
        self.tipPct   = tipPct
        self.people   = people
    }
    
    
    func EachWithTip(tipPct:Double, taxPct:Double, people:Double) -> Double{
        let eachpay: Double
        let roundedpay: Double
        eachpay = ((rawtotal/(taxPct*0.01 + 1)) * (1 + tipPct*0.01 + taxPct*0.01))/people
        roundedpay = round(10*eachpay)/10
        
        return roundedpay
    }
    
    func TotalWithTip(tipPct:Double, taxPct:Double, people:Double) -> Double{
        return EachWithTip(tipPct: tipPct, taxPct:taxPct, people:people)*people
    }
    
}

class ViewController: UIViewController, UITextFieldDelegate {
    
    // Mark:properties
    

    @IBOutlet weak var RawTotal: UITextField!

    @IBOutlet weak var TipRate: UITextField!

    @IBOutlet weak var NumPeople: UILabel!
    @IBOutlet weak var addpeople: UIStepper!

    @IBOutlet weak var TaxRate: UITextField!
    
    @IBAction func addpeople(_ sender: UIStepper) {
        NumPeople.text = "\(Int(addpeople.value))"
    }




    @IBOutlet weak var totalvalue: UILabel!
    @IBOutlet weak var eachvalue: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RawTotal.delegate = self
        TaxRate.delegate = self
        TipRate.delegate = self
        RawTotal.becomeFirstResponder()
        RawTotal.addDoneButtonToKeyboard(myAction:  #selector(RawTotal.resignFirstResponder))
        TaxRate.addDoneButtonToKeyboard(myAction:  #selector(RawTotal.resignFirstResponder))
        TipRate.addDoneButtonToKeyboard(myAction:  #selector(RawTotal.resignFirstResponder))
        
        loaddata()
        
    }
    

    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func savedata(){
        var defaults: UserDefaults = UserDefaults.standard
        
        defaults.set(TaxRate.text, forKey: "taxratesaved")
        defaults.set(TipRate.text, forKey:"tipratesaved")
        
        defaults.synchronize()
        
    }
    
    func loaddata(){
        var defaults: UserDefaults = UserDefaults.standard
        
        if (defaults.object(forKey: "taxratesaved") as? String) != nil {
            TaxRate.text = defaults.object(forKey: "taxratesaved") as? String
        }
        
        if (defaults.object(forKey: "tipratesaved") as? String) != nil {
            TipRate.text = defaults.object(forKey: "tipratesaved") as? String
        }
        
    }
    
    
    @IBAction func compute(_ sender: UIButton) {
        let rawtotal = Double(RawTotal.text!)
        let taxPct   = Double(TaxRate.text!)
        let tipPct   = Double(TipRate.text!)
        let people   = Double(NumPeople.text!)

        
        let tipcal = TipCalculator(rawtotal: rawtotal!, taxPct: taxPct!, tipPct: tipPct!, people: people!)
        
        
        totalvalue.text = "The total is        \(tipcal.TotalWithTip(tipPct: tipPct!, taxPct:taxPct!, people:people!))"
        eachvalue.text  = "  Each pays        \(tipcal.EachWithTip(tipPct: tipPct!, taxPct:taxPct!, people:people!))"
        
        savedata()
        
    }
 
    
    
}

