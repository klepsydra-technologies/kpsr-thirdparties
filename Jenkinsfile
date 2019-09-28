pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Pull dependencies from repository'
                sh 'rm  ~/.dockercfg || true'
                sh 'rm ~/.docker/config.json || true'
                
                // Build ZMQ and ROS
                sh 'docker build -f Dockerfile . --build-arg="BUILD_ID=${BUILD_ID}" --build-arg="third_party_flags='-y -z'" -t kpsr-thirdparties:ZMQ'
                sh 'docker build -f Dockerfile . --build-arg="BUILD_ID=${BUILD_ID}" --build-arg="third_party_flags='-r'" -t kpsr-thirdparties:ROS'

                // Pruning
                sh 'docker image prune --force --filter label=kpsr-thirdparties=builder  --filter  label=BUILD_ID=${BUILD_ID}'
            }
        }
        stage('Publish') {
            steps {
                echo 'Publish.'
            }
        }
    }
}



