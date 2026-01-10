if (global.authenticationState == 0)
{
	draw_text(12, 12, "Authentication test:\n   Press F1 to use device-flow authentication\n   Press F2 to use web-flow authentication");
}
else if (global.authenticationState == 1)
{
	if (global.authenticationMode == 0 && global.authenticationLink != undefined)
	{
		draw_text(12, 12, $"Device flow authentication test:\n   Login link: {global.authenticationLink}\n   Login code: {global.authenticationCode}\n   Press O to open link in browser\n   Press C to copy login code");
	}
	else if (global.authenticationMode == 1)
	{
		draw_text(12, 12, $"Web flow authentication test:\n   Please authenticate in your browser!");
	}
}
else if (global.authenticationState == 2)
{
	draw_text(12, 12, $"Successfully authenticated!\n   Welcome {global.authenticatedUser}\n   {global.test}");
}
else if (global.authenticationState == 3)
{
	draw_text(12, 12, $"Press F1 to return to start\nError:\n{global.authenticationErrorMessage}");
}