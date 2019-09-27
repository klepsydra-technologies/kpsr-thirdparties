pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Pull dependencies from repository'
                sh 'rm  ~/.dockercfg || true'
                sh 'rm ~/.docker/config.json || true'

                sh 'docker build -f Dockerfile_ZY . --build-arg="BUILD_ID=${BUILD_ID}" --no-cache'

                // Pruning
                sh 'docker container prune --force --filter label=kpsr-core=builder  --filter  label=BUILD_ID=${BUILD_ID}'
                sh 'docker image prune --force --filter label=kpsr-core=builder  --filter  label=BUILD_ID=${BUILD_ID}'

                echo 'Pull dependencies from repository'
                sh 'rm  ~/.dockercfg || true'
                sh 'rm ~/.docker/config.json || true'

                sh 'docker build -f Dockerfile_ROS . --build-arg="BUILD_ID=${BUILD_ID}" --no-cache'

                // Pruning
                sh 'docker container prune --force --filter label=kpsr-core=builder  --filter  label=BUILD_ID=${BUILD_ID}'
                sh 'docker image prune --force --filter label=kpsr-core=builder  --filter  label=BUILD_ID=${BUILD_ID}'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
    }
}



