// Feather disable all

if (async_load[? "port"] == GITHUB_GML_LOCALHOST_PORT)
{
	var _type = async_load[? "type"];
	if (_type == network_type_connect)
	{
		if (async_load[? "id"] == __server)
		{
			__socket = async_load[? "socket"];
		}
	}
	else if (_type == network_type_disconnect)
	{
		if ((async_load[? "id"] == __server)
		&&  (async_load[? "socket"] == __socket))
		{
			__socket = undefined;
		}
	}
	else
	{
		if (async_load[? "server"] == __server)
		{
			//Extract the HTTP body
			var _buffer = async_load[? "buffer"];
			var _string = buffer_read(_buffer, buffer_text);
			buffer_delete(_buffer);
			
			//Try to find key information from the HTTP header
			var _codePos = string_pos("GET /?code=", _string);
			var _httpPos = string_pos(" HTTP/1.1", _string);
				
			if ((_codePos > 0) && (_httpPos > 0) && (_httpPos > _codePos))
			{
				//We found the information we need, fire off a request to GitHub to get our accesst oken
				var _codeEndPos = _codePos + string_length("GET /?code=");
				var _code = string_copy(_string, _codeEndPos, _httpPos - _codeEndPos);
				
				var _params = $"client_id={__GitHubSystem().__clientID}&client_secret={__GitHubSystem().__clientSecret}&code={_code}";
				
				var _headerMap = ds_map_create();
				_headerMap[? "Accept"] = "application/json";
				
				var _request = new HTTPRequest(GITHUB_GML_ROOT_OAUTH_URL + "oauth/access_token?" + _params, "POST", _headerMap, "");
				var _githubRequest = new GitHubRequest(_request.requestID);
				_githubRequest.setCallback(function(_resultBody, _request)
				{
					// Get system
					var _system = __GitHubSystem();
					
					// Set user authentication
					_system.__currentUserAuthToken = _resultBody.access_token;
					_system.__currentUserTokenType = _resultBody.token_type;
					_system.__currentUserTokenScope = string_split(_resultBody.scope, ",");
					
					// Run the poll callback
					if (_system.__authenticationCallback != undefined)
					{
						_system.__authenticationCallback(_resultBody, _request);
					}
				});
				
				var _status  = "200 OK";
				var _content = "Please return to the game."; //TODO - Replace with a global value so the developer can define a web page to show
			}
			else
			{
				var _status  = "403 Forbidden";
				var _content = "Error!"; //TODO - Replace with a global value so the developer can define a web page to show
			}
			
			//Send a response back to the browser
			var _buffer = buffer_create(1024, buffer_grow, 1);
			buffer_write(_buffer, buffer_text, $"HTTP/1.1 {_status}\nContent-Length: {string_length(_content)}\nContent-Type: text/html\n\n{_content}");
			network_send_raw(__socket, _buffer, buffer_tell(_buffer));
			buffer_delete(_buffer);
			
			//Disconnect from the browser immediately
			network_destroy(__socket);
		}
	}
}