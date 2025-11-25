__GitHubSystem();

function __GitHubSystem()
{
	static _system = undefined;
	if (_system != undefined) return _system;
	
	_system = {  };
	with (_system)
	{
		__GitHubTrace("GitHub.gml implemented by Alun Jones. v" + GITHUB_GML_VERSION + " - " + GITHUB_GML_DATE);
		
		// These are to keep track of active requests because GameMakers async handling is bad
		__activeRequests = [[], []];
		__activeGitHubRequests = [[], []];
	}
	
	return _system;
}