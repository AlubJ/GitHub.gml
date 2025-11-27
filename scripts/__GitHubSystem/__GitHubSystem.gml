__GitHubSystem();

/// @ignore
function __GitHubSystem()
{
	static _system = undefined;
	if (_system != undefined) return _system;
	
	_system = {  };
	with (_system)
	{
		__GitHubTrace("GitHub.gml implemented by Alun Jones. v" + GITHUB_GML_VERSION + " - " + GITHUB_GML_DATE);
		
		// These are to keep track of active requests because GameMakers async handling is bad
		__activeRequests = {  };
		__activeGitHubRequests = {  };
		
		// Current user authorization token
		__currentUserAuthToken = undefined;
		__currentUserTokenType = undefined;
		__currentUserTokenScope = undefined;
		
		// OAuth helpers
		__clientID = undefined;
		__clientSecret = undefined;
		__deviceCode = undefined;
		__authenticationCallback = undefined;
		__authenticationErrorback = undefined;
		__pollTimesource = undefined;
	}
	
	return _system;
}