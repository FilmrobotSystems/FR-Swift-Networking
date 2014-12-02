//
//  Networking.swift
//
//  Created by Robert Clifford on 2014-11-12.
//  Simple Networking class writen in swift

import Foundation
class Networking
{
    let customHeader = ##Value##
    let baseUri = ##Base URL Value##
    
    // Set up request 
    // Below has an example on how to add custom headers
    private func setRequest(url: String, parameters: NSDictionary?, uriMethod: String)->NSMutableURLRequest{
        var fullUrl = NSURL(string: baseUri + url)
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        
        var request = NSMutableURLRequest(URL: fullUrl!, cachePolicy: cachePolicy, timeoutInterval: 10.0)
        request.HTTPMethod = uriMethod
        
        var err: NSError?
        
        // Pass in parameters if any
        if(Parameters != nil)
        {
            request.HTTPBody = NSJSONSerialization.dataWithJSONObject(Parameters!, options: nil, error: &err)
        }
        
        // Add headers to request
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(customHeader, forHTTPHeaderField: "#CustomHeader#")
        
        return request
    }
    
    // HTTP synchronous call 
    // Wait for reply from request before moving on to another task.
    func callSync(url: String, parameters: NSDictionary?, uriMethod : String)->NSDictionary?{
        
        var request = self.setRequest(url, parameters: parameters, uriMethod: uriMethod)
        var response: NSURLResponse? = nil
        var error: NSError? = nil
        
        // Send http request
        let reply = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)

        // Check if request came back empty
        if(reply != nil)
        {
            return  NSJSONSerialization.JSONObjectWithData(reply!, options: .MutableLeaves, error: &error) as? NSDictionary
        }
        else
        {
			println("Request error: \(error.localizedDescription)")
            return NSDictionary(objectsAndKeys: error!)
        }
    }
    
    // HTTP asynchronous call 
    // Will move on to next task before request is complete.
    func callAsync(url: String, parameters: NSDictionary?, uriMethod: String, completion: ((NSDictionary!) -> Void)?){
        
        var request = self.setRequest(url, parameters: parameters, uriMethod: uriMethod)
        var response: NSURLResponse? = nil
        var error: NSError? = nil
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
	// Send http request
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            if((error) != nil)
            {
                println("Request error: \(error.localizedDescription)")
            }
            
	    // Deserialize json data
            var err: NSError? = nil
            var json = NSJSONSerialization.JSONObjectWithData(data!, options: .MutableLeaves, error: &err) as? NSDictionary
            
            if((err) != nil)
            {
                println("Json Serialization error: \(error.localizedDescription)")
            }
            
            completion?(json?);
        });
        
        task.resume()
    }
}
