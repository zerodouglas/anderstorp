{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TypeOperators #-}

module Anderstorp
  ( startApp,
  )
where

import Anderstorp.Types.API (IncidentReport (..))
import Control.Monad.IO.Class (MonadIO (liftIO))
import Data.Aeson
import Data.ByteString
import Data.ByteString.UTF8 (fromString)
import Data.Text (Text)
import qualified Data.Text as T
import GHC.Generics
import Network.Wai.Handler.Warp (run)
import Servant (Proxy, Server, Handler, NoContent, serve, Proxy(..), NoContent(..))
import System.Environment (getEnv)
import Anderstorp.Server.API
import Report (executeWebhook)

data Config = Config
  { oauthUrl :: ByteString,
    webhookUrl :: ByteString
  }

startApp :: IO ()
startApp = do
  --oauthUrl <- fromString <$> getEnv "ANDERSTORP_ENV_OAUTH_URL"
  --webhookUrl <- fromString <$> getEnv "ANDERSTORP_ENV_WEBHOOK_URL"
  run 8080 $
    serve api $
      server $
        Config {..}

api :: Proxy ApiV1
api = Proxy

server :: Config -> Server ApiV1
server cfg = report
  where
    report :: IncidentReport -> Handler NoContent
    report args = do
      liftIO $ executeWebhook  args
      pure NoContent
