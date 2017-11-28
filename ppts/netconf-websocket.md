title: NETCONF over WebSocket
speaker: Tony Deng
url: https://github.com/tonydeng/note/master/ppts/r-poems.md
transition: cover-diamond
theme: colors

[slide data-transition="vertical3d"]

# NETCONF over WebSocket

[（https://tools.ietf.org/html/draft-iijima-netconf-websocket-ps-04）](https://tools.ietf.org/html/draft-iijima-netconf-websocket-ps-04)

<small>Tony Deng</small>

Github [@tonydeng](https://github.com/tonydeng)

Twitter [@wolfdeng](https://twitter.com/wolfdeng)

Blog [TonyDeng's Blog](https://tonydeng.github.io)

[slide data-transition="kontext"]

# Changes since the last IETF meeting
- As per comments received at the last IETF metting, we’ve made following changes.
    - Changed description about NETCONF username.
        - We propose extracting information about NETCONF username from TLS. Websocket needs TLS for ensuring security. Thus, using information is TLS is necessary in order to ensure that NETCONF user is very person who is authenticate by TLS(certificate).
        - We think, for this purpose, complying with Mr.Badra’s ID is the best approach since reinventing the wheel is not welcomed.
        -
[slide data-transition="kontext"]

# NETCONF username from TLS

- I haven't implemented all of the Mr.Badra's algorithms yet. But l've confirmed that it's possible for a NETCONF server supporting WebSocket to get TLS Certificate during TLS handshake by, for example, using HTTP server's API, or seeing SSL_Context through SSL_socket.
- NETCONF server example.
```java
public class NetconfWebSocketServlet extends WebSocketServlet{
    @Override
    void doGet(HttpServletRequest req, HttpServletResponse res){
        X509Certificate[] certificates = (X509Certificate[])req.getAttribute("...X509Certificate");
        // NETCONF server can see client's TLS certificate sent during TLS handshake here.
    }

    @Override
    public WebSocket doWebSocketConnect(HttpServletRequest req, String protocol){
        //NETCONF server can see messages sent over WebSocket here.
    }
}
```

[slide data-transition="kontext"]

# NETCONF message

![netconf message](/img/netconf-websocket/netconf-message.jpg)


[slide data-transition="kontext"]

# Conclusions

- We proposed a way of sending NETCONF over WebSocket protocol.
- We proposed extracting NetconfWebSocketServlet username from TLS, that is complying with Mr.Badra's algorithms.
- Does WG have interests?
- If YES, should this I-D move forward as an Experimental I-D?

[slide data-transition="kontext"]

# Reference

1. [NETCONF over WebSocket draft-iijima-netconf-websocket-ps-04](https://tools.ietf.org/html/draft-iijima-netconf-websocket-ps-04)
2. [Hiroyasu Kimura, Yoshifumi Atarashi, and Hidemitsu Higuchi](http://slideplayer.com/slide/8667609/)
