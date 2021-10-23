# Snapdrop with Custom Extensions and Fixes

My main use of Snapdrop is to enable Airdrop-like file transfers between my iOS devices and other devices since, well, the Airdrop works with iOS devices only.
However, the original Snapdrop does not work well in pure LAN environment and with my iOS devices so I implemented several extensions and fixes.

### Devices in LAN cannot see each other

Basically Snapdrop only allows clients in the same room to see each other and clients are put in a room based on their IP address.
This works well if clients are behind NATed router while the server is outside, so all clients would be identified with a common public IP.
However, when the server is also behind the NAT, the server would see clients private IP addresses instead, resulting in the clients put into different rooms.
This is discussed in https://github.com/RobinLinus/snapdrop/issues/159 and the simple workaround is to create a single room mode as suggested in https://github.com/RobinLinus/snapdrop/issues/159#issuecomment-691678186

```
sed -i 's/peer.ip/0/g' server/index.js
sed -i 's/sender.ip/0/g' server/index.js
```

Note that this would make all clients put into the same room so do this only for pure LAN environment!

With local docker image, simply defining SINGLE_ROOM=1 environment variable would enable this feature.

### WebRTC issues in pure LAN environment

Snapdrop server is doing signaling only and data transfer is done peer to peer with WebRTC.
However, WebRTC is problematic especially in pure LAN environment and I was having great problems trying to get it work in all OSes and browsers my devices use.

In this case an option to disable WebRTC and route everything through server could be nice. 
Surely this would put burden on the server and there would be security issue due to everything passing through the server, but for pure LAN environment and simple Airdrop replacement this is much better than a non-working WebRTC.

```
sed -i 's/window.isRtcSupported = .*/window.isRtcSupported = false;/' client/scripts/network.js
sed -i 's/window.isWSRelayEverything = .*/window.isWSRelayEverything = true;/' client/scripts/network.js
```

With local docker image, simply defining DISABLE_RTC=1 and WS_RELAY=1 environment variables would do both the above.


### iOS Safari handling of blobs

iOS Safari is always trying to display blobs when it thinks it can, even if download link is specified.
And the worst part is, it would fail to display a PDF blob, giving message: "The operation couldn't be completed" - "WebKitBlobResource error 1".

To fix this, the blob is converted to data url with type application/octet-stream to prevent iOS Safari from trying to display it and force it to download instead.
 
---

# Snapdrop 

[Snapdrop](https://snapdrop.net): local file sharing in your browser. Inspired by Apple's Airdrop.


#### Snapdrop is built with the following awesome technologies:
* Vanilla HTML5 / ES6 / CSS3 frontend
* [WebRTC](http://webrtc.org/) / [WebSockets](http://www.websocket.org/)
* [NodeJS](https://nodejs.org/en/) backend
* [Progressive Web App](https://de.wikipedia.org/wiki/Progressive_Web_App)


Have any questions? Read our [FAQ](/docs/faq.md).

You can [host your own instance with Docker](/docs/local-dev.md).


## Support the Snapdrop Community
Snapdrop is free. Still, we have to pay for the server. If you want to contribute, please use PayPal:

[<img src="https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif">](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=FTP9DXUR7LA7Q&source=url)

or Bitcoin:

[<img src="https://coins.github.io/thx/logo-color-large-pill-320px.png" alt="CoinThx" width="200"/>](https://coins.github.io/thx/#1K9zQ8f4iTyhKyHWmiDKt21cYX2QSDckWB?label=Snapdrop&message=Thanks!%20Your%20contribution%20helps%20to%20keep%20Snapdrop%20free%20for%20everybody!) 

Alternatively, you can become a [Github Sponsor](https://github.com/sponsors/RobinLinus).

Thanks a lot for supporting free and open software!


 
