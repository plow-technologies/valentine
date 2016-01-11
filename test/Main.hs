module Main where

import Valentine.ParserSpec
import Data.Either (lefts)
import Data.List (null)
-- main :: IO ()
-- main = if null allTestSuites
--        then print ("All Tests Passed" :: String)
--        else (putStrLn . unwords $ allTestSuites )*>
--             fail ("Error, some tests failed" :: String)
--  where
--    allTestSuites = lefts.concat $ [valentineParserSpec] ::[String]


main :: IO ()
main = return ()