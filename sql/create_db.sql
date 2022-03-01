CREATE TABLE "Member"
(
    id UUID PRIMARY KEY NOT NULL,
    email TEXT NOT NULL UNIQUE,
    hash TEXT NOT NULL,
    username TEXT
)