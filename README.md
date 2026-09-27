# README

API around thread-related activities.

## Install

```
bundle
rails db:create
rails db:migrate
rails db:seed
```

## Run tests

```
rails test
```

## Usage

Authentification is by bearer token.

```
rails s
curl -X POST http://localhost:3000/v1/auth \
  -H "Content-Type: application/json" \
  -d '{"name": "Paul", "email": "pr@example.com"}'
```

```
curl -X GET http://localhost:3000/v1/equipments \
  -H "Content-Type: application/json" \
  -H 'Authorization: Bearer <YOUR_TOKEN>'
```

## Generate the OpenAPI JSON file(s) for Swagger

```
rake rswag:specs:swaggerize
# Docs are at /api-docs
```