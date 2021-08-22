function upload_artifact()
{
  const yargs = require('yargs');
  const argv = yargs
    .option('artifact_name', {
      description: 'Name of artifact',
      type: 'string',
    })
    .option('root_directory', {
      description: 'Name of root directory',
      type: 'string',
    })
    .help()
    .alias('help', 'h')
    .argv;
  
  console.log(argv._[0])
  
  const artifact = require('@actions/artifact');
  const artifactClient = artifact.create()
  const artifactName = argv._[0];
  const rootDirectory = argv._[1];
  const globPattern = rootDirectory + '/**';
  
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
}

upload_artifact();