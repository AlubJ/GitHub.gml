// Get various auth keys
var _buffer = buffer_load("api.key");
var _key = buffer_read(_buffer, buffer_text);
buffer_delete(_buffer);

var _buffer = buffer_load("clientID.key");
var _clientID = buffer_read(_buffer, buffer_text);
buffer_delete(_buffer);

var _buffer = buffer_load("clientSecret.key");
var _clientSecret = buffer_read(_buffer, buffer_text);
buffer_delete(_buffer);

// Some globals
global.authenticationMode = -1; // -1 for none, 0 for device-flow and 1 for web-flow
global.authenticationState = 0;	// 0 for home, 1 for awaiting response, 2 for authenticated and 3 for error

global.authenticationLink = undefined;
global.authenticationCode = undefined;
global.authenticationExpire = undefined;

global.authenticationErrorMessage = undefined;

global.authenticatedUser = undefined;

// Create OAuth
global.oauth = new GitHubOAuth(_clientID, _clientSecret);

// Create authentication callback
global.oauth.setAuthenticationCallback(function(_resultBody, _request) {
	global.authenticationState = 2;
	global.github.setAuthenticationToken(global.oauth.getAuthenticationToken());
	var _ghRequest = global.github.getAuthenticatedUser()
	.setCallback(function (_resultBody, _request)
	{
		show_debug_message(json_stringify(_request.responseHeaders, true));
		global.authenticatedUser = _resultBody[$ "login"];
	});
});

// Create authentication errorback
global.oauth.setAuthenticationErrorback(function(_resultBody, _request) {
	global.authenticationState = 3;
	global.authenticationErrorMessage = json_stringify(_resultBody, true);
});

// GitHub
global.github = new GitHub();