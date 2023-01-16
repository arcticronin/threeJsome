module Main where

import qualified Data.Map as Map


data JsonValue =  JsonNull
                | JsonBool Bool
                | JsonNumber Integer
                | JsonString String
                | JsonArray [JsonValue]
                | JsonObject [(String, JsonValue)]
                deriving(Show, Eq)
-- (map String Jsonvalue) better but in some dependency

-- i wanna chain several parser together
-- so my return should be (String, a)
-- string object, so i can have the rest to parse

-- i can use Maybe or Either monad
-- Maybe it's fine,
-- Just something
-- or Nothing

-- haskell idiom : using a Record with only one element
-- to wrap runParser (one struct with one field)
newtype Parser a = Parser
  { runParser:: String -> Maybe (String, a)
  }
-- thats because if i look for the :t of runParser
-- it can extract a , amd if I call runParser JsonValue
-- it takes JsonValue as a.

-- ITS A TRICK
-- it uses the generation of a function, that haskell does
-- for records

jsonNull :: Parser JsonValue
jsonNull = undefined

charP :: Char -> Parser Char

charP x =
  Parser f
        where
          f (y:ys)
            | y == x = Just (ys, x)
            | otherwise = Nothing
          f [] = Nothing
-- lambda using version
charPOld x =
  Parser $ \input ->
            case input of
                y:ys
                  | y == x -> Just (ys, x)
                [] -> Nothing
                _ -> Nothing
-- y:ys -> _a
-- what should I return? compiler see a hole and tells me the
--expected type etc
-- this _a can be used in debug mode
-- holes _a are usefull, i can have info from the compiler

stringP :: Parser String
stringP = undefined


jsonValue :: Parser JsonValue
jsonValue = undefined

main :: IO()
main = undefined
