---
title: Use Svn - Quick Svn Tutorial
date: 2017-03-29
tags:
desc:
---

# Transfer from git
I am a `git` user in the past. However in [Mapsted](https://mapsted.com/), it uses `svn` for version control. Although pm said that we are transfer to git, it is a low priority tasks right now and we still need to use `svn` at main time.

So transferring from git, what should I know?

It seems that some definitions is different between `git` and `svn`.

## Definition
- work copy: local repository
- checkout: clone

# Git-Svn
So I use svn for my main workflow. Here is how.

## Clone a repository
Clone `svn` repository using `git`. When using this command, it will clone the `svn` repository into local as a `git` repository. I can use all git command with in that local repository including: `git status`, `git add`, `git commit`, `git branch`, `git checkout` etc. There is no difference between that local repository to any other git repositories.

``` sh
git svn clone https://example.svn/xx
```

Note that the difference between git and svn is I can use sub-directory and clone it as a repository itself. For example, I have <https://example.svn/svnMain>, say that it is the repository address. Within that I have several folders for `iOS`, `android`, `web`. I can use `git` svn clone <https://example.svn/svnMain/iOS> to clone the whole `iOS` folders as a repository.

About empty folders: `Git` do not track empty folders, so any empty folders in `svn` remote repository will be omitted when clone the `git` local repository.

## Commit Changes
Well as stated above, when use `git svn clone` to clone from the svn server, Now I have a local `git` repository to work with. So commit changes are the same as any other `git` repositories. Just do:

```sh
git svn add .
git svn commit -m "xx"
```

(Here is just an example, any git command works)

## Push/Fetch with Remote
Everything I committed using `git commit` is on my local `git` repository. I eventually will need to push the changes to the `svn` server. How am I going to do that? Below are the commands that I am going to need for push and fetch changes.

```sh
git svn dcommit #similar to push
git svn rebase  #similar to pull
```

First, use `git svn rebase` to fetch/pull changes from the server. It will do a `rebase` between the server commits and the local branch. It is similar to a `rebase` on branch. So you can go and solve any conflicts at this stage.

Now after the `rebase` we have merge the conflicts, We can use `git svn dcommit` to push our local changes to the server.

# Other SVN Commands
Here are the other operations that I need to do. I am not using these all the time, but it is good to know how and write it down as my own reference in case I need it.

## Create SVN Tag
Create an `svn` tag. I get this solution from [this Stack-Overflow answer](http://stackoverflow.com/a/851401). It is very useful since I am using `git-svn` and only want to create the `svn
   tag` on the server.

```sh
svn copy https//examples.svn/proj/trunk https://examples.svn/proj/tags/1.0 -m "Release 1.0"
```
