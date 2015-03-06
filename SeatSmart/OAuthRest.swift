//
//  OAuthRest.swift
//  SeatSmart
//
//  Created by Huey Ly on 3/6/15.
//  Copyright (c) 2015 SeatSmart. All rights reserved.
//

import Foundation

class OAuthRest : NSObject {
    
    
    
    private func sendGet(urlPath: NSString, callback: (result: AnyObject)->()) {
        let url: NSURL = NSURL(string: urlPath)!
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        var request = NSMutableURLRequest(URL: url, cachePolicy: cachePolicy, timeoutInterval: 2.0)
        request.HTTPMethod = "GET"
        
        let encryptedLoginString = self.getEncryptedLoginString()
        request.setValue(encryptedLoginString, forHTTPHeaderField: "Authorization")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            println("response = \(response)")
            
            var jsonError: NSError?
            var jsonData: AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &jsonError)!
            
            println("data = \(jsonData)")
            
            callback(result: jsonData)
        }
        
        task.resume()
    }
    
    private func sendPost(urlPath: NSString, postData: NSString, callback: (result: AnyObject)->()) {
        
        let url: NSURL = NSURL(string: urlPath)!
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        
        var postLength:NSString = String( postData.length )
        var request = NSMutableURLRequest(URL: url, cachePolicy: cachePolicy, timeoutInterval: 2.0)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData.dataUsingEncoding(NSUTF8StringEncoding)
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let encryptedLoginString = self.getEncryptedLoginString()
        request.setValue(encryptedLoginString, forHTTPHeaderField: "Authorization")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            println("response = \(response)")
            
            var responseData = NSString(data: data, encoding: NSUTF8StringEncoding)!
            println(responseData)
            
            callback(result: responseData)
        }
        task.resume()
        
    }
    
    private func getEncryptedLoginString() -> String {
        let username = "huey"
        let password = "asdf"
        let loginString = NSString(format: "%@:%@", username, password)
        let encryptedString = self.encryptString(loginString)
        
        return encryptedString
    }
    
    private func encryptString(value : NSString) -> String {
        return value
    }
}