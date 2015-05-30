-- ゼロかどうかを返す関数
-- Eq クラスかつNum クラスの値をaとして、aを引数にとりBoolを返す関数
-- 引数が0なら
isZero :: (Eq a, Num a) => a -> Bool
isZero 0 = True
isZero _ = False

-- 絶対値を返す関数
-- Ord クラスかつNum クラスの値をaとして、aを引数にとりaを返す関数
-- 引数nが0以上ならnを返す。nが0以下なら-nを返す
myAbs :: (Ord a, Num a) => a -> a
myAbs n
  | n >= 0 = n
  | n < 0  = -n
