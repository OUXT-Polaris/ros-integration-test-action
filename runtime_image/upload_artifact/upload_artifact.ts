import { file } from "tmp";

const artifact = require('@actions/artifact');
const artifactClient = artifact.create()
const artifactName = 'integration_test_artifacts';
const globPattern = '/artifacts/*'
const rootDirectory = '/artifacts';

const path = require('path');
const glob = require('glob');

function find(pattern : String) {
  return glob.sync(pattern);
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