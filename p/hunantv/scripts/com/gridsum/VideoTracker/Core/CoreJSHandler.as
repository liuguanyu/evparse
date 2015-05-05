package com.gridsum.VideoTracker.Core
{
   import flash.external.ExternalInterface;
   
   class CoreJSHandler extends Object
   {
      
      function CoreJSHandler()
      {
         super();
      }
      
      public static function Initialize() : void
      {
         var str:String = "";
         str = str + ("if(GVCoreFunction == undefined)" + "{");
         str = str + ("function getTxt() {" + "\treturn \"this is a text\";" + "}");
         str = str + ("function getBrowser() {" + "var ua = navigator.userAgent.toLowerCase(), s , o = {};" + "if( ua.indexOf(\"msie\") > -1 ) {" + "\ts=ua.indexOf(\"msie\");" + "\to.info = \"ie\";" + "\to.version = parseFloat(ua.substring(s+5));" + "} else if( ua.indexOf(\"firefox\") > -1 ) {" + "\ts=ua.indexOf(\"firefox\");" + "\to.info = \"firefox\";" + "\to.version = parseFloat(ua.substring(s+8));" + "} else if( ua.indexOf(\"chrome\") > -1 ) {" + "\ts=ua.indexOf(\"chrome\");" + "\to.info = \"chrome\";" + "\to.version = parseFloat(ua.substring(s+7));" + "} else if( ua.indexOf(\"opera\") > -1 ) {" + "\ts=ua.indexOf(\"opera\");" + "\to.info = \"opera\";" + "\to.version = parseFloat(ua.substring(s+6));" + "} else if( ua.indexOf(\"safari\") > -1 ) {" + "\tvar tmp=ua.substring(0, ua.indexOf(\"safari\"));" + "\ts=tmp.lastIndexOf(\"version\");" + "\to.info = \"safari\";" + "\to.version = parseFloat(tmp.substring(s+8));" + "} else if(Object.hasOwnProperty.call(window, \"ActiveXObject\") && !window.ActiveXObject) {" + "\to.info = \"ie\";" + "\to.version = \"11\";" + "}" + "o.info = (o.info?o.info:\"\") + \" \" + o.version;" + "return o.info;" + "}");
         str = str + ("var GVCoreFunction = 1;" + "}");
         try
         {
            if(ExternalInterface.available)
            {
               ExternalInterface.call("eval",str);
            }
         }
         catch(err:Error)
         {
         }
      }
      
      public static function getBrowser() : String
      {
         try
         {
            if(ExternalInterface.available)
            {
               return ExternalInterface.call("eval","getBrowser()");
            }
         }
         catch(err:Error)
         {
         }
         return null;
      }
   }
}
