module Valentine.QQ (
  valentine
) where

import           Language.Haskell.TH
import           Language.Haskell.TH.Quote


import           LiveVDom.Types (toLiveVDomTH)
import           Valentine.Parser (parseStringTrees)
import           Valentine.Parser.VDom.Live (parsePLiveVDom)


import           Text.Trifecta.Result

-- | Parser from string to LiveVDom
liveValentine :: String -> Q Exp
liveValentine s = do
  rN <- parseStringTrees parsePLiveVDom s
  case rN of
    Success vn -> if length vn > 1
                    then fail "One or more nodes can not be the main html. Maybe you're trying to use ophelia?"
                    else if length vn < 1
                      then fail "Unable to parse empty template"
                      else toLiveVDomTH $ vn !! 0
    Failure fString -> fail $ show fString

-- | Quasiquoter used to parse HTML similar to hamlet
-- but allow it to be rendered live
-- reference the README.md file in the repo for more information
valentine :: QuasiQuoter
valentine = QuasiQuoter liveValentine (error "quasi") (error "quasi") (error "quasi")
