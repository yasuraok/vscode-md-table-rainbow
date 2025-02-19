#!/bin/bash -ue

cd "$(dirname "$0")"

# gitにdiffが乗ってたらエラー扱いで終了
if [ -n "$(git diff)" ]; then
  echo "git diff が存在します。"
  exit 1
fi

# 採番 (package.jsonに書き込み)
VERSION=$(npm version prerelease --preid="$(git show --format='%H' --no-patch)" --no-git-tag-version)

# vsix作成
PACKAGE_NAME="$(jq -r '.name' package.json)-${VERSION}"
npx vsce package --pre-release -o "${PACKAGE_NAME}.vsix"

# package.jsonに書き込んだバージョンは元に戻す
git reset --hard HEAD
