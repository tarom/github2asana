# Github2Asana

Github の Issues から Asana にコピーする何か

## インストール

```
bundle install --path vendor/bundle
```

## コンフィグ

サンプルは以下の通り。トップのキーは必須

```yaml
github:
  token: '00000change_me00000'
  milestone_id: 1
  repos: 'testrepos'
asana:
  token: '00000change_me00000'
  tag_id: 0000000000
  project_id: 0000000000
assignees:
  hogepiyo: 0000000000
```

## 実行

```
bundle exec ./github2asana.rb
```
