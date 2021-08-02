function download_artifact()
{  
  const yargs = require('yargs');
  const argv = yargs
    .option('artifact_name', {
    description: 'Name of artifact',
    type: 'string',
    })
    .help()
    .alias('help', 'h')
    .argv;

  console.log(argv._[0])
  const artifact = require('@actions/artifact');
  const artifactClient = artifact.create();
  const artifactName = argv._[0];
  const path = "/";
  const options = {
    createArtifactFolder: false
  }
  async function run(): Promise<void> {
    try {
      const downloadResponse = await artifactClient.downloadArtifact(artifactName, path, options);
      console.log("Downloaded Artifacts!")
      for (const response in downloadResponse) {
        console.log(response);
      }
    }
    catch(err) {
      console.log(err.message)
    }
  }
  
  run();
}

download_artifact()