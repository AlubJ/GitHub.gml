// Get various auth keys
var _buffer = buffer_load("api.key");
var _key = buffer_read(_buffer, buffer_text);
buffer_delete(_buffer);

// GitHub
github = new GitHub(_key);

var _content = new GitHubContent("test-update", "This is a test of updating repository content", "835687084068c84de183b60fb5d278017456dfb4c1dbf97c3e39c832314f01e2");
github.createRepositoryContent("AlubJ", "TTGMT", "README.md", _content)
.setCallback(function (_resultBody, _request)
{
	show_debug_message(json_stringify(_resultBody, true));
})
.setErrorback(function (_resultBody, _request)
{
	show_debug_message(json_stringify(_resultBody, true));
})