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
oauth = new GitHubOAuth(_clientID);

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
		
		// Set our authentication callback (runs when authentication is successful)
		oauth.setAuthenticationCallback(function(_resultBody, _request) {
			show_message(_resultBody);
		});
		
		// Now we poll the authentication
		oauth.pollAuthentication(_resultBody.device_code, _resultBody.interval + 1, 20);
	}
});

github = undefined;