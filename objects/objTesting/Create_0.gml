// Get various auth keys
var _buffer = buffer_load("api.key");
var _key = buffer_read(_buffer, buffer_text);
buffer_delete(_buffer);

// GitHub
github = new GitHub(_key);