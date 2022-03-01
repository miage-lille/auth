# About the solution 

## Authentication

The product owner gives us some stories:

#### Storie 1:

AS an **anonymous**<br/>
I WANT to **sign up**<br/>
SO THAT i can become a **member**

Business rules:

1. **anonymous** MUST provide email and password to sign up
2. **anonymous** MAY provide username to sign up

#### Storie 2:

AS an **member**<br/>
I WANT to **sign in**<br/>
SO THAT i can get a **valid jwt token**

Business rules:

3. **anonymous** MUST provide valid email and password to sign in. We will use an email/password strategy.

#### Storie 3:

AS an **member**
WHEN I HAVE a **valid jwt token**<br/>
I WANT to **renew my jwt token**<br/>
SO THAT i can get a new **valid jwt token**

#### Storie 4:

AS an **member**<br/>
WHEN I HAVE a **valid jwt token**<br/>
I WANT to **change my password**<br/>
SO THAT i can get a **new password for sign in**

#### Storie 5:

AS an **member**<br/>
WHEN I HAVE a **valid jwt token**<br/>
I WANT to **change my username or email**<br/>
SO THAT i can change my **personal informations**

#### Storie 6:

AS an **member**<br/>
WHEN I HAVE a **valid jwt token**<br/>
I WANT to **delete my profil**<br/>
SO THAT i can remove my **personal informations**

## The domain

From the stories we can extract a common business langage from the domain:

- **Profil**: user informations, composed by personal informations
- **Personal informations**: username, email and password
- **Anonymous**: anybody who use don't have a profil
- **Member**: anybody who have a profil
- **Sign up**: registration to become a member
- **Sign in**: authentication of a member

## An entities overview

We will use SQLlite to store our datas. 

### Task 1:  create a `auth.db` database on local

We need a `Member` table to store our members. Nothing tricky about you should be accurate of this kind of table:

```sql
CREATE TABLE "Member"
(
    id TEXT PRIMARY KEY NOT NULL,
    email TEXT NOT NULL UNIQUE,
    hash TEXT NOT NULL,
    username TEXT
)
```

> 📌 Always use [UUID V4](https://en.wikipedia.org/wiki/Universally_unique_identifier#Version_4_(random)) for primary keys Never use either INT or data that may change like emails.

> 📌 Never store passwords in a database, only hashes of passwords

## A solution overview

The solution will expose services as a REST/JSON API. 

We will use thoose main modules:
- `Auth_lib.Domain` (lib/domain.ml) will contain the modules that modelize the core of our application
- `Auth_lib.Repository` (lib/repository.ml) will contain data repository of our application
- `Auth_lib.Service` (lib/service.ml) will contain the business services of our application
- `Auth_lib.Infra` (lib/infra.ml) will contain the communication with the infrastructure
- `Auth_lib.Api` (lib/api.ml) will contain binding of dependencies and routing description
- `Server` (bin/server.ml) will glue all components together to build miage-auth binary, it's our REST server


## Environment variables

The application will require the following envrionment variables:
- APP_NAME: namespace for the app, must not be an empty string
- PORT: HTTP port for the app
- SEED: seed for password hashes
- JWT_SECRET: secret for JWT signatures
- LEVEL: logging level
- DB_URI: name of the sqlite database

Some have a default value, see [lib/infra.ml](../lib/infra.ml)

Insufficient environment setup will cause the application crash at startup. That's what we want, we don't want release misconfigured app.

## API

At the end of this training you should be able to deploy this API.

### GET /

- summary: Heartbeat route, usefull to check service is running

### POST /echo

- summary: Echo your Autorization as response, usefull for debuging
- header: 
    - Autorization: jwt token

### POST /signup

- summary: Register a new member to the platform
- parameters: body/json
    - email: string
    - password: string


### POST /signin

- summary: Generate a valid JWT against email / password strategy
- parameters: body/json
    - email: string
    - password: string

### POST /verify

- summary: Verify the validity of a JWT
- parameters: body/json
    - jwt: string

### GET /member/:id

- summary: Get email and username
- header: 
    - Autorization: jwt token

### PUT /member/:id

- summary: Update email, username or password
- headers: 
    - Autorization: jwt token
- parameters: body/json
    - email: string
    - username: string
    - password: string

### DELETE /member/:id

- summary: Remove the user
- headers: 
    - Autorization: jwt token

----
Continue to:

3. [Build the API](./exercices.md)