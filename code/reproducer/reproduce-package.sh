#! /bin/bash

set -ex

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

spec="$1"
outdir=$(readlink -f "$2")

package="${spec%@*}"
version="${spec##*@}"

echo "Trying to reproduce package $package at version $version."

# Clone repo
for prop in repository.url repository homepage; do
  repoUrl=$(npm view "$spec" "$prop")
  if ! [ -z "$repoUrl" ]; then
    break
  fi
done
if [ -z "$repoUrl" ]; then
  echo "Could not find git repository for $spec."
  exit 1
fi
repoUrl=$(node -e "console.log(require('normalize-git-url')('$repoUrl').url)")
# replace ssh:// with https://
repoUrl=$(echo "$repoUrl" | sed 's#^ssh://#https://#')
git clone "$repoUrl" working

# Check out right commit
cd working
ref=$(npm view "$spec" gitHead)
if [ -z "$ref" ]; then
  # typical branch names for $version
  candidate_refs="$version v$version v-$version"
  # if $version contains pre-release tags, try those as well; they might be shas
  if [[ "$version" == *-* ]]; then
    candidate_refs="$candidate_refs $(echo ${version#*-} | sed 's/[-.]/ /g')"
  fi

  for candidate_ref in $candidate_refs; do
    ref=$(git rev-parse --verify "$candidate_ref" 2>/dev/null || echo "")
    if ! [ -z "$ref" ]; then
      break
    fi
  done

  if [ -z "$ref" ]; then
    echo "Could not find source commit for version $version; trying HEAD."
    ref=HEAD
  fi
fi
git checkout "$ref"

# Build package
"$SCRIPT_DIR/build-package.sh" "$package" . "$outdir"
