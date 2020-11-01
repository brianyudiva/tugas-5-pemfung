# Tugas 5 Pemrograman Fungsional

Brian Athallah Yudiva - 1806205804

Source: [Magesh Kumar Lambda Calculus REPL](https://github.com/Ema93sh/lambda-calculus-interpreter)

## Modifikasi

Menyesuaikan dengan permintaan soal Tugas 5, maka saya memodifikasi Parser agar merubah angka dan operasi (+) (*) menjadi representasi Lambda.

Pertama-tama saya memodifikasi file **Parser.hs**. Saya merubah fungsi **parseExpr** agar jika pertama input adalah bilangan bulat (0-9), maka akan memanggil fungsi baru **toChurch**

```bash
parseExpr :: String -> Either ParseError LExpr
parseExpr input
    | head input `elem` ['0'..'9'] = parse lambdaExpr "" (toChurch input)
    | otherwise = parse lambdaExpr "" input
```

Fungsi **toChurch** akan merubah bilangang bulat, operasi (+), dan operasi (*) menjadi representasi Lambda dengan bantuan fungsi **toChurchNumeral** untuk melakukan Church Numeral secara rekursif

```bash
toChurch :: String -> String
toChurch [] = ""
toChurch (x:xs)
    | length xs > 1 && xs !! 0 == '*' = "(λwyx.w(yx))" ++ toChurchNumeral x ++ toChurch xs
    | x `elem` ['0'..'9'] = toChurchNumeral x ++ toChurch xs
    | x == '+' = "(λwyx.y(wyx))" ++ toChurch xs
    | otherwise = toChurch xs
```
```bash
toChurchNumeral :: Char -> String
toChurchNumeral x
    | x == '0' = "(λsz.z)"
    | otherwise = "(λsz." ++ addLowerFunction(digitToInt x) ++ ")"
    where
        addLowerFunction 1 = "s(z)"
        addLowerFunction x = "s(" ++ addLowerFunction(x-1) ++ ")"
```

Pada file yang sama setelah melakukan pengecekan pada input saya juga menambahkan sebuah fungsi bernama **checkChurch** untuk melakukan pengubahan terhadap bilangan cacah (1,2,...,9) menjadi ekspresi lambda.

```bash
checkChurch :: Char -> String
checkChurch num 
    | num == '0' = "(λsz.z)"
    | otherwise = "(λsz."++ toNumerals (digitToInt num)++")"
```

Lalu saya juga menambahkan fungsi bernama **toNumerals** yang digunakan sebagai fungsi rekursif untuk membantu fungsi **checkChurch** menjadi ekspresi lambda

```bash
toNumerals :: Int -> String
toNumerals 1 = "s(z)"
toNumerals num = "s("++toNumerals (num-1)++")"
```

Setelah selesai evaluasi, maka fungsi **churchToNumeral** di dalam **Main.hs** akan merubah representasi lambda ke dalam bilangan bulat

```bash
churchToNumeral :: String -> String
churchToNumeral x
  | x == "λsz.z" = show 0
  | x == "λxz.z" = show 0
  | otherwise = show $ (length $ filter (=='(') x) + 1
```

## Cara Pemakaian

Untuk menjalankan program

```bash
cabal run
```
Berikut input yang ditambah setelah dimodifikasi

**Bilangan cacah**

```bash
cukup memasukan bilangan cacah yang diinginkan antara 0-9
```

**Pertambahan bilangan cacah**

```bash
menggunakan operator + diantara 2 bilangan cacah (bilangan cacah 0-9)

1+2
```

**Perkalian bilangan cacah**

```bash
menggunakan operator * didepan 2 bilangan cacah (bilangan cacah 0-9)

1*2
```

## Known Bugs

* Ketika input operasi (+) dan (*) digabung **berurutan**, contohnya **1+2*3**, hasil yang diberikan tidak sesuai

