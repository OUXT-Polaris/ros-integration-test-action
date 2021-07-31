const fs = require('fs');
const artifact = require('@actions/artifact');
const artifactClient = artifact.create()
const artifactName = 'scenario_test_artifacts';
const rootDirectory = '/artifacts'

import { dir } from "console";
import {readdirSync} from "fs"
    
export function getFileList(dirPath:string):string[] {
  let dirList: string[] = new Array();
  dirList = readdirSync(dirPath, {
      withFileTypes: true, 
  }).filter(dirent => dirent.isFile())
  .map(dirent => dirent.name);
  return dirList;
}

export function getDirectoryList(dirPath:string):string[] {
  let dirList: string[] = new Array();
  dirList = readdirSync(dirPath, {
      withFileTypes: true, 
  }).filter(dirent => dirent.isDirectory())
  .map(dirent => dirent.name);
  return dirList;
}

console.log("Searching Artifacts")

const dirs = getDirectoryList(rootDirectory);
const artifacts = getFileList(rootDirectory);
dirs.forEach(directory => {
  console.log(directory)
  const files = getFileList(directory);
  files.forEach(file => {
    artifacts.push(file);
  });
});

artifacts.filter(artifact => console.log(artifact));

const options = {
  continueOnError: false
}

async function run(): Promise<void> {
  const uploadResult = await artifactClient.uploadArtifact(artifactName, artifacts, rootDirectory, options)
}

run();