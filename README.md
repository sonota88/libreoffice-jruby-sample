(2021-01-02) JRubyでLibreOffice Calcのfodsファイルを読み書きするサンプル 2021 - memo88  
https://memo88.hatenablog.com/entry/2021/01/02/171445

(2019-12-02) JRubyでLibreOffice Calcのfodsファイルを読み書きするサンプル 2019 - memo88  
https://memo88.hatenablog.com/entry/2019/12/02/230545


# セットアップ

```
wget https://repo1.maven.org/maven2/org/jruby/jruby-dist/9.2.14.0/jruby-dist-9.2.14.0-bin.tar.gz
tar xf jruby-dist-9.2.14.0-bin.tar.gz 
```


# Docker

```
docker build \
  --build-arg USER=$USER \
  --build-arg GROUP=$(id -gn) \
  -t my:libo-jruby-webapi-2021 .
```


# サンプルの実行

```
./jruby.sh sample.rb
./jruby.sh dump.rb sample.fods Sheet1
./jruby.sh dump.rb sample.fods Sheet2
```
