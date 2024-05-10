#!/bin/sh

set -e


echo "export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}"  >> $GITHUB_ENV
echo "export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" >> $GITHUB_ENV

echo "/usr/local/bin/kubectl" >> $GITHUB_PATH
  
echo "aws version"

aws --version

echo "kubectl version"
kubectl version

echo $AWS_REGION, $CLUSTER_NAME
env 
echo "GITHUB ENV"
echo $GITHUB_ENV

echo "Attempting to update kubeconfig for aws"


aws eks --region "$AWS_REGION" update-kubeconfig --name "$CLUSTER_NAME"

if [ ! -d "$HOME/.kube" ]; then
    mkdir -p $HOME/.kube
fi

if [ ! -z "${KUBE_CONFIG}" ]; then
        echo "$KUBE_CONFIG" | base64 -d > $HOME/.kube/config
        kubectl get pods
elif [ ! -z "${KUBE_TOKEN}" ]; then
    kubectl config set-credentials cluster-admin --token="${KUBE_TOKEN}" > /dev/null
else    
    echo "No credentials found. Please provide KUBE_CONFIG or KUBE_TOKEN. Exiting..."
    exit 1    
fi    

echo "kubectl version"


kubectl "$@"