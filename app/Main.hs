{-# LANGUAGE BlockArguments #-}
{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -Wno-unused-top-binds #-}

module Main (main) where

import qualified Data.ByteString.Char8 as BC
import Network.Simple.TCP (HostPreference (HostAny), closeSock, recv, send, serve)

main :: IO ()
main = do
  let port = "6379"
  putStrLn $ "Redis server listening on port " ++ port
  serve HostAny port $ \(socket, address) -> do
    putStrLn $ "successfully connected client: " ++ show address
    Just req <- recv socket 1024
    BC.putStrLn req
    if req == "*1\r\n$4\r\nPING\r\n" then send socket "+PONG\r\n" else closeSock socket
    closeSock socket
