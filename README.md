# 📡 twins-notification

筑波大学の[Twins](https://twins.tsukuba.ac.jp/)の掲示板のお知らせを通知してくれるプログラムです。

> [!NOTE]
> このリポジトリは [shuuji3/twins-notification](https://github.com/shuuji3/twins-notification) をフォークして作成されたものです。  
> 手元のmacOS用にプログラムを変更しています。  
> また、一部機能を追加していますが動作を保証するものではありません。

## 環境

- MacBook Pro 14インチ (2021)
	- Apple M1 Pro
	- macOS Sequoia v15.4.1
- Docker version 28.0.4, build b8034c0
- GNU Make 3.81

## 使い方

1. `.env.example`を`.env`にコピーする。
1. `.env`に必要な情報を入力する。
1. `twins-notification.config.yaml`を自分好みに設定する。

### コンテナを使用する場合

```shell
make build
make run
```

### スケジュール実行する場合

cronを使用して、定期的に実行することができます。

ターミナルで以下のコマンドを実行して、cronの設定を開きます。

```shell
crontab -e
```

毎日9時に実行する場合、以下のようにcronを設定します。  
dockerが実行できるように、PATHを指定する必要があります。

```shell
PATH=/usr/local/bin:/usr/bin:/bin
0 9 * * * cd /path/to/twins-notification && make run
```

スケジュールの時間にmacbookをスリープさせていると、通知が届かない場合があります。  
その場合は、スリープを解除するためにpmsetでスリープ解除のスケジュールを設定することができます。

```shell
sudo pmset repeat wake MTWRFSU 08:59:00
```

## ライセンス

[GNU General Public License v3.0](./LICENSE)
