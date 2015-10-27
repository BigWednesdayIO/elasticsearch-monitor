Container with google cloud monitoring agent for Elasticsearch

# Deployment

 ``` shell
 # Set required variables
 export PROJECT_ID=first-footing-108508
 export NAMESPACE=production
 export TAG=v1
 export QUALIFIED_IMAGE_NAME=eu.gcr.io/${PROJECT_ID}/elasticsearch-monitor:${TAG}
 export DEPLOYMENT_ID=1
 export GCLOUD_MONITORING_API_KEY=APIKEY
 export ELASTICSEARCH_STATS_URL=https://user:pwd@elastichost:port/_nodes/_local/stats/

 # Build the image and push to the container engine
 docker build -t ${QUALIFIED_IMAGE_NAME} .
 gcloud docker push ${QUALIFIED_IMAGE_NAME}

 # Create the service:
 cat ./kubernetes/service.json | \
    perl -pe 's/\{\{(\w+)\}\}/$ENV{$1}/eg' | \
    kubectl create --namespace=${NAMESPACE} -f -

 # Create the replication controller:
 cat ./kubernetes/rc.json | \
    perl -pe 's/\{\{(\w+)\}\}/$ENV{$1}/eg' | \
    kubectl create --namespace=${NAMESPACE} -f -
 ```

## Update steps

 ``` shell
 # Set required variables
 export PROJECT_ID=first-footing-108508
 export NAMESPACE=production
 export TAG=v2
 export DEPLOYMENT_ID=2
 export QUALIFIED_IMAGE_NAME=eu.gcr.io/${PROJECT_ID}/elasticsearch-monitor:${TAG}
 export GCLOUD_MONITORING_API_KEY=APIKEY
 export ELASTICSEARCH_STATS_URL=https://user:pwd@elastichost:port/_nodes/_local/stats/

 # Build the new image and push to container engine
 docker build -t ${QUALIFIED_IMAGE_NAME} .
 gcloud docker push ${QUALIFIED_IMAGE_NAME}

 # Peform a rolling update on the replication controller
 OLD_RC=$(~/google-cloud-sdk/bin/kubectl get rc -l "app=elasticsearch-monitor" --namespace=${NAMESPACE} -o template --template="{{(index .items 0).metadata.name}}")

 export REPLICAS=$(~/google-cloud-sdk/bin/kubectl get rc ${OLD_RC} --namespace=${NAMESPACE} -o template --template="{{.spec.replicas}}")

 cat ./kubernetes/rc.json | \
    perl -pe 's/\{\{(\w+)\}\}/$ENV{$1}/eg' | \
    kubectl rolling-update ${OLD_RC} --namespace=${NAMESPACE} -f -
 ```

