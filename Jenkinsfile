pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                // Build ZMQ and ROS
                sh 'docker build -f Dockerfile . --build-arg=BUILD_ID=${BUILD_ID} --build-arg=third_party_flags=\'-y -z\' -t kpsr-thirdparties:ZMQ'
                sh 'docker build -f Dockerfile . --build-arg=BUILD_ID=${BUILD_ID} --build-arg=third_party_flags=\'-r\' -t kpsr-thirdparties:ROS'
            }
        }
        stage('Publish') {
            steps {
                echo 'Publish.'
            }
        }
    }
    post { 
        always { 
		// Pruning
		sh 'docker container prune --force --filter label=kpsr-thirdparties=builder  --filter  label=BUILD_ID=${BUILD_ID}'
		sh 'docker image prune --force --filter label=kpsr-thirdparties=builder  --filter  label=BUILD_ID=${BUILD_ID}'
        }
    }
}




