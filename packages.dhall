{-
Welcome to your new Dhall package-set!

Below are instructions for how to edit this file for most use
cases, so that you don't need to know Dhall to use it.

## Warning: Don't Move This Top-Level Comment!

Due to how `dhall format` currently works, this comment's
instructions cannot appear near corresponding sections below
because `dhall format` will delete the comment. However,
it will not delete a top-level comment like this one.

## Use Cases

Most will want to do one or both of these options:
1. Override/Patch a package's dependency
2. Add a package not already in the default package set

This file will continue to work whether you use one or both options.
Instructions for each option are explained below.

### Overriding/Patching a package

Purpose:
- Change a package's dependency to a newer/older release than the
    default package set's release
- Use your own modified version of some dependency that may
    include new API, changed API, removed API by
    using your custom git repo of the library rather than
    the package set's repo

Syntax:
Replace the overrides' "{=}" (an empty record) with the following idea
The "//" or "⫽" means "merge these two records and
  when they have the same value, use the one on the right:"
-------------------------------
let override =
  { packageName =
      upstream.packageName // { updateEntity1 = "new value", updateEntity2 = "new value" }
  , packageName =
      upstream.packageName // { version = "v4.0.0" }
  , packageName =
      upstream.packageName // { repo = "https://www.example.com/path/to/new/repo.git" }
  }
-------------------------------

Example:
-------------------------------
let overrides =
  { halogen =
      upstream.halogen // { version = "master" }
  , halogen-vdom =
      upstream.halogen-vdom // { version = "v4.0.0" }
  }
-------------------------------

### Additions

Purpose:
- Add packages that aren't already included in the default package set

Syntax:
Replace the additions' "{=}" (an empty record) with the following idea:
-------------------------------
let additions =
  { package-name =
       { dependencies =
           [ "dependency1"
           , "dependency2"
           ]
       , repo =
           "https://example.com/path/to/git/repo.git"
       , version =
           "tag ('v4.0.0') or branch ('master')"
       }
  , package-name =
       { dependencies =
           [ "dependency1"
           , "dependency2"
           ]
       , repo =
           "https://example.com/path/to/git/repo.git"
       , version =
           "tag ('v4.0.0') or branch ('master')"
       }
  , etc.
  }
-------------------------------

Example:
-------------------------------
let additions =
  { argonaut =
      { dependencies = 
          ["argonaut-codecs"
          ,"argonaut-core"
          ,"argonaut-traversals"]
      , repo = 
          "https://github.com/purescript-contrib/purescript-argonaut"
      , version = 
        "2b81ce16b4c0e8cac0be88b4bf616523b6ddda56"
      }
  , argonaut-codecs =
      { dependencies =
          ["argonaut-core"
          ,"arrays"
          ,"effect"
          ,"foreign-object"
          ,"identity"
          ,"integers"
          ,"maybe"
          ,"nonempty"
          ,"ordered-collections"
          ,"record"]
      , repo = 
          "https://github.com/purescript-contrib/purescript-argonaut-codecs/"
      , version = 
          "9b00fcc6b04bd999d3fd3b9de2ae830bff473a71"
      }
  , argonaut-traversals = 
      { dependencies = 
          ["argonaut-core"
          ,"argonaut-codecs"
          ,"profunctor-lenses"]
      , repo = 
          "https://github.com/purescript-contrib/purescript-argonaut-traversals"
      , version = 
          "9543b517011a4dbc66dfd5cd4d8d774aa620b764"
      }
  }
-------------------------------
-}


let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.13.3-20191005/packages.dhall sha256:ba287d858ada09c4164792ad4e643013b742c208cbedf5de2e35ee27b64b6817

let overrides = {=}

let additions =
  { argonaut =
      { dependencies = 
          ["argonaut-codecs"
          ,"argonaut-core"
          ,"argonaut-traversals"]
      , repo = 
          "https://github.com/purescript-contrib/purescript-argonaut"
      , version = 
        "2b81ce16b4c0e8cac0be88b4bf616523b6ddda56"
      }
  , argonaut-codecs =
      { dependencies =
          ["argonaut-core"
          ,"arrays"
          ,"effect"
          ,"foreign-object"
          ,"identity"
          ,"integers"
          ,"maybe"
          ,"nonempty"
          ,"ordered-collections"
          ,"record"]
      , repo = 
          "https://github.com/purescript-contrib/purescript-argonaut-codecs/"
      , version = 
          "9b00fcc6b04bd999d3fd3b9de2ae830bff473a71"
      }
  , argonaut-traversals = 
      { dependencies = 
          ["argonaut-core"
          ,"argonaut-codecs"
          ,"profunctor-lenses"]
      , repo = 
          "https://github.com/purescript-contrib/purescript-argonaut-traversals"
      , version = 
          "9543b517011a4dbc66dfd5cd4d8d774aa620b764"
      }
  }

in  upstream // overrides // additions
