module Main (main) where

import Expr
import qualified Reader.Main as Reader 
import qualified Writer.Main as Writer 
import qualified State.Main as State 
import qualified HW.Main as SM 
import qualified Cont.Main as C 
import qualified FailCont.Main as F


main :: IO ()
main = do 
  F.main
  -- C.main 
  -- SM.main 
  -- State.main
  -- Reader.main
  -- Writer.main