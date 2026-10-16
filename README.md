# gkd-subscription

我自己的 [GKD](https://gkd.li) 订阅仓库。规则写在 [`gkd.json5`](./gkd.json5) 里，改完推上来、版本号 +1，手机上 GKD 就会拉到更新。

- GitHub（主）：https://github.com/wjz983/gkd-subscription
- Gitee（镜像备份）：https://gitee.com/wj983/gkd-subscription

## 订阅链接

GKD → 订阅 → 添加订阅，填：

```
https://raw.githubusercontent.com/wjz983/gkd-subscription/main/gkd.json5
```

> ⚠️ 不要把 Gitee 的 raw 链接当订阅地址。Gitee 的 raw 会 302 跳到 `raw.giteeusercontent.com` 上带签名的**临时地址（约 50 分钟过期）**，GKD 定期检查更新时拿到的旧链接会失效。Gitee 这份只作备份和手工取用。
> 国内网络取 GitHub raw 不稳定时，可临时改用 jsDelivr：`https://cdn.jsdelivr.net/gh/wjz983/gkd-subscription@main/gkd.json5`

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

## 同步到 Gitee

```bash
bash sync-gitee.sh "feat: 新增 xxx 规则"
```

脚本把当前仓库内容推到 Gitee 镜像；凭据走 Windows 凭据管理器，命令行与 `.git/config` 里都不留明文令牌。
