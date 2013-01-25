{-# LANGUAGE FlexibleContexts, OverloadedStrings, RecordWildCards #-}
{-# OPTIONS_GHC -F -pgmFtrhsx #-}
module Theme where

import Clckwrks
import Clckwrks.Monad
import Data.Text (Text)
import HSP
import Paths_clckwrks_theme_bootstrap (getDataDir)

theme :: Theme
theme = Theme
    { themeName      = "bootstrap-theme"
    , _themeTemplate = pageTemplate
    , themeBlog      = blog
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
      <script src="http://code.jquery.com/jquery-latest.js"></script>
      <link rel="stylesheet" type="text/css" href=(ThemeData "style.css") />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <% hdr %>
--      <% googleAnalytics %>
     </head>
     <body>
      <h1><% ttl %></h1>
      <% bdy %>
     </body>
    </html>

blog :: XMLGenT (Clck ClckURL) XML
blog = undefined

{-
postsHTML :: XMLGenT (Clck ClckURL) XML
postsHTML =
    do posts <- getPosts
       <ol class="blog-posts">
        <% mapM postHTML posts %>
        </ol>

postHTML :: Page -> XMLGenT (Clck ClckURL) XML
postHTML Page{..} =
    <li class="blog-post">
     <h2><% pageTitle %></h2>
     <span class="pub-date"><% pageDate %></span>
     <% pageSrc %>
     <p><a href=(ViewPage pageId)>permalink</a></p>
    </li>

blog :: XMLGenT (Clck ClckURL) XML
blog =
    do ttl <- lift getBlogTitle
       pageTemplate ttl () $
           <%>
            <div id="blog-content">
             <h1 class="page-title"><% ttl %></h1>
             <% postsHTML %>
            </div>
           </%>
-}