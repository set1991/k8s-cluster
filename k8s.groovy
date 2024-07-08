

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
                sh "terraform init " 
                sh "terraform plan"
                sh "terraform apply -auto-approve"
            }
        }
        stage('Ansible Run') {
            agent { label 'master' }
            steps {
                //script {
                    // get EC2 IPs
                    //def ips = sh(script: "aws ec2 describe-instances --filters 'Name=instance.group-name,Values=es_sg' --query 'Reservations[*].Instances[*].PublicIpAddress' --output text", returnStdout: true).trim().split()
                    
                    // create Ansible inventory file
                    //writeFile file: 'hosts', text: "[elasticsearch]\n" + ips.join("\n")

                    // start Ansible playbook
                   
                    //sh 'cd ansible_project'
                    sh 'pwd'
                    sh 'ls -la '
                    
                    sh 'ansible-playbook ./ansible_project/playbook.yml'
                //}
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
        echo 'One way or another, I have finished'
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