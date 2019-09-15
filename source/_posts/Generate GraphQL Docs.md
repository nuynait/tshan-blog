---
title: Generate GraphQL Docs
date: 2019-07-17
tags:
desc:
---

If you want to work with the graphQL, it is much easier if you can get the schema and documentation for graphQL. I test graphQL query using **insomnia**. However the *DOC* section in **insomnia** doesn’t show the graphQL doc.
<!--more-->

There are several ways to fetch the graphQL doc.

# App
If you want to use an App to easily view the graphQL doc, try Altair. [Altair GraphQL Client](https://altair.sirmuel.design/)

Write the URL in the middle and press the *Docs* button on the right side.

# Generate Site
If you don’t want to use Altair like me, you can try the following way to generate the HTML doc instead.

First install the *graphdoc* tool if you have not. [Official Repository](https://github.com/2fd/graphdoc)
```
npm install -g @2fd/graphdoc
```

After install you will be able to generate the documentation from a live endpoint:
```
graphdoc -e http://localhost:8080/graphql -o ./doc/schema
```
