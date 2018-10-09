# Client Certificate Authentication with haproxy

This is a custom haproxy where you can use your own server.pem and ca.pem. Inspiration came from this article:

http://www.loadbalancer.org/blog/client-certificate-authentication-with-haproxy/

## Env vars to set

```
APP_HOST = link to your app in docker network where you want to proxy requsts
CA_PEM = Certificate Authority cert
SERVER_PEM = Server cert which has been signed against the CA
*VIRTUAL_PATH = Optional setting to add reqrep to haproxy config so it listens only to this route (for example: /myapp)
```

## docker-compose.example.yml

An (non-working, ie. it does not have an example image app) example how to use this with an app.
