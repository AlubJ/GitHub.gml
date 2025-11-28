// Get various auth keys
var _buffer = buffer_load("api.key");
var _key = buffer_read(_buffer, buffer_text);
buffer_delete(_buffer);

// GitHub
github = new GitHub(_key);

github.getAttestations("AlubJ", "sha256")
.setCallback(function (_resultBody, _request)
{
	show_debug_message(json_stringify(_resultBody, true));
});