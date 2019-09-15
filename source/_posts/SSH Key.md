---
title: SSH Key
date: 2016-06-13
tags:
desc:
---

Here everything related ssh keys.
<!--more-->

# Generate a new SSH key
When generating ssh key, you are generating two key files, a private key and a public key file.

``` bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

This creates ssh key using provided email address as a label. If you choose to save to the default location, you can see result files under `~/.ssh/` folder, `id_rsa` as private key and `id_rsa.pub` as public key.

If don’t want to provide email address as label, the simplest command is:

``` bash
ssh-keygen -t rsa
```


# Why passphrase for SSH key
What is passphrase? Why do we need that?

If you can make sure the secure of your private key, then a passphrase is not needed. However, if your private key is not secure enough, or you may need to share your private key with other people (friends), you will need to setup a passphrase.

## Detail example:
Assume that you didn’t set a passphrase while creating your keys. Now you will copy your public key to all the machines where you want to login by issuing `ssh-copy-id -i ~/.ssh/id_rsa.pub user@somehost`. Now, with your keys, you will be able to login to all the machines where you copied your keys.

Since you didn’t create a passphrase, anyone who gets your private key can login to all the machines where your public key is added. Assume you let your machine to be used by some of your friends and one of him is evil-minded. To prevent this, you set a passphrase to your private key. So whenever you login using your key, you will be prompted for the passphrase and so only you(who knows the passphrase) can login.

But it becomes cumbersome to type the passphrase whenever you login to other machines. So you can give your passphrase to ssh-agent once and it will use it whenever required. You use ssh-add to give your keys to ssh-agent. You can always check what all keys your ssh-agent is managing by issuing `ssh-add -l`.

# Avoid entering passphrase every time
First start the `ssh-agent` in the background. If you're using macOS Sierra 10.12.2 or later, you will need to modify your `~/.ssh/config` file to automatically load keys into the `ssh-agent` and store passphrase in your keychain.

```
Host *
 AddKeysToAgent yes
 UseKeychain yes
 IdentityFile ~/.ssh/id_rsa
```

Add your SSH private key to the ssh-agent and store your passphrase in the keychain. If you created your key with a different name, or if you are adding an existing key that has a different name, replace `id_rsa` in the command with the name of your private key file.

```
ssh-add -K ~/.ssh/id_rsa
```

# Copy public key to server
If you are using ssh key to perform ssh authentication, you will need to copy your public key to server. Here is how.

```
 ssh-copy-id demo@198.51.100.0
```

**NOTE:** On Mac,  `ssh-copy-id` is not installed by default. You can install via Homebrew. `brew install ssh-copy-id`

Alternatively, you can also copy over the keys using ssh.

```
cat ~/.ssh/id_rsa.pub | ssh demo@198.51.100.0 "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >>  ~/.ssh/authorized_keys"
```

# Disable password login
This is optional.

> Make sure you can login using your ssh key, and make sure your ssh will be safe and never lost. After disable password login, your ssh key is the only way to authenticate.  

```
sudo vim /etc/ssh/sshd_config
```

Within `/etc/ssh/sshd_config`, change the following line.

```
PermitRootLogin without-password
```

Run following command to put change into effect.

```
sudo systemctl reload sshd.service
```

# Reference
1. [Generating a new SSH key and adding it to the ssh-agent - User Documentation](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/)
2. [How To Set Up SSH Keys | DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys--2)
3. [What is the difference between ssh-add and ssh-agent? - Stack Overflow](https://stackoverflow.com/a/22272892)
