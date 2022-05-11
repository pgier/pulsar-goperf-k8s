#

# deployment

Create a partitioned topic first manually.

```
$ kubectl apply -f ./kubernetes/consumer-deploy.yaml 
$ kubectl apply -f ./kubernetes/producer-deploy.yaml 
```