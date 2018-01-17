////
//
////  ALNetworking.swift
//
////  Almak
//
////
//
////  Created by Tung Fam on 1/25/17.
//
////  Copyright © 2017 Almak. All rights reserved.
//
////
//
//
//
//import UIKit
//
//import Alamofire
//
//import RealmSwift
//
//import SwiftyJSON
//
//
//
//class ALNetworking: NSObject {
//    
//    
//    
//    var sessionManager: Alamofire.SessionManager = {
//        
//        // Create the server trust policies
//        
//        
//        
//        // TODO: commented to fix the forever loading
//        
//        //        let serverTrustPolicies: [String: ServerTrustPolicy] = [
//        
//        //            "1c.avto-prokat.spb.ru": .disableEvaluation,
//        
//        //            "avto-prokat.spb.ru": .disableEvaluation
//        
//        //        ]
//        
//        
//        
//        let serverTrustPolicies: [String: ServerTrustPolicy] = [:]
//        
//        // Create custom manager
//        
//        let configuration = URLSessionConfiguration.default
//        
//        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
//        
//        configuration.timeoutIntervalForRequest = 30
//        
//        configuration.timeoutIntervalForResource = 30
//        
//        
//        
//        // TODO: commented to fix the forever loading
//        
//        //        let man = Alamofire.SessionManager(configuration: configuration,
//        
//        //                                           serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
//        
//        
//        
//        let man = Alamofire.SessionManager(
//            
//            configuration: URLSessionConfiguration.default,
//            
//            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
//            
//        )
//        
//        
//        
//        return man
//        
//    }()
//    
//    
//    
//    typealias CompletionHandler = (_ data: Any?, _ errorMsg: String?) -> Void
//    
//    
//    
//    static let sharedInstance = ALNetworking()
//    
//    
//    
//    let domainUrl = "https://1c.avto-prokat.spb.ru/prokat/hs/api/ios"
//    
//    let locationsPath = "/main"
//    
//    let resultsPath = "/list"
//    
//    let orderDetailsPath = "/car"
//    
//    let orderRequestPath = "/reply"
//    
//    
//    
//    // MARK: - Methods
//    
//    
//    
//    func getLocations(completionHandler: @escaping CompletionHandler) {
//        
//        //        let url = URL(string: "\(domainUrl)\(locationsPath)")
//        
//        //
//        
//        //        let session = URLSession.shared
//        
//        //        var request = URLRequest(url: url!)
//        
//        //        request.httpMethod = "GET"
//        
//        //        let task = session.dataTask(with: request) {
//        
//        //            (data, response, error) in
//        
//        //            if error != nil {
//        
//        //                completionHandler(nil)
//        
//        //                print("error: \(error?.localizedDescription)")
//        
//        //                return
//        
//        //            }
//        
//        //
//        
//        //            if let data = data  {
//        
//        //                completionHandler(data)
//        
//        //            }
//        
//        //        }
//        
//        //        task.resume()
//        
//        
//        
//        let url = URL(string: "\(domainUrl)\(locationsPath)")
//        
//        sessionManager.request(url!)
//            
//            .validate()
//            
//            .responseJSON { response in
//                
//                guard response.result.isSuccess else {
//                    
//                    print("Error while fetching tags: \(String(describing: response.result.error))")
//                    
//                    completionHandler(nil, "\(response.result.error?.localizedDescription ?? "Неизвестная ошибка")")
//                    
//                    return
//                    
//                }
//                
//                
//                
//                switch response.result {
//                    
//                case .success:
//                    
//                    if response.result.value != nil {
//                        
//                        completionHandler(response.result.value!, nil)
//                        
//                    }
//                    
//                    break
//                    
//                case .failure(let error):
//                    
//                    if error._code == NSURLErrorTimedOut {
//                        
//                        completionHandler(nil, "Время запроса истекло.")
//                        
//                    }
//                    
//                    break
//                    
//                }
//                
//        }
//        
//    }
//    
//    
//    
//    func getResults(forPickupTime pickupTime: String,
//                    
//                    dropoffTime: String,
//                    
//                    pickupLocation: String,
//                    
//                    dropoffLocation: String,
//                    
//                    completionHandler: @escaping CompletionHandler) {
//        
//        var urlString = self.domainUrl
//        
//        urlString.append(self.resultsPath)
//        
//        urlString.append("/\(pickupLocation)")
//        
//        urlString.append("/\(pickupTime)")
//        
//        urlString.append("/\(dropoffLocation)")
//        
//        urlString.append("/\(dropoffTime)")
//        
//        let url = URL(string: urlString)
//        
//        sessionManager.request(url!)
//            
//            .validate()
//            
//            .responseJSON { response in
//                
//                guard response.result.isSuccess else {
//                    
//                    print("Error while fetching tags: \(String(describing: response.result.error))")
//                    
//                    completionHandler(nil, "\(response.result.error?.localizedDescription ?? "Неизвестная ошибка")")
//                    
//                    return
//                    
//                }
//                
//                
//                
//                switch response.result {
//                    
//                case .success:
//                    
//                    if response.result.value != nil {
//                        
//                        completionHandler(response.result.value!, nil)
//                        
//                    }
//                    
//                    break
//                    
//                case .failure(let error):
//                    
//                    if error._code == NSURLErrorTimedOut {
//                        
//                        completionHandler(nil, "Время запроса истекло.")
//                        
//                    }
//                    
//                    break
//                    
//                }
//                
//        }
//        
//    }
//    
//    
//    
//    // swiftlint:disable:next: function_parameter_count
//    
//    func getOrderDetails(forCarId carId: String,
//                         
//                         forPickupTime pickupTime: String,
//                         
//                         dropoffTime: String,
//                         
//                         pickupLocation: String,
//                         
//                         dropoffLocation: String,
//                         
//                         completionHandler: @escaping CompletionHandler) {
//        
//        var urlString = self.domainUrl
//        
//        urlString.append(self.orderDetailsPath)
//        
//        urlString.append("/\(carId)")
//        
//        urlString.append("/\(pickupLocation)")
//        
//        urlString.append("/\(pickupTime)")
//        
//        urlString.append("/\(dropoffLocation)")
//        
//        urlString.append("/\(dropoffTime)")
//        
//        let url = URL(string: urlString)
//        
//        sessionManager.request(url!)
//            
//            .validate()
//            
//            .responseJSON { response in
//                
//                guard response.result.isSuccess else {
//                    
//                    print("Error while fetching tags: \(String(describing: response.result.error))")
//                    
//                    completionHandler(nil, "\(response.result.error?.localizedDescription ?? "Неизвестная ошибка")")
//                    
//                    return
//                    
//                }
//                
//                
//                
//                switch response.result {
//                    
//                case .success:
//                    
//                    if response.result.value != nil {
//                        
//                        completionHandler(response.result.value!, nil)
//                        
//                    }
//                    
//                    break
//                    
//                case .failure(let error):
//                    
//                    if error._code == NSURLErrorTimedOut {
//                        
//                        completionHandler(nil, "Время запроса истекло.")
//                        
//                    }
//                    
//                    break
//                    
//                }
//                
//        }
//        
//    }
//    
//    
//    
//    func postOrderRequest(withData data: [String : Any], completionHandler: @escaping (_ orderID: String?) -> Void) {
//        
//        var urlString = domainUrl
//        
//        urlString.append(orderRequestPath)
//        
//        do {
//            
//            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
//            
//            
//            
//            // create post request
//            
//            let url = URL(string: urlString)!
//            
//            let request = NSMutableURLRequest(url: url)
//            
//            request.httpMethod = "POST"
//            
//            
//            
//            // insert json data to the request
//            
//            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
//            
//            request.httpBody = jsonData
//            
//            
//            
//            // swiftlint:disable:next unused_closure_parameter
//            
//            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
//                
//                if error != nil {
//                    
//                    print("Error -> \(String(describing: error))")
//                    
//                    return
//                    
//                }
//                
//                
//                
//                do {
//                    
//                    guard let data = data else { return }
//                    
//                    let result = try JSONSerialization.jsonObject(with: data,
//                                                                  
//                                                                  options: [.allowFragments]) as? [String: AnyObject]
//                    
//                    
//                    
//                    if let orderID = result?["application_number"] as? String {
//                        
//                        completionHandler(orderID)
//                        
//                    } else {
//                        
//                        completionHandler(nil)
//                        
//                    }
//                    
//                    //                    print("Result -> \(result)")
//                    
//                } catch {
//                    
//                    print("Error -> \(error)")
//                    
//                    completionHandler(nil)
//                    
//                }
//                
//            }
//            
//            task.resume()
//            
//        } catch {
//            
//            print(error)
//            
//            completionHandler(nil)
//            
//        }
//        
//    }
//    
//}
