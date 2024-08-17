#!/usr/bin/env bash
set -eu

SCRIPT_DIR="${BASH_SOURCE%/*}"

cd "$SCRIPT_DIR"

version="$(readlink KopiaUI.AppImage | sed -e 's/^KopiaUI-\(.*\)\.AppImage$/\1/')"

echo >&2 "==> Checking for KopiaUI update..."

#info="$(\
#  cat ./releases.json \
info="$(
	curl -s \
		-L \
		-H "Accept: application/vnd.github+json" \
		-H "X-GitHub-Api-Version: 2022-11-28" \
		'https://api.github.com/repos/kopia/kopia/releases' |
		jq '
           def filter_stable: map(select((.prerelease | not) and (.tag_name | test("-") | not)));
           filter_stable 
             | .[0] as $stable
             | $stable.tag_name[1:] as $version
             | ("KopiaUI-"+$version+".AppImage") as $file_name
             | $stable.assets | map(select(.name == $file_name)) | .[0]? as $asset
             | {
               version: $version,
               html_url: $stable.html_url,
               download_url: $asset.browser_download_url,
               file_name: $asset.name,
             }
        '
)"

new_version="$(echo "$info" | jq -r '.version')"
html_url="$(echo "$info" | jq -r '.html_url')"
download_url="$(echo "$info" | jq -r '.download_url')"
file_name="$(echo "$info" | jq -r '.file_name')"

if [[ $new_version == $version ]]; then
	echo >&2 "==> Nothing to do:  ${version}  ->  ${new_version}"
	exit
fi

echo >&2 "==> KopiaUI update available: ${version} -> ${new_version}"
echo >&2 "    Changelog: ${html_url}"
echo >&2 ""

read -p "    Do you want to update? [Y/n]: " inp
echo >&2 ""
if [[ ${inp,,} != 'y' ]] && [[ -n $inp ]]; then
	exit
fi

echo >&2 "==> Updating KopiaUI:  ${version}  ->  ${new_version}"

tmp_dir="$(mktemp -d)"
tmp_file_name="${tmp_dir}/${file_name}"
wget -O "$tmp_file_name" "$download_url"
#curl -L "$download_url" -o "$tmp_file_name"

echo >&2 "==> Installing KopiaUI v${new_version}"
install --mode '755' "$tmp_file_name" "$file_name"
ln -sf "$file_name" KopiaUI.AppImage

if command -v kopia-ui-crashsafe >/dev/null; then
	echo >&2 "==> Restarting KopiaUI (with crashsafe wrapper)"
	pkill -SIGHUP kopia-ui
	nohup >/dev/null 2>&1 kopia-ui-crashsafe &
	disown
else
	echo >&2 "==> Restarting KopiaUI"
	pkill -SIGHUP kopia-ui
	nohup >/dev/null 2>&1 kopia-ui &
	disown
fi

echo >&2 "==> KopiaUI update complete"
