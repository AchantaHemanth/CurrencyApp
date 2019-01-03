//
//  ApiCommunication.swift
//  CurrencyApp
//
//  Created by Hemanth on 28/12/18.
//  Copyright © 2018 Hemanth. All rights reserved.
//

import UIKit

class ApiCommunication: NSObject {

    let urlString = "https://ratesapi.io/api/latest?base=INR"
    var getCurrencyCompletionHandler:([String:Any])-> Void = {_ in}
    
    func getCurrencyRate()
    {
        let url = URL(string: urlString)
        //print("URL : \(url!)")
        var request = URLRequest.init(url: url!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error
            {
                print("Error : \(error)")
            }
            else
            {
                do
                {
                    let rates = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:Any]
                    //print("Rates : \(rates)")
                    self.getCurrencyCompletionHandler(rates)
                }
                catch
                {
                    print("Erroe")
                }
            }
        }
        task.resume()
    }
}
