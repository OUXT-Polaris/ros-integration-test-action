const artifact = require('@actions/artifact');
const artifactClient = artifact.create()
const artifactName = 'scenario_test_artifacts';
const globPattern = '/artifacts/*'
const rootDirectory = '/artifacts';

const path = require('path');
const glob = require('glob');

function find(pattern : String) {
	glob(pattern, function (err : Error, files : String) {
		if(err) {
			console.log(err);
		}
		console.log(pattern);
		console.log(files);
	});
}

const artifacts = find(globPattern);
console.log(artifacts);

const options = {
  continueOnError: false
}

async function run(): Promise<void> {
  try {
    const uploadResult = await artifactClient.uploadArtifact(artifactName, artifacts, rootDirectory, options)
    if (uploadResult.failedItems.length > 0) {
      console.log("failed to upload artifact");
    }
    else {
      console.log("all files uploaded");
    }
  }
  catch(err) {
    console.log(err.message)
  }
}

run();