/**
 * This Jenkinsfile defines a pipeline for building and running a Docker container
 * for the Pokedex front-end application.
 */

pipeline {
    agent any

    environment {
        /**
         * The name of the Docker image for the Pokedex front-end.
         * This image is tagged as "dev".
         */
        IMAGE_NAME = 'pokedex-front-0:dev'
        CONTAINER_NAME = 'pokedex-front-dev-0'
        OUT_CONTAINER_PORT = '61000'
        IN_CONTAINER_PORT = '80'
    }

    stages {
        /**
         * Checkout stage: Checks out the source code from the repository.
         */
        stage('Checkout') {
            steps {
                checkout scm 
            }
        }

        /**
         * Clean images not used stage: Removes unused Docker images and the previous
         * version of the Pokedex front-end image.
         */
        stage('Clean images not used') {
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    sh "docker images -a --no-trunc | grep 'none' | awk '{print \$3}' | xargs docker rmi" 
                    sh "docker rmi -f ${IMAGE_NAME}"
                }
            }
        }

        /**
         * Build Image stage: Builds the Docker image for the Pokedex front-end using
         * the Dockerfile in the current directory.
         */
        stage('Build Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME} -f Dockerfile ."
            }
        }

        /**
         * Stop Container stage: Stops and removes the previous container running the
         * Pokedex front-end.
         */
        stage('Stop Container') {
            steps {
                catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
                    sh "docker stop ${CONTAINER_NAME}"
                    sh "docker rm -f ${CONTAINER_NAME}"
                }
            }
        }

        /**
         * Run Container stage: Runs a new container using the built Docker image,
         * mapping the external port 61000 to the internal port 80.
         */
        stage('Run Container') {
            steps {
                sh "docker run -t -d -i -p ${OUT_CONTAINER_PORT}:${IN_CONTAINER_PORT} --name ${CONTAINER_NAME} ${IMAGE_NAME} &"
            }
        }
    }
}
