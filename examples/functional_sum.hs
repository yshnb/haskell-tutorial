-- mySum リストの値を合計する関数
-- Num クラスの値aのリストを引数にしてIntの値を返す。
mySum :: Num a => [a] -> a
-- リストが空のリストなら0を返す。
-- リストが先頭と残りの部分のリストに分けられるなら、残りの部分のリストのmyLengthに先頭の値を加えた値を返す。
mySum []     = 0
mySum (x:xs) = x + mySum xs

-- myLength リストの数を数える関数
-- 任意の型aのリストを引数にしてIntの値を返す。
myLength :: [a] -> Int
-- リストが空のリストなら0を返す。
-- リストが先頭と残りの部分のリストに分けられるなら、残りの部分のリストのmyLengthに1を加えた値を返す。
myLength []      = 0
myLength (_:xs)  = 1 + myLength xs

-- myAvg リストの値を平均する関数
-- 足し算と割り算ができるクラスの値aを使い、[a]のリストからMaybe a型の値を返す。
myAvg :: (Num a, Fractional a) => [a] -> Maybe a
-- リストが空のリストの場合は（平均値を取れないので）Nothingを返す。
-- リストが空でなければ、リストの合計からリストの長さを割った値を返すが、Maybe a型の1つであるJustにして変えす。
myAvg [] = Nothing
myAvg x  = Just (mySum x / fromIntegral (myLength x))

