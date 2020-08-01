def kpsrThirdPartiesECR="337955887028.dkr.ecr.us-east-2.amazonaws.com/kpsr-docker-registry/github/kpsr-thirdparties"

properties([
    parameters([
    booleanParam(
     defaultValue: true,
     description: 'Builds System_Dependencies/Dockerfile_Ubuntu_18_04',
     name: 'build_Dockerfile_Ubuntu_18_04'
    ),
    booleanParam(
     defaultValue: true,
     description: 'Builds System_Dependencies/Dockerfile_ROS_18_04',
     name: 'build_Dockerfile_ROS_18_04'
    ),
    booleanParam(
     defaultValue: true,
     description: 'Builds System_Dependencies/Dockerfile_ROS_16_04',
     name: 'build_Dockerfile_ROS_16_04'
    ),
    booleanParam(
     defaultValue: true,
     description: 'Builds System_Dependencies/Dockerfile_ZMQ',
     name: 'build_Dockerfile_ZMQ'
    ),
    booleanParam(
     defaultValue: true,
     description: 'Builds System_Dependencies/Dockerfile_pistache',
     name: 'build_Dockerfile_pistache'
    )
    ])
])

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

    stage('Build and Publish Ubuntu_18_04') {
      when {
        expression { params.build_Dockerfile_Ubuntu_18_04 }
      }
      steps {
        sh "docker build -f System_Dependencies/Dockerfile_Ubuntu_18_04 . --build-arg=BUILD_ID=${BUILD_ID} -t kpsr-thirdparties:sys_dep_ubuntu_18.04_${BUILD_ID}"
        script {
          docker.withRegistry("https://${kpsrThirdPartiesECR}", "ecr:us-east-2:AWS_ECR_CREDENTIALS") {
            sh "docker tag kpsr-thirdparties:sys_dep_ubuntu_18.04_${BUILD_ID} ${kpsrThirdPartiesECR}:sys_dep_ubuntu_18.04 && docker push ${kpsrThirdPartiesECR}:sys_dep_ubuntu_18.04"
          }
        }
      }
    }


    stage('Build and Publish ROS_18_04') {
      when {
        expression { params.build_Dockerfile_ROS_18_04 }
      }
      steps {
        sh "docker build -f System_Dependencies/Dockerfile_ROS_18_04 . --build-arg=BUILD_ID=${BUILD_ID} -t kpsr-thirdparties:sys_dep_ros_ubuntu_18.04_${BUILD_ID}"
        sh "docker build -f Dockerfile_ROS . --build-arg=BUILD_ID=${BUILD_ID} --build-arg=ros_image=kpsr-thirdparties:sys_dep_ros_ubuntu_18.04_${BUILD_ID} -t kpsr-thirdparties:ROS_${BUILD_ID}"
        script {
          docker.withRegistry("https://${kpsrThirdPartiesECR}", "ecr:us-east-2:AWS_ECR_CREDENTIALS") {
            sh "docker tag kpsr-thirdparties:sys_dep_ros_ubuntu_18.04_${BUILD_ID} ${kpsrThirdPartiesECR}:sys_dep_ros_ubuntu_18.04 && docker push ${kpsrThirdPartiesECR}:sys_dep_ros_ubuntu_18.04"
            sh "docker tag kpsr-thirdparties:ROS_${BUILD_ID} ${kpsrThirdPartiesECR}:ROS && docker push ${kpsrThirdPartiesECR}:ROS"
          }
        }
      }
    }

    stage('Build and Publish ROS_16_04') {
      when {
        expression { params.build_Dockerfile_ROS_16_04 }
      }
      steps {
        sh "docker build -f System_Dependencies/Dockerfile_ROS_16_04 . --build-arg=BUILD_ID=${BUILD_ID} -t kpsr-thirdparties:sys_dep_ros_ubuntu_16.04_${BUILD_ID}"
        script {
          docker.withRegistry("https://${kpsrThirdPartiesECR}", "ecr:us-east-2:AWS_ECR_CREDENTIALS") {
            sh "docker tag kpsr-thirdparties:sys_dep_ros_ubuntu_16.04_${BUILD_ID} ${kpsrThirdPartiesECR}:sys_dep_ros_ubuntu_16.04 && docker push ${kpsrThirdPartiesECR}:sys_dep_ros_ubuntu_16.04"
          }
        }
      }
    }

    stage('Build and Publish ZMQ') {
      when {
        expression { params.build_Dockerfile_ZMQ }
      }
      steps {
        sh "docker build -f Dockerfile_ZMQ . --build-arg=BUILD_ID=${BUILD_ID} --build-arg=system_image=kpsr-thirdparties:sys_dep_ubuntu_18.04_${BUILD_ID} -t kpsr-thirdparties:ZMQ_${BUILD_ID}"
        script {
          docker.withRegistry("https://${kpsrThirdPartiesECR}", "ecr:us-east-2:AWS_ECR_CREDENTIALS") {
            sh "docker tag kpsr-thirdparties:ZMQ_${BUILD_ID} ${kpsrThirdPartiesECR}:ZMQ && docker push ${kpsrThirdPartiesECR}:ZMQ"
            sh "docker tag kpsr-thirdparties:ZMQ_${BUILD_ID} ${kpsrThirdPartiesECR}:OCV && docker push ${kpsrThirdPartiesECR}:OCV"
          }
        }
      }
    }
  }
}
