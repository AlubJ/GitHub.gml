// Feather disable all
#macro __GITHUB_API_VERSION "2022-11-28"	// The version of the API to use
#macro __GITHUB_USER_AGENT "Alub"					// The user agent of the requests

// Active requests and active github request arrays
global.__activeRequests__ = [[], []];
global.__activeGitHubRequests__ = [[], []];