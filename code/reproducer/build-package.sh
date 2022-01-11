#! /bin/bash

set -ex

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <package-name> <working-dir> <out-dir>"
    exit 1
fi

pkgName="$1"
working="$2"
outdir=$(readlink -f $3)

cd "$working"
git rev-parse HEAD

# find directory containing package.json file with the same name as the package
# we sort the paths so that shallower ones are preferred over deeper ones
pkgDir=$(find . -name package.json | while read pkg; do test $(jq -r .name $pkg) = "$pkgName" && echo $pkg; done | xargs dirname | sort | head -n 1)

# first install dependencies in the root
npm install --production=false || echo "Dependency installation failed; continuing."

# then install dependencies in the package directory (if different from root)
if ! [ -z "$pkgDir" ] && [ "$pkgDir" != "." ]; then
  cd "$pkgDir"
  npm install --production=false || echo "Dependency installation failed; continuing."
fi

# attempt to set the time to the time of publication
now=$(date)
(npm view "$pkgName" time --json | jq ".[\"$version\"]" | xargs sudo -n date -s) || \
  (echo "Failed to set date; continuing.")

# run a few possible build scripts under a 10-minute timeout
for target in compile build pack webpack; do
  for prefix in "" "our:"; do
    timeout 10m npm run "$prefix$target" || true
  done
done
tarball=$(npm pack | tail -n 1)

# reset time
sudo -n date -s "$now" || echo "Failed to reset time; continuing."

mkdir -p "$outdir"
tar xf "$tarball" -C "$outdir" --strip-components=1
