{-# LANGUAGE FlexibleContexts, OverloadedStrings #-}
{-# OPTIONS_GHC -F -pgmFtrhsx #-}
module BootstrapTheme where

import Clckwrks
import Clckwrks.Monad
import Data.Text (Text)
import Happstack.Server
import HSP
import Paths_clckwrks_theme_bootstrap (getDataDir)

theme :: Theme
theme = Theme
    { themeName      = "bootstrap-theme"
    , _themeTemplate = pageTemplate
    , themeDataDir   = getDataDir
    }

pageTemplate :: ( EmbedAsChild (ClckT ClckURL (ServerPartT IO)) headers
                , EmbedAsChild (ClckT ClckURL (ServerPartT IO)) body
                ) =>
                Text
             -> headers
             -> body
             -> XMLGenT (ClckT ClckURL (ServerPartT IO)) XML
pageTemplate ttl hdr bdy =
    <html>
     <head>
      <title><% ttl %></title>
      <link href="http://netdna.bootstrapcdn.com/twitter-bootstrap/2.1.1/css/bootstrap.min.css"        rel="stylesheet" media="screen" />
      <link href="http://netdna.bootstrapcdn.com/twitter-bootstrap/2.1.1/css/bootstrap-responsive.css" rel="stylesheet" />
      <link rel="stylesheet" type="text/css" href=(ThemeData "style.css") />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <% hdr %>
      <% googleAnalytics %>
     </head>
     <body>
      <% bdy %>
      <script src="http://code.jquery.com/jquery-latest.js"></script>
     </body>
    </html>
