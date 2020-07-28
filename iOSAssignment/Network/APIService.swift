//
//  APIService.swift
//  iOSAssignment
//
//  Created by Nitesh Meshram on 25/07/20.
//  Copyright © 2020 Nitesh Meshram. All rights reserved.
//

import Foundation
import UIKit



class APIService: NSObject {
    
    lazy var endPoint: String = {
        return "https://randomuser.me/api/?results=50"
    }()
    
    func getUserDetails(completion: @escaping (Results<[[String: AnyObject]]>) -> Void) {
        
        let urlString = endPoint
        
        guard let url = URL(string: urlString) else { return completion(.Error("Invalid URL, we can't update your feed")) }
        
        guard NetworkReachability.shared.isConnected == true else {
            print("No Internet Connection")
            return completion(.Error("No Internet Connection"))
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else { return completion(.Error(error!.localizedDescription)) }
            guard let data = data else { return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
            }
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                //                print(jsonData)
                if let object = jsonData as? [String: Any] {
                    // json is a dictionary
                    if let jsonObjects = object["results"] as? [[String : AnyObject]] {
                        completion(.Success(jsonObjects))
                    }else {
                        
                    }
                    
                } else if let object = jsonData as? [Any] {
                    // json is an array
                    print(object)
                }else {
                    print("JSON is invalid")
                }
                
            }catch {
                print(error)
                return completion(.Error(error.localizedDescription))
            }
        }.resume()
    }
}

enum Results<T> {
    case Success(T)
    case Error(String)
}
