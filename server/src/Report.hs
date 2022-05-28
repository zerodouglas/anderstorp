{-# LANGUAGE OverloadedStrings #-}

module Report (executeWebhook) where

import Anderstorp.Types.API (IncidentReport (..), StewardId (..))
import Anderstorp.Types.Discord
  ( DiscordEmbed (..),
    DiscordEmbedField (..),
    DiscordEmbedFooter (..),
    DiscordWebhook (..),
  )
import Data.Aeson (encode)
import Data.Functor (void)
import Data.Text (Text)
import qualified Data.Text as T
import Data.Time (getCurrentTime)
import Data.Time.Format.ISO8601 (iso8601Show)
import Network.HTTP.Client
  ( RequestBody (RequestBodyLBS),
    httpLbs,
    method,
    newManager,
    parseRequest,
    requestBody,
    requestHeaders,
    responseBody
  )
import Network.HTTP.Client.TLS (tlsManagerSettings)
import Network.HTTP.Types.Header (hContentType)

generateTimestamp :: IO Text
generateTimestamp = fmap (T.pack . iso8601Show) getCurrentTime

data IsDriverOrSteward = Singular Int | Multiple [StewardId]

mentionByDiscordClientId :: IsDriverOrSteward -> String
mentionByDiscordClientId clientId =
  case clientId of
    Singular i -> "<@" ++ show i ++ ">"
    Multiple is -> foldMap (\i -> "<@" ++ show i ++ ">") $ fmap fromSteward is

mkRequestObject :: IncidentReport -> Text -> DiscordWebhook
mkRequestObject (IncidentReport title desc driver steward) time =
  DiscordWebhook
    { discordWebhookUsername = "SFiA",
      discordWebhookAvatarUrl = "https://i.imgur.com/KnyQoaV.png",
      discordWebhookEmbeds =
        [ DiscordEmbed
            { discordEmbedTitle = title,
              discordEmbedDescription = desc,
              discordEmbedFields =
                [ embedFieldDef "Förare" (T.pack $ mentionByDiscordClientId $ Singular driver) True,
                  embedFieldDef "Steward(s)" (T.pack $ mentionByDiscordClientId $ Multiple steward) True
                ],
              discordEmbedColor = 15158332,
              discordEmbedFooter = footerDef,
              discordEmbedTimestamp = time
            }
        ]
    }
  where
    footerDef =
      DiscordEmbedFooter
        { discordEmbedFooterText = ""
        }
    embedFieldDef :: Text -> Text -> Bool -> DiscordEmbedField
    embedFieldDef n v i =
      DiscordEmbedField
        { discordEmbedFieldName = n,
          discordEmbedFieldValue = v,
          discordEmbedFieldInline = i
        }

executeWebhook :: IncidentReport -> IO ()
executeWebhook reqObj = do
  manager <- newManager tlsManagerSettings
  timestamp <- generateTimestamp
  initialRequest <- parseRequest ""
  let req =
        initialRequest
          { method = "POST",
            requestHeaders = [(hContentType, "application/json")],
            requestBody = RequestBodyLBS $ encode $ mkRequestObject reqObj timestamp
          }
  void $ httpLbs req manager
