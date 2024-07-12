

pipeline {
    agent { label 'master' }
    stages {
        stage ('GIT clone') {
            agent { label 'master' }
            steps {
           // The below will clone your repo and will be checked out to master branch by default.
           git credentialsId: 'jenkins-rsa', url: 'git@github.com:set1991/k8s-cluster.git'
           // Do a ls -lart to view all the files are cloned. It will be clonned. This is just for you to be sure about it.
           sh "ls -lart ./*" 
           // List all branches in your repo. 
           sh "git branch -a"
        
       }
        }        

        //building external LB infrastructure on GCP with terraform
        stage ('build IaC') {
            agent { label 'master' }
            steps {
                echo 'Building infrastructure'
                sh '''
            
                terraform init
                terraform apply -auto-approve
                '''
            }
        }
        stage('Ansible Run') {
            agent { label 'master' }
            steps {
                
                sh '''
                cd ansible_project
                ansible-playbook  playbook.yml
                '''
                
            }
        }

        stage('Test prometheus and grafana') {
            agent {label 'master'}
            steps {
                script {
                    def grafana = sh(script: "gcloud compute instances describe k8s-grafana --zone=europe-west2-a --format='get(networkInterfaces[0].accessConfigs[0].natIP)'", returnStdout: true).trim()
                    echo "ip_grafana: ${grafana}"
                    sh "curl -XGET 'http://${grafana}:3000'"
                    def prometheus = sh(script: "gcloud compute instances describe k8s-prometheus --zone=europe-west2-a --format='get(networkInterfaces[0].accessConfigs[0].natIP)'", returnStdout: true).trim()
                    echo "ip prometheus: ${prometheus}"
                    sh "curl -XGET 'http://${prometheus}:9090'"
                }
            }
        }
        // stage ('destroy IaC') {
        //     agent { label 'master' }
        //     steps {
        //         echo 'Destroying LB on GCP'
        //         sh 'terraform destroy -auto-approve'
        //     }
        // }        
}


post {
    always {
        echo 'Pipeline finished'
    }
    success {
        echo 'I succeeded!'
    }
    failure {
        echo 'I failed :('
    }
    changed {
        echo 'Things were different before...'
    }
    
}      
}