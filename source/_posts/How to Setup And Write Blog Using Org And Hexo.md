---
title: How to Setup and Write Blog Using Org and Hexo
date: 2016-11-04
tags:
desc:
---

Hexo is a simple and powerful blog framework. Here, we want to connect Hexo with emacs org mode. The result is you can create a new post in emacs, write in org, insert images like normal and deploy it to github pages.

<!--more-->

# Hexo
What is hexo? Hexo is a simple and powerful blog framework. Take a look at [here](https://hexo.io/).

## Install
Install `git` and `nodejs` first and then using the following commnd to install hexo

```sh
npm install -g hexo-cli
```

## Setup
After `hexo` is installed, use `hexo init <folder>` to create a blog folder. That is a folder contains all the source codes for you blog (site)

```sh
hexo init ~/repo/blog/
cd ~/repo/blog/
npm install
```

## Minor Change in Config
Change the title and author name inside the config.

## Host on Github Pages
[Here](https://malekbenz.com/blog/2016/09/10/Create-Host-Blog-for-free-with-Hexo-Github) is a blog that teaches you how to host blog in your github repository.

[Here](https://hexo.io/docs/deployment.html) is the official documentation about git deployment.

Please create the repository for github pages. The repository name formate is username.github.io. After you finished create the repository, go to the setting and you can see it says **your site is published at xxx**.

Now install `hexo-deploy-git` to deploy your blog onto github pages.

```sh
npm install hexo-deployer-git --save
```

```sh
# Deployment
## Docs: https://hexo.io/docs/deployment.html
deploy:
type: git
repo: https://github.com/nuynait/nuynait.github.io.git
branch: master
message:
```

Now run `hexo deploy` to publish it on github.

## Custom Domain - Github Pages
In order to have github page custom domain, you have to set the zone file with your domain provider. See [here](https://help.github.com/articles/using-a-custom-domain-with-github-pages/) for help to setup the zone file.

After setting up the zone file, go to `{your_hexo_folder}/source/` folder, create a new file called `CNAME`. In that `CNAME` file, enter your domain. For example the following the what I have in my `CNAME` file.

```sh
blog.hourglasslab.com
```

# ORG Mode Plugin
[This](https://github.com/CodeFalling/hexo-renderer-org) is the plugin I use for combine org-mode and hexo.

## Install
`cd <blog-folder>` Get into your blog folder and install the plugin using the command listed below.

    npm install https://github.com/CodeFalling/hexo-renderer-org#emacs --save

# Theme
For theme, I saw a theme called [apollo](https://github.com/pinggod/hexo-theme-apollo). I like that style of feeling. So I am using this as a base, on top, I am going to make some modification to reveal my own personality. Thanks a lot to [@pinggod](https://github.com/pinggod) for making the theme.

``` sh
npm install --save hexo-renderer-jade hexo-generator-feed hexo-generator-sitemap hexo-browsersync hexo-generator-archive
```

## Creating a Theme
If you want to know how to modify a theme, the best way is to learn how to create a theme at first place. Here is some good source learning how to creating the theme.

[Create an Hexo Theme Part 1 Index](http://www.codeblocq.com/2016/03/Create-an-Hexo-Theme-Part-1-Index/)

## Customization
I changed css to make it look different on different level of headings. The author of `apollo` think that there is no good way to separate different headers for more than 2 levels. However, I am using the org-mode to create blogs. The title itself will be `h1`, and I do want to make difference to headings up to level 3 so I modify the css files directly. I don't know if modify the css directly is a good practise, but I am doing it anyway because I don't want to look inside to much just for now.

Then I changed some color pattern in css and config the comment service using [Disqus](https://disqus.com/).

# Blog-Admin
Last but not least, for easier deploy and blog management, I am going to use [blog-admin](https://github.com/CodeFalling/blog-admin) for easier access and deploy my blogs in Emacs.

## Install in Spacemacs
Thanks to [CodeFalling](https://github.com/CodeFalling/blog-admin/issues/13). Follow the guild [here](https://github.com/CodeFalling/blog-admin/issues/13) to install in spacemacs.

## Config
```emacs-lisp
(setq blog-admin-backend-path "~/blog")
(setq blog-admin-backend-type 'hexo)
(setq blog-admin-backend-new-post-in-drafts t) ;; create new post in drafts by default
(setq blog-admin-backend-new-post-with-same-name-dir t) ;; create same-name directory with new post
(setq blog-admin-backend-hexo-config-file "my_config.yml") ;; default assumes _config.yml
```

Added a keybinding to access `blog-admin-start`.

```emacs-lisp
(spacemacs/set-leader-keys "ob" 'blog-admin-start)
```

# Insert Image Assets
Again thanks to [CodeFalling](https://github.com/CodeFalling), we have a plugin to include absolute image path inside org raw files. Take a look at [hexo-asset-image](https://github.com/CodeFalling/hexo-asset-image).

Install it: `npm install hexo-asset-image --save`

## Config and Try
After installing the `hexo-asset-image`, Make sure `post_asset_folder: true` in your `_config.yml`.

Now when you put a post inside `_post/` folder, make a folder of exactly the same name of that post and put all the image file there. Inside the org file use the file link to generate the link to the img.

```latex
We have post name "HELLO WORLD.org"

------- _post
 |
 ----- HELLO WORLD.org
 dir-- HELLO WORLD

------- HELLO WORD
 |
 ----- img1.png

 Here is how to insert <file:Hello World/image1.png>
```

## Easier Image Insertion Config
I made some config to my emacs, so that when I want to insert an image, I took a screenshot of that image and it will create the folder, put the image, insert to org file for me. Below is the config function I use. This function is written by [kirchhoff](https://emacs-china.org/users/kirchhoff/activity) posted [here](https://emacs-china.org/t/org-mode/79). I made some changes to the file name to make sure it adapt to the hexo image insertion workflow.

```emacs-lisp
(defun my-org-screenshot ()
  "Take a screenshot into a time stamped unique-named file in the
same directory as the org-buffer and insert a link to this file."
  (interactive)
  (org-display-inline-images)
  (setq filename
        (concat
         (make-temp-name
          (concat (file-name-nondirectory (file-name-sans-extension buffer-file-name))
                  "/"
                  (format-time-string "%Y%m%d_%H%M%S_")) ) ".png"))
  (unless (file-exists-p (file-name-directory filename))
    (make-directory (file-name-directory filename)))
                                        ; take screenshot
  (if (eq system-type 'darwin)
      (progn
        (call-process-shell-command "screencapture" nil nil nil nil " -s " (concat
                                                                            "\"" filename "\"" ))
        (call-process-shell-command "convert" nil nil nil nil (concat "\"" filename "\" -resize  \"50%\"" ) (concat "\"" filename "\"" ))
        ))
  (if (eq system-type 'gnu/linux)
      (call-process "import" nil nil nil filename))
                                        ; insert into file if correctly taken
  (if (file-exists-p filename)
      (insert (concat "#+attr_html: :width 800\n" "[[file:" filename "]]")))
  ;; (org-display-inline-images)
  )
```
