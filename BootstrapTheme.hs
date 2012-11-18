{-# LANGUAGE FlexibleContexts, OverloadedStrings #-}
{-# OPTIONS_GHC -F -pgmFtrhsx #-}
module BootstrapTheme where

import Clckwrks
import Clckwrks.Monad
import Data.Text (Text)
import Happstack.Server
import HSP

theme :: Theme
theme = Theme
    { themeName      = "bootstrap-theme"
    , _themeTemplate = pageTemplate
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
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <% hdr %>
      <% googleAnalytics %>
     </head>
     <body>
      <% bdy %>
      <script src="http://code.jquery.com/jquery-latest.js"></script>
     </body>
    </html>
