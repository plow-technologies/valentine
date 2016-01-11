{-# LANGUAGE TemplateHaskell #-}

module Valentine.ParserSpec where
import Valentine.Parser (parseStringTrees)
import Valentine.Parser.VDom.Live (parsePLiveVDom)

import Data.Monoid ((<>))
import Control.Lens 
import           Text.Trifecta.Result
import           LiveVDom.Adapter.Types
import           LiveVDom.Types
import Language.Haskell.TH (nameBase)


-- makeLensesFor [(nameBase 'propertyName , "_" <> nameBase 'propertyName)] ''Property

-- makeLensesFor [(nameBase 'pLiveVNodePropsList, "_" <> nameBase 'pLiveVNodePropsList) ] ''PLiveVDom
-- makePrisms ''PLiveVDom


-- makeLensesFor [(nameBase 'vNodePropsList , "_" <> nameBase 'vNodePropsList) ] ''VNodeAdapter 
-- makePrisms ''VNodeAdapter

-- type ValidTest =  (String, Bool)

-- parseATestString = parseStringTrees parsePLiveVDom 

-- assert :: ValidTest -> Either String Bool
-- assert (str, rslt)  = if rslt
--                   then Right True
--                   else Left str

-- valentineParserSpec :: [Either String Bool]
-- valentineParserSpec = assert <$> allTests 
--  where
--   allTests = [ testParsePLiveVDom] 


-- -- Inputs
-- simpleDivDiv = "<div class=\"panel\">/n  here is a parsed thing with not much going on"
-- simpleDivDiv2 = "<div>/n  here is a parsed thing with not much going on"
-- simpleDivDivBroken = "<div here is a parsed thing with not much going on"


-- -- Test General Parsing Property

-- matchClassName a = "class" == a

-- -- testParseVNodeS :: ValidTest 
-- -- testParseVNodeS = ("Error Parsing Vnode on " <> simpleDivDiv , vnodeParserTester simpleDivDiv)
-- --  where
-- --   vnodeParserTester str = maybe False (const True) $ parseVNodeS str ^? _Just . _Success


-- -- testDontParseBrokenVNodeS :: ValidTest 
-- -- testDontParseBrokenVNodeS = ("Error Parsing Vnode on " <> simpleDivDivBroken , vnodeParserTester simpleDivDivBroken)
-- --  where
-- --   vnodeParserTester str = maybe True (const False) $ parseVNodeS str ^? _Just . _Success

-- -- testParseVNodeWithProp :: ValidTest 
-- -- testParseVNodeWithProp = ("Error Parsing Vnode class on " <> simpleDivDiv , vnodeParserTester simpleDivDiv)
-- --  where
-- --   vnodeParserTester str = anyOf ( _Just . _Success .folded . _vNodePropsList.folded. _propertyName )   matchClassName (parseVNodeS str) 

-- testParsePLiveVDom :: ValidTest
-- testParsePLiveVDom = ("Error Parsing PLiveVDom on " <> simpleDivDiv , parseStringTreeTest simpleDivDiv)
--  where
--   parseStringTreeTest str = anyOf (_Just . _Success .folded. _pLiveVNodePropsList.folded . _propertyName) matchClassName  (parseATestString str)



