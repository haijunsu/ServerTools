# ServerTools
Useful tools for server management

# Disable sudoer's password
```sh
sudo su
echo "YOUR NAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
```
