# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- API Documentaion at:
- http://127.0.0.1:3000/api-docs/index.html

**Swaggerize**
```
rake rswag:specs:swaggerize
bundle exec rspec
```

**Containerize Ror app**
```
docker-compose up --build
docker-compose run web rake rswag:specs:swaggerize
```

**GraphQL**

Gell all the users
```
query {
  users {
    id
    username
    email
    roles
  }
}

```

Get user by id
```
query {
  user(id: "id") {
    username
    email
    roles
  }
}
```

Create a user
```
mutation {
  createUser(input: {
    email: "spiderman@mail.com"
    password: "abcABC!1"
    username: "spiderman"
  }) {
    user {
      id
      username
      email
      roles
    }
    errors
  }
}
```

**EKS**
```
eksctl create cluster -f hris_cluster.yml --dry-run
eksctl create cluster -f hris_cluster.yml

eksctl utils update-cluster-logging --enable-types=all --region=ap-southeast-1 --cluster=hris-cluster-sg --approve


```

![Alt text](<Screenshot 2023-09-23 at 5.41.20 PM.png>)

```
kubectl create -f db-secret.yaml

kubectl create namespace auth-service

kubectl create -f deployment.yaml

kubectl apply -f deployment.yaml

kubectl get pods

kubectl describe pod authservice-69cc56589c-2dcjt

kubectl delete deployment auth-service-deployment

kubectl exec -it authservice-deployment-6b8f569bf7-97bg8 -- /bin/bash

kubectl exec -it auth-service-58d87b74c8-brkk4 -- /bin/bash
bundle exec rake db:seed

```

https://joachim8675309.medium.com/building-eks-with-eksctl-799eeb3b0efd
https://dev.to/michaellalatkovic/deploying-on-kubernetes-part-1-a-rails-api-backend-2ojl
https://www.stacksimplify.com/aws-eks/kubernetes-storage/aws-eks-storage-with-aws-rds-database/