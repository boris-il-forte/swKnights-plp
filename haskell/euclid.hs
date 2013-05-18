-- Extended Euclid's Algorithm

module Euclid where

    gcd :: (Integral a) => a -> a -> a
    gcd x y = first (euclid x y)
        where first (x, _, _) = x

    euclid :: (Integral a) => a -> a -> (a, a, a)
    euclid x y = euclid' (x, 1, 0) (y, 0, 1)
        where
        euclid' u (0, _, _) = u
        euclid' u v = euclid' v (next u v)
        next (u0, u1, u2) (v0, v1, v2) = 
            let r = u0 `div` v0
            in (u0 - r * v0, u1 - r * v1, u2 - r * v2)
