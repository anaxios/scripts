#!/usr/bin/env stack
-- stack --resolver lts-10.2 script
{-# LANGUAGE OverloadedStrings #-}
import Turtle

main = do
    echo "Hello, world."
    shell "shasum -a 256" "doop.hs"