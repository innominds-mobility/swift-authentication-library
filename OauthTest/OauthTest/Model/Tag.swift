// /Model/Tag.swift
 

import Foundation


public class Tag: JSONEncodable {

	public var  id: Int64?
	public var  name: String?

	// MARK: JSONEncodable
	func encodeToJSON() -> AnyObject {
		var nillableDictionary = [String : AnyObject?]()
		nillableDictionary["id"] = self.id?.encodeToJSON()
		nillableDictionary["name"] = self.name?.encodeToJSON()

		let dictionary: [String: AnyObject] = APIHelper.rejectNil(source: nillableDictionary as [String: AnyObject?]) ?? [:]
		return dictionary as AnyObject
	}

    public convenience init( id: Int64?, name: String?) {
        self.init()
		self.id = id
		self.name = name
	}
}