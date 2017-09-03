# ServerTools
Useful tools for server management

# Disable sudoer's password
```sh
echo "`whoami` ALL=(ALL) NOPASSWD: ALL" > `whomai`
sudo mv `whoami` /etc/sudoers.d/
```
# SSH proxy tunnel
```sh
ssh -D 1080 -C -N <proxy Linux/Unix server>
```

# SSH over sock proxy
```sh
ssh -o ProxyCommand="nc -X 5 -x localhost:1080 %h %p" <server behind firewall>
```
