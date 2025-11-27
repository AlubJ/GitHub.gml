// Feather disable all

// Create server to receive incoming HTTP requests as part of the web page authentication flow
__server = network_create_server_raw(network_socket_tcp, GITHUB_GML_LOCALHOST_PORT, 1);
__socket = undefined;