# Auth service

## Goals of this training

We will create an authentification service that may serve as an authorization provider for a micro service based system.
We'll work with stateless applications and authentication / authorization will be based on Json Web Tokens.

## Technical stack

We will build our first service in OCaml. Our stack will rely on:
- [Yojson](https://ocaml-community.github.io/yojson/yojson/Yojson/index.html): functions for reading and writing JSON data
- [Lwt](https://ocsigen.org/lwt/5.5.0/manual/manual): promises library
- [Dream](https://aantron.github.io/dream/): middleware based web framework - _Sinatra/Expressjs like_
- [Catqi](https://paurkedal.github.io/ocaml-caqti/index.html): OCaml connector API for relational databases
- PostgreSQL: realtional database

You will also need [Postman](https://www.postman.com/downloads/) (or similar tool) to test the API

## Development

- install: `esy install`
- build: `esy build`
- start: `esy start`

### Exercice 0: 

- Build and start the API
- Test a `GET` request on `http://localhost:3000/` endpoint
    - You should have a response `Welcome to auth server`
- Test a `POST` request on `http://localhost:3000/echo` endpoint with a `raw/json` body
    - You should have the body of your request as response


## Next steps

1. [Learn about JWT](./doc/jwt.md)
2. [Domain of the project](./doc/architecture.md)
3. [Build the API](./doc/exercices.md)
