//
//  httptool.swift
//  swifttest
//
//  Created by idol_ios on 2019/7/12.
//  Copyright © 2019 idol_ios. All rights reserved.
//

import Foundation
import Dispatch


fileprivate extension String{
    func urlencode() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}

open class IDCHttpTool:NSObject, URLSessionDelegate{
    
    var taskDic:[Int:AnyObject] = [Int:AnyObject]()
    
    var session:URLSession?
    
    public override init() {
        
        session = URLSession.init(configuration: URLSessionConfiguration.default)
    }
    
    open func request( url:String, params:[String:Any]?, method:String, json:Bool, success: @escaping( (AnyObject) -> () ), fail:@escaping((Error)->())){
        var trueUrl:String = url
        let ps = self.paramsString(params);
        if method == "GET"{
            
            if ps != nil{
                trueUrl = url.appending("?\(ps!)")
            }
        }
        
        
        
        if let urlUrl = URL(string: trueUrl){
            
            let request: NSMutableURLRequest = NSMutableURLRequest(url:urlUrl)
            
            request.httpMethod = method
            request.timeoutInterval = 30
            
            if method == "GET"{
                
            }else{
                
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.httpBody = ps?.data(using: String.Encoding.utf8)
                
            }
            
            let task = self.session?.dataTask(with: request as URLRequest, completionHandler: { (data:Data?, response:URLResponse?, error:Error?) in
                
                if data != nil{
                    
                    if json {
                        let rs = try? JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableLeaves)
                        
                        
                        if let jsono:NSDictionary = rs as? NSDictionary{
                            success(jsono as AnyObject)
                        }
                        
                    }else{
                        
                        success(data as AnyObject)
                        
                    }
                }else{
                    
                    fail( error!  )
                    
                }
                
            })
            
            task?.resume()
            
        }
        
        
        
    }
    
    
    
    func paramsString(_ params:[String:Any]?) -> String? {
        var sv:[String] = [];
        
        if params != nil{
            for (key, value) in params! {
                let v = "\(value)"
                sv.append("\(key)=\(v.urlencode()!)")
            }
            
            return sv.joined(separator: "&")
        }else{
            return nil
        }
    }
    
    
}
