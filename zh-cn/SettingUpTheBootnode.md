# 目标

# 参考资料

https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-18-04

https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-18-04

https://www.digitalocean.com/community/questions/configure-nginx-for-nodejs-backend-and-react-frontend-app

https://serverfault.com/questions/424452/nginx-enable-site-command

# 步骤

## 基础系统

在 digital ocean (或类似) 建立一个始于 Ubuntu 18.04. SSH 基础的新机器。

## 创建网路服务器

安装 nginx `apt 安装 nginx`

通过直接在浏览器中访问您的 IP 来确认服务器正在工作。应该会看到 nginx 测试页面。

`cd /var/www/html` `cp index.nginx-debian.html index.html` `vim index.html`

```html
<!DOCTYPE html>
<html>
  <head>
    <title>SFBW Substrate Testnet</title>
    <style>
      body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
      }
    </style>
  </head>
  <body>
    <h1>SFBW Substrate Testnet</h1>
    <p>Thanks for joining our Substrate testnet.</p>

    <p>
      你可以从github编译节点
      <a href="https://github.com/substrate-develeoper-hub/substrate-node-template"
        >Substrate Node Template</a
      >.<br />
      Download the <a href="spec.json">Chain Specification</a>.<br />
      Download the <a href="alice.json">Prefunded Alice Key</a>.<br />
    </p>
  </body>
</html>
```

我们稍后会创建这些链接文件。确认新网页加载。

## 添加 SSL

我们需要一个域名。注册它并设置 dns 使其指向您的服务器。这个过程因注册商而异。什么时候
您的域加载了我们刚刚创建的网页，您可以继续设置 SSL。
For setting up subdomains like sfbw.bootnodes.net just use an A record `sfbw A 1.2.3.4 3600`

安装 certbot

```bash
add-apt-repository ppa:certbot/certbot
apt install python-certbot-nginx
```

设置服务器块

```bash
cd /etc/nginx/sites-available
vim sfbw.bootnodes.net
```

```
server {
       listen 80;
       listen [::]:80;

       server_name sfbw.bootnodes.net;

       root /var/www/html/;
       index index.html;

       location / {
               try_files $uri $uri/ =404;
       }
}
```

通过将新配置从可用站点链接到启用站点来启用新配置
`ln -s /etc/nginx/sites-available/sfbw.bootnodes.net /etc/nginx/sites-enabled/` 确认配置格式没问题 `nginx -t`.
重新加载服务器 `systemctl reload nginx`

使用 certbot 设置 ssl `certbot --nginx -d sfbw.bootnodes.net --register-unsafely-without-email` 你也可以 fork
通过您的电子邮件。它只适用于 EFF。我选择不重定向 http，但我们应该尝试一下。如果没有
破坏任何东西，我们应该去做。

通过导航到例如确认您的网站加载了 ssl `https://sfbw.bootnodes.net`

## 安装节点

```bash

# 我第一次手动安装 apt/rustup
# 脚本也适用于 2019 年 11 月 1 日
curl https://getsubstrate.io -sSf | bash -s -- --fast

git clone https://github.com/substrate-developer-hub/substrate-node-template
cd substrate-node-template
cargo build --release # If cargo was _just_ installed, start a new shell so it's on your path
```

## 节点的服务器块

构建节点后，添加服务器块以重定向标准端口 9944 和 9933。这些设置假定节点
将分别在端口 9994 和 9993 上公开 ws 和 rpc。这可以通过`--ws-port 9994 --rpc-port 9993`来完成。
我们很快就会自动执行这些设置。

将此添加到底部，并注意由于 certbot，顶部已更改。您需要在这些中调整域名线。

```
server {
  listen 9944 ssl;

  server_name sfbw.bootnodes.net;

  ssl_certificate /etc/letsencrypt/live/sfbw.bootnodes.net/fullchain.pem; # managed by Certbot
  ssl_certificate_key /etc/letsencrypt/live/sfbw.bootnodes.net/privkey.pem; # managed by Certbot

  location / {
    proxy_buffers 16 4k;
    proxy_buffer_size 2k;
    proxy_pass http://127.0.0.1:9994;
    proxy_http_version 1.1;
  }
}


server {
  listen 9933 ssl;

  server_name sfbw.bootnodes.net;

  ssl_certificate /etc/letsencrypt/live/sfbw.bootnodes.net/fullchain.pem; # managed by Certbot
  ssl_certificate_key /etc/letsencrypt/live/sfbw.bootnodes.net/privkey.pem; # managed by Certbot

  location / {
    proxy_buffers 16 4k;
    proxy_buffer_size 2k;
    proxy_pass http://127.0.0.1:9993;
  }
}

```

检查语法并重新加载

```bash
nginx -t
systemctl 重新加载 nginx
```

使用 --ws-port 9994 --rpc-port 9993 启动您的节点，并确认您可以连接托管应用程序。在设置选项卡上使用
`wss://sfbw.bootnodes.net:9944`

## 创建共享链规范

基于本地测试网`node-template build-spec --chain local > spec.json`创建一个基本的 chainspec

编辑网络的名称和 ID、根密钥、预付账户等。

在我们将引导节点添加到链规范之前，我们需要知道它们的节点身份。这意味着我们需要开始每个
node 一次让它生成节点密钥。

像`node-template --chain=spec.json --alice`一样启动 Alice 的节点，一旦节点启动，观察它的节点身份，然后
用 ^C 杀死它。在 chainspec 的 bootnodes 部分对您想要的任何其他节点重复此操作。

现在再次编辑链规范，以格式添加每个引导节点

```json
"bootNodes": [
    "/dns4/sfbw.bootnodes.net/tcp/30333/p2p/QmNdzun5tXSo7TPEntmujvU3eLEjTJKfXpJAvwp1ikpa6T",
    "/ip4/167.71.86.67/tcp/30333/p2p/QmdP4qG1ZSgzmsdFpBwuPAVWG9zjPRHV3dSkTT8v4TGP4J"
],
```

警告：从现在开始，您不应删除节点的整个数据目录。你可以用
`purge-chain` 子命令，但是如果你删除整个目录，它会删除节点键并改变节点的
身份。

最后，通过将 chainspec 复制到 web 目录来发布链规范

`cp spec.json /var/www/html/spec.json`

确认您可以通过网络访问 https://sfbw.bootnodes.net/spec.json`

## 启动脚本（可选）

如果您的节点需要许多标志，那么制作一个启动脚本可能是明智的，这样您就不会将其弄乱。我通常
写一个这样的。

```bash
# 清除所有旧链。
# 仅适用于频繁重启的链条（例如车间）
# 不应清除长时间运行的链以避免不断重新同步
./target/release/node-template purge-chain --chain=spec.json -y

./target/release/node-template \
        --chain=spec.json \
        --alice \
        --ws-port 9994 \
        --rpc-port 9993
```

## 共享预付账户

请记住，我们的网站为用户提供下载预先资助的密钥。将 Alice 密钥添加到应用程序并将其导出到
json。
[Dev phrase](https://github.com/paritytech/substrate/blob/93123cc63eac37fed7a6cc6cc58e7e43d666ee03/core/primitives/src/crypto.rs#L40)

底部驱动器服从湖帘烟篮举行比赛孤独适合步行//爱丽丝我使用密码：爱丽丝或只是一个上传
服务器的 json 密钥

## Host a frontend

回到/root，克隆前端模板
`git clone https://github.com/substrate-developer-hub/substrate-front-end-template/`

Install yarn following https://yarnpkg.com/lang/en/docs/install/#debian-stable

```bash
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
apt 更新
apt 安装 yarn
```

安装依赖`yarn` 修改生产服务器以满足您的需求 `vim src/config/production.json` and use
wss://sfbw.bootnodes.net:9944

使用“yarn build”构建生产版本，然后将构建输出目录移动到 Web 根目录中
`mv build /var/www/html/front-end`

您必须确保配置文件中的项目名称与您从中提供服务的位置相匹配。
