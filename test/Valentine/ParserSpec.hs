{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE RankNTypes #-}
module Valentine.ParserSpec where
import Valentine.Parser (parseStringTrees)
import Valentine.Parser.VDom.Live (parseLiveDom)
import qualified Data.Tree as Tree
import Data.Monoid ((<>))
import Control.Lens 
import           Text.Trifecta.Result
import           LiveVDom.Adapter.Types
import           LiveVDom.Types
import Language.Haskell.TH (nameBase)

import Text.Trifecta.Parser 


type Test = (String, IO Bool)

makeTest :: String -> IO Bool -> Test
makeTest str ioTest = (str, ioTest)


runTests :: [Test] -> IO () 
runTests [] = return () 
runTests (test:tests) = do
  (str, rslt) <- sequence test
  if rslt
     then return ()
     else fail str


assertEqual :: forall a .  (Eq a,Show a) => a -> a -> IO Bool
assertEqual v1 v2
  |v1 == v2 = return True
  |otherwise = do
       putStrLn $ show v1  ++ (" does not equal ") ++  show v2
       return False





testParseStringTrees = [makeTest "check for parser equality"  $  assertEqual multiDivNoWhiteSpace multiDivWithWhiteSpace
                       ,makeTest "check that it isn't nothing" $ not <$> assertEqual multiDivNoWhiteSpace Nothing]
      where
           makeSpace i = replicate i ' '
           newline = "\n"
           whiteSpace i = makeSpace i  <> newline
           div = "<div>"
           multiDivNoWhiteSpace   = testParser $ div <> newline <>
                                                     makeSpace 5 <> "test" <> newline <>
                                                         makeSpace 10 <> div <> newline <>
                                                            makeSpace 15 <> "test" <> newline <>
                                                         makeSpace 10 <> div <> newline <>
                                                            makeSpace 15 <> "test" <> newline




           multiDivWithWhiteSpace = testParser $ div <> newline <>
                                                   makeSpace 5 <> "test" <> newline <>
                                                        makeSpace 10 <> div <> newline <>
                                                           whiteSpace 12 <>                                                
                                                           whiteSpace 12 <>
                                                              makeSpace 15 <> "test" <> newline <>
                                                        makeSpace 10 <> div <> newline <>
                                                           whiteSpace 12 <>                                                
                                                           whiteSpace 12 <>
                                                              makeSpace 15 <> "test" <> newline






testParser :: String -> Maybe ([PLiveVDom])
testParser str = do
  (Success rslt ) <-  parseLiveDom str
  return rslt


