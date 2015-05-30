# Haskellの関数型っぽいこと

## ループのない世界の繰り返し処理

Haskellの世界にはforやwhileのようなループはありません。

それでは他の言語のようにループを扱いたい場合はどうするのかというと、  
リストのような連続したデータを処理するのには、再帰関数とパターンマッチを使います。  
これについてはいくつか例を見て、やり方を体得するのが近道だと思います。

### 繰り返しを伴う関数の例

```
-- mySum リストの値を合計する関数
-- Num クラスの値aのリストを引数にしてIntの値を返す。
mySum :: Num a => [a] -> a
-- リストが空のリストなら0を返す。
-- リストが先頭と残りの部分のリストに分けられるなら、残りの部分のリストのmyLengthに先頭の値を加えた値を返す。
mySum []     = 0
mySum (x:xs) = x + mySum xs
```

```
-- myLength リストの数を数える関数
-- 任意の型aのリストを引数にしてIntの値を返す。
myLength :: [a] -> Int
-- リストが空のリストなら0を返す。
-- リストが先頭と残りの部分のリストに分けられるなら、残りの部分のリストのmyLengthに1を加えた値を返す。
myLength []      = 0
myLength (_:xs)  = 1 + myLength xs
```

```
-- myAvg リストの値を平均する関数
-- 足し算と割り算ができるクラスの値aを使い、[a]のリストからMaybe a型の値を返す。
myAvg :: (Num a, Fractional a) => [a] -> Maybe a
-- リストが空のリストの場合は（平均値を取れないので）Nothingを返す。
-- リストが空でなければ、リストの合計からリストの長さを割った値を返すが、返す型はMaybe a型のため
-- Maybe a型に変換するためJustにした値を返す。
myAvg [] = Nothing
myAvg x  = Just (mySum x / fromIntegral (myLength x))
```

## さまざまな高階関数

こちらもあまり他の言語では使う機会のない、高階関数の例を紹介します。

### 高階関数とは
関数の使い方の中で、 `(+)` という関数を使う例を紹介しました。

```
Prelude> (+) 2 1
3
```

ここで、(+) という関数をみると、この関数は２つの変数をとって値を返しているようにみえます。
しかしHaskellの関数は、原則として値を１つしかとりません。

というのはつまり

```
(+) 2 1
```

これは実際には、１つずつ順番に値が適用されています。

```
((+) 2) 1
```

このコードをJavaScriptにすると、次のようなコードと同じです。

```
// JavaScript
var plus = function(x) {
  return function(y){
    return x + y;
  }
};

plus(2)(1); // 3
```

`plus`という関数は、「xと引数の和を返す関数」を返すようになっています。  
（ややこしいですね・・ちなみに、 `plus` のような、関数を返す関数を作れるようにすることを*カリー化*と呼びます。）  

このような関数を返す関数とか、後に述べる関数を引数にする関数は**高階関数**と呼ばれます。

### 部分適用

`(+) 2` のように、一部の値のみを適用することを**部分適用**といいます。  
これに対して `(+) 2 1` のように、本来とる値をすべて適用することを**完全適用**と呼びます。

そして、関数は値になれるので `((+) 2)` の部分を取り出してみることもできます。

```
Prelude> let plusTwo = ((+) 2)
Prelude> plusTwo 1
3
```

というように、 `plusTwo` というのをまた関数として使うようになっています。

これもJavaScriptにすると、先ほどの `plus` を使って以下のように表せます。

```
// JavaScript
var plusTwo = plus(2); // 関数から関数を返している
plusTwo(1); // 3
```

### 関数を引数にする関数

高階関数には他にも、関数を引数としてとる関数もあります。

例としてリストの各要素を２倍することを考えてみましょう。  
`fmap` という関数と、ラムダ式を使って以下のように書くことができます。

```
Prelude> fmap (\x -> x * 2) [1,2,3]
[2,4,6]
```

これは、JavaScriptにすると以下のように書けます。

```
// JavaScript
[1,2,3].map(function(x) { return x * 2; }); // [2, 4, 6]
```

Haskellの `fmap` も、JavaScriptの `map` も同じですが、関数を引数にとっていますね。  
こうしたものも高階関数の一種です。


## モナドとdo記法

Haskellでよく難しいと言われるものがモナドですが、
モナドってなんでしょうか？

まず、形式的な話にすると、Haskellのモナドは単に型クラスの１つにすぎません。

```
Prelude> :info Monad
class Applicative m => Monad (m :: * -> *) where
  (>>=) :: m a -> (a -> m b) -> m b
  (>>) :: m a -> m b -> m b
  return :: a -> m a
  fail :: String -> m a
  	-- Defined in ‘GHC.Base’
instance Monad (Either e) -- Defined in ‘Data.Either’
instance Monad [] -- Defined in ‘GHC.Base’
instance Monad Maybe -- Defined in ‘GHC.Base’
instance Monad IO -- Defined in ‘GHC.Base’
instance Monad ((->) r) -- Defined in ‘GHC.Bas’
```

いろいろありますが、重要なのは次の２つです。

`return` は、モナドの文脈に持ち上げるものです。  
`(>>=)` はbindと呼ばれるもので、モナドの文脈に持ち上げる関数を、すでにモナドの文脈にある値に対して適用するものです。
・・・といっても意味不明ですね。

ここではとりあえずMaybeモナドを使って解説します。

### Maybe モナド

モナドの例として、一番分かりやすいMaybeモナドを見てみましょう。  
Maybeモナドは失敗する可能性のある値を扱うモナドです。

例えば、次のように使うことができます。
これは整数値のみ2で割ることの出来る関数です。

[maybe.hs](examples/maybe.hs)
```
myHalf :: Integral a => a -> Maybe a
myHalf x
  | (mod x 2) == 0 = Just (div x 2)
  | otherwise      = Nothing
```

使用すると次のようになります。

```
*Main> myHalf 2
Just 1

*Main> myHalf 3
Nothing
```

※Haskellだからよくわからん、みたいな人のために、  
たぶんもっと慣れているであろうPHPによるMaybeモナドの実装例も用意しました→  [Maybe.php](Maybe.php)

これを元に、 `return` と `bind` について解説します。

### return

`return` とは、モナドの文脈に持ち上げるための関数です。
といってもよくわからないと思いますが、PHPの例を見るとわかるようなコンストラクタのようなものとも言えます。

Maybeの場合、`Just x` や `Nothing` が `return` に相当するものです。

### bind


先ほどの`myHalf`は半分にする関数なので、1/4にするためには２回この関数を適用すればよさそうです。
しかしそのままこれを適用しようとすると次のようにエラーがでます。

```
*Main> myHalf myHalf 8

<interactive>:35:1:
    Couldn't match expected type ‘Integer -> t’
                with actual type ‘Maybe (a0 -> Maybe a0)’
    Relevant bindings include it :: t (bound at <interactive>:35:1)
    The function ‘myHalf’ is applied to two arguments,
    but its type ‘(a0 -> Maybe a0) -> Maybe (a0 -> Maybe a0)’
    has only one
    In the expression: myHalf myHalf 8
    In an equation for ‘it’: it = myHalf myHalf 8
```

これは `myHalf` が`a` 型を入力として、`Maybe a` 型の値を返す関数だからです。
`Maybe a` 型から `Maybe a` 型を返す関数を別に作ればよさそうですが、ちょっと不便そうです。

bindを使うと、以下のように解決できます。

```
*Main> myHalf =<< myHalf 8
Just 2
```

これだったら何回でも適用できそうです。

```
*Main> myHalf =<< myHalf =<< myHalf 8
Just 1

*Main> myHalf =<< myHalf =<< myHalf =<< myHalf 8
Nothing
```

このように、bindはモナドの文脈にある値に結合の仕組みを与えるものです。



