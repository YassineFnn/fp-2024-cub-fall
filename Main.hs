module Main where

import Control.Monad (unless)
import Text.Printf (printf)

short :: [a] -> Bool
short xs = length (take 3 xs) < 3

lovely :: [Int] -> Bool
lovely lst = short lst || lst !! 2 == 14

rightTriangles :: [(Int, Int, Int)]
rightTriangles = [(a, b, c) | c <- [1..], b <- [1..c], a <- [1..b], a^2 + b^2 == c^2] 

fizzBuzz :: [String]
fizzBuzz = [fizzBuzzHelper n | n <- [1..]] 

fizzBuzzHelper :: Int -> String
fizzBuzzHelper n
    | n `mod` 15 == 0 = "FizzBuzz"
    | n `mod` 5 == 0 = "Buzz"
    | n `mod` 3 == 0 = "Fizz"
    | otherwise = show n

ageOn :: String -> Float -> Float
ageOn planet ageInSeconds =
    let ageInEarthYears = ageInSeconds / 31557600.0
    in case planet of
        "Mercury"  -> ageInEarthYears / 0.2408467
        "Venus"    -> ageInEarthYears / 0.61519726
        "Earth"    -> ageInEarthYears
        "Mars"     -> ageInEarthYears / 1.8808158
        "Jupiter"  -> ageInEarthYears / 11.862615
        "Saturn"   -> ageInEarthYears / 29.447498
        "Uranus"   -> ageInEarthYears / 84.016846
        "Neptune"  -> ageInEarthYears / 164.79132
        _          -> error "Unknown planet"

isLeapYear :: Int -> Bool
isLeapYear year 
    | year `mod` 400 == 0 = True
    | year `mod` 100 == 0 = False
    | year `mod` 4 == 0 = True
    | year < 0 = error "Year cannot be negative"
    | otherwise = False

main = do
  runTests
  putStrLn "Done"

runTests = do
  runShortTests
  runLovelyTests
  runRightTriangleTests
  runFizzBuzzTests
  runAgeOnTests
  runIsLeapYearTests
  where
    describeFailure functionName errorMsg input exp actual =
      printf
        "Test for a function %s has failed:\n  %s\n  Input: %s\n  Expected: %s\n  But got: %s\n"
        functionName
        errorMsg
        (show input)
        (show exp)
        (show actual)

    eqTest funName errorMsg input exp actual =
      unless (actual == exp) $ describeFailure funName errorMsg input exp actual

    runShortTests =
      mapM_ test cases
      where
        test (input, exp) = eqTest "short" "unexpected result" input exp (short input)
        cases = [([], True), ([1], True), ([1, 2], True), ([1, 2, 3], False), ([1, 2, 3, 4], False), ([1 ..], False)]

    runLovelyTests =
      mapM_ test cases
      where
        test (input, exp) = eqTest "lovely" "unexpected result" input exp (lovely input)
        cases = [([], True), ([1], True), ([1, 2], True), ([1, 2, 3], False), ([1, 2, 3, 4], False), ([1, 2, 14, 4], True), ([1 ..], False)]

    runRightTriangleTests = do
      let n = 20
      let exp = [(3, 4, 5), (6, 8, 10), (5, 12, 13), (9, 12, 15), (8, 15, 17), (12, 16, 20), (15, 20, 25), (7, 24, 25), (10, 24, 26), (20, 21, 29), (18, 24, 30), (16, 30, 34), (21, 28, 35), (12, 35, 37), (15, 36, 39), (24, 32, 40), (9, 40, 41), (27, 36, 45), (30, 40, 50), (14, 48, 50)]
      unless (take n rightTriangles == exp) $
        putStrLn $
          printf
            "rightTriangles produces a wrong result. The first %s answers are supposed to be: %s"
            (show n)
            (show exp)

    runFizzBuzzTests = do
      let n = 20
      let exp = ["1", "2", "Fizz", "4", "Buzz", "Fizz", "7", "8", "Fizz", "Buzz", "11", "Fizz", "13", "14", "FizzBuzz", "16", "17", "Fizz", "19", "Buzz"]
      unless (take n fizzBuzz == exp) $
        putStrLn $
          printf
            "fizzBuzz produces a wrong result. The first %s answers are supposed to be: %s"
            (show n)
            (show exp)

    runAgeOnTests =
      mapM_ test cases
      where
        test (planet, seconds, exp) =
          let actual = ageOn planet seconds
           in unless (actual `isEqual` exp) $ describeFailure "ageOn" (printf "Wrong age on planet %s" planet :: String) seconds exp actual
          where
            isEqual x y = roundTo 2 x == roundTo 2 y
            roundTo n = (/ 10 ^ n) . fromIntegral . round . (* 10 ^ n)
        cases =
          [ ( "Earth",
              1000000000,
              31.69
            ),
            ( "Mercury",
              2134835688,
              280.88
            ),
            ( "Venus",
              189839836,
              9.78
            ),
            ( "Mars",
              2129871239,
              35.88
            ),
            ( "Jupiter",
              901876382,
              2.41
            ),
            ( "Saturn",
              2000000000,
              2.15
            ),
            ( "Uranus",
              1210123456,
              0.46
            ),
            ( "Neptune",
              1821023456,
              0.35
            )
          ]

    runIsLeapYearTests =
      mapM_ test cases
      where
        test (errorMsg, input, exp) =
          let actual = isLeapYear input
           in unless (actual == exp) $ describeFailure "isLeapYear" errorMsg input exp actual

        cases =
          [ ( "year not divisible by 4 in common year",
              2015,
              False
            ),
            ( "year divisible by 2, not divisible by 4 in common year",
              1970,
              False
            ),
            ( "year divisible by 4, not divisible by 100 in leap year",
              1996,
              True
            ),
            ( "year divisible by 4 and 5 is still a leap year",
              1960,
              True
            ),
            ( "year divisible by 100, not divisible by 400 in common year",
              2100,
              False
            ),
            ( "year divisible by 100 but not by 3 is still not a leap year",
              1900,
              False
            ),
            ( "year divisible by 400 in leap year",
              2000,
              True
            ),
            ( "year divisible by 400 but not by 125 is still a leap year",
              2400,
              True
            ),
            ( "year divisible by 200, not divisible by 400 in common year",
              1800,
              False
            )
          ]