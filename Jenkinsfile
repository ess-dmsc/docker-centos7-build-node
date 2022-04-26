@Library('ecdc-pipeline-test')
import ecdcpipeline.ImageBuilder

// Disable concurrent builds to avoid overwritting images in the registry.
properties([
  [$class: 'JiraProjectProperty'],
  disableConcurrentBuilds(abortPrevious: true)
])

imageVersion = '6.1.0'

imageName = "dockerregistry.esss.dk/ecdc_group/build-node-images/centos7-build-node:${imageVersion}"

imageBuilder = new ImageBuilder(this, imageName)
imageBuilder.buildAndPush()
