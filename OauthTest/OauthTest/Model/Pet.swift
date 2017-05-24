// /Model/Pet.swift
 

import Foundation


public class Pet: JSONEncodable {

	public var  id: Int64?
	public var  category: Category?
	public var  name: String?
	public var  photoUrls: [String]?
	public var  tags: [Tag]?
	public var  status: String?

	// MARK: JSONEncodable
	func encodeToJSON() -> AnyObject {
		var nillableDictionary = [String : AnyObject?]()
		nillableDictionary["id"] = self.id?.encodeToJSON()
		nillableDictionary["category"] = self.category?.encodeToJSON()
		nillableDictionary["name"] = self.name?.encodeToJSON()
		nillableDictionary["photoUrls"] = self.photoUrls?.encodeToJSON()
		nillableDictionary["tags"] = self.tags?.encodeToJSON()
		nillableDictionary["status"] = self.status?.encodeToJSON()

		let dictionary: [String: AnyObject] = APIHelper.rejectNil(source: nillableDictionary as [String: AnyObject?]) ?? [:]
		return dictionary as AnyObject
	}

    public convenience init( id: Int64?, category: Category?, name: String?, photoUrls: [String]?, tags: [Tag]?, status: String?) {
        self.init()
		self.id = id
		self.category = category
		self.name = name
		self.photoUrls = photoUrls
		self.tags = tags
		self.status = status
	}
}
