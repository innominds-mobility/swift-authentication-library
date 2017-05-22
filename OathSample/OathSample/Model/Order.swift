// /Model/Order.swift
 

import Foundation


public class Order: JSONEncodable {

	public var  id: Int64?
	public var  petId: Int64?
	public var  quantity: Int32?
	public var  shipDate: Date?
	public var  status: String?
	public var  complete: Bool?

	// MARK: JSONEncodable
	func encodeToJSON() -> AnyObject {
		var nillableDictionary = [String : AnyObject?]()
		nillableDictionary["id"] = self.id?.encodeToJSON()
		nillableDictionary["petId"] = self.petId?.encodeToJSON()
		nillableDictionary["quantity"] = self.quantity?.encodeToJSON()
		nillableDictionary["shipDate"] = self.shipDate?.encodeToJSON()
		nillableDictionary["status"] = self.status?.encodeToJSON()
		nillableDictionary["complete"] = self.complete?.encodeToJSON()

		let dictionary: [String: AnyObject] = APIHelper.rejectNil(source: nillableDictionary as [String: AnyObject?]) ?? [:]
		return dictionary as AnyObject
	}

    public convenience init( id: Int64?, petId: Int64?, quantity: Int32?, shipDate: Date?, status: String?, complete: Bool?) {
        self.init()
		self.id = id
		self.petId = petId
		self.quantity = quantity
		self.shipDate = shipDate
		self.status = status
		self.complete = complete
	}
}