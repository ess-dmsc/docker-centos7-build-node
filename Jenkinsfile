version = "6.1.0"

node('docker') {
  // Delete workspace when build is done.
  cleanWs()

  stage("Checkout") {
    checkout scm
  }

  def image_name
  stage("Build") {
    if (env.BRANCH_NAME == 'master') {
      image_version = version
    } else if (env.CHANGE_ID) {
      // Pull request.
      image_version = "${version}-pr"
    } else {
      // Development branch.
      image_version = "${version}-dev"
    }

    image_name = "dockerregistry.esss.dk/ecdc_group/centos7-build-node:${image_version}"
    echo "${image_name}"
    sh "docker build -t ${image_name} ."
  }

  stage("Push") {
    if (env.BRANCH_NAME == 'master') {
      // Don't overwrite image if it exists.
      def image_exists
      try {
        // How to check if an image exists?
        sh "docker manifest inspect ${image_name}"
        image_exists = true
      } catch {
        image_exists = false
      }

      echo "image_exists: ${image_exists}"
    } else {
      echo "Not in master, will push image"
    }
  }
}  // node
