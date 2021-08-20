# isucon11

## ToDo

### 全体像の理解

* アプリケーションの動作を把握

ブラウザにアクセスして確認

* 使われているミドルウェアの把握

`pstree`, `ps auxw`, `systemctl list-units --type service --all`など

### 環境構築

* リポジトリの準備

アプリが入っている`/home/isucon`以下と各種設定が入っている`/etc`以下をコピっておく

* デプロイ自動化

ローカルで`make deploy`叩くとコード、各種設定がリモートに送られた後、リモートの`init.sh`が実行されて各種サービスが初期化される。

その際、ログを自動でロールバックしておくと良さそう。以下みたいな感じ

```sh
#!/bin/bash
set -ex

if [ -f /var/lib/mysql/mysqld-slow.log ]; then
    sudo mv /var/lib/mysql/mysqld-slow.log /var/lib/mysql/mysqld-slow.log.$(date "+%Y%m%d_%H%M%S")
fi
if [ -f /var/log/nginx/isucon5.access_log.tsv ]; then
    sudo mv /var/log/nginx/isucon5.access_log.tsv /var/log/nginx/isucon5.access_log.tsv.$(date "+%Y%m%d_%H%M%S")
fi
sudo systemctl restart mysql
sudo service memcached restart
sudo systemctl restart isuxi.perl
sudo systemctl restart nginx
```

### 計測

* CPU使用率, Memory, Disk I/Oの把握

`htop`, `vmstat`, `netdata`などを利用

* でかいテーブルの把握

* `alp`の導入

https://nishinatoshiharu.com/install-alp-to-nginx/

* MySQLで`slow-query`の有効化

https://nishinatoshiharu.com/mysql-slow-query-log/

* `pt-query-digest`の導入

https://nishinatoshiharu.com/percona-slowquerylog/

* アプリにCloud Traceの導入

https://cloud.google.com/trace/docs/setup/go

https://opencensus.io/quickstart/go/tracing/

https://github.com/census-instrumentation/opencensus-go

traceしたい部分に以下を書く
```go
	// 3. Create a span with the background context, making this the parent span.
	// A span must be closed.
	ctx, span := trace.StartSpan(context.Background(), "main")
	// 5b. Make the span close at the end of this function.
	defer span.End()
```

以下を使うとhttpリクエストや, sqlクエリの実行回数・時間も計測できるっぽい

https://pkg.go.dev/go.opencensus.io/plugin/ochttp

https://pkg.go.dev/github.com/opencensus-integrations/ocsql


### アプリ最適化

* クエリの改善
    * `SELECT *`を出来るだけなくす

* N+1クエリをなくす
    * 事前に`JOIN`しておく
    * 出来るだけクエリをアプリ側でキャッシュしておく

* DBへのクエリを`goroutine`で並列化する

* 計算時間がかかるアルゴリズムの改善

### DB最適化

* インデックスを作る

* アプリとDBを別サーバーに分ける

* DBのテーブルを複数サーバーに分割

* Buffer Pool Sizeを増やす

https://gist.github.com/south37/d4a5a8158f49e067237c17d13ecab12a#file-03_mysql-md

https://qiita.com/stomk/items/6265e9fdfdfb4f104a7e#%E3%83%81%E3%83%A5%E3%83%BC%E3%83%8B%E3%83%B3%E3%82%B0

### nginx最適化

* ロードバランスの設定
* Unix Data Socketを使う
* 静的コンテンツのキャッシュ
* gzip圧縮
* http2

### OS最適化

* カーネルパラメーター

https://gist.github.com/south37/d4a5a8158f49e067237c17d13ecab12a#%E3%82%AB%E3%83%BC%E3%83%8D%E3%83%AB%E3%83%91%E3%83%A9%E3%83%A1%E3%83%BC%E3%82%BF%E3%83%81%E3%83%A5%E3%83%BC%E3%83%8B%E3%83%B3%E3%82%B0

## 参考文献

* https://gist.github.com/south37/d4a5a8158f49e067237c17d13ecab12a
* [ISUCON予選突破を支えたオペレーション技術](https://blog.yuuk.io/entry/web-operations-isucon)
* [Webアプリケーションの パフォーマンス向上のコツ 概要編](https://www.slideshare.net/kazeburo/isucon-summerclass2014action1)
* [ISUCONで学ぶ Webアプリケーションのパフォーマンス向上のコツ 実践編 完全版](https://www.slideshare.net/kazeburo/isucon-summerclass2014action2final)
