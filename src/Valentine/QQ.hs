module Valentine.QQ (
  valentine
) where

import           Language.Haskell.TH
import           Language.Haskell.TH.Quote


import           Valentine.Parser
import           Valentine.Parser.VDom.Live
import           LiveVDom.Types


import           Text.Trifecta.Result

-- opheliaExp :: String -> Q Exp
-- opheliaExp s = do
--   rN <- parseVNodeS s
--   case rN of
--     Success vn -> lift vn
--     Failure fString -> fail $ show fString

-- ophelia :: QuasiQuoter
-- ophelia = QuasiQuoter opheliaExp undefined undefined undefined


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
valentine :: QuasiQuoter
valentine = QuasiQuoter liveValentine undefined undefined undefined
