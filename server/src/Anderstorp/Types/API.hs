{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE RecordWildCards #-}

module Anderstorp.Types.API
  ( IncidentReport (..),
    StewardId (..),
  )
where

import Data.Aeson (Value(..))
import Data.Aeson (FromJSON, ToJSON, parseJSON, toJSON)
import Data.Text (Text)
import GHC.Generics (Generic)

newtype StewardId = StewardId {fromSteward :: Int}
  deriving (Show, Generic)

instance ToJSON StewardId where
 toJSON (StewardId{..}) =
   Number $ fromInteger $ toInteger fromSteward

instance FromJSON StewardId where
  parseJSON = fmap StewardId . parseJSON

data IncidentReport = IncidentReport
  { title :: Text,
    description :: Text,
    driver :: Int,
    steward :: [StewardId]
  }
  deriving (Show, Generic)

instance ToJSON IncidentReport

instance FromJSON IncidentReport
