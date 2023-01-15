# Bitbucket to GitHub Migration Scripts

Migrate all your repositories from Bitbucket to GitHub.

## Migrate Repos to GitHub

The format of the CSV created by the `list_bitbucket_repos.sh` is not the same
as the one required to migrate. See `example_migrate_repos.csv` for the migrate
format. Make sure you do not have any commas in any of the columns since
the script will not escape them and things will break.

Requires the [GitHub CLI](https://cli.github.com/).

```bash
$ ./migrate_repos_to_github.sh example_migrate_repos.csv
```

## List Bitbucket Repos

This will help you make a list of repositories to build your import CSV.

```bash
$ ./list_bitbucket_repos.sh > bb_repos.csv
```

## Bulk Scripts

In the `bulk_scripts` folder I've included some other potentially helpful
scripts.

Based on https://github.com/tinkertanker/bitbucket-github-migration.
