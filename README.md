# gkd-subscription

我自己的 [GKD](https://gkd.li) 订阅仓库。规则写在 [`gkd.json5`](./gkd.json5) 里，改完推上来、版本号 +1，手机上 GKD 就会拉到更新。

- Gitee（**主源**，订阅地址走这里）：https://gitee.com/wj983/gkd-subscription
- GitHub（备份，内容一致）：https://github.com/wjz983/gkd-subscription

## 订阅链接

GKD → 订阅 → 添加订阅，填（**推荐 Gitee，国内更稳**）：

```
https://gitee.com/wj983/gkd-subscription/raw/master/gkd.json5
```

备用（内容完全一致）：

```
https://raw.githubusercontent.com/wjz983/gkd-subscription/main/gkd.json5
```

> Gitee 的 raw 会 302 跳到 `raw.giteeusercontent.com` 上带签名的临时地址（约 50 分钟过期）。
> 这不影响 GKD —— 它每次检查更新都重新请求、自己跟跳转。只有当你**把跳转后的地址抄下来反复用**时才会失效，
> 所以订阅地址永远填 `gitee.com/.../raw/...` 这一条，别填 `raw.giteeusercontent.com` 那条。
> jsDelivr（`cdn.` / `fastly.`）实测都会再跳回 `raw.githubusercontent.com`，对国内访问没有加速作用。

## 文件

| 文件 | 作用 |
|---|---|
| `gkd.json5` | 订阅本体：`globalGroups` 全局规则、`categories` 类目、`apps[]` 按 App 分组的规则 |
| `gkd.version.json5` | 只放 `version`，供 `checkUpdateUrl` 轻量比对，避免每次检查都拉 1 MB+ 的正文 |

## 加一条规则的步骤

1. 在 GKD 里用「自行选择 / 快照」拿到目标控件的节点文本，写成 `matches`。
2. 找到 `apps[]` 里对应的包名（没有就新增一项 `apps`），在其 `groups[]` 里加组，组里加 `rules`。
3. **顶层 `version` 和 `gkd.version.json5` 里的 `version` 一起 +1**（两处必须一致，否则检查更新和实际内容会错位）。
4. 提交推送，手机上拉一次更新验证。

写 JSON5 的要点：允许 `//` 注释、允许单引号、允许尾逗号；`matches` 外层多个 `[..]` 是**或**，`[..][..]` 连写是**且**；`action` 用 `"clickNode"`（点节点）或 `"clickCenter"`（点中心）。

## 语法校验（推送前跑一次）

```bash
"C:/Users/Administrator/.workbuddy/binaries/python/versions/3.13.12/python.exe" \
  -c "import json5;json5.load(open('gkd.json5',encoding='utf-8'));print('ok')"
```

解析失败 GKD 会直接报「订阅格式错误」，整份订阅不加载。

## 怎么改这份订阅

**手机上（日常用这个）**：装 `GkdUploader.apk`（本机在 `D:\gkd-uploader\out\`，不进仓库），
填好 Gitee 用户名和私人令牌 → 编辑正文 → 点「上传（Gitee 主源）」。
App 每次上传前会自动 GET 一次拿文件 `sha`（Gitee 更新接口的硬性要求），
所以**不需要先手动点「拉取仓库当前内容」**；那个按钮只在你怀疑线上版本和本机草稿不一致时用。
「另存 GitHub 备份」是可选的，不点也不影响订阅生效。

**电脑上**：

```bash
cd /d/gkd-rules/gkd-subscription
# 改 gkd.json5 + 版本号，然后
bash sync-gitee.sh "feat: 新增 xxx 规则"     # 推 Gitee（master + main）
git push github main                          # 想留备份再推这条
```

凭据都走 Windows 凭据管理器，命令行与 `.git/config` 里不留明文令牌。

> 只传一边就行，别双写。两边都传时一旦一边失败就会出现"线上两个版本"，
> 订阅到底生效哪份都说不清。Gitee 是主源，GitHub 只是备份。
