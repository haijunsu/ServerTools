# ServerTools
Useful tools for server management

# Disable sudoer's password
```sh
echo "`whoami` ALL=(ALL) NOPASSWD: ALL" > `whomai`
sudo mv `whoami` /etc/sudoers.d/
```
Test issue
