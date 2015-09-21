{-# LANGUAGE TemplateHaskell #-}

module Valentine.ParserSpec where

import Valentine.Parser.VDom (parseVNodeS)

import Data.Monoid ((<>))
import Control.Lens 
import           Text.Trifecta.Result
import           LiveVDom.Adapter.Types
import Language.Haskell.TH (nameBase)

makeLensesFor [(nameBase 'vNodePropsList , "_" <> nameBase 'vNodePropsList) ] ''VNodeAdapter 
makePrisms ''VNodeAdapter

type ValidTest =  (String, Bool)

assert :: ValidTest -> Either String Bool
assert (str, rslt)  = if rslt
                  then Right True
                  else Left str

valentineParserSpec :: [Either String Bool]
valentineParserSpec = assert <$> allTests 
 where
  allTests = [ testParseVNodeS
             , testDontParseBrokenVNodeS
             , testParseVNodeWithProp] 


-- Inputs
simpleDivDiv = "<div class=\"panel\"> \n  here is a parsed thing with not much going on"
simpleDivDivBroken = "<div here is a parsed thing with not much going on"


-- Test General Parsing Property


testParseVNodeS :: ValidTest 
testParseVNodeS = ("Error Parsing Vnode on " <> simpleDivDiv , vnodeParserTester simpleDivDiv)
 where
  vnodeParserTester str = maybe False (const True) $ parseVNodeS str ^? _Just . _Success


testDontParseBrokenVNodeS :: ValidTest 
testDontParseBrokenVNodeS = ("Error Parsing Vnode on " <> simpleDivDivBroken , vnodeParserTester simpleDivDivBroken)
 where
  vnodeParserTester str = maybe True (const False) $ parseVNodeS str ^? _Just . _Success






testParseVNodeWithProp :: ValidTest 
testParseVNodeWithProp = ("Error Parsing Vnode class on " <> simpleDivDiv , vnodeParserTester simpleDivDiv)
 where
  vnodeParserTester str = not $ nullOf ( _Just . _Success .folded . _vNodePropsList ) (parseVNodeS str)
