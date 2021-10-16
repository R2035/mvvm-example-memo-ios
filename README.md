# mvvm-example-memo-ios

MVVMのサンプル用のメモアプリ

## アプリ概要

### レイアウトと機能の策定

- MVVMのサンプルアプリなのでレイアウトは標準パーツを多用して簡素にした。
- ネットワークがなくても動作確認できるようにAPI通信ではなくDBを使うメモアプリにした。

### 画面構成

### A01 メモ一覧

- DBから取得したメモの一覧を表示する。
   - メモ一覧はDBの更新に追従する。
- 画面上部のUISearchControllerでメモの本文のインクリメンタルサーチを行う。
- 画面上部の+ボタンをタップすると`A02 メモ編集`に遷移する。
- UITableViewのCellをタップすると`A02 メモ編集`に遷移する。

### A02 メモ編集

- メモの本文の入力を行う
- 画面上部の保存ボタンをタップするとメモの新規作成または上書き更新を行い、`A02 メモ編集`に戻る。
  - `A01 メモ一覧`の画面上部の+ボタンをタップして遷移してきた場合はメモの新規作成を行う。
  - `A01 メモ一覧`のUITableViewのCellをタップして遷移してきた場合は選択したCellで表示していたメモの上書き更新を行う。
- 画面上部のゴミ箱のアイコンのボタンをタップするとメモの削除を行い、`A02 メモ編集`に戻る。

## 対応OS

- iOS 15以上

## 開発環境

- Xcode 13

## ライブラリ

ライブラリは全てCocoaPodsで管理している。

### 初期設定

リポジトリをCloneしたらアプリをビルドするために以下が必要になる。

rbenvを使って.ruby-versionで指定されているバージョンのRubyをインストールする。

MacにBundlerがインストールされていない場合はBundlerをインストールする。

Gemfileが置かれているディレクトリで以下を実行してCocoaPodsをインストールする。

```sh
$ bundle install
```

Podfileが置かれているディレクトリで以下を実行してライブラリをインストールする。

```sh
$ bundle exec pod install
```

### 使用ライブラリ一覧

|ライブラリ|用途|
|--------|----|
|[RealmSwift](https://github.com/realm/realm-cocoa)|DB|
|[Reusable](https://github.com/AliSoftware/Reusable)|UITableViewのセルの再利用処理の実装の省力化|
|[SnapKit](https://github.com/SnapKit/SnapKit)|レイアウト実装の省力化|
|[SwiftFormat/CLI](https://github.com/nicklockwood/SwiftFormat)|コードフォーマット|
|[SwiftGen](https://github.com/SwiftGen/SwiftGen)|文字などのリソースの取り扱いの省力化|
|[SwiftLint](https://github.com/realm/SwiftLint)|Lint|
|[Swinject](https://github.com/Swinject/Swinject)|DI|

## アーキテクチャ

### MVVM

ViewModel → RepositoryのLayered Architectureを採用している。

#### ViewModel

ViewModelが外部に公開するのは以下の2つだけにする。

- ViewControllerへのOutputであるAnyPublisher 
- ViewControllerからのInputである返り値を持たないfunc

#### Repository

Repositoryはprotocolを定義して、protocolをViewModeにInjectすることで疎結合を保証する。

Repositoryのprotocolは特定のライブラリに依存しないようにする。

## マルチモジュール

以下の2つのモジュールに分けている。

### アプリモジュール

ViewModel以上のものを配置している。

### Coreモジュール

Repository以下のものを配置している。

Repositoryのprotocolはpubicにしてアプリモジュールから参照できるようにする。

特定のライブラリに依存する実装はinternalにしてアプリモジュールから参照できないようにする。