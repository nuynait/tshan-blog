---
title: How to Write Blog With Pure Plain Text MarkDown
date: 2018-01-26 20:34:04
tags:
---

Last year, I wrote a blog about hosting blog using Hexo and org documents. Now I have not using Emacs for my notes anymore. The main reason is that I could not visit my notes on my Phone or Tablet which I feel really inconvenient. Now I want to use convert all my .org notes into markdown format and host my markdown notes directly into my blog for convenience.

<!--more-->

## Install Hexo
Using following command to install hexo first if not installed before.
``` bash
npm install -g hexo-cli
```

## Create Blog Repository
Find a folder to host blog `.md` files. I choose to use a git repository and upload it to a git server. Create the folder. Run `hexo init` inside folder to init hexo structures. Also run `git init` to init the git folder and link with a git remote.

``` bash
mkdir ~/repo/blog
cd ~/repo/blog
hexo init
git init
git add .
git commit -m "init hexo"
git remote add <remote address>
git push -u origin master

hexo generate --watch
```

Then generate all files and file structures.

## Config Your New Blog
[Configuration | Hexo](https://hexo.io/docs/configuration.html)

Config your new blog. The config file locates under `./_config.yml`. Focus on `# Site`, `# URL` section. Finish these areas first. For language, use `en`. For timezone, [here is the list.](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones).

Here is what I used in my blog.

```
# Site
title: Tianyun Shan's Blog
subtitle: Tianyun Shan's Personal Blog
description: The technical blog written by Tianyun Shan. Will post some of my notes here.
keywords: Tianyun Shan, Jerry, CS, Technical, Blog
author: Tianyun Shan
language: en
timezone: America/Toronto

# URL
## If your site is put in a subdirectory, set url as 'http://yoursite.com/child' and root as '/child/'
url: http://blog.houglasslab.com
root: /
permalink: :year/:month/:day/:title/
permalink_defaults:
```

## Deploy Using Github Pages
In order to host on GitHub pages, we need [GitHub - hexojs/hexo-deployer-git: Git deployer plugin for Hexo.](https://github.com/hexojs/hexo-deployer-git) first.

``` bash
npm install hexo-deployer-git --save
```

If you want custom domain support, you need to go to `./source` folder and `vim CNAME`, it will create a new file. Within that file, enter your domain name. For example, my CNAME file is:
```
blog.hourglasslab.com
```

## Create New Post
Run following command to create a new post.

```
hexo new <post-title>
```

Because I made my notes in my specific notebook app, I can export the markdown. And pastes them directly into `source/_posts/xx.md`. Then I will need to manually copy the header and write the following meta data.

## Assets Image
First we need to enable the assets folder.  Edit  `./_config.yml` file and find the following line and change to true.

```
# Writing
...
post_asset_folder: true
...
```

In order to insert image using markdown syntax directly is not supported by native hexo. [hexo-asset-image](https://github.com/CodeFalling/hexo-asset-image) This is the plugin I found that support inserting image using markdown syntax.

```
npm install hexo-asset-image --save
```

Notes (v0.0.3): When install on date: 2018-07-02, the latest version is v0.0.3. It does not work. For detail, please refer to [Issue #32](https://github.com/CodeFalling/hexo-asset-image/issues/32).  To solve this issue before developer released new version, we can rollback to `v0.0.2`.

```
npm install hexo-asset-image@0.0.2 --save
```

## Deploy
Now after you have changed the posts, you can deploy directly to Github pages using following commands.

```
hexo clean
hexo deploy
```

## About Theme
To install custom theme, first find corresponding git repository, clone it into `./themes` folder. After that, edit `_config.yml` file, find `# Extensions`, within there is a `theme:`, fill in the theme you cloned. For my blog, this is what I use.

```
# Extensions
## Plugins: https://hexo.io/plugins/
## Themes: https://hexo.io/themes/
theme: apollo
```

Notes: depending on different theme installed, to achieve different functionality, you might need to install additional plugins. For example, for theme: [GitHub - pinggod/hexo-theme-apollo: a clean and delicate hexo theme](https://github.com/pinggod/hexo-theme-apollo) which is the one I used, here is the plugins required:

```
npm install --save hexo-renderer-jade hexo-generator-feed hexo-generator-sitemap hexo-browsersync hexo-generator-archive
```

## Workflow
Here is my current workflow. Now I use a third party note app and write notes in pure markdown format, I manage all my notes using tags within that note app.

1. Export notes.
When export notes, choose markdown and include attachments. It will generate 2 parts, `.md` file and a folder contains all the assets if the note inserts any images.

2. Copy all exported parts into `_posts` folder.
First copy `.md` file. If there are image, copy the generated folder into the same directory where `.md` locates.

3. Add header meta data.
Now open `.md` file, add following header information.
```
---
title: post-title
date: 2018-06-30 13:02:31
tags:
desc:
---

<Brief Description>

<!--more-->
```

4. Run deploy command
Now we have prepared post and ready to deploy. Run following command. It will push to my github.io project repository which will update the website with the newly added posts.
