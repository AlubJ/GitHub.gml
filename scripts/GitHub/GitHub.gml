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
	
	#region Releases
	
	/// @func getLatestRelease(owner, repo)
	/// @desc Create a request for the latest release of a specific repository.
	/// @arg {String} owner The owner of the repo.
	/// @arg {String} repo The repository name.
	static getLatestRelease = function(_owner, _repo)
	{
		// Create Default Headers
		var _header = __createDefaultHeaders();
		
		// Create Request
		var _request = new HTTPRequest($"https://api.github.com/repos/{_owner}/{_repo}/releases/latest", "GET", _header, "");
		
		// Create GitHub Request
		var _githubRequest = new GitHubRequest(_request.requestID);
		
		// Return Request
		return _githubRequest;
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
		var _header = __createDefaultHeaders();
		
		// Create Optional Query Params
		var _queryParams = "?";
		if (_perPage != undefined) _queryParams += $"per_page={clamp(round(_perPage), 30, 100)}&";
		if (_page != undefined) _queryParams += $"page={clamp(round(_page), 1, 100)}&";
		
		// Create Request
		var _request = new HTTPRequest($"https://api.github.com/repos/{_owner}/{_repo}/releases{_queryParams}", "GET", _header, "");
		
		// Create GitHub Request
		var _githubRequest = new GitHubRequest(_request.requestID);
		
		// Return Request
		return _githubRequest;
	}
	
	/// @func createRelease(owner, repo, release)
	/// @desc Create a new release.
	/// @arg {String} owner The owner of the repo.
	/// @arg {String} repo The repository name.
	/// @arg {Struct} release The release struct.
	static createRelease = function(_owner, _repo, _release)
	{
		// Create Default Headers
		var _header = __createDefaultHeaders();
		
		// Create Request
		var _request = new HTTPRequest($"https://api.github.com/repos/{_owner}/{_repo}/releases", "POST", _header, _release.generateJSON());
		
		// Create GitHub Request
		var _githubRequest = new GitHubRequest(_request.requestID);
		
		// Return Request
		return _githubRequest;
	}
	
	#endregion
	
	#region Helper
	
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
	
	#endregion
	
	#region Other
	
	/// @func destroy()
	/// @desc Destroy the GitHub controller and clean up memory.
	static destroy = function()
	{
		// Stop and destroy the timesource.
		time_source_stop(timesource);
		time_source_destroy(timesource);
	}
	
	#endregion
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
	/// @func parseResult(result)
	/// @desc Parses the incoming JSON data into the struct.
	/// @arg {String} result The incoming JSON data.
	static parseResult = function(_result)
	{
		result = json_parse(_result);
	}
}


/// @func GitHubRelease()
/// @desc Constructor for creating a GitHub Release
function GitHubRelease() constructor
{
	// Variables
	tagName = undefined; // Required
	targetCommitish = undefined;
	name = undefined;
	body = undefined;
	draft = false;
	prerelease = false;
	discussionCategoryName = undefined;
	generateReleaseNotes = false;
	makeLatest = true;
	
	// Methods
	/// @func generateJSON()
	/// @desc Generates JSON data to be sent with the POST request.
	/// @return {String} The JSON data.
	static generateJSON = function()
	{
		// Create Struct
		var _struct = {};
		
		// Append Values Into Structure
		// Tag Name
		if (tagName != undefined) _struct[$ "tag_name"] = tagName;
		else throw ("GitHubRelease.tagName is required");
		
		// Target Commitish
		if (targetCommitish != undefined) _struct[$ "target_commitish"] = targetCommitish;
		
		// Name
		if (name != undefined) _struct[$ "name"] = name;
		
		// Body
		if (body != undefined) _struct[$ "body"] = body;
		
		// Draft
		_struct[$ "draft"] = bool(draft);
		
		// Pre-Release
		_struct[$ "prerelease"] = bool(prerelease);
		
		// Discussion Category Name
		if (discussionCategoryName != undefined) _struct[$ "discussion_category_name"] = discussionCategoryName;
		
		// Generate Release Notes
		_struct[$ "generate_release_notes"] = bool(generateReleaseNotes);
		
		// Make Latest
		_struct[$ "make_latest"] = makeLatest ? "true" : "false";
		
		// Return JSON
		return json_stringify(_struct);
	}
}