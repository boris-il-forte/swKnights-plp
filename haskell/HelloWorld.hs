module Main where

main = do
{
        x <- return 1;
        y <- return 6;
        z <- return (x*y+x);
        putStrLn "Hello World!";
        putStrLn "Ciao!";
        putStrLn "Come ti chiami?";
        k <- getLine;
        putStr "Bella ";
        putStrLn k; 
        print x;
        print z;
}::IO()