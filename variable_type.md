# Haskellの基本: 変数と型・型クラス

## 変数と値

`a` という変数に値を代入してみます。

```
Prelude> let a = 3
```

出力してみましょう。

```
Prelude> a
3
```

3と表示されますね。

### 数値

数値が使えます。見ての通りです。

```
Prelude> let number = 1
Prelude> number
1
```

数値の中にもいろいろ型がありますが、後ほど説明します。

### 文字列

文字列です。これも見ての通り。

```
Prelude> let hoge = "fuga"
Prelude> hoge
"fuga"
```

### リスト

ほかの言語でいうリストも扱えます。リストは `[]` を使います。

```
Prelude> let l1 = [1,2,3]
Prelude> l2
[1,2,3]
```

リストの値は次のように `..` で省略して記述することもできます。

```
Prelude> let l2 = [1 .. 10]
Prelude> l2
[1,2,3,4,5,6,7,8,9,10]
```

他にもリストの定義の仕方はあります。  
例えば、以下の方法はリスト内包表記という方法です。  
（`l3` というリストは `x * 10` という要素からなり、 `x` は `[1 .. 10]` からなるという意味）

```
Prelude> let l3 = [ x * 10 | x <- [1 .. 10]]
Prelude> l3
[10,20,30,40,50,60,70,80,90,100]
```

リストに対して使えるメソッドはいろいろあります。

```
Prelude> sum l2
55

Prelude> take 3 l2
[1,2,3]

Prelude> drop 3 l2
[4,5,6,7,8,9,10]

Prelude> reverse l2
[10,9,8,7,6,5,4,3,2,1]

Prelude> zip l1 l2
[(1,1),(2,2),(3,3)]

Prelude> map (*2) l2
[2,4,6,8,10,12,14,16,18,20]
```

リストは結構重要になるので、覚えておいてください。

### タプル

リストの他に、タプルというものもあります。タプルは値の組です。  
リストの場合は要素の数に対する制約がないのに対して、タプルの場合は要素が有限個である必要があります。

```
Prelude> let tup = (1,3)
(1,3)
```

異なる型の値をもつこともできます。

```
Prelude> let tup2 = (1,"hoge")
(1,"hoge")
```

### 参照透過性：代入した値は変更できない

一度代入した値を再代入することはできません。  
この性質があるので、プログラムのどこでも変数の値は同じになります。（値は変わらないので、変数ではなく定数ですね。）  
変数ではないので、これを変数の束縛というみたいです。

この性質を「参照透過性」といいます。

試しに `a` という値を定義した後で書き変えてみると

```
Prelude> let a = 3
Prelude> a = 2

<interactive>:7:3: parse error on input ‘=’
```

このように、エラーになってしまいます。

こんなんでプログラミングできるの？と思うかもしれませんが、関数プログラミングなりのアプローチがあります。  

## 型

ここまでなんとなく型という用語を出しています（まあ知ってると思うけど...）が、  
Haskellにおいて型はとっても重要なので、型について説明します。

#### 静的型付けと動的型付け

Haskellの特徴を説明するにあたって、**静的型付け** と **動的型付け** については最低限知っておく必要があるので、簡単に説明します。

静的型付けとは、プログラムの実行以前に型を解析しておく言語です。

C言語, Objective-C, C++, Java, C#, F#, Scala, Goなどは静的型付け言語です。

以下はC言語の例です。

```
#include <stdio.h>

int main(void) {
	int hogeValue = 1; // プログラムの実行前に型を知る必要があるので、このように int と型を指定してあげなければいけない
	printf("hogeValue is %d", hogeValue);

	return 0;
}
```

一方、PHPのように、実行時に型が解析されるものは**動的型付け**言語と言われます。  
動的型付け言語には、PHPのほかPerl,Python,RubyなどのLL言語（Lightweight Language）や、JavaScript, Groovy, Clojureなどの言語があります。

```
<?php
$hogeValue = 1; // integer型であることは実行時にわかる
echo "hogeValue is {$hogeValue}";
```

### Haskellの型付け

さて、Haskellの話に戻りましょう。

Haskellは**静的型付け**言語です。

型を指定して代入するときは、以下のように `let <変数名> = <値> :: <型>` とします。

```
Prelude> let intVal = 1 :: Int;
Prelude> intVal
1
```

型は `:type` を使って確認することができます。

```
Prelude> :type intVal
intVal :: Int
```

`intVal` という変数がInt型であることを示しています。

Haskellの型には、例えばこういうものがあります。

- Bool （真偽値）
- Int （固定長整数）
- Integer （多倍長整数）
- Float （単精度浮動小数点数）
- Double （倍精度浮動小数点数）
- Rational （有理数）
- Char （文字）
- String （文字列）


### 型推論

しかし、最初の例 `let a = 3` では、C言語のように `int a` などと型を指定はしていません。  
Haskellには型推論という仕組みがあり、型をintなどと明示的に指定しなくても、その前後の関係から型を推測できる仕組みがあります。

C#, Scala, Swift, Goなどの言語にもあり、型を指定しなくてもプログラムのコンパイル時に型を特定できるようになっています。

試しに、`boolVal`という値を作って、その型を調べてみましょう。

```
Prelude> let boolVal = True
Prelude> :type boolVal
boolVal :: Bool
```

`boolVal` はBool型であることがわかります。


### 多相型

空のリストの型を調べてみましょう。

```
Prelude> :type []
[] :: [t]
```

ここでどこからともなく `[t]` というものが登場しています。  
この `t` というのは型パラメーターで、任意の型を取ることができることを示しています。

こうした型パラメーターを取ることができる型を多相型といいます。

C++ でいうテンプレート、Javaでいうジェネリクスのようなものだと考えてください。  

多相型は具体的な値を入れると型推論により具体的な型パラメータが決まります。  

```
Prelude> :type [True, False]
[True, False] :: [Bool]
```

以下のように、明示的に多相型内部の型パラメータを指定しておくこともできます。

```
Prelude> let list =  [] :: [Bool]
Prelude> :type list
list :: [Bool]
```

## 型クラス

### 最初の例をもう一度

最初に `let a = 3` のような形で変数に値を束縛しました。

```
Prelude> let a = 3
Prelude> :type a
a :: Num a => a
```

`Bool` とか `Int` みたいな単純な型ではなく、 `a :: Num a => a` という謎の表示になります。

関数の部分でも説明しますが、これは`a`という変数が`a`という関数を持っており  
`a` という関数が、 `Num a` という値を引数にして、 `a` という値を返すということを表しています。

また `Num` というのは型クラスと呼ばれるものの一種です。

この型クラスという概念はScalaにもありますが、ほかの言語ではあまりなじみのない概念だと思いますので、少し説明しましょう。

### 型クラスとは何者か？

型クラスとは、型に共通する性質をインターフェイスとして定義したものです。  
... なんて言ってもよくわからないので、具体例をみてみましょう。

例えば、 `Num` は名前から数値っぽいものだということがわかりますが、  
これは「足し算、引き算、掛け算、符号反転、絶対値などが定義されている」という数値の基本的な性質を表す型クラスです。

`:info` で型クラスの定義を調べることができるので、見てみましょう。

```
Prelude> :info Num
class Num a where
  (+) :: a -> a -> a
  (-) :: a -> a -> a
  (*) :: a -> a -> a
  negate :: a -> a
  abs :: a -> a
  signum :: a -> a
  fromInteger :: Integer -> a
  	-- Defined in ‘GHC.Num’
instance Num Word -- Defined in ‘GHC.Num’
instance Num Integer -- Defined in ‘GHC.Num’
instance Num Int -- Defined in ‘GHC.Num’
instance Num Float -- Defined in ‘GHC.Float’
instance Num Double -- Defined in ‘GHC.Float’
```

`Num` 型クラスで使える関数（演算）が `where` 以下で定義されています。

例えば、 `(+) :: a -> a -> a` は、 `(+)` という関数が、 `Num` 型の値と別の `Num` 型の値を与えると、  
`Num` 型の値を返す関数として定義されていることを示しています。

関数の章であらためて説明します。

試しにその通りにやってみましょう。

```
Prelude> (+) 2 3
5
```

これはもちろん、普通の言語のように `2 + 3` と書くことも可能なのですが、  
Haskell ではこうした演算子も関数として定義されているので、上記のようなことが可能になります。
（逆ポーランド記法というやつです）

ほかの例もいくつかみてみましょう。

```
Prelude> (-) 3 2
1

Prelude> abs 3
3

Prelude> abs (-3)
3

Prelude> negate 9
-9
```

`:info Num` の後半では、`Num` 型クラスを実装した具体的な型が説明されています。

```
instance Num Word -- Defined in ‘GHC.Num’
instance Num Integer -- Defined in ‘GHC.Num’
instance Num Int -- Defined in ‘GHC.Num’
instance Num Float -- Defined in ‘GHC.Float’
instance Num Double -- Defined in ‘GHC.Float’
```

`Word , Int, Integer, Float, Double` など、さまざまな数値型はすべて `Num` 型クラスを実装した型というわけです。

PHPやJavaのような言語でいうと、型クラスはインターフェイス、型はクラスに対応しているようなイメージです。

### 主要な型クラスの例

- Eq （比較可能）
- Ord （順序付け可能）
- Show （表示可能）
- Read （読み込み可能）
- Num （基本的な数値演算が可能）
- Integral （整数の割り算が可能）
- Fractional （分数の割り算が可能）


### 最初の例は

さて、あらためて最初の例に戻りましょう。

```
Prelude> let a = 3
Prelude> :type a
a :: Num a => a
```

なぜこのような表示になるのかというと、 `a` という変数は `3` という値なわけですが、  
それだけだと、型推論では `Int` なのか `Double` なのか判別することはできません。

それだけで型が決まらないことによりエラーとしてしまうと、型推論があるのに使いにくい言語となってしまいます  
Haskellではこのように、少なくとも `Num` 型クラスの何かの型、というように扱っています。

`Num` 型クラスを実装したほかの型と演算をすることで、具体的な型クラスが初めて決まります。

```
Prelude> let a = 3
Prelude> :type a
a :: Num a => a

Prelude> let i :: Integer; i = 3
Prelude> :type a + i
a + i :: Integer
```

`a + i` は `Integer` 型になっていますね。

一方で、 `Double` 型との足し算をしてみると

```
Prelude> let j :: Double; j = 3
Prelude> :type a + j
a + j :: Double
```

`a + j` は `Double` 型になるのがわかります。

## 型をつくる

この辺の型や型クラスの仕組みを使いつつ、自分で新しい型を作ることができます。

### 既存の型から型を作る

```
Prelude> type PersonNumber = Int
Prelude> let John = 1 :: PersonNumber
Prelude> John
1
```

これは元々あった `Int` 型に対して、 PersonNUmber という新しい別名で型を宣言しています。

### 自分で新しい型を定義する

既存の型を作るだけでなく、自分で新しい型を定義することもできます。  
以下は性別を表現する `Sex` 型を定義する例です。

```
Prelude> data Sex = Male | Female deriving(Eq, Show)

-- このように使える
Prelude> let someone = Male :: Sex
Prelude> someone
Male

-- bobとjaneは性別が違うので、イコールにならない
Prelude> let bob = Male :: Sex
Prelude> let jane = Female :: Sex
Prelude> bob == jane
False
```

複数の型からデータ型を作ることもできます。  
以下は先ほどの `Sex` と `Name` `Age` 型を使い `Person` 型を作る例です。

```
Prelude> type Name = String
Prelude> type Age  = Int
Prelude> data Person = Person { name :: String, age :: Age, sex :: Sex } deriving Show
```

Haskellでは型検査が行われるので、このようにして目的に特化した型を用意することで、  
エラーの少ないプログラムを書きやすくすることが可能になります。


