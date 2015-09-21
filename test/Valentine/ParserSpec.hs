module Valentine.ParserSpec where

import Valentine.Parser.VDom (parseVNodeS)


import Control.Lens 

type ValidTest a =  (String, a -> Bool)

assert :: ValidTest a  -> a -> Either String Bool
assert (str, f) a = if f a
                  then Right True
                  else Left str

valentineParserSpec :: [Either String Bool]
valentineParserSpec = assert <$> allTests <*> inputs
 where
  allTests = [] :: [ValidTest a]
  inputs = []



testParseVNodeS = undefined 

