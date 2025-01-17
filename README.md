# wgetsh

Very expirmental PoC for a reverse shell requiring only wget and sh on the remote machine

## Usage

First run the server:

```
sudo python3 server.py
```

*Default port is 80. If needed change in the code.*

Then modify the `client.sh` to set ths fqdn or the server (and the code if required) then run it.

```
sh client.sh
```

The client should connect to the server. Use the server's console to run the command and display the results. Type `exit` on the console to stop the client. If the client is not stopped, it will try to reconnect forever.

## Example

```
$sudo python3 server.py 
Welcome to the wgetsh.

(wgetsh) Http Server Serving at port 80

(wgetsh) pwd
(wgetsh) /tmp/test
```
