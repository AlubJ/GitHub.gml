if (request.httpStatus == 200 && !requestComplete)
{
	show_debug_message($"{json_stringify(request.result, true)}");
	requestComplete = true;
}