module Elasticsearch.Client where

import Prelude
import Data.Argonaut            (decodeJson
                                ,(.:))
import Data.Argonaut.Core       (Json)
import Data.Argonaut.Decode     (class DecodeJson)
import Data.Either              (Either(..))
import Data.Maybe               (Maybe(..))
import Data.Traversable         (traverse)

newtype SearchHit r = SearchHit
  { id     :: String
  , index  :: String
  , type_  :: String
  , score  :: Maybe Number
  , source :: r
  }

instance decodeJsonSearchHit :: DecodeJson r => DecodeJson (SearchHit r) where
  decodeJson json = do
    obj <- decodeJson json
    id     <- obj .: "_id"
    index  <- obj .: "_index"
    type_  <- obj .: "_type"
    score  <- obj .: "_score"
    source <- obj .: "_source"
    pure $ SearchHit { id, index, type_, score, source }

newtype SearchResponse r = SearchResponse
  { maxScore :: Maybe Number
  , total    :: Int
  , hits     :: Array (SearchHit r)
  }

instance decodeSearchResponse :: DecodeJson r => DecodeJson (SearchResponse r) where
  decodeJson json = do
    obj <- decodeJson json
    maxScore <- obj .: "max_score"
    total <- obj .: "total"
    hitObj <- obj .: "hits"
    let 
      hits = case decodeJsonSearchHitArray hitObj of
        Right h -> h
        Left err -> []

    pure $ SearchResponse
      { maxScore
      , total
      , hits
      }

decodeJsonSearchHitArray :: forall r. DecodeJson r => Json -> Either String (Array (SearchHit r))
decodeJsonSearchHitArray json = decodeJson json >>= traverse decodeJson
