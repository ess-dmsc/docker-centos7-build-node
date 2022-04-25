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

    image_name = "dockerregistry.esss.dk/ecdc_group/build-node-images/centos7-build-node:${image_version}"
    echo "${image_name}"
    sh "docker build --build-arg httpProxy=$http_proxy,httpsProxy=$https_proxy -t ${image_name} ."
  }

  stage("Push") {
    if (env.BRANCH_NAME == 'master') {
      // Don't overwrite image if it exists.
      try {
        // How to check if an image exists?
        sh "docker manifest inspect ${image_name}"
        error "Image ${image_name} already exists in registry, cannot push from master."
      } catch (e) {
        echo "Image ${image_name} not found in registry and will be pushed."
      }
    } else {
      echo "Not in master, image will be pushed."
    }

    sh "docker push ${image_name}"
  }
}  // node