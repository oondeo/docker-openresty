/**
 * cbpAnimatedHeader.js v1.0.0
 * http://www.codrops.com
 *
 * Licensed under the MIT license.
 * http://www.opensource.org/licenses/mit-license.php
 * 
 * Copyright 2013, Codrops
 * http://www.codrops.com
 */
var cbpAnimatedHeader=function(){function n(){window.addEventListener("scroll",function(n){a||(a=!0,setTimeout(e,250))},!1)}function e(){var n=t();n>=i?classie.add(r,"navbar-shrink"):classie.remove(r,"navbar-shrink"),a=!1}function t(){return window.pageYOffset||o.scrollTop}var o=document.documentElement,r=document.querySelector(".navbar-fixed-top"),a=!1,i=300;n()}();