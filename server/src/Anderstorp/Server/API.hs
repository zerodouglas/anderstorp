{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Anderstorp.Server.API (ApiV1) where

import Anderstorp.Types.API (IncidentReport (..))
import Servant.API (JSON, NoContent, Post, ReqBody, (:>))

type ApiV1 = "api" :> "v1" :> ApiReports

type ApiReports =
  "reports"
    :> ReqBody '[JSON] IncidentReport
    :> Post '[JSON] NoContent

-- Oauth endpoints
