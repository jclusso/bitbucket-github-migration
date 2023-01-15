#!/bin/bash
WARNING="\e[0;31m⚠\e[0m"
PLUS="\e[0;33m✚\e[0m"
CHECKMARK="\e[0;32m✓\e[0m"

if [[ ! -f $1 ]]; then echo "$1 file not found"; exit 99; fi
(cat "$1" ; echo) | tail -n +2 | tr -d '\r' | while IFS=, read -r bb_repo bb_org gh_repo gh_org description private archive team permission
do
  if [ -z "$bb_repo" ]; then continue; fi # skip empty lines
  echo

  printf "$PLUS Processing $bb_org/$bb_repo ➔ $gh_org/$gh_repo."
  echo
  printf "$PLUS Cloning from Bitbucket."
  git clone --mirror git@bitbucket.org:$bb_org/$bb_repo.git
  cd $bb_repo.git
  echo

  printf "$PLUS $bb_org/$bb_repo cloned, now creating $gh_org/$gh_repo on GitHub with description [$description] and [$permission] permission for [$team].\n"
  PRIVATE_FLAG="--private"
  if [ "$private" = "no" ]; then
    printf "$WARNING $gh_org/$gh_repo will be public!\n"
    PRIVATE_FLAG="--public"
  fi
  if [ -n "$team" ]; then
    TEAM_FLAG="-t $team"
  fi
  if [ -n "$description" ]; then
    DESCRIPTION_FLAG="-d $description"
  fi
  gh repo create "$gh_org/$gh_repo" $TEAM_FLAG $DESCRIPTION_FLAG $PRIVATE_FLAG
  if [ -n "$team" ]; then
    gh api \
      --method PUT \
      -H "Accept: application/vnd.github+json" \
      --silent \
      "/orgs/$gh_org/teams/$team/repos/$gh_org/$gh_repo" \
      -f permission="$permission" &&
      printf "$CHECKMARK Added $permission permissions for $team."
    echo
  fi

  printf "$PLUS Pushing $gh_org/$gh_repo to GitHub."
  git push --mirror git@github.com:$gh_org/$gh_repo.git
  echo

  if [ "$archive" = "yes" ]; then
    echo
    printf "$PLUS Archiving $gh_org/$gh_repo on GitHub.\n"
    gh repo archive $gh_org/$gh_repo -y
  fi

  cd ..
  printf "$PLUS Cleaning up"
  rm -rf $bb_repo.git
  echo
  printf "$CHECKMARK Done"
done
