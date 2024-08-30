pipeline {
    agent any

    environment {
        FLOATING_IP = '192.168.16.100'
        PORT = '80'
        LOG_FILE = '/logs/floating_ip_check.log'
    }

    stages {
        stage('Get Timestamp') {
            steps {
                script {
                    env.TIMESTAMP = sh(script: "date '+%Y-%m-%d %H:%M:%S'", returnStdout: true).trim()
                }
            }
        }

        stage('Send cURL Request') {
            steps {
                script {
                    env.RESPONSE = sh(script: "curl -s http://${env.FLOATING_IP}:${env.PORT}", returnStdout: true).trim()
                }
            }
        }

        stage('Find Container') {
            steps {
                script {
                    def containerName = sh(script: '''
                        docker ps --format "{{.Names}}" | while read container; do
                            if docker exec $container ip addr show | grep -q ${FLOATING_IP}; then
                                echo $container
                                break
                            fi
                        done
                    ''', returnStdout: true).trim()
                    env.CONTAINER_NAME = containerName
                }
            }
        }

        stage('Log Information') {
            steps {
                script {
                    sh """
                    echo "${env.TIMESTAMP} - Container: ${env.CONTAINER_NAME} - Response: ${env.RESPONSE}" >> ${env.LOG_FILE}
                    """
                }
            }
        }
    }
}
