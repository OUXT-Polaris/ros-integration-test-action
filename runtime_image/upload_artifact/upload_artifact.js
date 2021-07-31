const fs = require('fs');
const artifact = require('@actions/artifact');
const artifactClient = artifact.create()
const artifactName = 'scenario_test_artifacts';
const rootDirectory = '/artifacts'
const files = fs.readdirSync(rootDirectory);
const artifacts = [];

files.forEach(file => {
  artifacts.push(rootDirectory + '/' + file);
  console.log(rootDirectory + '/' + file);
});

const options = {
  continueOnError: true
}
artifactClient.uploadArtifact(artifactName, artifacts, rootDirectory, options)