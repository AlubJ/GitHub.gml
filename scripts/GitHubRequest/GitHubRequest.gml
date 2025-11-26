// Feather disable all

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