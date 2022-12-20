module Elasticsearch.Client where

import Prelude

import Data.Argonaut (decodeJson, (.:), (.:?))
import Data.Argonaut.Core (Json)
import Data.Argonaut.Decode (class DecodeJson)
import Data.Argonaut.Decode.Error (JsonDecodeError)
import Data.Either (Either(..))
import Data.Maybe (Maybe)
import Data.Newtype (class Newtype, unwrap)
import Data.Traversable (traverse)

newtype SearchHit r = SearchHit
  { source :: r
  }

newtype SearchHits r = SearchHits
  { hits :: Array (SearchHit r)
  , maxScore :: Maybe Number
  }

newtype SearchResult r = SearchResult
  { took :: Int
  , timedOut :: Boolean
  , hits :: SearchHits r
  }

instance decodeJsonSearchHit :: DecodeJson r => DecodeJson (SearchHit r) where
  decodeJson json = do
    obj <- decodeJson json
    source <- obj .: "_source"
    pure $ SearchHit { source }

instance decodeJsonSearchHits :: DecodeJson r => DecodeJson (SearchHits r) where
  decodeJson json = do
    obj <- decodeJson json
    hits <- obj .: "hits"
    maxScore <- obj .:? "max_score"
    pure $ SearchHits { hits, maxScore }

instance decodeSearchResult :: DecodeJson r => DecodeJson (SearchResult r) where
  decodeJson json = do
    obj <- decodeJson json
    took <- obj .: "took"
    timedOut <- obj .: "timed_out"
    hits <- obj .: "hits"

    pure $ SearchResult
      { took
      , timedOut
      , hits
      }

decodeJsonSearchHitArray :: forall r. DecodeJson r => Json -> Either JsonDecodeError (Array (SearchHit r))
decodeJsonSearchHitArray json = decodeJson json >>= traverse decodeJson

getSearchHitsSources :: forall r. DecodeJson r => SearchResult r -> Array r
getSearchHitsSources (SearchResult result) = case result.hits of
  SearchHits hits -> map (\(SearchHit x) -> x.source) hits.hits
  _ -> []

