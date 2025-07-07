// Feather disable all

if (array_contains(global.__activeRequests__[0], async_load[? "id"]))
{
	// Request ID
	var _requestID = async_load[? "id"];
	
	// Get Request Object
	var _requestIndex = array_get_index(global.__activeRequests__[0], _requestID);
	var _requestObject = global.__activeRequests__[1][_requestIndex];
	
	// Set Status
	_requestObject.status = async_load[? "status"];
	
	// Get GitHub Request and Set Its Status
	if (array_contains(global.__activeGitHubRequests__[0], _requestID))
	{
		// Get GitHub Request Object
		var _ghRequestIndex = array_get_index(global.__activeGitHubRequests__[0], _requestID);
		var _ghRequestObject = global.__activeGitHubRequests__[1][_ghRequestIndex];
		
		// Set Status
		_ghRequestObject.status = async_load[? "status"];
	}
	
	// Check Request Status
	if (async_load[? "status"] > 0)
	{
		// Still Recieving Packets
		_requestObject.contentLength = async_load[? "contentLength"];
		_requestObject.sizeDownloaded = async_load[? "sizeDownloaded"];
	}
	else if (async_load[? "status"] == 0)
	{
		// Recieved All Packets
		// Set HTTP Status
		_requestObject.httpStatus = async_load[? "http_status"];
		
		// Get GitHub Request and Set Its HTTP Status
		if (array_contains(global.__activeGitHubRequests__[0], _requestID))
		{
			// Get GitHub Request Object
			var _ghRequestIndex = array_get_index(global.__activeGitHubRequests__[0], _requestID);
			var _ghRequestObject = global.__activeGitHubRequests__[1][_ghRequestIndex];
			
			// Set Status
			_ghRequestObject.httpStatus = async_load[? "http_status"];
		}
		
		// Check HTTP Status
		if (async_load[? "http_status"] >= 200 && async_load[? "http_status"] < 300)
		{
			// Get Result
			_requestObject.result = async_load[? "result"];
			
			// Get GitHub Request
			if (array_contains(global.__activeGitHubRequests__[0], _requestID))
			{
				// Get GitHub Request Object
				var _ghRequestIndex = array_get_index(global.__activeGitHubRequests__[0], _requestID);
				var _ghRequestObject = global.__activeGitHubRequests__[1][_ghRequestIndex];
				
				// Parse The Incoming JSON
				_ghRequestObject.parseResult(_requestObject.result);
			}
		}
		
		// Delete The Header Map
		if (ds_exists(_requestObject.headerMap, ds_type_map)) _requestObject.headerMap.destroy();
		
		// Delete From Active Requests
		array_delete(global.__activeRequests__[0], _requestIndex, 1);
		array_delete(global.__activeRequests__[1], _requestIndex, 1);
		
		// Get GitHub Request
		if (array_contains(global.__activeGitHubRequests__[0], _requestID))
		{
			// Get GitHub Request Object
			var _ghRequestIndex = array_get_index(global.__activeGitHubRequests__[0], _requestID);
			var _ghRequestObject = global.__activeGitHubRequests__[1][_ghRequestIndex];
			
			// Delete From Active GitHub Requests
			array_delete(global.__activeGitHubRequests__[0], _ghRequestIndex, 1);
			array_delete(global.__activeGitHubRequests__[1], _ghRequestIndex, 1);
		}
		
		show_debug_message(async_load[? "result"]);
	}
}