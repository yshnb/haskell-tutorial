myHalf :: Integral a => a -> Maybe a
myHalf x
 | (mod x 2) == 0 = Just (div x 2)
 | otherwise      = Nothing
