// Feather disable all

/// @func GitHubOAuth(clientID)
/// @desc Constructor for creating a new instance of GitHubOAuth.
/// @arg {String} _clientID The client ID to use for authentication.
/// @arg {String} _clientID The client secret to use for authentication. 
function GitHubOAuth(_clientID, _clientSecret) constructor
{
	__GitHubSystem().__clientID = _clientID;
	__GitHubSystem().__clientSecret = _clientSecret;
	
	// Create __github_controller if it doesn't exist
	if (!instance_exists(__github_worker)) instance_create_depth(0, 0, 0, __github_worker);
	
	// Create early destruction detection timesource, essentially a "keep alive" to make sure the worker exists at all times when GitHub exists
	static __timesource = time_source_create(time_source_game, 1, time_source_units_seconds, function() {
		if (instance_number(__github_worker) > 1) instance_destroy(__github_worker);
		if (!instance_exists(__github_worker)) instance_create_depth(0, 0, 0, __github_worker);
	}, [], -1, );
	if (time_source_get_state(__timesource) != time_source_state_active) time_source_start(__timesource);
	
	/// @func requestAuthenticationViaWebPage()
	/// @desc Request OAuth user authentication via a web page.
	/// @arg {Array.String} scope An array of authentication scopes.
	/// @returns {Any}
	static requestAuthenticationViaWebPage = function(_scope)
	{
		// Ensure server does not exist
		if (__github_worker.__server != undefined)
		{
			__GitHubWarn("requestAuthenticationViaWebPage: Server is already running, ensure there is not another web-flow authentication in progress.")
		}
		
		// Create the server
		__github_worker.__server = network_create_server_raw(network_socket_tcp, GITHUB_GML_LOCALHOST_PORT, 1);
		
		// Open the URL
		url_open($"{GITHUB_GML_ROOT_OAUTH_URL}oauth/authorize?client_id={__GitHubSystem().__clientID}&scope={__constructScopeString(_scope)}");
	}
	
	/// @func requestAuthentication()
	/// @desc Request OAuth user authentication via the device flow.
	/// @arg {Array.String} scope An array of authentication scopes.
	/// @returns {Struct.GitHubRequest}
	static requestAuthentication = function(_scope)
	{
		// Create Header
		var _header = __createDefaultHeaders();
		
		// Build body TODO: create authentication scope enum / bitfield
		var _body = "client_id=" + __GitHubSystem().__clientID + "&scope=" + __constructScopeString(_scope);
		
		// Send request
		var _request = new HTTPRequest(GITHUB_GML_ROOT_OAUTH_URL + "device/code", "POST", _header, _body);
		
		// Create GitHub Request
		var _githubRequest = new GitHubRequest(_request.requestID);
		
		// Return Request
		return _githubRequest;
	}
	
	/// @func pollAuthentication(deviceCode, interval, [maxAttempts])
	/// @desc Start polling the authentication to check if the user as granted it.
	/// @arg {String} deviceCode The device code that was returned back from `requestAuthentication`.
	/// @arg {Real} interval The interval in seconds to poll the authentication.
	/// @arg {Real} [maxAttempts] The maximum number of attempts to make to poll the authentication.
	/// @returns {Any}
	static pollAuthentication = function(_deviceCode, _interval, _maxAttempts = 10)
	{
		// Clamp the interval and max attempts
		_interval = clamp(_interval, 5, GITHUB_GML_OAUTH_MAX_POLL_INTERVAL);
		_maxAttempts = clamp(_maxAttempts, 1, GITHUB_GML_OAUTH_MAX_POLLS);
		
		// System
		var _system = __GitHubSystem();
		
		// Save device code
		_system.__deviceCode = _deviceCode;
		
		// Create the time source
		_system.__pollTimesource = time_source_create(time_source_global, _interval, time_source_units_seconds, __pollAuthentication, [], _maxAttempts, time_source_expire_after);;
		
		// Start the timesource
		time_source_start(_system.__pollTimesource);
	}
	
	/// @func setAuthenticationCallback()
	/// @desc Set the authentication callback which will be executed when the authentication is successful.
	/// @arg {Function} callback The method to execute.
	/// @returns {Any}
	static setAuthenticationCallback = function(_callback)
	{
		__GitHubSystem().__authenticationCallback = _callback;
	}
	
	/// @func getAuthenticationToken()
	/// @desc Returns back the current authentication token.
	/// @returns {String}
	static getAuthenticationToken = function()
	{
		return __GitHubSystem().__currentUserAuthToken;
	}
	
	/// @func getAuthenticationTokenType()
	/// @desc Returns back the current authentication token type.
	/// @returns {String}
	static getAuthenticationTokenType = function()
	{
		return __GitHubSystem().__currentUserTokenType;
	}
	
	/// @func getAuthenticationTokenScope()
	/// @desc Returns back the current authentication token scope.
	/// @returns {String}
	static getAuthenticationTokenScope = function()
	{
		return __GitHubSystem().__currentUserTokenScope;
	}
	
	/// @func __pollAuthentication()
	/// @desc Authentication poll for the timesource.
	/// @ignore
	static __pollAuthentication = function()
	{
		// Create Header
		var _header = ds_map_create();
		
		// Build Header
		ds_map_add(_header, "Accept", "application/json");
		ds_map_add(_header, "Content-Type", "application/x-www-form-urlencoded");
		
		// System
		var _system = __GitHubSystem();
		
		// Build body
		var _body = "client_id=" + _system.__clientID + "&device_code=" + _system.__deviceCode + "&grant_type=" + GITHUB_GML_OAUTH_GRANT_TYPE;
		
		// Send request
		var _request = new HTTPRequest(GITHUB_GML_ROOT_OAUTH_URL + "oauth/access_token", "POST", _header, _body);
		
		// Create GitHub Request
		_system.__pollRequest = new GitHubRequest(_request.requestID);
		
		// Create the special callback
		_system.__pollRequest.__specialCallback = function (_resultBody, _request)
		{
			// Check that the response has come back clean and that there is no error.
			if (_request.httpStatus == 200 && !variable_struct_exists(_resultBody, "error"))
			{
				// Get system
				var _system = __GitHubSystem();
				
				// Set user authentication
				_system.__currentUserAuthToken = _resultBody.access_token;
				_system.__currentUserTokenType = _resultBody.token_type;
				_system.__currentUserTokenScope = string_split(_resultBody.scope, ",");
				
				// Clear timesources
				time_source_stop(_system.__pollTimesource);
				time_source_destroy(_system.__pollTimesource);
				
				// Run the poll callback
				if (_system.__authenticationCallback != undefined)
				{
					_system.__authenticationCallback(_resultBody, _request);
				}
			}
		};
	}
	
	/// @func __constructScopeString(scope)
	/// @desc Construct a scope string.
	/// @ignore
	static __constructScopeString = function(_scope)
	{
		var _returnString = "";
		var _scopeCount = array_length(_scope);
		var _i = 0;
		
		repeat(_scopeCount)
		{
			_returnString += _scope[_i] + "%20";
			_i++;
		}
		
		return _returnString;
	}
	
	/// @func __createDefaultHeaders()
	/// @desc Creates default header.
	/// @return {Struct}
	/// @ignore
	static __createDefaultHeaders = function()
	{
		// Create Header
		var _header = ds_map_create();
		
		// Build Header
		ds_map_add(_header, "Accept", "application/json");
		ds_map_add(_header, "Content-Type", "application/x-www-form-urlencoded");
		
		// Return Header
		return _header;
	}
}