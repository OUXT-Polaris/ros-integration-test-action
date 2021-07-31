const fs = require('fs');
const artifact = require('@actions/artifact');
const artifactClient = artifact.create()
const artifactName = 'scenario_test_artifacts';
const rootDirectory = '/artifacts'
const files = fs.readdirSync(rootDirectory);
const options = {
    continueOnError: true
}
const uploadResult = await artifactClient.uploadArtifact(artifactName, files, rootDirectory, options)