---
title: Spacemacs Config - How I Organize Tasks And Notes
date: 2016-10-19
tags:
desc:
---

I love write down things I leaned. So I need to find a way to organize my notes and search though them easily. After trying all different kinds of tools, I found out that Org Emacs mode suit me the best. It can insert code blocks easily. Stores as plain text files. I also have used vim for years. With evil mode, I can still use the vim keybindings. For task management, I love manage my everyday tasks. I also tried lots of gtd tools for this as well and org agenda is the most powerful tool for task management as well.

<!--more-->

# Emacs and system version
Before reading this blog, it is nice to know the version and tools I use.

-   Mac (GNU) Emacs 25.1.1
-   Spacemacs 0.200.2
-   MacOS Sierra 10.12

# How do I config my Emacs?
Finally, I choose to use emacs org modes for writing my notes. Reason? Writing in emacs is so fast that it saves me tons of time on taking the notes. Moreover, it is plain text. Everything in plain text is the best format for storage since you don\'t need any other application to filter the text for you. Export also becomes fixable.

## About Spacemacs
I use spacemacs. The reason I use spacemacs is that I love using the vim editing style. Spacemacs is a community config that includes the evil mode. It has a gorgeous theme and some default config and the layer config style make things easier.

## Install Spacemacs
Spacemacs separates its own config outside the .emacs.d. When you install spacemacs, it installs all the package inside .emacs.d with a default config add your own config on to the default setting. See below for detail on how to install the spacemacs config

### Install a clean Spacemacs
-   install Emacs latest version, I use Mac Emacs
-   make sure you don\'t have any Emacs config, the following folder should not exists `~/.emacs.d/`
-   run the following command to install spacemacs

``` bash
    git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d~
    ;; run emacs here to generate spacemacs file
    mkdir .spacemacs.d~
    mv ~/.spacemacs ~/.spacemacs.d/init.el~
```

-   now init git under `.spacemacs.d` folder and push it to a version control server to sync you config

### Install Spacemacs from an existing config

-   the first step is all the same, install spacemacs from its repository

```bash
    git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d~
```

-   now, don't run emacs, clone your own repository under home folder

```bash
    git clone https://github.com/xxxx/spacemacs-config ~/.spacemacs.d
```

-   run emacs, it will install spacemacs with your own config

## Spacemacs configuration
I am also a beginner for emacs config. Also for spacemacs, I have only used it for three weeks. So anything I say here is what I learned during those three weeks. It will be a good tutorial for beginners but not for advance users. It may have mistakes, if you see any mistakes here, please let me know and I will fix it.

### About layers
Spacemacs is composed with hundreds of different layers. You may know about packages, but layers are different compare to packages. You can define a package inside the layer and include all the customization related to that package. You can also define several packages together inside a single layer

### Adding pre-exist layers
You can see all the layers enabled currently in your config. First, open your config files `<spc f e d>`, you can add layers you want to use into the beginning of the config like this

```emacs-lisp
dotspacemacs-configuration-layers
'(
  ivy
  html
  helm
  auto-completion
  better-defaults
  emacs-lisp
  git
  markdown
  org
  swift
  javascript
  deft
  spell-checking
  syntax-checking
  )
```

All these layers are spacemacs defined layers and you can enable them by adding them to this list. So how do I know that this layer exists in spacemacs?

`<spc h spc>` is a keybinding for checking the layer information. Here is how I did that. If I want to use something, say I need support for swift. Then I can first use that keybinding and search for swift, I can see there is a swift layer so just adding that layer onto the list above can enable the swift mode for me pretty easily.

`<spc f e l>` this is a keybinding for checking the package information. If you want to know if this package has been used in any other layers, you can this command. More will be mentioned layer when talking about setting up a custom layer

### Adding a custom layer
What if the package I want to install is not in any of the pre-exist layers? What if I want to change the variable or keybindings that defines in any of the preexist layer? You can do it by create one or several custom layers

Following the spacemacs docs or quick guilds, you can see it has a command `configuration-layer/create-layer` that create the basic file structures for you. Since I always prefer do things myself instead of using the script, here is how I do it.

First in `.spacemacs.d`, create a folder name with name of your layer. Here my layer name is `tshan`, so I am using `tshan` as the folder name. Create some basic files for config your layers.

```bash
config.el
keybindings.el
packages.el
funcs.el
README.org
```

Put all your config into `config.el`, keybindings into `keybindings.el`, install any new packages or config exist packages under `packages.el` and if you want to share this layer, put all self-define functions inside `funcs.el`, write a read me to let people know how to use your layer.

Last but not least, include your custom defined layer into `init.el` under `dotspacemacs-configuration-layers`

### Is package already installed or used in any default layers?
If you want to install a package, first you should check whether this package is included in any of the layer you included. The way you see it is using `<spc h spc>` and another way to search all packages include in spacemacs is to use `<spc f e l>` and if the package you want to install is not inside that list than it means you can probably init it inside your own layer

### Install a new package
If the package you want to install is not included in any default spacemacs layers, you can install them with the following method

```emacs-lisp
(defconst xxx-packages
  '(
    package-you-want-to-install
    )
  )

(defun xxx/init-package-you-want-to-install ()
  (use-package package-you-want-to-install
    :init
    ;; here you can config your package
    ;; and set any custom variables
    )
  )
```

`xxx` is the layer name, `package-you-want-to-install` is the package from `melpa` that you need to install. Do all the customization for that specific package under init function

### Config an already installed package
If the package you want to install is already exists inside a spacemacs layer, you may first enable the layer and start using it. If you want to do any customization to the package, include that package name inside your layer, and use the `post-init-yyy` function to do any customization you want

```emacs-lisp
(defconst xxx-packages
  '(
    other-package
    swift-mode
    another-package
    )
  )

(defun tshan/post-init-swift-mode ()
  ;; customize setting for swift package
  (setq swift-mode:basic-offset 2)
  )
```

Above is the customization I made to the swift-mode package and making it to have a indentation of 2 instead of 4. You can see that first I include swift-mode package into the package list, then I wrote a post-init-swift-mode function and put all the customization codes under it

One thing to notice is that the `xxx-package` constant should have a list of the **package** name, not the layer name. Even if you are editing a package that already installed by other layers, you still have to include it inside the package list to make it work

## My own config layer
Since I am still a beginner, I use only one layer to config everything I want to change. Right now, I am an iOS developer and I use emacs mainly for org-mode to organize tasks and notes. So most of my config related tweak for org-mode and org-agenda. Here is description for some important parts of my config file

These config some were figured out by myself using `<C-h v>`, `M-x describe
   faces`, etc. Some were written by others and I found them on internet

### Open files in the current emacs window
`(setq s-pop-up-frames nil)` make sure that when I open Emacs in terminal, it always uses the existing emacs window.

When open from terminal, first I have the following alias set in `.bashrc`

```bash
alias e="/Applications/Emacs.app/Contents/MacOS/bin/emacsclient"
```

Then I can use `e filename` to open that file in the current Mac Emacs window

### Making org level headers the same size
The default behavior for the theme is to have different scale size for different level of headers and I don\'t want them to be different sizes. I like everything to be the same size

```emacs-lisp
(custom-set-faces
 '(org-level-1 ((t (:inherit outline-1 :height 1.0 ))))
 '(org-level-2 ((t (:inherit outline-2 :height 1.0 ))))
 '(org-level-3 ((t (:inherit outline-3 :height 1.0 ))))
 '(org-level-4 ((t (:inherit outline-3 :height 1.0 ))))
 '(org-level-5 ((t (:inherit outline-3 :height 1.0 ))))
 '(org-level-6 ((t (:inherit outline-3 :height 1.0 ))))
 '(org-level-7 ((t (:inherit outline-3 :height 1.0 ))))
 '(org-level-8 ((t (:inherit outline-3 :height 1.0 ))))
 )
```

### Setting up the to-do workflow
The default org to-do keyword only has TODO and DONE which is not enough for my workflow. So I setup a custom keyword and assign them different color to make them look differently

```emacs-lisp
(setq org-todo-keywords
      '((sequence "TODO(t)" "SUBTREE(s)" "WAIT(w@/!)" "|" "DONE(d!)" "CANCELLED(c@/!)")
        (sequence "CRASH(c)" "BUG(b)" "REQUEST(r)" "TEST(e)" "|" "FIXED(f)")))

(setq org-todo-keyword-faces
      '(("WAIT" . "white")
        ("CRASH" . "red")
        ("BUG" . "red")
        ("SUBTREE" . "grey")
        ("TEST" . "turquoise1")
        ))
```

### Making priority displayed with different color
For todo items, when you have different priority, you want them to have different colors to stands out. Here is how I did that. You can always change the color to anything you want. Use `list-colors-display` command to show a list name of different colors

```emacs-lisp
(setq org-priority-faces
      '((?A . (:foreground "red" :weight 'bold))
        (?B . (:foreground "yellow"))
        (?C . (:foreground "green"))))
```

UPDATE: (2017-FEB-05) Now I am using more priority category from A to E. A means this task is what I have to do immediately. Stop all other tasks and focus on A task first. Should have as less A tasks as possible. B means this task is important and I need to finish it as soon as possible. Not good to have to many B tasks as well. C means this is an important task. The default priority will be C and means this task is normal priority. D means this task is not very important but I will be happy if I finish this task. E means I don\'t care if I have finished this task at all.

Here is the config for my new priority setup.

```emacs-lisp
(setq org-agenda-custom-commands
      '(
        ("p" . "筛选任务(目前无效果，需要修复)")
        ("pa" "超级紧急的任务" tags "+PRIORITY=\"A\"")
        ("pb" "比较紧急的任务" tags "+PRIORITY=\"B\"")
        ("pc" "一定要完成但是不着急的任务" tags "+PRIORITY=\"C\"")
        ("pd" "做完有好处的任务" tags "+PRIORITY=\"D\"")
        ("pe" "无所谓做不做的任务" tags "+PRIORITY=\"E\"")
        ))

(setq org-priority-faces
      '((?A . (:foreground "red1" :weight 'bold))
        (?B . (:foreground "VioletRed1"))
        (?C . (:foreground "DeepSkyBlue3"))
        (?D . (:foreground "DeepSkyBlue4"))
        (?E . (:foreground "gray40"))))

(setq org-highest-priority 65)
(setq org-default-priority 67)
(setq org-lowest-priority 69)
```

### Org capture and refile

For templates of org capture, I use almost the default setting, one template for task, the other one for journal. I haven't got deep into that. All I do with it is to create the task where-ever I am to fast my task creating speed.

For refile, I add a config to make refile works through all agenda files. Because I use different files to organize different projects

```emacs-lisp
(setq org-capture-templates
      '(("t" "Task" entry (file+headline "~/dropbox/ORG Notebook/Idea Capture/gtd/gtd.org" "Inbox")
         "* TODO %?\n  %i")
        ("j" "Journal" entry (file+datetree "~/dropbox/ORG Notebook/Idea Capture/journal.org")
         "* %?\nEntered on %U\n  %i\n  %a")))

(setq org-refile-targets '((nil :maxlevel . 9)
                           (org-agenda-files :maxlevel . 9)))
```

### Making all agenda items the same sizes

I don't know why, but the default behavior for `spacemacs-theme` is to have different size for todo tasks, here is how default situation is

1.  today's scheduled tasks is larger
2.  any tasks done is larger

I don't like this default behavior at all, so I changed the face to make all font the same size. Here is how I did that

```emacs-lisp
(setq org-priority-faces
      '((?A . (:foreground "red" :weight 'bold))
        (?B . (:foreground "yellow"))
        (?C . (:foreground "green"))))
```

### (OUTDATED) Setting up custom command for agenda
The agenda\'s timeline is perfect to see everyday scheduled tasks but there is no convenient way to list all the unscheduled tasks. I like to view all the unscheduled tasks every morning to arrange my daily tasks. So I set up several commands. First one is to go through my agenda library and find all tasks that is not scheduled but is todo. Second one is same as the first one but finds out all tasks having \'bugs\' as keywords. Third one finds the wait keywords, and many more.

UPDATE: that is a little bit out dated, see *here* for updated information

### Agenda view customization
The default agenda display format is not what I like. Below is some customization I did to make agenda display better information I need. I want the time string to be displayed at anytime no matter we have time scheduling tasks or not.

For format customization, I did some major change here. The first string is the task tag name, followed by the **scheduled** keyword, then is the scheduled time if available followed with the TODO keyword and task title.

I will describe details later for how I organize my tasks

```emacs-lisp
(setq org-agenda-time-grid
      '((daily today today)
        #("----------------" 0 16 (org-heading t))
        (800 1000 1200 1400 1600 1800 2000 2200 2359))) ;; show default time lines
(setq org-agenda-prefix-format '((agenda  . "%-10:T% s%?-2t") ; (agenda . " %s %-12t ")
                                 (timeline . "%-9:T%?-2t% s")
                                 (todo . "%i%-8:T")
                                 (tags . "%i%-8:T")
                                 (search . "%i%-8:T")))
(setq org-agenda-remove-tags t)
```

Also, I don't like the default agenda look. The font do not have the same size is the main problem that I don't like it. So I custom the face a little bit here.

```emacs-lisp
(custom-set-faces
 '(org-agenda-done ((t (:foreground "#86dc2f" :height 1.0)))))

(custom-set-faces
 '(org-scheduled-today ((t (:foreground "DodgerBlue2" :height 1.0)))))
```

### Setup agenda files
Because I put all my notes and gtd files in one folder with many other subfolders underneath to create some categorization, I find a function [here](https://github.com/suvayu/.emacs.d/blob/master/lisp/nifty.el) to recursively add files and files under subfolders into agenda

```emacs-lisp
(setq org-agenda-files
      (append (sa-find-org-file-recursively "~/Dropbox/ORG Notebook/" "org")))
```

### Tag completion though out all agenda files
I want all my notes to have the same completion for tags which means if one use :org, then it should not have `:ORG` appear in other notes. This is the setting to make sure they have same tags using through all different org files

```emacs-lisp
(setq org-complete-tags-always-offer-all-agenda-tags t)
```

# How do I manage my tasks?
I put all my tasks and notes under a folder in dropbox, so that they get sync through all my devices. There is a gtd folder under the main notebook folder and all my gtd items goes there.

## Different files for different projects
I use different files to organize different tasks. A main gtd files act as task inbox. Each file has a main header (level 1) and under neath is all the to items (level 2). I can have multiple level 1 headings in a file which means they are projects related to the file. For example, I have a file called life.org, and having two level 1 headings. One is *Life*. The other one is *Interviews*.

## For each file and tag settings
In order to display correctly using my own config in agenda, I need to have a tag attached to all level 1 headings. Also tags need to be less than or equal to 7 chars long

The reason I do that is because I changed my org agenda display format. See detail *here*. In short, I use tag name instead for the file name display inside agenda.

## My task workflow
Every morning when I wake up, I use a custom command to show all unscheduled tasks, to see what I need to do today. After arrange all the tasks, I go to the timeline view and assign each of them a priority. Then I know which task should be done first.

After that I just focus on finish all my scheduled task. When start doing the task, I use clock-in to start a time tracking. After finished, use clock-out to stop a time tracking

## Update: Using agenda
Instead of using a custom command to show all unscheduled items, now I use a config to make all the todo list showing tasks that do not have a schedule or deadline. So there are no more custom commands anymore. All I need to do is `<C-c a t>` or `<C-c a T>` to filter todo keywords

[Here](http://pragmaticemacs.com/emacs/org-mode-basics-vii-a-todo-list-with-schedules-and-deadlines/) is a blog talking about this and is where I get this idea from.

# How do I manage my notes?
I put all my tasks and notes under a folder in dropbox, so that they get sync through all my devices. There are folders with different names under the main notebook folder for different categorization

## How do I manage my notes?
First I need to give the note a main directory. Is this a swift related notes? Is this a computer science notes? Is this a cooking recipe? Then this should be the only categorization though folders, which means all swift related notes should placed under the swift folder. There **may be** hundreds of files under that folder, how do I find the file I need?

## Tags
For each heading, I can choose to assign **one** tag for that header what it talks about. When I search the notes I was looking for, I can type keyword, or filter by tags to find that specific related notes.

Why only one tags for each header? I *setup* the tag completion but that only works for the first tag for each header. I don\'t know why but the second tag do not get auto-completion.

I may look into it later but for now, I think one tag is enough to describe each header

What I plan to do is to create a file called **tags-list.org** which contain all the tags and their meaning and usage. So when I assign tags in notes, it will force me to use existing tags from the auto-completion. Any time I have to add a new tag, go into the tags-list.org file to add it. I think that is better way to manage all the tags.

## Deft
For easier note search I also config the deft layer to help me find the notes I need. It has some weakness, the most obvious one is that it does not support filter the result by tags which I need it the most. So I use agenda for search enhancement

## ORG Editing
Everything goes here relates to how I wrote my notes using the org-mode. It contains some org-tricks.

### Insert the picture
I find a function through google about taking a screenshot and save it in a corresponding folder and then insert it into the current org buffer.

So this is how I handle the image. First I use [Snappy App](https://itunes.apple.com/ca/app/snappy-snapshots-smart-way./id512617038?mt=12) to take the screenshot of the image I want to insert, then I resize it to the desired size. Note that we should not have a large image insert into the org file. It will be really difficult to view with the inline display and will not be good after the export as well.

After I finish prepare the image, I call the function that mentioned previously about taking the screenshot. Then it goes into my org buffer and image inserted successfully

Things I need to be aware is when I delete an inserted image from the buffer, I should first delete it in its corresponding folder to make life easier. Leaving unwanted image inside the folder is not what we want. We want to take all effort to make the storage as small as possible.

# Keybindings
(anything in table that marked `\` is mapped in my own config file)

## Global
Global commands used in all kinds of buffers

### Open Agenda and Deft
```
  Keybindings   Function
  ------------- ------------------
  <spc o a>  	open agenda
  <spc o d>   open deft
```

## Org Mode
Here is some useful keybindings for ending in org-mode

### Picture related
```
  Keybindings     Function
  --------------- ------------------------------------------------------
  <spc o s>    	take screenshot, save it and insert into current buffer
  <spc o o i>   	display inline images
  <spc o o o>  	cancel display inline images
```
## Inside Agenda

Here is some useful keybindings for agenda view that helps me a lot for organizing my tasks

### Keybindings toggles agenda
```
  Keybindings   Function
  ------------- --------------------------------
  <C-c a>     toggle agenda <, R> in spacemacs
  <C-c [>    	add current file into agenda
  <C-c ]>    	remove current file out agenda
  <C-\'>      cycle through all the files include into the agenda
  <SPC o a>  	toggle agenda
```

### Keybindings inside agenda (for spacemacs)
```
  Keybindings   Function
  ------------- --------------------------------------------------------------
  d/w           	toggles day / week view
  .             	switch to today
  J             	ask which day you want to switch to
  b             	back one week
  f            	forward one week
  r             	refresh view - when you make changes, you need to refresh to see update
  s            	save all org buffers in current Emacs session
  A             	open another agenda session in current agenda buffer
  o             	close all other windows
  F             	toggle follow mode (show the original heading in another inactive buffer dynamically)
  I             	clock in current item
  O             	clock out current item
  X             	clock cancelled
  , j           	jump to the current clock item
  L             	toggle logbook mode
  \            	filter by tag
  <           	show all items with the same file-name
  ^            	show all items with the same top headline
  <S-\>     		remove all filter
  t            	change the to-do state
  <S-right>   	schedule next day
  <S-left>    	schedule previous day
  m             	mark current item
  u             	unmark current item
  \*           	mark all items
  U             	unmark all items
  B             	bulk action for marked items
```
