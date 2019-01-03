//
//  ViewController.swift
//  CurrencyApp
//
//  Created by Hemanth on 27/12/18.
//  Copyright © 2018 Hemanth. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    @IBOutlet var amountTF: UITextField!
    
    let api = ApiCommunication()
    var cur : [String:Any] = [:]
    var keys:[String] = []
    var values:[Double] = []
    var amount  = Double()
    var currencyCode = String()
    
    @IBOutlet var picker: UIPickerView!
    @IBOutlet var currencyLbl: UILabel!
    @IBOutlet var amountLbl: UILabel!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        DispatchQueue.global(qos: .background).async {
            self.api.getCurrencyRate()
            self.api.getCurrencyCompletionHandler = {(currency:[String:Any]) -> Void in
                self.cur = currency["rates"] as! [String:Any]
                for (key,value) in self.cur
                {
                    self.keys.append(key)
                    self.values.append(value as! Double)
                }
                //print(self.keys)
                //print(self.values)
                DispatchQueue.main.async {
                    self.picker.reloadAllComponents()
                }
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return keys.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return keys[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        //print(keys[row])
        currencyCode = keys[row]
        amount = values[row]
    }

    @IBAction func convertAction(_ sender: UIButton)
    {
        self.currencyLbl.text = currencyCode
        let amountEnter = amountTF.text!
        if amountEnter == ""
        {
            let alert = UIAlertController.init(title: "Alert", message: "Enter Amount", preferredStyle: .alert)
            let action = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            let totalAmount = Double(amountEnter)! * amount
            self.amountLbl.text = String(format: "%.2f", totalAmount)
            self.amountTF.text = ""
        }
        
    }
}
