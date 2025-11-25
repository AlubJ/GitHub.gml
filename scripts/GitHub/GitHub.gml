// Feather disable all

/// @func GitHub([__authToken])
/// @desc Constructor for creating a new instance of GitHub.
/// @arg {String} [__authToken] The authorization token to be used for requests. 
function GitHub(_authToken = undefined) constructor
{
	// Create
	if (_authToken == undefined) __GitHubTrace("No authentication token provided to GitHub.gml, you may encounter rate limits and certain API functions returning nothing");
	__authToken = _authToken;
	
	// Create __github_controller if it doesn't exist
	if (!instance_exists(__github_worker)) instance_create_depth(0, 0, 0, __github_worker);
	
	// Create early destruction detection timesource, essentially a "keep alive" to make sure the worker exists at all times when GitHub exists
	__timesource = time_source_create(time_source_game, 1, time_source_units_seconds, function() {
		if (instance_number(__github_worker) > 1) instance_destroy(__github_worker);
		if (!instance_exists(__github_worker)) instance_create_depth(0, 0, 0, __github_worker);
	}, [], -1, );
	time_source_start(__timesource);
	
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
		var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/releases/latest", "GET", _header, "");
		
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
		var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/releases{_queryParams}", "GET", _header, "");
		
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
		var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/releases/tags/{_tagName}", "GET", _header, "");
		
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
		var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/releases/{_releaseID}", "GET", _header, "");
		
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
		var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/releases", "POST", _header, _release.generateJSON());
		
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
		var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/releases/{_releaseID}", "PATCH", _header, _release.generateJSON());
		
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
		var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/releases/{_releaseID}", "DELETE", _header, "");
		
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
		var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/releases/assets/{_assetID}", "GET", _header, "");
		
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
		var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/releases/{_releaseID}/assets{_queryParams}", "GET", _header, "");
		
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
		var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/releases/assets/{_assetID}", "PATCH", _header, json_stringify({name: _filename, label: _label}));
		
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
		var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/releases/assets/{_assetID}", "DELETE", _header, "");
		
		// Create GitHub Request
		var _githubRequest = new GitHubRequest(_request.requestID);
		
		// Return Request
		return _githubRequest;
	}
	
	#endregion
	
	#region Assignees
	
	/// @func getAssignees(owner, repo, [perPage], [page])
	/// @desc Get assignees / contributors in a repository.
	/// @arg {String} owner The owner of the repo.
	/// @arg {String} repo The repository name.
	/// @arg {Real} [perPage] The number of results per page (max 100).
	/// @arg {Real} [page] The page number of the results to fetch.
	/// Documentation: https://docs.github.com/en/rest/issues/assignees#list-assignees
	static getAssignees = function(_owner, _repo, _perPage = undefined, _page = undefined)
	{
		// Create Default Headers
		var _header = __createDefaultHeaders();
		
		// Create Optional Query Params
		var _queryParams = "?";
		if (_perPage != undefined) _queryParams += $"per_page={clamp(round(_perPage), 30, 100)}&";
		if (_page != undefined) _queryParams += $"page={clamp(round(_page), 1, 100)}&";
		
		// Create Request
		var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/assignees{_queryParams}", "GET", _header, "");
		
		// Create GitHub Request
		var _githubRequest = new GitHubRequest(_request.requestID);
		
		// Return Request
		return _githubRequest;
	}
	
	/// @func userAssignable(owner, repo, assignee)
	/// @desc Get assignees / contributors in a repository.
	/// @arg {String} owner The owner of the repo.
	/// @arg {String} repo The repository name.
	/// @arg {String} assignee The assignee name.
	/// Documentation: https://docs.github.com/en/rest/issues/assignees#check-if-a-user-can-be-assigned
	static userAssignable = function(_owner, _repo, _assignee)
	{
		// Create Default Headers
		var _header = __createDefaultHeaders();
		
		// Create Request
		var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/assignees/{_assignee}", "GET", _header, "");
		
		// Create GitHub Request
		var _githubRequest = new GitHubRequest(_request.requestID);
		
		// Return Request
		return _githubRequest;
	}
	
	/// @func addAssigneesToIssue(owner, repo, issueID, assignees)
	/// @desc Add assignees / contributors in a repository to an issue.
	/// @arg {String} owner The owner of the repo.
	/// @arg {String} repo The repository name.
	/// @arg {Real} issueID	The issue ID / number.
	/// @arg {Array.String} assignees List of assignees.
	/// Documentation: https://docs.github.com/en/rest/issues/assignees#add-assignees-to-an-issue
	static addAssigneesToIssue = function(_owner, _repo, _issueID, _assignees)
	{
		// Create Default Headers
		var _header = __createDefaultHeaders();
		
		// Request body
		var _requestBody = "";
		if (!is_undefined(_assignees) && !is_array(_assignees)) _assignees = [_assignees];
		_requestBody = json_stringify({assignees: _assignees});
		
		// Create Request
		var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/{_issueID}/assignees", "POST", _header, _requestBody);
		
		// Create GitHub Request
		var _githubRequest = new GitHubRequest(_request.requestID);
		
		// Return Request
		return _githubRequest;
	}
	
	/// @func removeAssigneesFromIssue(owner, repo, issueID, assignees)
	/// @desc Remove assignees / contributors in a repository from an issue.
	/// @arg {String} owner The owner of the repo.
	/// @arg {String} repo The repository name.
	/// @arg {Real} issueID	The issue ID / number.
	/// @arg {Array.String} assignees List of assignees.
	/// Documentation: https://docs.github.com/en/rest/issues/assignees#remove-assignees-from-an-issue
	static removeAssigneesFromIssue = function(_owner, _repo, _issueID, _assignees)
	{
		// Create Default Headers
		var _header = __createDefaultHeaders();
		
		// Request body
		var _requestBody = "";
		if (!is_undefined(_assignees) && !is_array(_assignees)) _assignees = [_assignees];
		_requestBody = json_stringify({assignees: _assignees});
		
		// Create Request
		var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/{_issueID}/assignees", "DELETE", _header, _requestBody);
		
		// Create GitHub Request
		var _githubRequest = new GitHubRequest(_request.requestID);
		
		// Return Request
		return _githubRequest;
	}
	
	/// @func userAssignableToIssue(owner, repo, issueID, assignee)
	/// @desc Get assignees / contributors in a repository.
	/// @arg {String} owner The owner of the repo.
	/// @arg {String} repo The repository name.
	/// @arg {Real} issueID	The issue ID / number.
	/// @arg {String} assignee The assignee name.
	/// Documentation: https://docs.github.com/en/rest/issues/assignees#check-if-a-user-can-be-assigned-to-a-issue
	static userAssignableToIssue = function(_owner, _repo, _issueID, _assignee)
	{
		// Create Default Headers
		var _header = __createDefaultHeaders();
		
		// Create Request
		var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/{_issueID}/assignees/{_assignee}", "GET", _header, "");
		
		// Create GitHub Request
		var _githubRequest = new GitHubRequest(_request.requestID);
		
		// Return Request
		return _githubRequest;
	}
	
	#endregion
	
	#region Issue Comments
	
	/// @func getRepoIssueComments(owner, repo, [sort], [direction], [since], [perPage], [page])
	/// @desc Get all issue comments in a repository.
	/// @arg {String} owner The owner of the repo.
	/// @arg {String} repo The repository name.
	/// @arg {String} [sort] Sort by "created" or "updated".
	/// @arg {String} [direction] Direction to sort by, "asc" or "desc".
	/// @arg {String} [since] Only show results that were updated after the given time. (`YYYY-MM-DDTHH:MM:SSZ`).
	/// @arg {Real} [perPage] The number of results per page (max 100).
	/// @arg {Real} [page] The page number of the results to fetch.
	/// Documentation: https://docs.github.com/en/rest/issues/comments#list-issue-comments-for-a-repository
	static getRepoIssueComments = function(_owner, _repo, _sort = undefined, _direction = undefined, _since = undefined, _perPage = undefined, _page = undefined)
	{
		// Create Default Headers
		var _header = __createDefaultHeaders();
		
		// Create Optional Query Params
		var _queryParams = "?";
		if (_sort != undefined)			_queryParams += $"sort={_sort}&";
		if (_direction != undefined)	_queryParams += $"direction={_direction}&";
		if (_since != undefined)		_queryParams += $"since={_since}&";
		if (_perPage != undefined)		_queryParams += $"per_page={clamp(round(_perPage), 30, 100)}&";
		if (_page != undefined)			_queryParams += $"page={clamp(round(_page), 1, 100)}&";
		
		// Create Request
		var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/comments{_queryParams}", "GET", _header, "");
		
		// Create GitHub Request
		var _githubRequest = new GitHubRequest(_request.requestID);
		
		// Return Request
		return _githubRequest;
	}
	
	/// @func getIssueComment(owner, repo, commentID)
	/// @desc Get an issue comment in a repository.
	/// @arg {String} owner The owner of the repo.
	/// @arg {String} repo The repository name.
	/// @arg {Real} commentID The comment ID.
	/// Documentation: https://docs.github.com/en/rest/issues/comments#get-an-issue-comment
	static getIssueComment = function(_owner, _repo, _commentID)
	{
		// Create Default Headers
		var _header = __createDefaultHeaders();
		
		// Create Request
		var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/comments/{_commentID}", "GET", _header, "");
		
		// Create GitHub Request
		var _githubRequest = new GitHubRequest(_request.requestID);
		
		// Return Request
		return _githubRequest;
	}
	
	/// @func updateIssueComment(owner, repo, commentID, body)
	/// @desc Update an issue comment in a repository.
	/// @arg {String} owner The owner of the repo.
	/// @arg {String} repo The repository name.
	/// @arg {Real} commentID The comment ID.
	/// @arg {String} body The body of the comment.
	/// Documentation: https://docs.github.com/en/rest/issues/comments#update-an-issue-comment
	static updateIssueComment = function(_owner, _repo, _commentID, _body)
	{
		// Create Default Headers
		var _header = __createDefaultHeaders();
		
		// Create Request
		var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/comments/{_commentID}", "PATCH", _header, $"\{\"body\": \"{_body}\"\}");
		
		// Create GitHub Request
		var _githubRequest = new GitHubRequest(_request.requestID);
		
		// Return Request
		return _githubRequest;
	}
	
	/// @func deleteIssueComment(owner, repo, commentID)
	/// @desc Delete an issue comment in a repository.
	/// @arg {String} owner The owner of the repo.
	/// @arg {String} repo The repository name.
	/// @arg {Real} commentID The comment ID.
	/// Documentation: https://docs.github.com/en/rest/issues/comments#delete-an-issue-comment
	static deleteIssueComment = function(_owner, _repo, _commentID)
	{
		// Create Default Headers
		var _header = __createDefaultHeaders();
		
		// Create Request
		var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/comments/{_commentID}", "DELETE", _header, "");
		
		// Create GitHub Request
		var _githubRequest = new GitHubRequest(_request.requestID);
		
		// Return Request
		return _githubRequest;
	}
	
	/// @func getIssueComments(owner, repo, issueID, [since], [perPage], [page])
	/// @desc Get an issues comments in a repository.
	/// @arg {String} owner The owner of the repo.
	/// @arg {String} repo The repository name.
	/// @arg {Real} issueID The repository name.
	/// @arg {String} [since] Only show results that were updated after the given time. (`YYYY-MM-DDTHH:MM:SSZ`).
	/// @arg {Real} [perPage] The number of results per page (max 100).
	/// @arg {Real} [page] The page number of the results to fetch.
	/// Documentation: https://docs.github.com/en/rest/issues/comments#list-issue-comments
	static getIssueComments = function(_owner, _repo, _issueID, _since = undefined, _perPage = undefined, _page = undefined)
	{
		// Create Default Headers
		var _header = __createDefaultHeaders();
		
		// Create Optional Query Params
		var _queryParams = "?";
		if (_since != undefined)		_queryParams += $"since={_since}&";
		if (_perPage != undefined)		_queryParams += $"per_page={clamp(round(_perPage), 30, 100)}&";
		if (_page != undefined)			_queryParams += $"page={clamp(round(_page), 1, 100)}&";
		
		// Create Request
		var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/{_issueID}/comments{_queryParams}", "GET", _header, "");
		
		// Create GitHub Request
		var _githubRequest = new GitHubRequest(_request.requestID);
		
		// Return Request
		return _githubRequest;
	}
	
	/// @func createIssueComment(owner, repo, issueID, _body)
	/// @desc Create an issue comment in a repository.
	/// @arg {String} owner The owner of the repo.
	/// @arg {String} repo The repository name.
	/// @arg {Real} issueID The repository name.
	/// @arg {String} body The body of the issue comment.
	/// Documentation: https://docs.github.com/en/rest/issues/comments#create-an-issue-comment
	static createIssueComment = function(_owner, _repo, _issueID, _body)
	{
		// Create Default Headers
		var _header = __createDefaultHeaders();
		
		// Create Request
		var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/{_issueID}/comments", "POST", _header, $"\{\"body\": \"{_body}\"\}");
		
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
		var _header = ds_map_create();
		
		// Build Header
		ds_map_add(_header, "Accept", "application/vnd.github+json");
		ds_map_add(_header, "X-GitHub-Api-Version", GITHUB_GML_API_VERSION);
		ds_map_add(_header, "User-Agent", GITHUB_GML_USER_AGENT);
		if (__authToken != undefined) ds_map_add(_header, "Authorization", "Bearer " + __authToken);
		
		// Return Header
		return _header;
	}
	
	#endregion
	
	#region Other
	
	/// @func destroy()
	/// @desc Destroy the GitHub controller and clean up memory.
	static destroy = function()
	{
		// Stop and destroy the timesource.
		time_source_stop(__timesource);
		time_source_destroy(__timesource);
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
	
	// Get system
	var _system = __GitHubSystem();
	
	// Push Request To Active GitHub Requests
	array_push(_system.__activeGitHubRequests[0], requestID);
	array_push(_system.__activeGitHubRequests[1], self);
	
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