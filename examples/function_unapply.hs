-- ScalaでいうExtractor
-- パターンマッチでMaybeモナドの文脈から値を抽出する
unapply :: Num a => Maybe a -> a
unapply (Just x)  = x
unapply Nothing   = 0

-- e.g.
-- > unapply (Just 10)
-- 10
-- > unapply Nothing
-- 0
