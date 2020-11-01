module Parser (
    parseExpr
    ) where

import Syntax
import Text.ParserCombinators.Parsec
import Data.Char


type LambdaParser = GenParser Char () LExpr


varName :: GenParser Char () Name
varName = letter

arguments :: GenParser Char () [Name]
arguments = many1 varName

variable :: LambdaParser
variable = do
              variable <- varName
              return (Var variable)

abstraction :: LambdaParser
abstraction = do
                 char '\\' <|> char 'λ'
                 args <- arguments
                 char '.'
                 body <- lambdaExpr
                 return $ foldr Abs body args

brackets :: LambdaParser
brackets = between (char '(') (char ')') lambdaExpr

lambdaTerm :: LambdaParser
lambdaTerm =    brackets
            <|> abstraction
            <|> variable

lambdaExpr :: LambdaParser
lambdaExpr  = do
                  terms <- many1 lambdaTerm
                  return $ foldl1 App terms

parseExpr :: String -> Either ParseError LExpr
parseExpr input
    | head input `elem` ['0'..'9'] = parse lambdaExpr "" (toChurch input)
    | otherwise = parse lambdaExpr "" input

toChurch :: String -> String
toChurch [] = ""
toChurch (x:xs)
    | x `elem` ['0'..'9'] = toChurchNumeral x ++ toChurch xs
    | x == '+' = "(λwyx.y(wyx))" ++ toChurch xs
    | x == '*' = "(λwyx.w(yx))" ++ toChurch xs
    | otherwise = toChurch xs

toChurchNumeral :: Char -> String
toChurchNumeral x
    | x == '0' = "(λsz.z)"
    | otherwise = "(λsz." ++ addLowerFunction(digitToInt x) ++ ")"
    where
        addLowerFunction 1 = "s(z)"
        addLowerFunction x = "s(" ++ addLowerFunction(x-1) ++ ")"