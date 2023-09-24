# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- API Documentaion at:
- http://127.0.0.1:3001/api-docs/index.html

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

kubectl create namespace authservice

kubectl create -f deployment.yaml

kubectl apply -f deployment.yaml

kubectl get pods

kubectl describe pod authservice-69cc56589c-2dcjt

kubectl delete deployment authservice-deployment

kubectl exec -it authservice-69cc56589c-6zqdb -- /bin/bash

```

https://joachim8675309.medium.com/building-eks-with-eksctl-799eeb3b0efd
https://dev.to/michaellalatkovic/deploying-on-kubernetes-part-1-a-rails-api-backend-2ojl
