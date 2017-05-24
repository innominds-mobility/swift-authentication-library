// /Apis/DefaultAPI.swift
 

import Foundation

public class DefaultAPI: APIBase { 
	/**
	  Update an existing pet
      
	  - parameter body: (body) Pet object that needs to be added to the store 
	  - parameter completion: completion handler to receive the data and the error objects
	*/

	public class func updatePet(body: Pet ,  completion: @escaping ((_ error: Error?) -> Void)) {
		updatePetRequestBuilder(body: body).execute { (response, error) -> Void in
			completion(error)
		}
	}

	/**
	  Update an existing pet
      
	  - PUT /pet
	  - 
	  - OAuth:
	    - type: oauth2
		- name:  OAuthImplicit ,  OAuthAccessCode ,  OAuthPassword ,  OAuthApplication 
		- parameter  body: (body) Pet object that needs to be added to the store  

	  - returns: RequestBuilder<Void>
	*/

	public class func updatePetRequestBuilder(body: Pet) -> RequestBuilder<Void> { 
		let path = "/pet"
		let URLString = PetstoreAPI.sharedInstance.basePath + path
		let parameters = body.encodeToJSON() as? [String:AnyObject]
		let convertedParameters = APIHelper.convertBoolToString(source: parameters)
		let requestBuilder: RequestBuilder<Void>.Type = PetstoreAPI.sharedInstance.requestBuilderFactory.getBuilder()

		var customHeadersDict : [String: String] = [:]



		return requestBuilder.init(method: "PUT", URLString: URLString, parameters: convertedParameters, customHeader: customHeadersDict,isBody: true , authNames: ["OAuthImplicit", "OAuthAccessCode", "OAuthPassword", "OAuthApplication"])
	}
	/**
	  Add a new pet to the store
      
	  - parameter body: (body) Pet object that needs to be added to the store 
	  - parameter completion: completion handler to receive the data and the error objects
	*/

	public class func addPet(body: Pet ,  completion: @escaping ((_ error: Error?) -> Void)) {
		addPetRequestBuilder(body: body).execute { (response, error) -> Void in
			completion(error)
		}
	}

	/**
	  Add a new pet to the store
      
	  - POST /pet
	  - 
	  - OAuth:
	    - type: oauth2
		- name:  HTTP Basic 
		- parameter  body: (body) Pet object that needs to be added to the store  

	  - returns: RequestBuilder<Void>
	*/

	public class func addPetRequestBuilder(body: Pet) -> RequestBuilder<Void> { 
		let path = "/pet"
		let URLString = PetstoreAPI.sharedInstance.basePath + path
		let parameters = body.encodeToJSON() as? [String:AnyObject]
		let convertedParameters = APIHelper.convertBoolToString(source: parameters)
		let requestBuilder: RequestBuilder<Void>.Type = PetstoreAPI.sharedInstance.requestBuilderFactory.getBuilder()

		var customHeadersDict : [String: String] = [:]



		return requestBuilder.init(method: "POST", URLString: URLString, parameters: convertedParameters, customHeader: customHeadersDict,isBody: true , authNames: ["HTTP Basic"])
	}
	/**
	  Get user by user name
      
	  - parameter username: (path) The name that needs to be fetched. Use user1 for testing.  
	  - parameter completion: completion handler to receive the data and the error objects
	*/

	public class func getUserByName(username: String ,  completion: @escaping ((_ data: User?, _ error: Error?) -> Void)) {
		getUserByNameRequestBuilder(username: username).execute { (response, error) -> Void in
			completion(response?.body, error)
		}
	}

	/**
	  Get user by user name
      
	  - GET /user/{username}
	  - 
	  - OAuth:
	    - type: oauth2
		- name:  OAuthImplicit ,  OAuthAccessCode ,  OAuthPassword ,  OAuthApplication 
		- parameter  username: (path) The name that needs to be fetched. Use user1 for testing.   

	  - returns: RequestBuilder<User>
	*/

	public class func getUserByNameRequestBuilder(username: String) -> RequestBuilder<User> { 
		var path = "/user/{username}"
		path = path.replacingOccurrences(of: "{username}", with: "\(username)", options: String.CompareOptions.literal, range: nil)
		let URLString = PetstoreAPI.sharedInstance.basePath + path
		let nillableParameters: [String:AnyObject?] = [:]
		let parameters = APIHelper.rejectNil(source: nillableParameters  as [String : AnyObject?])
		let convertedParameters = APIHelper.convertBoolToString(source: parameters)
		let requestBuilder: RequestBuilder<User>.Type = PetstoreAPI.sharedInstance.requestBuilderFactory.getBuilder()

		var customHeadersDict : [String: String] = [:]



		return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, customHeader: customHeadersDict,isBody:  true, authNames: ["OAuthImplicit", "OAuthAccessCode", "OAuthPassword", "OAuthApplication"])
	}
	/**
	  Updated user
      This can only be done by the logged in user.
	  - parameter username: (path) name that need to be updated 
	  - parameter completion: completion handler to receive the data and the error objects
	  - parameter body: (body) Updated user object 
	  - parameter completion: completion handler to receive the data and the error objects
	*/

	public class func updateUser(username: String , body: User ,  completion: @escaping ((_ error: Error?) -> Void)) {
		updateUserRequestBuilder(username: username, body: body).execute { (response, error) -> Void in
			completion(error)
		}
	}

	/**
	  Updated user
      This can only be done by the logged in user.
	  - PUT /user/{username}
	  - This can only be done by the logged in user.
	  - OAuth:
	    - type: oauth2
		- name:  API Key 
		- parameter  username: (path) name that need to be updated  
		- parameter  body: (body) Updated user object  

	  - returns: RequestBuilder<Void>
	*/

	public class func updateUserRequestBuilder(username: String,body: User) -> RequestBuilder<Void> { 
		var path = "/user/{username}"
		path = path.replacingOccurrences(of: "{username}", with: "\(username)", options: String.CompareOptions.literal, range: nil)
		let URLString = PetstoreAPI.sharedInstance.basePath + path
		let parameters = body.encodeToJSON() as? [String:AnyObject]
		let convertedParameters = APIHelper.convertBoolToString(source: parameters)
		let requestBuilder: RequestBuilder<Void>.Type = PetstoreAPI.sharedInstance.requestBuilderFactory.getBuilder()

		var customHeadersDict : [String: String] = [:]



		return requestBuilder.init(method: "PUT", URLString: URLString, parameters: convertedParameters, customHeader: customHeadersDict,isBody: true , authNames: ["API Key"])
	}
	/**
	  Delete user
      This can only be done by the logged in user.
	  - parameter username: (path) The name that needs to be deleted 
	  - parameter completion: completion handler to receive the data and the error objects
	*/

	public class func deleteUser(username: String ,  completion: @escaping ((_ error: Error?) -> Void)) {
		deleteUserRequestBuilder(username: username).execute { (response, error) -> Void in
			completion(error)
		}
	}

	/**
	  Delete user
      This can only be done by the logged in user.
	  - DELETE /user/{username}
	  - This can only be done by the logged in user.
	  - OAuth:
	    - type: oauth2
		- name:  OAuthImplicit ,  OAuthAccessCode ,  OAuthPassword ,  OAuthApplication 
		- parameter  username: (path) The name that needs to be deleted  

	  - returns: RequestBuilder<Void>
	*/

	public class func deleteUserRequestBuilder(username: String) -> RequestBuilder<Void> { 
		var path = "/user/{username}"
		path = path.replacingOccurrences(of: "{username}", with: "\(username)", options: String.CompareOptions.literal, range: nil)
		let URLString = PetstoreAPI.sharedInstance.basePath + path
		let nillableParameters: [String:AnyObject?] = [:]
		let parameters = APIHelper.rejectNil(source: nillableParameters  as [String : AnyObject?])
		let convertedParameters = APIHelper.convertBoolToString(source: parameters)
		let requestBuilder: RequestBuilder<Void>.Type = PetstoreAPI.sharedInstance.requestBuilderFactory.getBuilder()

		var customHeadersDict : [String: String] = [:]



		return requestBuilder.init(method: "DELETE", URLString: URLString, parameters: convertedParameters, customHeader: customHeadersDict,isBody:  true, authNames: ["OAuthImplicit", "OAuthAccessCode", "OAuthPassword", "OAuthApplication"])
	}
	/**
	  Finds Pets by status
      Multiple status values can be provided with comma separated strings
	  - parameter status: (query) Status values that need to be considered for filter 
	  - parameter completion: completion handler to receive the data and the error objects
	*/

	public class func findPetsByStatus(status: [String] ,  completion: @escaping ((_ data: [Pet]?, _ error: Error?) -> Void)) {
		findPetsByStatusRequestBuilder(status: status).execute { (response, error) -> Void in
			completion(response?.body, error)
		}
	}

	/**
	  Finds Pets by status
      Multiple status values can be provided with comma separated strings
	  - GET /pet/findByStatus
	  - Multiple status values can be provided with comma separated strings
	  - OAuth:
	    - type: oauth2
		- name:  OAuthImplicit ,  OAuthAccessCode ,  OAuthPassword ,  OAuthApplication 
		- parameter  status: (query) Status values that need to be considered for filter  

	  - returns: RequestBuilder<[Pet]>
	*/

	public class func findPetsByStatusRequestBuilder(status: [String]) -> RequestBuilder<[Pet]> { 
		let path = "/pet/findByStatus"
		let URLString = PetstoreAPI.sharedInstance.basePath + path
		let nillableParameters: [String:AnyObject?] = [
			"status": status as AnyObject]
		let parameters = APIHelper.rejectNil(source: nillableParameters  as [String : AnyObject?])
		let convertedParameters = APIHelper.convertBoolToString(source: parameters)
		let requestBuilder: RequestBuilder<[Pet]>.Type = PetstoreAPI.sharedInstance.requestBuilderFactory.getBuilder()

		var customHeadersDict : [String: String] = [:]



		return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, customHeader: customHeadersDict,isBody:  false, authNames: ["OAuthImplicit", "OAuthAccessCode", "OAuthPassword", "OAuthApplication"])
	}
	/**
	  Creates list of users with given input array
      
	  - parameter body: (body) List of user object 
	  - parameter completion: completion handler to receive the data and the error objects
	*/

	public class func createUsersWithListInput(body: [User] ,  completion: @escaping ((_ error: Error?) -> Void)) {
		createUsersWithListInputRequestBuilder(body: body).execute { (response, error) -> Void in
			completion(error)
		}
	}

	/**
	  Creates list of users with given input array
      
	  - POST /user/createWithList
	  - 
	  - OAuth:
	    - type: oauth2
		- name:  OAuthImplicit ,  OAuthAccessCode ,  OAuthPassword ,  OAuthApplication 
		- parameter  body: (body) List of user object  

	  - returns: RequestBuilder<Void>
	*/

	public class func createUsersWithListInputRequestBuilder(body: [User]) -> RequestBuilder<Void> { 
		let path = "/user/createWithList"
		let URLString = PetstoreAPI.sharedInstance.basePath + path
		let parameters = body.encodeToJSON() as? [String:AnyObject]
		let convertedParameters = APIHelper.convertBoolToString(source: parameters)
		let requestBuilder: RequestBuilder<Void>.Type = PetstoreAPI.sharedInstance.requestBuilderFactory.getBuilder()

		var customHeadersDict : [String: String] = [:]



		return requestBuilder.init(method: "POST", URLString: URLString, parameters: convertedParameters, customHeader: customHeadersDict,isBody: true , authNames: ["OAuthImplicit", "OAuthAccessCode", "OAuthPassword", "OAuthApplication"])
	}
	/**
	  uploads an image
      
	  - parameter petId: (path) ID of pet to update 
	  - parameter completion: completion handler to receive the data and the error objects
	  - parameter additionalMetadata: (formData) Additional data to pass to server (optional)
	  - parameter completion: completion handler to receive the data and the error objects
	  - parameter file: (formData) file to upload (optional)
	  - parameter completion: completion handler to receive the data and the error objects
	*/

	public class func uploadFile(petId: Int64 , additionalMetadata: String? = nil , file: NSURL? = nil ,  completion: @escaping ((_ data: ApiResponse?, _ error: Error?) -> Void)) {
		uploadFileRequestBuilder(petId: petId, additionalMetadata: additionalMetadata, file: file).execute { (response, error) -> Void in
			completion(response?.body, error)
		}
	}

	/**
	  uploads an image
      
	  - POST /pet/{petId}/uploadImage
	  - 
	  - OAuth:
	    - type: oauth2
		- name:  OAuthImplicit ,  OAuthAccessCode ,  OAuthPassword ,  OAuthApplication 
		- parameter  petId: (path) ID of pet to update  
		- parameter  additionalMetadata: (formData) Additional data to pass to server (optional) 
		- parameter  file: (formData) file to upload (optional) 

	  - returns: RequestBuilder<ApiResponse>
	*/

	public class func uploadFileRequestBuilder(petId: Int64,additionalMetadata: String? = nil,file: NSURL? = nil) -> RequestBuilder<ApiResponse> { 
		var path = "/pet/{petId}/uploadImage"
		path = path.replacingOccurrences(of: "{petId}", with: "\(petId)", options: String.CompareOptions.literal, range: nil)
		let URLString = PetstoreAPI.sharedInstance.basePath + path
		let nillableParameters: [String:AnyObject?] = [
		 	"additionalMetadata": additionalMetadata as AnyObject , 
		 	"file": file as AnyObject ]
		let parameters = APIHelper.rejectNil(source: nillableParameters  as [String : AnyObject?])
		let convertedParameters = APIHelper.convertBoolToString(source: parameters)
		let requestBuilder: RequestBuilder<ApiResponse>.Type = PetstoreAPI.sharedInstance.requestBuilderFactory.getBuilder()

		var customHeadersDict : [String: String] = [:]



		return requestBuilder.init(method: "POST", URLString: URLString, parameters: convertedParameters, customHeader: customHeadersDict,isBody:  false, authNames: ["OAuthImplicit", "OAuthAccessCode", "OAuthPassword", "OAuthApplication"])
	}
	/**
	  Logs user into the system
      
	  - parameter username: (query) The user name for login 
	  - parameter completion: completion handler to receive the data and the error objects
	  - parameter password: (query) The password for login in clear text 
	  - parameter completion: completion handler to receive the data and the error objects
	*/

	public class func loginUser(username: String , password: String ,  completion: @escaping ((_ data: String?, _ error: Error?) -> Void)) {
		loginUserRequestBuilder(username: username, password: password).execute { (response, error) -> Void in
			completion(response?.body, error)
		}
	}

	/**
	  Logs user into the system
      
	  - GET /user/login
	  - 
	  - OAuth:
	    - type: oauth2
		- name:  OAuthImplicit ,  OAuthAccessCode ,  OAuthPassword ,  OAuthApplication 
		- parameter  username: (query) The user name for login  
		- parameter  password: (query) The password for login in clear text  

	  - returns: RequestBuilder<String>
	*/

	public class func loginUserRequestBuilder(username: String,password: String) -> RequestBuilder<String> { 
		let path = "/user/login"
		let URLString = PetstoreAPI.sharedInstance.basePath + path
		let nillableParameters: [String:AnyObject?] = [
			"username": username as AnyObject, 
			"password": password as AnyObject]
		let parameters = APIHelper.rejectNil(source: nillableParameters  as [String : AnyObject?])
		let convertedParameters = APIHelper.convertBoolToString(source: parameters)
		let requestBuilder: RequestBuilder<String>.Type = PetstoreAPI.sharedInstance.requestBuilderFactory.getBuilder()

		var customHeadersDict : [String: String] = [:]



		return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, customHeader: customHeadersDict,isBody:  false, authNames: ["OAuthImplicit", "OAuthAccessCode", "OAuthPassword", "OAuthApplication"])
	}
	/**
	  Returns pet inventories by status
      Returns a map of status codes to quantities
	*/

	public class func getInventory( completion: @escaping ((_ data: [String:Any]?, _ error: Error?) -> Void)) {
		getInventoryRequestBuilder().execute { (response, error) -> Void in
			completion(response?.body, error)
		}
	}

	/**
	  Returns pet inventories by status
      Returns a map of status codes to quantities
	  - GET /store/inventory
	  - Returns a map of status codes to quantities
	  - OAuth:
	    - type: oauth2
		- name:  HTTP Basic ,  API Key 

	  - returns: RequestBuilder<[String:Any]>
	*/

	public class func getInventoryRequestBuilder() -> RequestBuilder<[String:Any]> { 
		let path = "/store/inventory"
		let URLString = PetstoreAPI.sharedInstance.basePath + path
		let nillableParameters: [String:AnyObject?] = [:]
		let parameters = APIHelper.rejectNil(source: nillableParameters  as [String : AnyObject?])
		let convertedParameters = APIHelper.convertBoolToString(source: parameters)
		let requestBuilder: RequestBuilder<[String:Any]>.Type = PetstoreAPI.sharedInstance.requestBuilderFactory.getBuilder()

		var customHeadersDict : [String: String] = [:]



		return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, customHeader: customHeadersDict,isBody:  true, authNames: ["HTTP Basic", "API Key"])
	}
	/**
	  Create user
      This can only be done by the logged in user.
	  - parameter body: (body) Created user object 
	  - parameter completion: completion handler to receive the data and the error objects
	*/

	public class func createUser(body: User ,  completion: @escaping ((_ error: Error?) -> Void)) {
		createUserRequestBuilder(body: body).execute { (response, error) -> Void in
			completion(error)
		}
	}

	/**
	  Create user
      This can only be done by the logged in user.
	  - POST /user
	  - This can only be done by the logged in user.
	  - OAuth:
	    - type: oauth2
		- name:  OAuthImplicit ,  OAuthAccessCode ,  OAuthPassword ,  OAuthApplication 
		- parameter  body: (body) Created user object  

	  - returns: RequestBuilder<Void>
	*/

	public class func createUserRequestBuilder(body: User) -> RequestBuilder<Void> { 
		let path = "/user"
		let URLString = PetstoreAPI.sharedInstance.basePath + path
		let parameters = body.encodeToJSON() as? [String:AnyObject]
		let convertedParameters = APIHelper.convertBoolToString(source: parameters)
		let requestBuilder: RequestBuilder<Void>.Type = PetstoreAPI.sharedInstance.requestBuilderFactory.getBuilder()

		var customHeadersDict : [String: String] = [:]



		return requestBuilder.init(method: "POST", URLString: URLString, parameters: convertedParameters, customHeader: customHeadersDict,isBody: true , authNames: ["OAuthImplicit", "OAuthAccessCode", "OAuthPassword", "OAuthApplication"])
	}
	/**
	  Creates list of users with given input array
      
	  - parameter body: (body) List of user object 
	  - parameter completion: completion handler to receive the data and the error objects
	*/

	public class func createUsersWithArrayInput(body: [User] ,  completion: @escaping ((_ error: Error?) -> Void)) {
		createUsersWithArrayInputRequestBuilder(body: body).execute { (response, error) -> Void in
			completion(error)
		}
	}

	/**
	  Creates list of users with given input array
      
	  - POST /user/createWithArray
	  - 
	  - OAuth:
	    - type: oauth2
		- name:  OAuthImplicit ,  OAuthAccessCode ,  OAuthPassword ,  OAuthApplication 
		- parameter  body: (body) List of user object  

	  - returns: RequestBuilder<Void>
	*/

	public class func createUsersWithArrayInputRequestBuilder(body: [User]) -> RequestBuilder<Void> { 
		let path = "/user/createWithArray"
		let URLString = PetstoreAPI.sharedInstance.basePath + path
		let parameters = body.encodeToJSON() as? [String:AnyObject]
		let convertedParameters = APIHelper.convertBoolToString(source: parameters)
		let requestBuilder: RequestBuilder<Void>.Type = PetstoreAPI.sharedInstance.requestBuilderFactory.getBuilder()

		var customHeadersDict : [String: String] = [:]



		return requestBuilder.init(method: "POST", URLString: URLString, parameters: convertedParameters, customHeader: customHeadersDict,isBody: true , authNames: ["OAuthImplicit", "OAuthAccessCode", "OAuthPassword", "OAuthApplication"])
	}
	/**
	  Finds Pets by tags
      Muliple tags can be provided with comma separated strings. Use tag1, tag2, tag3 for testing.
	  - parameter tags: (query) Tags to filter by 
	  - parameter completion: completion handler to receive the data and the error objects
	*/

	public class func findPetsByTags(tags: [String] ,  completion: @escaping ((_ data: [Pet]?, _ error: Error?) -> Void)) {
		findPetsByTagsRequestBuilder(tags: tags).execute { (response, error) -> Void in
			completion(response?.body, error)
		}
	}

	/**
	  Finds Pets by tags
      Muliple tags can be provided with comma separated strings. Use tag1, tag2, tag3 for testing.
	  - GET /pet/findByTags
	  - Muliple tags can be provided with comma separated strings. Use tag1, tag2, tag3 for testing.
	  - OAuth:
	    - type: oauth2
		- name:  OAuthImplicit ,  OAuthAccessCode ,  OAuthPassword ,  OAuthApplication 
		- parameter  tags: (query) Tags to filter by  

	  - returns: RequestBuilder<[Pet]>
	*/

	public class func findPetsByTagsRequestBuilder(tags: [String]) -> RequestBuilder<[Pet]> { 
		let path = "/pet/findByTags"
		let URLString = PetstoreAPI.sharedInstance.basePath + path
		let nillableParameters: [String:AnyObject?] = [
			"tags": tags as AnyObject]
		let parameters = APIHelper.rejectNil(source: nillableParameters  as [String : AnyObject?])
		let convertedParameters = APIHelper.convertBoolToString(source: parameters)
		let requestBuilder: RequestBuilder<[Pet]>.Type = PetstoreAPI.sharedInstance.requestBuilderFactory.getBuilder()

		var customHeadersDict : [String: String] = [:]



		return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, customHeader: customHeadersDict,isBody:  false, authNames: ["OAuthImplicit", "OAuthAccessCode", "OAuthPassword", "OAuthApplication"])
	}
	/**
	  Place an order for a pet
      
	  - parameter body: (body) order placed for purchasing the pet 
	  - parameter completion: completion handler to receive the data and the error objects
	*/

	public class func placeOrder(body: Order ,  completion: @escaping ((_ data: Order?, _ error: Error?) -> Void)) {
		placeOrderRequestBuilder(body: body).execute { (response, error) -> Void in
			completion(response?.body, error)
		}
	}

	/**
	  Place an order for a pet
      
	  - POST /store/order
	  - 
	  - OAuth:
	    - type: oauth2
		- name:  API Key 
		- parameter  body: (body) order placed for purchasing the pet  

	  - returns: RequestBuilder<Order>
	*/

	public class func placeOrderRequestBuilder(body: Order) -> RequestBuilder<Order> { 
		let path = "/store/order"
		let URLString = PetstoreAPI.sharedInstance.basePath + path
		let parameters = body.encodeToJSON() as? [String:AnyObject]
		let convertedParameters = APIHelper.convertBoolToString(source: parameters)
		let requestBuilder: RequestBuilder<Order>.Type = PetstoreAPI.sharedInstance.requestBuilderFactory.getBuilder()

		var customHeadersDict : [String: String] = [:]



		return requestBuilder.init(method: "POST", URLString: URLString, parameters: convertedParameters, customHeader: customHeadersDict,isBody: true , authNames: ["API Key"])
	}
	/**
	  Logs out current logged in user session
      
	*/

	public class func logoutUser( completion: @escaping ((_ error: Error?) -> Void)) {
		logoutUserRequestBuilder().execute { (response, error) -> Void in
			completion(error)
		}
	}

	/**
	  Logs out current logged in user session
      
	  - GET /user/logout
	  - 
	  - OAuth:
	    - type: oauth2
		- name:  OAuthImplicit ,  OAuthAccessCode ,  OAuthPassword ,  OAuthApplication 

	  - returns: RequestBuilder<Void>
	*/

	public class func logoutUserRequestBuilder() -> RequestBuilder<Void> { 
		let path = "/user/logout"
		let URLString = PetstoreAPI.sharedInstance.basePath + path
		let nillableParameters: [String:AnyObject?] = [:]
		let parameters = APIHelper.rejectNil(source: nillableParameters  as [String : AnyObject?])
		let convertedParameters = APIHelper.convertBoolToString(source: parameters)
		let requestBuilder: RequestBuilder<Void>.Type = PetstoreAPI.sharedInstance.requestBuilderFactory.getBuilder()

		var customHeadersDict : [String: String] = [:]



		return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, customHeader: customHeadersDict,isBody:  true, authNames: ["OAuthImplicit", "OAuthAccessCode", "OAuthPassword", "OAuthApplication"])
	}
	/**
	  Find pet by ID
      Returns a single pet
	  - parameter petId: (path) ID of pet to return 
	  - parameter completion: completion handler to receive the data and the error objects
	*/

	public class func getPetById(petId: Int64 ,  completion: @escaping ((_ data: Pet?, _ error: Error?) -> Void)) {
		getPetByIdRequestBuilder(petId: petId).execute { (response, error) -> Void in
			completion(response?.body, error)
		}
	}

	/**
	  Find pet by ID
      Returns a single pet
	  - GET /pet/{petId}
	  - Returns a single pet
	  - OAuth:
	    - type: oauth2
		- name:  OAuthImplicit ,  OAuthAccessCode ,  OAuthPassword ,  OAuthApplication 
		- parameter  petId: (path) ID of pet to return  

	  - returns: RequestBuilder<Pet>
	*/

	public class func getPetByIdRequestBuilder(petId: Int64) -> RequestBuilder<Pet> { 
		var path = "/pet/{petId}"
		path = path.replacingOccurrences(of: "{petId}", with: "\(petId)", options: String.CompareOptions.literal, range: nil)
		let URLString = PetstoreAPI.sharedInstance.basePath + path
		let nillableParameters: [String:AnyObject?] = [:]
		let parameters = APIHelper.rejectNil(source: nillableParameters  as [String : AnyObject?])
		let convertedParameters = APIHelper.convertBoolToString(source: parameters)
		let requestBuilder: RequestBuilder<Pet>.Type = PetstoreAPI.sharedInstance.requestBuilderFactory.getBuilder()

		var customHeadersDict : [String: String] = [:]



		return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, customHeader: customHeadersDict,isBody:  true, authNames: ["OAuthImplicit", "OAuthAccessCode", "OAuthPassword", "OAuthApplication"])
	}
	/**
	  Updates a pet in the store with form data
      
	  - parameter petId: (path) ID of pet that needs to be updated 
	  - parameter completion: completion handler to receive the data and the error objects
	  - parameter name: (formData) Updated name of the pet (optional)
	  - parameter completion: completion handler to receive the data and the error objects
	  - parameter status: (formData) Updated status of the pet (optional)
	  - parameter completion: completion handler to receive the data and the error objects
	*/

	public class func updatePetWithForm(petId: Int64 , name: String? = nil , status: String? = nil ,  completion: @escaping ((_ error: Error?) -> Void)) {
		updatePetWithFormRequestBuilder(petId: petId, name: name, status: status).execute { (response, error) -> Void in
			completion(error)
		}
	}

	/**
	  Updates a pet in the store with form data
      
	  - POST /pet/{petId}
	  - 
	  - OAuth:
	    - type: oauth2
		- name:  OAuthImplicit ,  OAuthAccessCode ,  OAuthPassword ,  OAuthApplication 
		- parameter  petId: (path) ID of pet that needs to be updated  
		- parameter  name: (formData) Updated name of the pet (optional) 
		- parameter  status: (formData) Updated status of the pet (optional) 

	  - returns: RequestBuilder<Void>
	*/

	public class func updatePetWithFormRequestBuilder(petId: Int64,name: String? = nil,status: String? = nil) -> RequestBuilder<Void> { 
		var path = "/pet/{petId}"
		path = path.replacingOccurrences(of: "{petId}", with: "\(petId)", options: String.CompareOptions.literal, range: nil)
		let URLString = PetstoreAPI.sharedInstance.basePath + path
		let nillableParameters: [String:AnyObject?] = [
		 	"name": name as AnyObject , 
		 	"status": status as AnyObject ]
		let parameters = APIHelper.rejectNil(source: nillableParameters  as [String : AnyObject?])
		let convertedParameters = APIHelper.convertBoolToString(source: parameters)
		let requestBuilder: RequestBuilder<Void>.Type = PetstoreAPI.sharedInstance.requestBuilderFactory.getBuilder()

		var customHeadersDict : [String: String] = [:]



		return requestBuilder.init(method: "POST", URLString: URLString, parameters: convertedParameters, customHeader: customHeadersDict,isBody:  false, authNames: ["OAuthImplicit", "OAuthAccessCode", "OAuthPassword", "OAuthApplication"])
	}
	/**
	  Deletes a pet
      
	  - parameter apiKey: (header)  (optional)
	  - parameter completion: completion handler to receive the data and the error objects
	  - parameter petId: (path) Pet id to delete 
	  - parameter completion: completion handler to receive the data and the error objects
	*/

	public class func deletePet(petId: Int64 , apiKey: String? = nil ,  completion: @escaping ((_ error: Error?) -> Void)) {
		deletePetRequestBuilder(petId: petId, apiKey: apiKey).execute { (response, error) -> Void in
			completion(error)
		}
	}

	/**
	  Deletes a pet
      
	  - DELETE /pet/{petId}
	  - 
	  - OAuth:
	    - type: oauth2
		- name:  OAuthImplicit ,  OAuthAccessCode ,  OAuthPassword ,  OAuthApplication 
		- parameter  api_key: (header)  (optional) 
		- parameter  petId: (path) Pet id to delete  

	  - returns: RequestBuilder<Void>
	*/

	public class func deletePetRequestBuilder(petId: Int64,apiKey: String? = nil) -> RequestBuilder<Void> { 
		var path = "/pet/{petId}"
		path = path.replacingOccurrences(of: "{petId}", with: "\(petId)", options: String.CompareOptions.literal, range: nil)
		let URLString = PetstoreAPI.sharedInstance.basePath + path
		let nillableParameters: [String:AnyObject?] = [:]
		let parameters = APIHelper.rejectNil(source: nillableParameters  as [String : AnyObject?])
		let convertedParameters = APIHelper.convertBoolToString(source: parameters)
		let requestBuilder: RequestBuilder<Void>.Type = PetstoreAPI.sharedInstance.requestBuilderFactory.getBuilder()

		var customHeadersDict : [String: String] = [:]

		  if let apiKey = apiKey {
            customHeadersDict["api_key"] = apiKey
        }

		return requestBuilder.init(method: "DELETE", URLString: URLString, parameters: convertedParameters, customHeader: customHeadersDict,isBody:  false, authNames: ["OAuthImplicit", "OAuthAccessCode", "OAuthPassword", "OAuthApplication"])
	}
	/**
	  Find purchase order by ID
      For valid response try integer IDs with value >= 1 and <= 10. Other values will generated exceptions
	  - parameter orderId: (path) ID of pet that needs to be fetched 
	  - parameter completion: completion handler to receive the data and the error objects
	*/

	public class func getOrderById(orderId: Int64 ,  completion: @escaping ((_ data: Order?, _ error: Error?) -> Void)) {
		getOrderByIdRequestBuilder(orderId: orderId).execute { (response, error) -> Void in
			completion(response?.body, error)
		}
	}

	/**
	  Find purchase order by ID
      For valid response try integer IDs with value >= 1 and <= 10. Other values will generated exceptions
	  - GET /store/order/{orderId}
	  - For valid response try integer IDs with value >= 1 and <= 10. Other values will generated exceptions
	  - OAuth:
	    - type: oauth2
		- name:  OAuthImplicit ,  OAuthAccessCode ,  OAuthPassword ,  OAuthApplication 
		- parameter  orderId: (path) ID of pet that needs to be fetched  

	  - returns: RequestBuilder<Order>
	*/

	public class func getOrderByIdRequestBuilder(orderId: Int64) -> RequestBuilder<Order> { 
		var path = "/store/order/{orderId}"
		path = path.replacingOccurrences(of: "{orderId}", with: "\(orderId)", options: String.CompareOptions.literal, range: nil)
		let URLString = PetstoreAPI.sharedInstance.basePath + path
		let nillableParameters: [String:AnyObject?] = [:]
		let parameters = APIHelper.rejectNil(source: nillableParameters  as [String : AnyObject?])
		let convertedParameters = APIHelper.convertBoolToString(source: parameters)
		let requestBuilder: RequestBuilder<Order>.Type = PetstoreAPI.sharedInstance.requestBuilderFactory.getBuilder()

		var customHeadersDict : [String: String] = [:]



		return requestBuilder.init(method: "GET", URLString: URLString, parameters: convertedParameters, customHeader: customHeadersDict,isBody:  true, authNames: ["OAuthImplicit", "OAuthAccessCode", "OAuthPassword", "OAuthApplication"])
	}
	/**
	  Delete purchase order by ID
      For valid response try integer IDs with positive integer value. Negative or non-integer values will generate API errors
	  - parameter orderId: (path) ID of the order that needs to be deleted 
	  - parameter completion: completion handler to receive the data and the error objects
	*/

	public class func deleteOrder(orderId: Int64 ,  completion: @escaping ((_ error: Error?) -> Void)) {
		deleteOrderRequestBuilder(orderId: orderId).execute { (response, error) -> Void in
			completion(error)
		}
	}

	/**
	  Delete purchase order by ID
      For valid response try integer IDs with positive integer value. Negative or non-integer values will generate API errors
	  - DELETE /store/order/{orderId}
	  - For valid response try integer IDs with positive integer value. Negative or non-integer values will generate API errors
	  - OAuth:
	    - type: oauth2
		- name:  OAuthImplicit ,  OAuthAccessCode ,  OAuthPassword ,  OAuthApplication 
		- parameter  orderId: (path) ID of the order that needs to be deleted  

	  - returns: RequestBuilder<Void>
	*/

	public class func deleteOrderRequestBuilder(orderId: Int64) -> RequestBuilder<Void> { 
		var path = "/store/order/{orderId}"
		path = path.replacingOccurrences(of: "{orderId}", with: "\(orderId)", options: String.CompareOptions.literal, range: nil)
		let URLString = PetstoreAPI.sharedInstance.basePath + path
		let nillableParameters: [String:AnyObject?] = [:]
		let parameters = APIHelper.rejectNil(source: nillableParameters  as [String : AnyObject?])
		let convertedParameters = APIHelper.convertBoolToString(source: parameters)
		let requestBuilder: RequestBuilder<Void>.Type = PetstoreAPI.sharedInstance.requestBuilderFactory.getBuilder()

		var customHeadersDict : [String: String] = [:]



		return requestBuilder.init(method: "DELETE", URLString: URLString, parameters: convertedParameters, customHeader: customHeadersDict,isBody:  true, authNames: ["OAuthImplicit", "OAuthAccessCode", "OAuthPassword", "OAuthApplication"])
	}
}
