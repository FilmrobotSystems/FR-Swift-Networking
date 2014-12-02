FR-Swift-Networking
===================

Simple networking class writen in swift

````swift
// Load Class
var network = Networking()
var data : Array<AnyObject> = []

// For synchronous call method
network.callSync("#uri#", parameters: searchParams, uriMethod: "GET/POST/PUT/DELETE", completion: self.dataResult)

// For asynchronous call method
network.callAsync("#uri#", parameters: searchParams, uriMethod: "GET/POST/PUT/DELETE", completion: self.dataResult)

// Compleation method for asynchronous call
func dataResult(json:NSDictionary!)
{
	// Do what ever you need with the data here
	// Below is an example of parsing the data into a swift array
	if let parseJson = json{
		data += parseJson["DATA"] as Array
	}
}
````
