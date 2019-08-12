{-# LANGUAGE FlexibleContexts, OverloadedStrings, RecordWildCards, QuasiQuotes #-}
module Theme where

import Clckwrks
import Clckwrks.Authenticate.Plugin   (authenticatePlugin)
import Clckwrks.Authenticate.URL      (AuthURL(Auth))
import Clckwrks.Types                 (NamedLink(..))
import Clckwrks.NavBar.API            (getNavBarData)
import Clckwrks.NavBar.Types          (NavBar(..), NavBarItem(..))
import Clckwrks.Monad
import Control.Monad.State            (get)
import Data.Maybe                     (fromMaybe)
import Data.Text.Lazy                 (Text)
import qualified Data.Text            as T
import Happstack.Authenticate.Password.URL (PasswordURL(UsernamePasswordCtrl), passwordAuthenticationMethod)
import HSP.JMacro
import HSP.XMLGenerator
import HSP.XML
import Language.Javascript.JMacro
import Language.Haskell.HSX.QQ        (hsx)
import Paths_clckwrks_theme_bootstrap (getDataDir)
import Web.Plugins.Core               (pluginName, getPluginRouteFn)

-- | this `Theme`
theme :: Theme
theme = Theme
    { themeName    = "bootstrap-theme"
    , themeStyles  = [defaultStyle]
    , themeDataDir = getDataDir
    }

-- | function te generate the navigation bar
genNavBar :: GenXML (Clck ClckURL)
genNavBar =
    do menu  <- lift getNavBarData
       mName <- query GetSiteName
       openId <- query GetEnableOpenId
       navBarHTML (fromMaybe "clckwrks" mName) openId menu

-- | helper function to generate a navigation bar from the navigation bar data
navBarHTML :: T.Text   -- ^ brand
           -> Bool     -- ^ enable OpenId
           -> NavBar   -- ^ navigation bar links
           -> GenXML (Clck ClckURL)
navBarHTML brand enableOpenId (NavBar menuItems) = [hsx|
 <nav class="navbar navbar-default">
  <div class="container-fluid">
    -- Brand and toggle get grouped for better mobile display
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" href="#"><% brand %></a>
    </div>

    -- Collect the nav links, forms, and other content for toggling
    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1" ng-show="!isAuthenticated">
      -- this is where actual menu things go
      <ul class="nav navbar-nav">
        <% mapM mkNavBarItem menuItems %>
      </ul>

      <span ng-controller="UsernamePasswordCtrl">
       <up-login-inline />
      </span>

      -- navbar-text would make more sense than navbar-form, but it shifts the images funny. :-/
      <% if enableOpenId
            then [openIdHtml] else []
       %>

      <span up-authenticated=True class="navbar-left navbar-text">
       <a ng-click="logout()" href="">Logout {{claims.user.username}}</a>
      </span>
    </div> -- /.navbar-collapse
  </div>  -- /.container-fluid
 </nav>
    |]
  where
    openIdHtml =
      [hsx| <span class="navbar-left navbar-btn" ng-controller="OpenIdCtrl" ng-show="!isAuthenticated">
              <openid-yahoo />
            </span>
          |]

mkNavBarItem :: NavBarItem -> GenXML (Clck ClckURL)
mkNavBarItem (NBLink (NamedLink ttl lnk)) =
    [hsx| <li><a href=lnk><% ttl %></a></li> |]

-- | default template for this theme
defaultTemplate
  :: ( EmbedAsChild (ClckT ClckURL (ServerPartT IO)) headers
     , EmbedAsChild (ClckT ClckURL (ServerPartT IO)) body
     ) =>
     T.Text  -- ^ title to stick in \<title\> tag
  -> headers -- ^ extra values to stick in \<head\> tag
  -> body    -- ^ value to stick in \<body\> tag
  -> XMLGenT (ClckT ClckURL (ServerPartT IO)) XML
defaultTemplate ttl hdr bdy = do
    p <- plugins <$> get
    ~(Just authRouteFn) <- getPluginRouteFn p (pluginName authenticatePlugin)
    [hsx|
    <html>
     <head>
      <meta charset="utf-8" />
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      -- the meta tags must come first
      <title><% ttl %></title>
      <script src="http://code.jquery.com/jquery-latest.js"></script>
      <link rel="stylesheet" type="text/css" media="screen" href=(ThemeData "data/css/bootstrap.min.css")  />
      <script src=(ThemeData "data/js/bootstrap.min.js")></script>
      <link rel="stylesheet" type="text/css" href=(ThemeData "data/css/hscolour.css") />
      <script src="//ajax.googleapis.com/ajax/libs/angularjs/1.2.24/angular.min.js"></script>
      <script src="//ajax.googleapis.com/ajax/libs/angularjs/1.2.24/angular-route.min.js"></script>
      <script src=(JS ClckwrksApp)></script>
      <script src=(authRouteFn (Auth Controllers) [])></script>
      <% hdr %>
      <% googleAnalytics %>
     </head>
     <body ng-app="clckwrksApp" ng-controller="AuthenticationCtrl">
      <div id="wrap">
       <% genNavBar %>
       <div class="container">
         <div class="row">
          <div class="span8">
           <% bdy %>
          </div>
         </div>
       </div>
       <div id="push"></div>
      </div>

      <footer id="footer" class="footer">
       <div class="container">
         <p class="muted">Powered by <a href="http://clckwrks.com/">Clckwrks</a> and <a href="http://happstack.com/">Happstack</a>.</p>
       </div>
      </footer>
     </body>
    </html>
    |]


-- | default `ThemeStyle` for this theme
defaultStyle :: ThemeStyle
defaultStyle = ThemeStyle
    { themeStyleName        = "default"
    , themeStyleDescription = "default view"
    , themeStylePreview     = Nothing
    , themeStyleTemplate    = defaultTemplate
    }
