module Elasticsearch where

import Prelude
import Data.Argonaut            (decodeJson
                                ,(.:))
import Data.Argonaut.Core       (Json)
import Data.Argonaut.Decode     (class DecodeJson)
import Data.Either              (Either(..))
import Data.Traversable         (traverse)

newtype SearchHit r = SearchHit
  { source :: r
  }

instance decodeJsonSearchHit :: DecodeJson r => DecodeJson (SearchHit r) where
  decodeJson json = do
    obj <- decodeJson json
    source <- obj .: "_source"
    pure $ SearchHit { source }

newtype SearchResponse r = SearchResponse
  { total :: Int
  , hits  :: Array (SearchHit r)
  }

instance decodeSearchResponse :: DecodeJson r => DecodeJson (SearchResponse r) where
  decodeJson json = do
    obj <- decodeJson json
    total <- obj .: "total"
    hitObj <- obj .: "hits"
    let 
      hits = case decodeJsonSearchHitArray hitObj of
               Right h -> h
               Left err -> []

    pure $ SearchResponse
      { total
      , hits
      }

decodeJsonSearchHitArray :: forall r. DecodeJson r => Json -> Either String (Array (SearchHit r))
decodeJsonSearchHitArray json = decodeJson json >>= traverse decodeJson
