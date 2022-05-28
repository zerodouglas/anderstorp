{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module Anderstorp.Types.Discord
  ( DiscordWebhook (..),
    DiscordEmbed (..),
    DiscordEmbedField (..),
    DiscordEmbedFooter (..),
  )
where

import Data.Aeson (FromJSON, ToJSON, object, parseJSON, toJSON, withObject, (.:), (.=))
import Data.Text (Text)
import GHC.Generics (Generic)

data DiscordWebhook = DiscordWebhook
  { discordWebhookUsername :: Text,
    discordWebhookAvatarUrl :: Text,
    discordWebhookEmbeds :: [DiscordEmbed]
  }
  deriving (Show, Generic)

instance ToJSON DiscordWebhook where
  toJSON (DiscordWebhook {..}) =
    object
      [ "username" .= discordWebhookUsername,
        "avatar_url" .= discordWebhookAvatarUrl,
        "embeds" .= discordWebhookEmbeds
      ]

instance FromJSON DiscordWebhook where
  parseJSON = withObject "DiscordWebhook" $ \o ->
    DiscordWebhook
      <$> o .: "username"
      <*> o .: "avatar_url"
      <*> o .: "embeds"

data DiscordEmbed = DiscordEmbed
  { discordEmbedTitle :: Text,
    discordEmbedDescription :: Text,
    discordEmbedFields :: [DiscordEmbedField],
    discordEmbedColor :: Int,
    discordEmbedTimestamp :: Text,
    discordEmbedFooter :: DiscordEmbedFooter
  }
  deriving (Show, Generic)

instance ToJSON DiscordEmbed where
  toJSON (DiscordEmbed {..}) =
    object
      [ "title" .= discordEmbedTitle,
        "description" .= discordEmbedDescription,
        "fields" .= discordEmbedFields,
        "color" .= discordEmbedColor,
        "timestamp" .= discordEmbedTimestamp,
        "footer" .= discordEmbedFooter
      ]

instance FromJSON DiscordEmbed where
  parseJSON = withObject "DiscordEmbed" $ \o ->
    DiscordEmbed
      <$> o .: "title"
      <*> o .: "description"
      <*> o .: "fields"
      <*> o .: "color"
      <*> o .: "timestamp"
      <*> o .: "footer"

newtype DiscordEmbedFooter = DiscordEmbedFooter
  {discordEmbedFooterText :: Text}
  deriving (Show, Generic)

instance ToJSON DiscordEmbedFooter where
  toJSON (DiscordEmbedFooter {..}) =
    object
      ["text" .= discordEmbedFooterText]

instance FromJSON DiscordEmbedFooter where
  parseJSON = withObject "DiscordEmbedFooter" $ \o ->
    DiscordEmbedFooter
      <$> o .: "text"

data DiscordEmbedField = DiscordEmbedField
  { discordEmbedFieldName :: Text,
    discordEmbedFieldValue :: Text,
    discordEmbedFieldInline :: Bool
  }
  deriving (Show, Generic)

instance ToJSON DiscordEmbedField where
  toJSON (DiscordEmbedField {..}) =
    object
      [ "name" .= discordEmbedFieldName,
        "value" .= discordEmbedFieldValue,
        "inline" .= discordEmbedFieldInline
      ]

instance FromJSON DiscordEmbedField where
  parseJSON = withObject "DiscordEmbedField" $ \o ->
    DiscordEmbedField
      <$> o .: "name"
      <*> o .: "value"
      <*> o .: "inline"
