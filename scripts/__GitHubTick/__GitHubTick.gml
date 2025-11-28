// Function disable all

/// @ignore
function __GitHubTick()
{
	if (__GitHubSystem().__authenticationExpireTime != undefined && __GitHubSystem().__authenticationExpireTime > 0)
	{
		__GitHubSystem().__authenticationExpireTime--;
	}
	else if (__GitHubSystem().__authenticationExpireTime <= 0 && __github_worker.__server != undefined)
	{
		// Request server shutdown here please
	}
}