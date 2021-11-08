#!/bin/bash

# Non-zero exit code if anything fails
set -e

SOURCE_BRANCH="main"
TARGET_BRANCH="gh-pages"

# No pull requests and commits to other branches
if [[ "$TRAVIS_PULL_REQUEST" != "false" || "$TRAVIS_BRANCH" != "$SOURCE_BRANCH" ]]; then
    echo "Skipping deploy (pull request or different branch)"
    exit 0
fi

REPO=$(git config remote.origin.url)
SSH_REPO=${REPO/https:\/\/github.com\//git@github.com:}
SHA=$(git rev-parse --verify HEAD)

# Create an empty branch if gh-pages doesn't exist
git clone "$REPO" out
git -C out checkout "$TARGET_BRANCH" || git -C out checkout --orphan "$TARGET_BRANCH"

# To count original files
LIST_ORIGINAL=(out/*)

# Remove existing contents
mv -v out/site site_out
mv -v out/wiki wiki_out
mv -v out/highlight highlight_out
mv -v out/.git .git_out
mv -v out/index.html .
mv -v out/.gitignore .
mv -v out/Makefile Makefile_out
rm -rf out
mkdir out
mv -v site_out out/site
mv -v wiki_out out/wiki
mv -v highlight_out out/highlight
mv -v .git_out out/.git
mv -v index.html out
mv -v .gitignore out
mv -v Makefile_out out/Makefile
touch out/.nojekyll

# Copy the PDFs (built earlier by .travis.yml / make)
cp -v zsdoc/pdf/*.pdf out

# To count new files
LIST_NEW=(out/*)

### CD ###
cd out

# No changes?
if git diff --quiet --exit-code && [[ "${#LIST_ORIGINAL}" -eq "${#LIST_NEW}" ]]; then
    echo -- "<- ${LIST_ORIGINAL[*]}"
    echo -- "-> ${LIST_NEW[*]}"
    echo "NO CHANGES, exiting"
    exit 0
fi

# Now let's go have some fun with the cloned repo
git config user.name "Salvydas Lukosius [Travis CI]"
git config user.email "$COMMIT_AUTHOR_EMAIL"

# Commit the new files
git add -A .
git commit -m "GitHub Pages deploy: ${SHA}"

# Get the deploy key by using Travis's stored variables to decrypt deploy_key.enc
ENCRYPTED_KEY_VAR="encrypted_${ENCRYPTION_LABEL}_key"
ENCRYPTED_IV_VAR="encrypted_${ENCRYPTION_LABEL}_iv"
ENCRYPTED_KEY="${!ENCRYPTED_KEY_VAR}"
ENCRYPTED_IV="${!ENCRYPTED_IV_VAR}"

#openssl aes-256-cbc -K $ENCRYPTED_KEY -iv $ENCRYPTED_IV -in ../share/deploy_key.enc -out ../share/deploy_key -d
chmod 600 ../share/deploy_key
eval "$(ssh-agent -s)"
ssh-add ../share/deploy_key

echo
ls -1
echo

# Push to GitHub, without --force, it shouldn't be needed
git push "$SSH_REPO" "$TARGET_BRANCH"

rm -f ../share/deploy_key

mail -s "The Zinit deploy done on $(date '+%m/%d/%Y')" sall@w-ss.io <<<'The deploy has been done'
