# oxpasta

[oxpasta](https://github.com/rskntroot/oxpasta) is a minimal shell script for interacting with a [rustypaste](https://github.com/orhun/rustypaste) server

## Brief

As someone who needed quick access to only a handful of features, [rpaste](https://github.com/orhun/rustypaste-cli) was overkill. As such, this shell only provides shortcuts for 3 features: upload, oneshot (-o), and url shortening (-s).

## Help

``` zsh
Usage: oxpasta [OPTION] FILE

Options:
  [none]             {file}   Upload a file
  -o, --oneshot      {file}   Upload a file as a oneshot link
  -s, --shorten-url  {url}    Shorten a given URL
  -h, --help                  Display this help message

Description:
  minimal rustypaste cli script

Requires:
  export OXP_SERVER="https://example.com"

Examples:
  oxpasta /path/to/file
    | Uploads the file located at /path/to/file
  oxpasta -o /path/to/file
    | Uploads the oneshot URL https://example.com
  oxpasta -s https://example.com/long/url
    | Shortens the URL to https://<server>/<some-text>
```

## Setup

1. save `oxpasta.sh` file


1. symlink `oxpasta`
    ``` zsh
    sudo ln -s /path/to/oxpasta.sh /usr/local/bin/oxpasta
    ```

1. set server url
    ``` zsh
    echo 'export OXP_SERVER="https://<rustypaste-server-url>"' >> ~/.bashrc
    source ~/.bashrc
    ```

## Example

``` zsh
$ git clone https://github.com/rskntroot/oxpasta.git
$ echo $PATH | grep -o '/usr/local/sbin'
$ sudo ln -s /home/${USER}/workspace/oxpasta/oxpasta.sh /usr/local/bin/oxpasta
$
$ sha256sum oxpasta/oxpasta.sh > file && cat file
8fb227774b7f24c22b1437303af7bcd222b4bd058563576102f87c351595deb0  workspace/oxpasta/oxpasta.sh
$ oxpasta file
https://paste.rskio.com/unsolicitous-fredricka.txt
$ curl https://paste.rskio.com/unsolicitous-fredricka.txt
8fb227774b7f24c22b1437303af7bcd222b4bd058563576102f87c351595deb0  workspace/oxpasta/oxpasta.sh
```
