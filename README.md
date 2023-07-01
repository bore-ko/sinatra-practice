# メモアプリ

bundle installコマンドでインストールする

```
bundle install
```

保存先のDB `memos`

テーブルを定義するSQL文
```
CREATE TABLE memos 
(id serial,
title VARCHAR(100) NOT NULL,
content VARCHAR(1000),
PRIMARY KEY (id));
```

プログラムを実行する
```
ruby memo.rb
```
ブラウザで http://localhost:4567 にアクセスします。

`Ctrl`キーを押しながら`C`キーを押すことでプログラムを終了できます。
