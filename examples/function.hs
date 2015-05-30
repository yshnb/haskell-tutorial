-- 簡単な関数定義の例

-- plusOneという名前の関数は、Num 型クラスの値aを使う。値aを引数にとり、同じNum 型クラスの値を返す。
-- plusOneが返す値は、引数xに対して+1した値
plusOne :: Num a => a -> a
plusOne x = x + 1

-- powerという名前の関数は、Integral 型クラスの値aとNum 型クラスの値bを使う。
-- Num 型クラスの値aをとり、さらにIntegral 型クラスの値bをとると、最終的に値aを返す。
-- powerは、Num 型クラスの引数xとIntegral 型クラスの引数yを使って、xをy乗した値を返す
power :: (Integral b, Num a) => a -> b -> a
power x y = x ^ y
