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