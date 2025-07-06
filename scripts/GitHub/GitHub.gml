// Feather disable all
/// @func GitHub([authToken])
/// @desc Constructor for creating a new instance of GitHub.
/// @arg {String} [authToken] The authorization token to be used for requests. 
function GitHub(_authToken = undefined) constructor
{
	// Create
	authToken = _authToken;
	if (!instance_exists(__github_controller)) instance_create_depth(0, 0, 0, __github_controller);
	
	/// @func getLatestRelease(owner, repo)
	/// @desc Create a request for the latest release of a specific repository.
	/// @arg {String} owner The owner of the repo.
	/// @arg {String} repo The repository name.
	static getLatestRelease = function(_owner, _repo)
	{
		// Create Header
		var header = new HTTPHeader();
		
		// Build Header
		header.add("Accept", "application/vnd.github+json");
		header.add("X-GitHub-Api-Version", __GITHUB_API_VERSION);
		header.add("User-Agent", __USER_AGENT);
		if (authToken != undefined) header.add("Authorization", "Bearer " + authToken);
		
		// Create Request
		var request = new HTTPRequest($"https://api.github.com/repos/{_owner}/{_repo}/releases/latest", "GET", header.headerMap, "");
		
		// Create GitHub Request
		var githubRequest = new GitHubRequest(request.requestID);
		
		// Destroy Header Builder
		header.destroy();
		
		// Return Request
		return githubRequest;
	}
}

/// @func GitHubRequest(requestID)
/// @desc Constructor for a GitHub specific request, when valid data is returned back, it will be parsed into the structure.
/// @arg {Real} requestID The ID for the request that has been sent.
function GitHubRequest(_requestID) constructor
{
	// Variables
	requestID = _requestID;
	status = undefined;
	httpStatus = undefined;
	result = "null";
	
	// Push Request To Active GitHub Requests
	array_push(global.__activeGitHubRequests__[0], requestID);
	array_push(global.__activeGitHubRequests__[1], self);
	
	// Methods
	static parseResult = function(_result)
	{
		result = json_parse(_result);
	}
}