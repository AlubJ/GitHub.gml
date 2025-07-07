github = new GitHub();
//request = github.getReleases("AlubJ", "BactaTank-Classic");
requestComplete = false;

//request1 = new HTTPGetFile("https://github.com/AlubJ/BactaTank-Classic/releases/download/v0.3.3/BactaTank-Classic-v0.3.3-VM.zip", "BactaTank-Classic-v0.3.3-VM.zip");

release = new GitHubRelease();
release.tagName = "v3.3.0";
release.name = "This release was updated in GameMaker!";
release.body = "I updated this release entirely in GML, without accessing GitHub from the browser at all!";
//230525467
//request1 = github.createRelease("AlubJ", "TTGMT", release);

//request1 = github.uploadReleaseAsset("AlubJ", "TTGMT", 230525467, buffer_load("test.zip"), "application/zip", "upload3.zip");
//request1 = github.getReleaseAssets("AlubJ", "TTGMT", 230525467);
//request1 = github.updateReleaseAsset("AlubJ", "TTGMT", 270747319, "newFilename.zip", "Windows Binary");
//request1 = github.deleteReleaseAsset("AlubJ", "TTGMT", 270747847);
//request1 = github.deleteRelease("AlubJ", "TTGMT", 230521461);
//request1 = github.getReleaseByTag("AlubJ", "TTGMT", "v3.3.0");