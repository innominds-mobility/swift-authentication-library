// /Model/User.swift
 

import Foundation


public class User: JSONEncodable {

	public var  id: Int64?
	public var  username: String?
	public var  firstName: String?
	public var  lastName: String?
	public var  email: String?
	public var  password: String?
	public var  phone: String?
	public var  userStatus: Int32?

	// MARK: JSONEncodable
	func encodeToJSON() -> AnyObject {
		var nillableDictionary = [String : AnyObject?]()
		nillableDictionary["id"] = self.id?.encodeToJSON()
		nillableDictionary["username"] = self.username?.encodeToJSON()
		nillableDictionary["firstName"] = self.firstName?.encodeToJSON()
		nillableDictionary["lastName"] = self.lastName?.encodeToJSON()
		nillableDictionary["email"] = self.email?.encodeToJSON()
		nillableDictionary["password"] = self.password?.encodeToJSON()
		nillableDictionary["phone"] = self.phone?.encodeToJSON()
		nillableDictionary["userStatus"] = self.userStatus?.encodeToJSON()

		let dictionary: [String: AnyObject] = APIHelper.rejectNil(source: nillableDictionary as [String: AnyObject?]) ?? [:]
		return dictionary as AnyObject
	}

    public convenience init( id: Int64?, username: String?, firstName: String?, lastName: String?, email: String?, password: String?, phone: String?, userStatus: Int32?) {
        self.init()
		self.id = id
		self.username = username
		self.firstName = firstName
		self.lastName = lastName
		self.email = email
		self.password = password
		self.phone = phone
		self.userStatus = userStatus
	}
}