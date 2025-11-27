// Feather disable all

// The GitHub API has numerous versions to work with. GitHub.gml is designed to work with the latest version at the time of writing (2022-11-28)
#macro GITHUB_GML_API_VERSION	"2022-11-28"

// The GitHub API requires a user agent to be set when making requests to the API endpoints
#macro GITHUB_GML_USER_AGENT	"Alub"

// The maximum amount of times that GitHubOAuth can poll the authentication request
#macro GITHUB_GML_OAUTH_MAX_POLLS			20

// The maximum amount of time in seconds that GitHubOAuth can poll the authentication request, the minimum should be whatever the OAuth request sends back.
#macro GITHUB_GML_OAUTH_MAX_POLL_INTERVAL	60