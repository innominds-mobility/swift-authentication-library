// /Models.swift
 

import Foundation

protocol JSONEncodable {
    func encodeToJSON() -> AnyObject
}

public enum ErrorResponse: Error {
    case Error(Int, Data?, Error)
}

public class AXResponse<T> {
    public let statusCode: Int
    public let header: [String: String]
    public let body: T

    public init(statusCode: Int, header: [String: String], body: T) {
        self.statusCode = statusCode
        self.header = header
        self.body = body
    }

    public convenience init(response: HTTPURLResponse, body: T) {
        let rawHeader = response.allHeaderFields
        var header = [String: String]()
        for (key, value) in rawHeader {
            header[key as! String] = value as? String
        }
        self.init(statusCode: response.statusCode, header: header, body: body)
    }
}

private var once = Int()

class Decoders {
    
    static fileprivate func initialize() {
        _ = Decoders.__once
    }

   static private var decoders = Dictionary<String, ((AnyObject) -> AnyObject)>()

    static func addDecoder<T>(clazz: T.Type, decoder: @escaping ((AnyObject) -> T)) {
        let key = "\(T.self)"
        decoders[key] = { decoder($0) as AnyObject }
    }

    static func decode<T>(clazz: [T].Type, source: AnyObject) -> [T] {
        let array = source as! [AnyObject]
        return array.map { Decoders.decode(clazz: T.self, source: $0) }
    }

    static func decode<T, Key: Hashable>(clazz: [Key:T].Type, source: AnyObject) -> [Key:T] {
        let sourceDictionary = source as! [Key: AnyObject]
        var dictionary = [Key: T]()
        for (key, value) in sourceDictionary {
            dictionary[key] = Decoders.decode(clazz: T.self, source: value)
        }
        return dictionary
    }

    static func decode<T>(clazz: T.Type, source: AnyObject) -> T {
        initialize()
        if T.self is Int32.Type && source is NSNumber {
            return source.int32Value as! T
        }
        if T.self is Int64.Type && source is NSNumber {
            return source.int64Value as! T
        }
        if T.self is UUID.Type && source is String {
            return UUID(uuidString: source as! String) as! T
        }
        if source is T {
            return source as! T
        }
        if T.self is Data.Type && source is String {
            return Data(base64Encoded: source as! String) as! T
        }

        let key = "\(T.self)"
        if let decoder = decoders[key] {
            return decoder(source) as! T
        } else {
            fatalError("Source \(source) is not convertible to type \(clazz): Maybe swagger file is insufficient")
        }
    }

    static func decodeOptional<T>(clazz: T.Type, source: AnyObject?) -> T? {
        if source is NSNull {
            return nil
        }
        return source.map { (source: AnyObject) -> T in
            Decoders.decode(clazz: clazz, source: source)
        }
    }

    static func decodeOptional<T>(clazz: [T].Type, source: AnyObject?) -> [T]? {
        if source is NSNull {
            return nil
        }
        return source.map { (someSource: AnyObject) -> [T] in
            Decoders.decode(clazz: clazz, source: someSource)
        }
    }

    static func decodeOptional<T, Key: Hashable>(clazz: [Key:T].Type, source: AnyObject?) -> [Key:T]? {
        if source is NSNull {
            return nil
        }
        return source.map { (someSource: AnyObject) -> [Key:T] in
            Decoders.decode(clazz: clazz, source: someSource)
        }
    }

    private static var __once: () = {
        let formatters = [
            "yyyy-MM-dd",
            "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
            "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ",
            "yyyy-MM-dd'T'HH:mm:ss'Z'",
            "yyyy-MM-dd'T'HH:mm:ss.SSS",
            "yyyy-MM-dd HH:mm:ss"
            ].map { (format: String) -> DateFormatter in
                let formatter = DateFormatter()
                formatter.dateFormat = format
                return formatter
        }
        // Decoder for Date
        Decoders.addDecoder(clazz: Date.self) { (source: AnyObject) -> Date in
            if let sourceString = source as? String {
                for formatter in formatters {
                    if let date = formatter.date(from: sourceString) {
                        return date
                    }
                }
            }
            if let sourceInt = source as? Int64 {
                // treat as a java date
                return Date(timeIntervalSince1970: Double(sourceInt / 1000) )
            }
            fatalError("formatter failed to parse \(source)")
        }

			// Decoder for [Order]
            Decoders.addDecoder(clazz: [Order].self) { (source: AnyObject) -> [Order] in
                return Decoders.decode(clazz: [Order].self, source: source)
            }

            // Decoder for Order
            Decoders.addDecoder(clazz: Order.self) { (source: AnyObject) -> Order in
            if (source is NSNull) {
                return Order()
            }
            let sourceDictionary = source as! [AnyHashable: AnyObject]
            let instance = Order(
                            id : Decoders.decodeOptional(clazz: Int64.self, source: sourceDictionary["id"]),
                            petId : Decoders.decodeOptional(clazz: Int64.self, source: sourceDictionary["petId"]),
                            quantity : Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["quantity"]),
                            shipDate : Decoders.decodeOptional(clazz: Date.self, source: sourceDictionary["shipDate"]),
                            status : Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["status"]),
                            complete : Decoders.decodeOptional(clazz: Bool.self, source: sourceDictionary["complete"])
            )
            return instance
            }

			// Decoder for [Category]
            Decoders.addDecoder(clazz: [Category].self) { (source: AnyObject) -> [Category] in
                return Decoders.decode(clazz: [Category].self, source: source)
            }

            // Decoder for Category
            Decoders.addDecoder(clazz: Category.self) { (source: AnyObject) -> Category in
            if (source is NSNull) {
                return Category()
            }
            let sourceDictionary = source as! [AnyHashable: AnyObject]
            let instance = Category(
                            id : Decoders.decodeOptional(clazz: Int64.self, source: sourceDictionary["id"]),
                            name : Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"])
            )
            return instance
            }

			// Decoder for [User]
            Decoders.addDecoder(clazz: [User].self) { (source: AnyObject) -> [User] in
                return Decoders.decode(clazz: [User].self, source: source)
            }

            // Decoder for User
            Decoders.addDecoder(clazz: User.self) { (source: AnyObject) -> User in
            if (source is NSNull) {
                return User()
            }
            let sourceDictionary = source as! [AnyHashable: AnyObject]
            let instance = User(
                            id : Decoders.decodeOptional(clazz: Int64.self, source: sourceDictionary["id"]),
                            username : Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["username"]),
                            firstName : Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["firstName"]),
                            lastName : Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["lastName"]),
                            email : Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["email"]),
                            password : Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["password"]),
                            phone : Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["phone"]),
                            userStatus : Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["userStatus"])
            )
            return instance
            }

			// Decoder for [Tag]
            Decoders.addDecoder(clazz: [Tag].self) { (source: AnyObject) -> [Tag] in
                return Decoders.decode(clazz: [Tag].self, source: source)
            }

            // Decoder for Tag
            Decoders.addDecoder(clazz: Tag.self) { (source: AnyObject) -> Tag in
            if (source is NSNull) {
                return Tag()
            }
            let sourceDictionary = source as! [AnyHashable: AnyObject]
            let instance = Tag(
                            id : Decoders.decodeOptional(clazz: Int64.self, source: sourceDictionary["id"]),
                            name : Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"])
            )
            return instance
            }

			// Decoder for [ApiResponse]
            Decoders.addDecoder(clazz: [ApiResponse].self) { (source: AnyObject) -> [ApiResponse] in
                return Decoders.decode(clazz: [ApiResponse].self, source: source)
            }

            // Decoder for ApiResponse
            Decoders.addDecoder(clazz: ApiResponse.self) { (source: AnyObject) -> ApiResponse in
            if (source is NSNull) {
                return ApiResponse()
            }
            let sourceDictionary = source as! [AnyHashable: AnyObject]
            let instance = ApiResponse(
                            code : Decoders.decodeOptional(clazz: Int32.self, source: sourceDictionary["code"]),
                            type : Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["type"]),
                            message : Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["message"])
            )
            return instance
            }

			// Decoder for [Pet]
            Decoders.addDecoder(clazz: [Pet].self) { (source: AnyObject) -> [Pet] in
                return Decoders.decode(clazz: [Pet].self, source: source)
            }

            // Decoder for Pet
            Decoders.addDecoder(clazz: Pet.self) { (source: AnyObject) -> Pet in
            if (source is NSNull) {
                return Pet()
            }
            let sourceDictionary = source as! [AnyHashable: AnyObject]
            let instance = Pet(
                            id : Decoders.decodeOptional(clazz: Int64.self, source: sourceDictionary["id"]),
                            category : Decoders.decodeOptional(clazz: Category.self, source: sourceDictionary["Category"]),
                            name : Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["name"]),
                            photoUrls : Decoders.decodeOptional(clazz: [String].self, source: sourceDictionary["photoUrls"]),
                            tags : Decoders.decodeOptional(clazz: [Tag].self, source: sourceDictionary["tags"]),
                            status : Decoders.decodeOptional(clazz: String.self, source: sourceDictionary["status"])
            )
            return instance
            }
        }()
    }
