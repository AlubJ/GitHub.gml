if (request.httpStatus != 204 && request.httpStatus != undefined && !requestComplete)
{
	show_debug_message($"{json_stringify(request.result, true)}");
	requestComplete = true;
}
else
{
	show_debug_message(request.httpStatus);
}

//if (request1.status > 0) show_debug_message($"Uploaded {request1.sizeDownloaded} of {request1.contentLength} ({request1.sizeDownloaded / request1.contentLength}%)");