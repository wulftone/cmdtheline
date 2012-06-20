import System.Console.CmdTheLine
import Control.Applicative

import System.Exit ( exitSuccess )

data Verbosity = Verbose | Normal | Silent

fizzBuzz :: Verbosity -> String -> String -> Int -> IO ()
fizzBuzz verb fizz buzz n = do
  case verb of
    Verbose -> putStrLn $ concat
      [ "FizzBuzz: Printing the result of FizzBuzz over the numbers 1 to ", show n
      , "\nFizz = ", fizz, "\nBuzz = ", buzz
      ]
    Silent  -> exitSuccess
    _       -> return ()

  mapM_ fizzAndBuzzOr [1..n]
  where
  fizzAndBuzzOr n = putStrLn output
    where
    output = case fizz' ++ buzz' of
      ""  -> show n
      str -> str

    fizz' = if (n `mod` 3) == 0 then fizz else ""
    buzz' = if (n `mod` 5) == 0 then buzz else ""


-- A flag that can appear many times on the command line, only the last of
-- which will be counted.
verbosity :: Term Verbosity
verbosity = lastOf $ vFlagAll [Normal] [ ( Verbose, verbose )
                                       , ( Silent,  silent  )
                                       ]
  where
  verbose =(optInfo [ "verbose", "v" ])
          { argDoc  = "Give verbose output." }

  silent  =(optInfo [ "quiet", "silent", "q", "s" ])
          { argDoc  = "Provide no output." }

fizz, buzz :: Term String
fizz = opt "Fizz" $ (optInfo [ "Fizz", "fizz", "f" ])
     { argDoc = "A string to print in the 'Fizz' case." }

buzz = opt "Buzz" $ (optInfo [ "Buzz", "buzz", "b" ])
     { argDoc = "A string to print in the 'Buzz' case." }

times :: Term Int
times = opt 100 $ (optInfo [ "times", "t" ])
      { argName = "TIMES"
      , argDoc  = "Run $(mname) for the numbers 1 to $(argName)."
      }

term :: Term (IO ())
term = fizzBuzz <$> verbosity <*> fizz <*> buzz <*> times

termInfo :: TermInfo
termInfo = def
  { termName = "FizzBuzz"
  , version  = "v1.0"
  , termDoc  = "An implementation of the world renowned FizzBuzz algorithm."
  , man      = [ S "BUGS"
               , P "Email bug reports to <sirFrancisDrank@example.com>"
               ]
  }

main = run ( term, termInfo )
