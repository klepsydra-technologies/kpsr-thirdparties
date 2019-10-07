def kpsrThirdPartiesECR="337955887028.dkr.ecr.us-east-2.amazonaws.com/kpsr-docker-registry/github/kpsr-thirdparties"


pipeline {
    agent any

    stages {
        stage('Dependencies') {
            steps {
                echo 'Pull dependencies from repository'
                sh 'rm  ~/.dockercfg || true'
                sh 'rm ~/.docker/config.json || true'

            }
        }
        stage('Build') {
            steps {
                // Build ZMQ and ROS
                sh "docker build -f Dockerfile_ZMQ . --rm --build-arg=BUILD_ID=${BUILD_ID} -t kpsr-thirdparties:ZMQ_${BUILD_ID}"
                sh "docker build -f Dockerfile_ROS . --rm --build-arg=BUILD_ID=${BUILD_ID} -t kpsr-thirdparties:ROS_${BUILD_ID}"
                sh "docker build -f Dockerfile_OCV . --rm --build-arg=BUILD_ID=${BUILD_ID} -t kpsr-thirdparties:OCV_${BUILD_ID}"
            }
        }
        stage('Publish') {
            steps {
                echo 'Publish to ECR.'
                script {
                    docker.withRegistry("https://${kpsrThirdPartiesECR}", "ecr:us-east-2:AWS_ECR_CREDENTIALS") {
                        sh "docker tag kpsr-thirdparties:ZMQ_${BUILD_ID} ${kpsrThirdPartiesECR}:ZMQ && docker push ${kpsrThirdPartiesECR}:ZMQ"
                        sh "docker tag kpsr-thirdparties:ROS_${BUILD_ID} ${kpsrThirdPartiesECR}:ROS && docker push ${kpsrThirdPartiesECR}:ROS"
                        sh "docker tag kpsr-thirdparties:OCV_${BUILD_ID} ${kpsrThirdPartiesECR}:OCV && docker push ${kpsrThirdPartiesECR}:OCV"
                    }
                }
            }
        }
    }
    post {
        always {
          // Pruning
          sh 'docker container prune --force --filter label=kpsr-thirdparties=builder --filter  label=BUILD_ID=${BUILD_ID}'
          sh 'docker image prune --force --filter label=kpsr-thirdparties=builder --filter label=BUILD_ID=${BUILD_ID}'
          sh 'docker rmi --force $(docker images --filter "reference=kpsr-thirdparties:*_${BUILD_ID}" -q)'
        }
    }
}

