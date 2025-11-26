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
	/// Documentation: https://docs.github.com/en/rest/releases/releases#get-the-latest-release
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
	/// Documentation: https://docs.github.com/en/rest/releases/releases#list-releases
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
	/// Documentation: https://docs.github.com/en/rest/releases/releases#get-a-release-by-tag-name
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
	/// Documentation: https://docs.github.com/en/rest/releases/releases#get-a-release
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
	/// @arg {Struct.GitHubRelease} release The release struct.
	/// Documentation: https://docs.github.com/en/rest/releases/releases#create-a-release
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
	/// @arg {Struct.GitHubRelease} release The release struct.
	/// Documentation: https://docs.github.com/en/rest/releases/releases#update-a-release
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
	/// Documentation: https://docs.github.com/en/rest/releases/releases#delete-a-release
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
	/// Documentation: https://docs.github.com/en/rest/releases/assets#get-a-release-asset
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
	/// Documentation: https://docs.github.com/en/rest/releases/assets#list-release-assets
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
	/// Documentation: https://docs.github.com/en/rest/releases/assets#upload-a-release-asset
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
	/// Documentation: https://docs.github.com/en/rest/releases/assets#update-a-release-asset
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
	/// Documentation: https://docs.github.com/en/rest/releases/assets#delete-a-release-asset
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
	
	#region Issues
	
	/// @func getIssuesAssignedToMe([filter], [state], [labels], [sort], [direction], [since], [collab], [orgs], [owned], [pulls], [perPage], [page])
	/// @desc Get all the issues assigned to the authenticated user.
	/// @arg {String} [filter] Filter by "assgined", "created", "mentioned", "subscribed", "repos" or "all".
	/// @arg {String} [state] Issue state filter by "open", "closed" or "all".
	/// @arg {String} [labels] Issue labels separated by commas ("bug,ui,@high").
	/// @arg {String} [sort] Sort by "created" or "updated".
	/// @arg {String} [direction] Direction to sort by, "asc" or "desc".
	/// @arg {String} [since] Only show results that were updated after the given time. (`YYYY-MM-DDTHH:MM:SSZ`).
	/// @arg {Bool} [collab]
	/// @arg {Bool} [orgs]
	/// @arg {Bool} [owned]
	/// @arg {Bool} [pulls]
	/// @arg {Real} [perPage] The number of results per page (max 100).
	/// @arg {Real} [page] The page number of the results to fetch.
	/// Documentation: https://docs.github.com/en/rest/issues/issues#list-issues-assigned-to-the-authenticated-user
	static getIssuesAssignedToMe = function(_filter = undefined, _state = undefined, _labels = undefined, _sort = undefined, _direction = undefined, _since = undefined, _collab = undefined, _orgs = undefined, _owned = undefined, _pulls = undefined, _perPage = undefined, _page = undefined)
	{
		// Create Default Headers
		var _header = __createDefaultHeaders();
		
		// Create Optional Query Params
		var _queryParams = "?";
		if (_filter != undefined)		_queryParams += $"filter={_filter}&";
		if (_state != undefined)		_queryParams += $"state={_state}&";
		if (_labels != undefined)		_queryParams += $"labels={_labels}&";
		if (_sort != undefined)			_queryParams += $"sort={_sort}&";
		if (_direction != undefined)	_queryParams += $"direction={_direction}&";
		if (_since != undefined)		_queryParams += $"since={_since}&";
		if (_collab != undefined)		_queryParams += $"collab={_collab ? "true" : "false"}&";
		if (_orgs != undefined)			_queryParams += $"orgs={_orgs ? "true" : "false"}&";
		if (_owned != undefined)		_queryParams += $"owned={_owned ? "true" : "false"}&";
		if (_pulls != undefined)		_queryParams += $"pulls={_pulls ? "true" : "false"}&";
		if (_perPage != undefined)		_queryParams += $"per_page={clamp(round(_perPage), 30, 100)}&";
		if (_page != undefined)			_queryParams += $"page={clamp(round(_page), 1, 100)}&";
		
		// Create Request
		var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}issues{_queryParams}", "GET", _header, "");
		
		// Create GitHub Request
		var _githubRequest = new GitHubRequest(_request.requestID);
		
		// Return Request
		return _githubRequest;
	}
	
	/// @func getOrgIssuesAssignedToMe(org, [filter], [state], [labels], [sort], [direction], [perPage], [page])
	/// @desc Get an organizations issues assigned to the authenticated user.
	/// @arg {String} org The organization.
	/// @arg {String} [filter] Filter by "assgined", "created", "mentioned", "subscribed", "repos" or "all".
	/// @arg {String} [state] Issue state filter by "open", "closed" or "all".
	/// @arg {String} [labels] Issue labels separated by commas ("bug,ui,@high").
	/// @arg {String} [sort] Sort by "created" or "updated".
	/// @arg {String} [direction] Direction to sort by, "asc" or "desc".
	/// @arg {String} [since] Only show results that were updated after the given time. (`YYYY-MM-DDTHH:MM:SSZ`).
	/// @arg {Real} [perPage] The number of results per page (max 100).
	/// @arg {Real} [page] The page number of the results to fetch.
	/// Documentation: https://docs.github.com/en/rest/issues/issues#list-organization-issues-assigned-to-the-authenticated-user
	static getOrgIssuesAssignedToMe = function(_org, _filter = undefined, _state = undefined, _labels = undefined, _sort = undefined, _direction = undefined, _since = undefined, _perPage = undefined, _page = undefined)
	{
		// Create Default Headers
		var _header = __createDefaultHeaders();
		
		// Create Optional Query Params
		var _queryParams = "?";
		if (_filter != undefined)		_queryParams += $"filter={_filter}&";
		if (_state != undefined)		_queryParams += $"state={_state}&";
		if (_labels != undefined)		_queryParams += $"labels={_labels}&";
		if (_sort != undefined)			_queryParams += $"sort={_sort}&";
		if (_direction != undefined)	_queryParams += $"direction={_direction}&";
		if (_since != undefined)		_queryParams += $"since={_since}&";
		if (_perPage != undefined)		_queryParams += $"per_page={clamp(round(_perPage), 30, 100)}&";
		if (_page != undefined)			_queryParams += $"page={clamp(round(_page), 1, 100)}&";
		
		// Create Request
		var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}orgs/{_org}/issues{_queryParams}", "GET", _header, "");
		
		// Create GitHub Request
		var _githubRequest = new GitHubRequest(_request.requestID);
		
		// Return Request
		return _githubRequest;
	}
	
	/// @func getIssues(owner, repo, [milestone], [state], [assignee], [type], [creator], [mentioned], [labels], [sort], [direction], [since], [perPage], [page])
	/// @desc Get issues from a repository.
	/// @arg {String} owner The owner of the repo.
	/// @arg {String} repo The repository name.
	/// @arg {Real} [milestone] Pass an integer to refer to a specific milestone, pass "*" to refer to all milestones or pass "none" to omit issues without milestones.
	/// @arg {String} [state] Issue state filter by "open", "closed" or "all".
	/// @arg {String} [assignee] Filter by the user assigned.
	/// @arg {String} [type] Filter by the issue type.
	/// @arg {String} [creator] Filter by the user who created the issue.
	/// @arg {String} [mentioned] Filter by a user who was mentioned in the issue.
	/// @arg {String} [labels] Issue labels separated by commas ("bug,ui,@high").
	/// @arg {String} [sort] Sort by "created" or "updated".
	/// @arg {String} [direction] Direction to sort by, "asc" or "desc".
	/// @arg {String} [since] Only show results that were updated after the given time. (`YYYY-MM-DDTHH:MM:SSZ`).
	/// @arg {Real} [perPage] The number of results per page (max 100).
	/// @arg {Real} [page] The page number of the results to fetch.
	/// Documentation: https://docs.github.com/en/rest/issues/issues#list-repository-issues
	static getIssues = function(_owner, _repo, _milestone = undefined, _state = undefined, _assignee = undefined, _type = undefined, _creator = undefined, _mentioned = undefined, _labels = undefined, _sort = undefined, _direction = undefined, _since = undefined, _perPage = undefined, _page = undefined)
	{
		// Create Default Headers
		var _header = __createDefaultHeaders();
		
		// Create Optional Query Params
		var _queryParams = "?";
		if (_milestone != undefined)	_queryParams += $"milestone={_milestone}&";
		if (_state != undefined)		_queryParams += $"state={_state}&";
		if (_assignee != undefined)		_queryParams += $"assignee={_assignee}&";
		if (_type != undefined)			_queryParams += $"type={_type}&";
		if (_creator != undefined)		_queryParams += $"creator={_creator}&";
		if (_mentioned != undefined)	_queryParams += $"mentioned={_mentioned}&";
		if (_labels != undefined)		_queryParams += $"labels={_labels}&";
		if (_sort != undefined)			_queryParams += $"sort={_sort}&";
		if (_direction != undefined)	_queryParams += $"direction={_direction}&";
		if (_since != undefined)		_queryParams += $"since={_since}&";
		if (_perPage != undefined)		_queryParams += $"per_page={clamp(round(_perPage), 30, 100)}&";
		if (_page != undefined)			_queryParams += $"page={clamp(round(_page), 1, 100)}&";
		
		// Create Request
		var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues{_queryParams}", "GET", _header, "");
		
		// Create GitHub Request
		var _githubRequest = new GitHubRequest(_request.requestID);
		
		// Return Request
		return _githubRequest;
	}
	
	/// @func createIssue(owner, repo, issue)
	/// @desc Create a new issue.
	/// @arg {String} owner The owner of the repo.
	/// @arg {String} repo The repository name.
	/// @arg {Struct.GitHubIssue} issue The issue struct.
	/// Documentation: https://docs.github.com/en/rest/issues/issues#create-an-issue
	static createIssue = function(_owner, _repo, _issue)
	{
		// Create Default Headers
		var _header = __createDefaultHeaders();
		
		// Create Request
		var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues", "POST", _header, _issue.generateJSON());
		
		// Create GitHub Request
		var _githubRequest = new GitHubRequest(_request.requestID);
		
		// Return Request
		return _githubRequest;
	}
	
	/// @func getIssue(owner, repo, issueID)
	/// @desc Get an issue by its issueID.
	/// @arg {String} owner The owner of the repo.
	/// @arg {String} repo The repository name.
	/// @arg {Real} issueID The ID of the issue.
	/// Documentation: https://docs.github.com/en/rest/issues/issues#get-an-issue
	static getIssue = function(_owner, _repo, _issueID)
	{
		// Create Default Headers
		var _header = __createDefaultHeaders();
		
		// Create Request
		var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/{_issueID}", "GET", _header, "");
		
		// Create GitHub Request
		var _githubRequest = new GitHubRequest(_request.requestID);
		
		// Return Request
		return _githubRequest;
	}
	
	/// @func updateIssue(owner, repo, issueID, issue)
	/// @desc Update an existing issue.
	/// @arg {String} owner The owner of the repo.
	/// @arg {String} repo The repository name.
	/// @arg {Real} issueID The ID of the issue.
	/// @arg {Struct.GitHubIssue} issue The issue struct.
	/// Documentation: https://docs.github.com/en/rest/issues/issues#update-an-issue
	static updateIssue = function(_owner, _repo, _issueID, _issue)
	{
		// Create Default Headers
		var _header = __createDefaultHeaders();
		
		// Create Request
		var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/{_issueID}", "PATCH", _header, _issue.generateJSON());
		
		// Create GitHub Request
		var _githubRequest = new GitHubRequest(_request.requestID);
		
		// Return Request
		return _githubRequest;
	}
	
	/// @func lockIssue(owner, repo, issueID, lockReason)
	/// @desc Lock an existing issue.
	/// @arg {String} owner The owner of the repo.
	/// @arg {String} repo The repository name.
	/// @arg {Real} issueID The ID of the issue.
	/// @arg {String} lockReason The reason for locking, can be "off-topic", "too heated", "resolved" or "spam"
	/// Documentation: https://docs.github.com/en/rest/issues/issues#lock-an-issue
	static lockIssue = function(_owner, _repo, _issueID, _lockReason)
	{
		// Create Default Headers
		var _header = __createDefaultHeaders();
		
		// Create Request
		var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/{_issueID}/lock", "PUT", _header, $"\{\"lock_reason\":\"{_lockReason}\"\}");
		
		// Create GitHub Request
		var _githubRequest = new GitHubRequest(_request.requestID);
		
		// Return Request
		return _githubRequest;
	}
	
	/// @func unlockIssue(owner, repo, issueID, lockReason)
	/// @desc Unlock a locked issue.
	/// @arg {String} owner The owner of the repo.
	/// @arg {String} repo The repository name.
	/// @arg {Real} issueID The ID of the issue.
	/// Documentation: https://docs.github.com/en/rest/issues/issues#unlock-an-issue
	static unlockIssue = function(_owner, _repo, _issueID)
	{
		// Create Default Headers
		var _header = __createDefaultHeaders();
		
		// Create Request
		var _request = new HTTPRequest($"{GITHUB_GML_ROOT_URL}repos/{_owner}/{_repo}/issues/{_issueID}/lock", "DELETE", _header, "");
		
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