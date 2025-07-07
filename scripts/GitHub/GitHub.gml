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
	
	/// @func getReleaseByTag(owner, repo, tagName)
	/// @desc Get a release by its tag name.
	/// @arg {String} owner The owner of the repo.
	/// @arg {String} repo The repository name.
	/// @arg {String} tagName The tag name of the release.
	static getReleaseByTag = function(_owner, _repo, _tagName)
	{
		// Create Default Headers
		var _header = __createDefaultHeaders();
		
		// Create Request
		var _request = new HTTPRequest($"https://api.github.com/repos/{_owner}/{_repo}/releases/tags/{_tagName}", "GET", _header, "");
		
		// Create GitHub Request
		var _githubRequest = new GitHubRequest(_request.requestID);
		
		// Return Request
		return _githubRequest;
	}
	
	/// @func getRelease(owner, repo, releaseID)
	/// @desc Get a release by its releaseID.
	/// @arg {String} owner The owner of the repo.
	/// @arg {String} repo The repository name.
	/// @arg {Real} releaseID The ID of the release.
	static getRelease = function(_owner, _repo, _releaseID)
	{
		// Create Default Headers
		var _header = __createDefaultHeaders();
		
		// Create Request
		var _request = new HTTPRequest($"https://api.github.com/repos/{_owner}/{_repo}/releases/{_releaseID}", "GET", _header, "");
		
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
	
	/// @func updateRelease(owner, repo, releaseID, release)
	/// @desc Update an existing release.
	/// @arg {String} owner The owner of the repo.
	/// @arg {String} repo The repository name.
	/// @arg {Real} releaseID The ID of the release.
	/// @arg {Struct} release The release struct.
	static updateRelease = function(_owner, _repo, _releaseID, _release)
	{
		// Create Default Headers
		var _header = __createDefaultHeaders();
		
		// Create Request
		var _request = new HTTPRequest($"https://api.github.com/repos/{_owner}/{_repo}/releases/{_releaseID}", "PATCH", _header, _release.generateJSON());
		
		// Create GitHub Request
		var _githubRequest = new GitHubRequest(_request.requestID);
		
		// Return Request
		return _githubRequest;
	}
	
	/// @func deleteRelease(owner, repo, releaseID)
	/// @desc Delete an existing release.
	/// @arg {String} owner The owner of the repo.
	/// @arg {String} repo The repository name.
	/// @arg {Real} releaseID The ID of the release.
	static deleteRelease = function(_owner, _repo, _releaseID)
	{
		// Create Default Headers
		var _header = __createDefaultHeaders();
		
		// Create Request
		var _request = new HTTPRequest($"https://api.github.com/repos/{_owner}/{_repo}/releases/{_releaseID}", "DELETE", _header, "");
		
		// Create GitHub Request
		var _githubRequest = new GitHubRequest(_request.requestID);
		
		// Return Request
		return _githubRequest;
	}
	
	#endregion
	
	#region Release Assets
	
	/// @func getReleaseAsset(owner, repo, assetID)
	/// @desc Get asset from a release.
	/// @arg {String} owner The owner of the repo.
	/// @arg {String} repo The repository name.
	/// @arg {Real} assetID The asset ID of the repo.
	static getReleaseAsset = function(_owner, _repo, _assetID)
	{
		// Create Default Headers
		var _header = __createDefaultHeaders();
		
		// Create Request
		var _request = new HTTPRequest($"https://api.github.com/repos/{_owner}/{_repo}/releases/assets/{_assetID}", "GET", _header, "");
		
		// Create GitHub Request
		var _githubRequest = new GitHubRequest(_request.requestID);
		
		// Return Request
		return _githubRequest;
	}
	
	/// @func getReleaseAssets(owner, repo, releaseID, [perPage], [page])
	/// @desc Get asset from a release.
	/// @arg {String} owner The owner of the repo.
	/// @arg {String} repo The repository name.
	/// @arg {Real} releaseID The release ID of the repo.
	/// @arg {Real} [perPage] The number of results per page (max 100).
	/// @arg {Real} [page] The page number of the results to fetch.
	static getReleaseAssets = function(_owner, _repo, _releaseID, _perPage = undefined, _page = undefined)
	{
		// Create Default Headers
		var _header = __createDefaultHeaders();
		
		// Create Optional Query Params
		var _queryParams = "?";
		if (_perPage != undefined) _queryParams += $"per_page={clamp(round(_perPage), 30, 100)}&";
		if (_page != undefined) _queryParams += $"page={clamp(round(_page), 1, 100)}&";
		
		// Create Request
		var _request = new HTTPRequest($"https://api.github.com/repos/{_owner}/{_repo}/releases/{_releaseID}/assets{_queryParams}", "GET", _header, "");
		
		// Create GitHub Request
		var _githubRequest = new GitHubRequest(_request.requestID);
		
		// Return Request
		return _githubRequest;
	}
	
	/// @func uploadReleaseAsset(owner, repo, releaseID, buffer, contentType, targetFilename, [label])
	/// @desc Upload a release asset.
	/// @arg {String} owner The owner of the repo.
	/// @arg {String} repo The repository name.
	/// @arg {Real} releaseID The release ID of the repo.
	/// @arg {Id.Buffer} buffer The buffer to upload.
	/// @arg {String} contentType The content type of the release asset.
	/// @arg {String} targetFilename The target filename for the release asset.
	/// @arg {String} [label] The label for the release asset.
	static uploadReleaseAsset = function(_owner, _repo, _releaseID, _buffer, _contentType, _targetFilename, _label = "")
	{
		// Create Default Headers
		var _header = __createDefaultHeaders();
		_header.add("Content-Length", buffer_get_size(_buffer));
		_header.add("Content-Type", _contentType);
		
		// Seek To 0x01 In Buffer
		buffer_seek(_buffer, buffer_seek_start, 1);
		
		// Create Request
		var _request = new HTTPRequest($"https://uploads.github.com/repos/{_owner}/{_repo}/releases/{_releaseID}/assets?name={_targetFilename}&label={_label}", "POST", _header, _buffer);
		
		// Create GitHub Request
		var _githubRequest = new GitHubRequest(_request.requestID);
		
		// Return Request
		return _githubRequest;
	}
	
	/// @func updateReleaseAsset(owner, repo, assetID, filename, [label])
	/// @desc Upload a release asset.
	/// @arg {String} owner The owner of the repo.
	/// @arg {String} repo The repository name.
	/// @arg {Real} assetID The asset ID of the release.
	/// @arg {String} filename The updated filename.
	/// @arg {String} [label] The updated label.
	static updateReleaseAsset = function(_owner, _repo, _assetID, _filename, _label = "")
	{
		// Create Default Headers
		var _header = __createDefaultHeaders();
		
		// Create Request
		var _request = new HTTPRequest($"https://api.github.com/repos/{_owner}/{_repo}/releases/assets/{_assetID}", "PATCH", _header, json_stringify({name: _filename, label: _label}));
		
		// Create GitHub Request
		var _githubRequest = new GitHubRequest(_request.requestID);
		
		// Return Request
		return _githubRequest;
	}
	
	/// @func deleteReleaseAsset(owner, repo, assetID)
	/// @desc Delete an existing release asset.
	/// @arg {String} owner The owner of the repo.
	/// @arg {String} repo The repository name.
	/// @arg {Real} assetID The ID of the asset.
	static deleteReleaseAsset = function(_owner, _repo, _assetID)
	{
		// Create Default Headers
		var _header = __createDefaultHeaders();
		
		// Create Request
		var _request = new HTTPRequest($"https://api.github.com/repos/{_owner}/{_repo}/releases/assets/{_assetID}", "DELETE", _header, "");
		
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
	contentLength = 0;
	sizeDownloaded = 0;
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