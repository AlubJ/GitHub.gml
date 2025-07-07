github = new GitHub("");
//request = github.getReleases("AlubJ", "BactaTank-Classic");
requestComplete = false;

//request1 = new HTTPGetFile("https://github.com/AlubJ/BactaTank-Classic/releases/download/v0.3.3/BactaTank-Classic-v0.3.3-VM.zip", "BactaTank-Classic-v0.3.3-VM.zip");

release = new GitHubRelease();
release.tagName = "v3.1.0";
release.name = "This release was submitted in GameMaker!";
release.body = "I submitted this release entirely in GML, without accessing GitHub from the browser at all!";

request1 = github.createRelease("AlubJ", "TTGMT", release);