if (request1.httpStatus != 204 && request1.httpStatus != undefined && !requestComplete)
{
	show_debug_message($"{json_stringify(request1.result, true)}");
	requestComplete = true;
}
show_debug_message(request1.httpStatus);

if (request1.status > 0) show_debug_message($"Uploaded {request1.sizeDownloaded} of {request1.contentLength} ({request1.sizeDownloaded / request1.contentLength}%)");