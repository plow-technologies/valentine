
{-# LANGUAGE TemplateHaskell   #-}
{- |
Module      : Valentine.QQSpec
Description : A test parser for valentine
Copyright   : Plow Technologies LLC
License     : MIT License

Maintainer  : Scott Murphy


| -}

module Valentine.QQSpec where


import Valentine.Parser (parseStringTrees)
import Valentine.Parser.VDom.Live (parseLiveDom,parsePLiveVDom)
import qualified Data.Tree as Tree
import Data.Monoid ((<>))
import Control.Lens 
import           Text.Trifecta.Result
import           LiveVDom.Adapter.Types
import           LiveVDom.Types
import Language.Haskell.TH (nameBase)
import           Language.Haskell.TH
import           Language.Haskell.TH.Quote
import           Language.Haskell.TH.Syntax
import Text.Trifecta.Parser 


-- | Parser from string to LiveVDom
testParseLiveValentine :: String -> Q Exp
testParseLiveValentine s = do
  rN <- parseStringTrees parsePLiveVDom s
  case rN of
    Success vn -> if length vn > 1
                    then fail "One or more nodes can not be the main html. Maybe you're trying to use ophelia?"
                    else if length vn < 1
                      then fail "Unable to parse empty template"
                      else lift $ (vn !! 0)
    Failure fString -> fail $ show fString


-- | Quasiquoter used to parse HTML similar to hamlet
-- but allow it to be rendered live
-- reference the README.md file in the repo for more information
testvalentine :: QuasiQuoter
testvalentine = QuasiQuoter testParseLiveValentine (error "quasi") (error "quasi") (error "quasi")


