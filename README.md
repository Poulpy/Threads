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
rspec spec
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

## Run docker container

```
docker compose up --build
```

## Generate the OpenAPI JSON file(s) for Swagger

```
rake rswag:specs:swaggerize
# Docs are at /api-docs
```

## Run Rubocop

```
rubocop

# Autocorrect
rubocop -a

# Stronger speculative autocorrect
rubocop -A
```

## Vérifier GitHub Actions localement avec `act`

[`act`](https://github.com/nektos/act) permet d'exécuter localement les workflows GitHub Actions à l'aide de Docker, sans avoir besoin de pousser un commit sur GitHub.

### Installation

macOS avec Homebrew :

```bash
brew install act
```

### Lister les workflows et jobs

```bash
act -l
```

### Tester un workflow

Simuler un `push` :

```bash
act push
```

Tester uniquement un job :

```bash
act push -j test
```

```bash
act push -j lint
```

### Faire uniquement une vérification à blanc

```bash
act -n
```

