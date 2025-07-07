// Feather disable all
/// @func GitHub([authToken])
/// @desc Constructor for creating a new instance of GitHub.
/// @arg {String} [authToken] The authorization token to be used for requests. 
function GitHub(_authToken = undefined) constructor
{
	// Create
	authToken = _authToken;
	
	// Create __github_controller if it doesn't exist
	if (!instance_exists(__github_controller)) instance_create_depth(0, 0, 0, __github_controller);
	
	// Create Early Destruction Detection Timesource
	timesource = time_source_create(time_source_game, 1, time_source_units_seconds, function() {
		if (instance_number(__github_controller) > 1) instance_destroy(__github_controller);
		if (!instance_exists(__github_controller)) instance_create_depth(0, 0, 0, __github_controller);
	}, [], -1, );
	time_source_start(timesource);
	
	/// @func getLatestRelease(owner, repo)
	/// @desc Create a request for the latest release of a specific repository.
	/// @arg {String} owner The owner of the repo.
	/// @arg {String} repo The repository name.
	static getLatestRelease = function(_owner, _repo)
	{
		// Create Default Headers
		var header = __createDefaultHeaders();
		
		// Create Request
		var request = new HTTPRequest($"https://api.github.com/repos/{_owner}/{_repo}/releases/latest", "GET", header, "");
		
		// Create GitHub Request
		var githubRequest = new GitHubRequest(request.requestID);
		
		// Return Request
		return githubRequest;
	}
	
	/// @func getReleases(owner, repo, [perPage], [page])
	/// @desc Get a list of releases from a repository.
	/// @arg {String} owner The owner of the repo.
	/// @arg {String} repo The repository name.
	/// @arg {Real} [perPage] The number of results per page (max 100).
	/// @arg {Real} [page] The page number of the results to fetch.
	static getReleases = function(_owner, _repo, _perPage = undefined, _page = undefined)
	{
		// Create Default Headers
		var header = __createDefaultHeaders();
		
		// Create Optional Query Params
		var queryParams = "?";
		if (_perPage != undefined) queryParams += $"per_page={clamp(round(_perPage), 30, 100)}&";
		if (_page != undefined) queryParams += $"page={clamp(round(_page), 1, 100)}&";
		
		// Create Request
		var request = new HTTPRequest($"https://api.github.com/repos/{_owner}/{_repo}/releases{queryParams}", "GET", header, "");
		
		// Create GitHub Request
		var githubRequest = new GitHubRequest(request.requestID);
		
		// Return Request
		return githubRequest;
	}
	
	/// @func __createDefaultHeaders()
	/// @desc Creates default header.
	/// @return {Struct}
	static __createDefaultHeaders = function()
	{
		// Create Header
		var header = new HTTPHeader();
		
		// Build Header
		header.add("Accept", "application/vnd.github+json");
		header.add("X-GitHub-Api-Version", __GITHUB_API_VERSION);
		header.add("User-Agent", __GITHUB_USER_AGENT);
		if (authToken != undefined) header.add("Authorization", "Bearer " + authToken);
		
		// Return Header
		return header;
	}
	
	/// @func destroy()
	/// @desc Destroy the GitHub controller and clean up memory.
	static destroy = function()
	{
		// Stop and destroy the timesource.
		time_source_stop(timesource);
		time_source_destroy(timesource);
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