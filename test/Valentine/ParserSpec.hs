{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE QuasiQuotes #-}

{-# LANGUAGE OverloadedStrings #-}

module Valentine.ParserSpec where
import Valentine.Parser (parseStringTrees, parseLineForest, ParsedTree(..),parseLines)
import Valentine.Parser.VDom.Live (parseLiveDom,parsePLiveVDom)
import qualified Data.Tree as Tree
import Data.Monoid ((<>))
import Control.Lens
import Debug.Trace (traceShow)
import           Text.Trifecta.Result
import           Text.Trifecta.Parser
import           Text.Trifecta.Delta
import           LiveVDom.Adapter.Types
import           LiveVDom.Types
import Language.Haskell.TH (nameBase)
import           Language.Haskell.TH
import           Language.Haskell.TH.Quote
import           Language.Haskell.TH.Syntax
import Data.String.Here
import Text.Trifecta.Parser 
import Valentine.QQSpec



type Test = (String, IO Bool)

makeTest :: String -> IO Bool -> Test
makeTest str ioTest = (str, ioTest)


runTests :: [Test] -> IO () 
runTests [] = return () 
runTests (test:tests) = do
  (str, rslt) <- sequence test
  if rslt
     then runTests tests
     else fail str


assertEqual :: forall a .  (Eq a,Show a) => a -> a -> IO Bool
assertEqual v1 v2
  |v1 == v2 = return True
  |otherwise = do
       putStrLn $ show v1  ++ (" does not equal ") ++  show v2
       return False



assertEqualIO  v1IO v2IO  = do
   v1 <- v1IO
   v2 <- v2IO
   case () of
     _ 
      |v1 == v2 -> return True
      |otherwise -> do
          putStrLn $ show v1  ++ (" does not equal ") ++  show v2
          return False


testParseStringTrees = [makeTest "check for tree parser equality" $ assertEqualIO (testLineParser quotedStringNoSpaces)
                                                                                  (testLineParser quotedStringSpacesAdded)

--                      , makeTest "check for PLiveDom Equality" $    assertEqualIO (testParser quotedDomNoSpaces) (testParser multiDivNoWhiteSpace)
                       ,makeTest "check that quasi quotes produce right parse" $ assertEqual quotedDomNoSpaces quotedDomSpacesAdded]

quotedDomNoSpaces = [testvalentine|
<div>
  <section id="hello-app">
    <header id="header">
           <div>
                  Hello
               <div>
                 pumpernell
           <div>
              Guffman
|]



quotedDomSpacesAdded = [testvalentine|
<div>
  <section id="hello-app">
    <header id="header">
           <div>
                  Hello



               <div>



                 pumpernell

                 
           <div>
              Guffman
|]

quotedStringNoSpaces = [here|
<div>
  <section id="hello-app">
    <header id="header">
           <div>
                  Hello
               <div>
                 pumpernell
           <div>
              Guffman
|]



quotedStringSpacesAdded = [here|
<div>
  <section id="hello-app">
    <header id="header">
           <div>
                  Hello



               <div>



                 pumpernell


           <div>
              Guffman
|]





testParser :: String -> IO ([PLiveVDom])
testParser str = do
  (Success rslt ) <-  parseLiveDom str
  putStrLn . show $ rslt
  return rslt



testTreeparser :: String -> IO (ParsedTree String)
testTreeparser str = do
   let (Success rslt) =  parseString parseLineForest (Columns 0 0) str
   putStrLn . show $ rslt
   return rslt


testLineParser :: String -> IO ( [(Int,String)])
testLineParser str = do
   let (Success rslt) =  parseString parseLines (Columns 0 0) str
   putStrLn . show $ rslt
   return rslt
