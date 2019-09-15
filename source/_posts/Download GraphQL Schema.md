---
title: Download GraphQL Schema
date: 2019-07-17
tags:
desc:
---
You can manually download the schema *JSON* file by sending an introspection query to the server. It uses the *apollo-cli* package.  [Offical Repository](https://github.com/apollographql/apollo-tooling) .  If you don’t have that, install using the command below.
<!--more-->

```bash
npm install -g apollo
```

Use the following command to download the schema *JSON* file .
```bash
apollo schema:download --endpoint=http://localhost:8080/graphql schema.json
```
