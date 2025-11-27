// Lol no peeking!
var _buffer = buffer_load("api.key");
var _key = buffer_read(_buffer, buffer_text);
buffer_delete(_buffer);

var _buffer = buffer_load("clientID.key");
var _clientID = buffer_read(_buffer, buffer_text);
buffer_delete(_buffer);

var _buffer = buffer_load("clientSecret.key");
var _clientSecret = buffer_read(_buffer, buffer_text);
buffer_delete(_buffer);

// Create OAuth
oauth = new GitHubOAuth(_clientID, _clientSecret);
oauth.setAuthenticationCallback(function(_resultBody, _request) {
	show_message(_resultBody);
});

var _mode = 1; // 0 = device flow, 1 = webpage flow
if (_mode == 0)
{
	// Create auth request
	oauthRequest = oauth.requestAuthentication(["repo", "read:user"]);
	
	// Set the request callback
	oauthRequest.setCallback(function (_resultBody, _request)
	{
		// Check that the request has made it through
		if (_request.httpStatus == 200)
		{
			// Show debug message to login
			show_debug_message($"Please visit: \"{_resultBody.verification_uri}\" and use the code: \"{_resultBody.user_code}\". This code will expire in {_resultBody.expires_in} seconds.");
		
			// Now we poll the authentication
			oauth.pollAuthentication(_resultBody.device_code, _resultBody.interval + 1, 20);
		}
	});
}
else
{
	// Create auth request
	oauth.requestAuthenticationViaWebPage(["repo", "read:user"]);
}

github = undefined;