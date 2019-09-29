def kpsrThirdPartiesECR="337955887028.dkr.ecr.us-east-2.amazonaws.com/kpsr-docker-registry/github/kpsr-thirdparties"

pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                // Build ZMQ and ROS
                sh "docker build -f Dockerfile . --rm --build-arg=BUILD_ID=${BUILD_ID} --build-arg=third_party_flags=\'-y -z\' -t kpsr-thirdparties:ZMQ_${BUILD_ID}"
                sh "docker build -f Dockerfile . --rm --build-arg=BUILD_ID=${BUILD_ID} --build-arg=third_party_flags=\'-r\' -t kpsr-thirdparties:ROS_${BUILD_ID}"
            }
        }
        stage('Publish') {
            when {
                branch 'master' 
            }
            steps {
                echo 'Publish to ECR.'
                script {
                    docker.withRegistry("https://${kpsrThirdPartiesECR}", "ecr:us-east-2:AWS_ECR_CREDENTIALS") {
                        sh "docker tag kpsr-thirdparties:ZMQ_${BUILD_ID} ${kpsrThirdPartiesECR}:ZMQ && docker push ${kpsrThirdPartiesECR}:ZMQ"
                        sh "docker tag kpsr-thirdparties:ROS_${BUILD_ID} ${kpsrThirdPartiesECR}:ZMQ && docker push ${kpsrThirdPartiesECR}:ROS"
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
