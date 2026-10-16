#!/usr/bin/env bash
# 把本仓库内容镜像推送到 Gitee。
# 凭据来自 Windows 凭据管理器（首次会提示输入：用户名 wj983 / 密码填私人令牌）。
# 令牌不写进本脚本，也不留在 .git/config 里。
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
GITEE_URL="https://gitee.com/wj983/gkd-subscription.git"
MSG="${1:-sync: $(date +%F)}"

cd "$REPO"
git add -A
if ! git diff --cached --quiet; then
  git commit -m "$MSG"
else
  echo "[sync-gitee] 无变更，跳过提交"
fi

git remote add gitee "$GITEE_URL" 2>/dev/null || git remote set-url gitee "$GITEE_URL"

# Gitee 新建仓库默认分支是 master，两边都推，网页上立刻能看到内容
git push gitee HEAD:master
git push gitee HEAD:main || true

# 自检：远端 URL 不得含明文凭据；本地与远端 SHA 必须一致
git remote -v | grep -v '@' >/dev/null && echo "[sync-gitee] remote 无明文凭据"
echo "[sync-gitee] 本地 $(git rev-parse HEAD)"
echo "[sync-gitee] 远端 $(git ls-remote gitee master | cut -f1)"
