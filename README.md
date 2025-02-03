# Nix Config

## Nix Daemon Proxy

```xml
    <key>EnvironmentVariables</key>
    <dict>
           <key>ALL_PROXY</key>
           <string>socks5://127.0.0.1:7890</string>
           <key>HTTPS_PROXY</key>
           <string>http://127.0.0.1:7890</string>
           <key>HTTP_PROXY</key>
           <string>http://127.0.0.1:7890</string>
           <key>NO_PROXY</key>
           <string>localhost,internal.domain,.local,example.dev,.example.dev,10.0.0.1/8,127.0.0.1/24,192.168.0.1/16</string>

           <key>all_proxy</key>
           <string>socks5://127.0.0.1:7890</string>
           <key>https_proxy</key>
           <string>http://127.0.0.1:7890</string>
           <key>http_proxy</key>
           <string>http://127.0.0.1:7890</string>
           <key>no_proxy</key>
           <string>localhost,internal.domain,.local,example.dev,.example.dev,10.0.0.1/8,127.0.0.1/24,192.168.0.1/16</string>
    </dict>
```
