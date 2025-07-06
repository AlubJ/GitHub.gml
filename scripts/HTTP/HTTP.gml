// Feather disable all
/// @func HTTPRequest(requestURL, requestMethod, headerMap, requestBody)
/// @desc Constructor for creating a new HTTP request.
/// @arg {String} [requestURL] The URL to send the request to. 
/// @arg {String} [requestMethod] The request method to use. 
/// @arg {Id.DsMap} [headerMap] The header map to use.
/// @arg {String} [requestBody] The body of the request.
function HTTPRequest(_requestURL, _requestMethod, _headerMap, _requestBody) constructor
{
	// Variables
	requestID = undefined;
	status = undefined;
	result = "null";
	requestURL = _requestURL;
	httpStatus = undefined;
	headerMap = _headerMap;
	requestBody = _requestBody;
	requestMethod = _requestMethod;
	
	// Request
	requestID = http_request(requestURL, requestMethod, headerMap, requestBody);
	
	// Push Request To Active Requests
	array_push(global.__activeRequests__[0], requestID);
	array_push(global.__activeRequests__[1], self);
}

/// @func HTTPGet(requestURL)
/// @desc Constructor for creating a new HTTP get request.
/// @arg {String} [requestURL] The URL to send the request to. 
function HTTPGet(_requestURL) constructor
{
	// Variables
	requestID = undefined;
	status = undefined;
	result = "null";
	requestURL = _requestURL;
	httpStatus = undefined;
	headerMap = _headerMap;
	requestBody = _requestBody;
	requestMethod = _requestMethod;
	
	// Send Request
	requestID = http_get(requestURL);
	
	// Push Request To Active Requests
	array_push(global.__activeRequests__[0], requestID);
	array_push(global.__activeRequests__[1], self);
}

/// @func HTTPHeader()
/// @desc Constructor for creating HTTP header maps.
function HTTPHeader() constructor
{
	// Header Map
	headerMap = ds_map_create();
	
	/// @func add(key, value)
	/// @desc Add a header argument to the header map.
	/// @arg {String} key The key.
	/// @arg {String} value The Value.
	static add = function(_key, _value)
	{
		ds_map_add(headerMap, _key, _value);
	}
	
	/// @func remove(key)
	/// @desc Remove a header argument from the header map.
	/// @arg {String} key The key to remove.
	static remove = function(_key)
	{
		ds_map_delete(headerMap, _key);
	}
	
	/// @func destroy()
	/// @desc Destroy the header map and clean up memory.
	static destroy = function()
	{
		ds_map_destroy(headerMap);
	}
}