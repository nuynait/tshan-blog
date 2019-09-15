---
title: Web Develop Environment - Apache in macOS Sierra 10.12
date: 2018-04-13
tags:
desc:
---

So recently I need to develop [Hourglass](hourglasslab.com) website, in order to do so, I need to setup a local web server for that. I know that many people uses `MAMP`, however, I don’t like that. I think it installs way too much things compare to what I need, and a simple `Apache` in this case is what all I want.
<!--more-->

So, I found [this post](https://medium.com/@JohnFoderaro/how-to-set-up-apache-in-macos-sierra-10-12-bca5a5dfffba), by [@John Foderaro](https://medium.com/@JohnFoderaro?source=post_header_lockup) posted on **Medium**. It is very helpful, and below is just a summary of the important part in that post. If anything is confusing, you can always go to original post and take a look at the detail.

# Create Site Folder
Create a site folder under home directory
``` bash
mkdir ~/Sites
```

You can link any projects file using softlink

``` bash
cd ~/Sites
ln -s ~/repo/web-repo
```

# Config Apache
The apache is already installed on Mac by default, you only need to config it properly to enable user directory sites. First if you don’t know your userId, use `whoami` command.

## Apache Users Config File
Navigate to `/etc/apache2/users` and create a `<username>.conf` file under that directory. Note that **<username>** is a placeholder, use the result from `whoami`. Copy everything below into newly created file.

*REMEMBER TO REPLACE <username> in both filename and contents*

``` bash
<Directory "/Users/<username>/Sites/">
  AllowOverride All
  Options Indexes MultiViews FollowSymLinks
  Require all granted
</Directory>
```

Give the file you just created a 644 permission

``` bash
sudo chmod 644 <username>.conf
```

## Modules Config
Now navigate to `/etc/apache2`, edit file `httpd.conf`. Before you edit that, it would be a good behaviour to make a backup of that file with extension `.bak`

``` bash
cd /etc/apache2
sudo cp httd.conf httpd.conf.bak
sudo vim httpd.conf
```

In that file, many modules are excluded with `#` comment tag at front. Here is a list of modules we want to enable. Some may already enabled some may not. Remove the `#` comment tag at front to enable them.

``` bash
LoadModule authz_host_module libexec/apache2/mod_authz_host.so
LoadModule authz_core_module libexec/apache2/mod_authz_core.so
LoadModule userdir_module libexec/apache2/mod_userdir.so
LoadModule vhost_alias_module libexec/apache2/mod_vhost_alias.so
Include /private/etc/apache2/extra/httpd-userdir.conf
Include /private/etc/apache2/extra/httpd-vhosts.conf
```

If you want to enable php modules, when enable modules, also enable the following one. This is *optional*. By doing that you can now serve any files with the `.php` extension. If you don’t want to execute any php file, then ignore this step.
``` bash
LoadModule php5_module libexec/apache2/libphp5.so
```

Once you finish search above lines, remove the prepending `#`, save and close `httpd.conf`

## Edit Extra User Directory Configuration
Now navigate to `/etc/apache2/extra` and edit the file `httpd-userdir.conf`, also it is a good behaviour to make a backup of that file too.

``` bash
cd /etc/apache2/extra
sudo cp httpd-userdir.conf httpd-userdir.conf.bak
sudo vim httpd-userdir.conf
```

Uncomment the following line:

``` bash
Include /private/etc/apache2/users/*.conf
```


## Restarting Apache
``` bash
sudo apachectl restart
```


# Access Your Sites
Now you can access your website repository by going to `http://localhost/~username`, replace username with result from `whoiam`. Because we link different repositories into the root site folder, you will need to navigate into child folders to access different web repositories.
