{-# LANGUAGE NoImplicitPrelude #-}

import Prelude ((+), (-))

class Monad m where
	return :: a -> m a

	(>>=) :: m a -> (a -> m b) -> m b


data Either e a =
	Right a |
	Left e

data ComputationalErr = FibonacciError

fibonacci :: Int Either 
