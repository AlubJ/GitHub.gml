if (global.authenticationState == 0)
{
	if (keyboard_check_pressed(vk_f1))
	{
		// Create auth request
		oauthRequest = global.oauth.requestAuthentication(["repo", "read:user"])
		
		// Set the request callback
		.setCallback(function (_resultBody, _request)
		{
			// Check that the request has made it through
			if (_request.httpStatus == 200)
			{
				// Show debug message to login
				show_debug_message($"Please visit: \"{_resultBody.verification_uri}\" and use the code: \"{_resultBody.user_code}\". This code will expire in {_resultBody.expires_in} seconds.");
				global.authenticationLink = _resultBody.verification_uri;
				global.authenticationCode = _resultBody.user_code;
				global.authenticationExpire = _resultBody.expires_in;
		
				// Now we poll the authentication
				oauth.pollAuthentication(_resultBody.device_code, _resultBody.interval + 1, 20);
			}
		});
		
		// Set authentication state
		global.authenticationState = 1;
		global.authenticationMode = 0;
	}
	if (keyboard_check_pressed(vk_f2))
	{
		// Create web-flow request
		oauthRequest = global.oauth.requestAuthenticationViaWebPage(["repo", "read:user"]);
		
		// Set authentication state
		global.authenticationState = 1;
		global.authenticationMode = 1;
	}
}
else if (global.authenticationState == 1)
{
	if (global.authenticationMode == 0)
	{
		if (keyboard_check_pressed(ord("O")))
		{
			url_open(global.authenticationLink);
		}
		if (keyboard_check_pressed(ord("C")))
		{
			clipboard_set_text(global.authenticationCode);
		}
	}
}
else if (global.authenticationState == 2)
{
	if (global.authenticationMode == 0)
	{
		if (keyboard_check_pressed(vk_f1))
		{
			// Cancel callback just in case
			global.oauth.cancelAuthentication();
			
			// Some globals
			global.authenticationMode = -1; // -1 for none, 0 for device-flow and 1 for web-flow
			global.authenticationState = 0;	// 0 for home, 1 for awaiting response, 2 for authenticated and 3 for error

			global.authenticationLink = undefined;
			global.authenticationCode = undefined;
			global.authenticationExpire = undefined;

			global.authenticationErrorMessage = undefined;
			
			global.authenticatedUser = undefined;
		}
	}
}