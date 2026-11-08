# CronLMS
### About
**CronLMS** is a TUI application that lets users **view their canvas courses through a Linux terminal**. The script is written in **Bash** and can be ran on almost any Linux distribution.
*ChronLMS is not affiliated nor connected with Canvas LMS and exists as a separate entity*

### Precautions 
To use CronLMS, you must have an **Access Token**, placed inside of the **token.txt** file. An Access Token **is not a browser cookie**. Cookies are temporary, and last only a **few hours**.

### Get an Access Token
There are multiple ways to get a canvas **access token**, The safest and most reliable is to use the **Create Access Token Button** through your canvas settings. 
Some schools may blocked this, meaning you have to choose another way to gain it, or ask an administrator. Here are the following ways to **get an access token safely**.
- Generate an access token through **official canvas** (easiest)
- Use a waydroid machine and **intercept the token** with **mitmproxy** from the android app (moderate)
- Do whatever [this guy is doing](https://tsun1031.xyz/posts/retrieving-instructure-canvas-lms-token)

### Dependencies
**CronLMS** Uses the following dependencies
- curl
- w3m
- jq
- sed
- whiptail
- coreutils

#### Debian/Ubuntu
```
sudo apt update && sudo apt install -y bash curl jq w3m whiptail
```

#### Fedora/RHEL/CentOS
```
sudo dnf install -y bash curl jq w3m newt
```
*If w3m is not available in RHEL, you might need to [enable epel](https://www.redhat.com/en/blog/install-epel-linux)*.

#### Arch/Manjaro
```
sudo pacman -Syu --needed bash curl jq w3m libnewt
```

#### OpenSUSE
```
sudo zypper install -y bash curl jq w3m newt
```
