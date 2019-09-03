# autotest-atcoder

Windows向けの簡単なテストツールです。  
サンプルケースの取得、コンパイル、取得したケースに対するテストを自動で行います。

## Screenshot

![screenshot](https://user-images.githubusercontent.com/45958851/64147770-7367b400-ce5c-11e9-8870-04f3bf13b648.png)

## Dependencies

- gcc (>= 5.2)
- curl

## Installation

ダウンロードしたフォルダを適当な場所に配置して、パスを通してください。

## Usage

適当なディレクトリで

```sh
$ atcoder [問題のURL]
```

を実行すると、

```
.
├─ test
│   └─ [ID].txt  \\ 入力･出力サンプル
├─ bin
|   └─ [ID].exe
|
└─ [ID].cpp
```

が自動で作成され、テストが行われます。

### test\\[ID].txt

空行区切りで入力と出力が記入されています。

```
[入力例1]
-- 空行 --
[出力例1]
-- 空行 --
[入力例2]
   ⋮
[出力例x]
-- 空行 --
```

新たにテストケースを追加したい場合は、同じ形式で追記してください。

### [ID].cpp

テンプレートを変更したい場合は、`autotest-atcoder\config\template.txt`を編集してください。
