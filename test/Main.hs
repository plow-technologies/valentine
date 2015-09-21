module Main where

import Valentine.ParserSpec
import Data.Either (lefts)

main :: IO ()
main = print . lefts $ allTestSuites
 where
   allTestSuites = concat [valentineParserSpec]
