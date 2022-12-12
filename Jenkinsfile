@Library('ecdc-pipeline')
import ecdcpipeline.ImageBuilder

// Disable concurrent builds to avoid overwritting images in the registry.
properties([
  [$class: 'JiraProjectProperty'],
  disableConcurrentBuilds(abortPrevious: true)
])

imageVersion = '10.0.3'

imageName = "dockerregistry.esss.dk/ecdc_group/build-node-images/centos7-build-node:${imageVersion}"

imageBuilder = new ImageBuilder(this, imageName)
imageBuilder.buildAndPush()
