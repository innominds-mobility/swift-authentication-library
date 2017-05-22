// /Model/ApiResponse.swift
 

import Foundation


public class ApiResponse: JSONEncodable {

	public var  code: Int32?
	public var  type: String?
	public var  message: String?

	// MARK: JSONEncodable
	func encodeToJSON() -> AnyObject {
		var nillableDictionary = [String : AnyObject?]()
		nillableDictionary["code"] = self.code?.encodeToJSON()
		nillableDictionary["type"] = self.type?.encodeToJSON()
		nillableDictionary["message"] = self.message?.encodeToJSON()

		let dictionary: [String: AnyObject] = APIHelper.rejectNil(source: nillableDictionary as [String: AnyObject?]) ?? [:]
		return dictionary as AnyObject
	}

    public convenience init( code: Int32?, type: String?, message: String?) {
        self.init()
		self.code = code
		self.type = type
		self.message = message
	}
}