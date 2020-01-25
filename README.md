# docker_offlineimap

*Unofficial* OfflineIMAP Dockerfile for backing up all folders of an imap server.

## Quickstart
After installing docker, just run the following command:

```sh
docker pull maxkratz/offlineimap:latest
```

## Environment variables
You can use the following environment variables for customization of this container:

```sh
MAILLOG # If set to true, container will create a log instead of using console output
```

## Mount volumes or bind folders
One may mount a folder of the host to **/mnt/mail** within the container to enable persistent backups of imap servers.

* **/mnt/mail** may be used as backup target.
* **/mnt/config** will be used as config. Be sure to place a file named **offlineimap.conf** with a valid configuration in here.
* **/mnt/secret** may be used as folder to get secrets from. You can e.g. place password files in this folder and use them in your config file.
* **/mnt/log** will be used as log target (if environment variable is set).

## Full example command
```sh
docker run -it -v ~/email-backups/offlineimap-config:/mnt/config -v ~/email-backups/offlineimap-secret:/mnt/secret -v ~/email-backups/offlineimap-mail:/mnt/mail -v ~/email-backups/offlineimap-log:/mnt/log -e MAILLOG=TRUE maxkratz/offlineimap:latest
```

**offlineimap.conf**
```sh
[general]
accounts = personal-mail

[Account personal-mail]
localrepository = local-personal-mail
remoterepository = remote-personal-mail

[Repository local-personal-mail]
type = Maildir
localfolders = /mnt/mail

[Repository remote-personal-mail]
type = IMAP
remotehost = imap.example.com
remoteuser = user123
remotepassfile = /mnt/secret/password.conf
sslcacertfile = /etc/ssl/certs/ca-certificates.crt
```

**password.conf**
```sh
MyPassword123
```

Please notice that this container provides validated CAs in folder shown above.

## Dockerfile
The Dockerfile can be found at:
[https://github.com/maxkratz/docker_offlineimap/blob/master/Dockerfile](https://github.com/maxkratz/docker_offlineimap/blob/master/Dockerfile)

## What gets installed in this container?
The following packages are installed within this docker container:

* Some utility packages like locales, bash-completion, ca-certificates etc.
* [OfflineIMAP](http://www.offlineimap.org/about/) (thats the whole point ...)