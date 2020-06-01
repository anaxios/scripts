#!/usr/bin/env stack
-- stack --resolver lts-10.2 script
{-# LANGUAGE OverloadedStrings #-}
import Prelude
--import Turtle
import System.Directory
import Data.String
import Data.List
import Data.Char

testList = ["dlfkdjfldfj", "test", "dlfkhdfdfodifh","fhdoheoidfoihsdf","sdofisfosidfhs","test","dlfkdjfldfj", "test", "dlfkhdfdfodifh","fhdoheoidfoihsdf","sdofisfosidfhs","test","dlfkdjfldfj", "test", "dlfkhdfdfodifh","fhdoheoidfoihsdf","sdofisfosidfhs","test","dlfkdjfldfj", "test", "dlfkhdfdfodifh","fhdoheoidfoihsdf","sdofisfosidfhs","test","dlfkdjfldfj", "test", "dlfkhdfdfodifh","fhdoheoidfoihsdf","sdofisfosidfhs","test"]



--findMatching' [] = []
--findMatching' [a] = []
findMatching' :: [String] -> String
findMatching' [] = []
findMatching' (x:xs)
    | elem x theTail = x
    | otherwise = "nothing"
    where theTail = findMatching' xs 

main = print $ findMatching' testList
    
