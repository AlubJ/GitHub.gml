// Function disable all

/// @ignore
function __GitHubTick()
{
	if (__GitHubSystem().__authenticationExpireTime != undefined && __GitHubSystem().__authenticationExpireTime > 0)
	{
		__GitHubSystem().__authenticationExpireTime--;
	}
}