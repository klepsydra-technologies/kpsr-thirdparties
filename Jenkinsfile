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
                sh "docker build -f System_Dependencies/Dockerfile_Ubuntu_18_04 . --rm --build-arg=BUILD_ID=${BUILD_ID} -t kpsr-thirdparties:sys_dep_ubuntu_18.04_${BUILD_ID}"
		sh "docker build -f System_Dependencies/Dockerfile_ROS_18_04 . --rm --build-arg=BUILD_ID=${BUILD_ID} -t kpsr-thirdparties:sys_dep_ros_ubuntu_18.04_${BUILD_ID}"
                sh "docker build -f System_Dependencies/Dockerfile_ROS_16_04 . --rm --build-arg=BUILD_ID=${BUILD_ID} -t kpsr-thirdparties:sys_dep_ros_ubuntu_16.04_${BUILD_ID}"
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
                        sh "docker tag kpsr-thirdparties:sys_dep_ubuntu_18.04_${BUILD_ID} ${kpsrThirdPartiesECR}:sys_dep_ubuntu_18.04 && docker push ${kpsrThirdPartiesECR}:sys_dep_ubuntu_18.04"
                        sh "docker tag kpsr-thirdparties:sys_dep_ros_ubuntu_18.04_${BUILD_ID} ${kpsrThirdPartiesECR}:sys_dep_ros_ubuntu_18.04 && docker push ${kpsrThirdPartiesECR}:sys_dep_ros_ubuntu_18.04"
                        sh "docker tag kpsr-thirdparties:sys_dep_ros_ubuntu_16.04_${BUILD_ID} ${kpsrThirdPartiesECR}:sys_dep_ros_ubuntu_16.04 && docker push ${kpsrThirdPartiesECR}:sys_dep_ros_ubuntu_16.04"
                        sh "docker tag kpsr-thirdparties:ZMQ_${BUILD_ID} ${kpsrThirdPartiesECR}:ZMQ && docker push ${kpsrThirdPartiesECR}:ZMQ"
                        sh "docker tag kpsr-thirdparties:ROS_${BUILD_ID} ${kpsrThirdPartiesECR}:ROS && docker push ${kpsrThirdPartiesECR}:ROS"
                        sh "docker tag kpsr-thirdparties:OCV_${BUILD_ID} ${kpsrThirdPartiesECR}:OCV && docker push ${kpsrThirdPartiesECR}:OCV"
                    }
                }
            }
        }
    }
}
