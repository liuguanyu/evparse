package com.letv.player.model.config
{
   public class SkinControlBarConfig extends Object
   {
      
      private var _nextBtnVisible:Boolean = true;
      
      private var _infotipVisible:Boolean = true;
      
      private var _definitionVisible:Boolean = true;
      
      public var cHeight:int = 0;
      
      private var _logoURL:String;
      
      private var _logoClkURL:String;
      
      private var _logoVisible:Boolean;
      
      private var _nextBtnStatus:String = "auto";
      
      public function SkinControlBarConfig(param1:Object, param2:XML)
      {
         var xml:XML = null;
         var flashvars:Object = param1;
         var pccs:XML = param2;
         super();
         try
         {
            xml = XML(pccs.skin[0].controlBar[0]);
         }
         catch(e:Error)
         {
         }
         try
         {
            this._nextBtnVisible = String(xml.nextBtn[0]) == "0"?false:true;
         }
         catch(e:Error)
         {
            _nextBtnVisible = true;
         }
         try
         {
            this._infotipVisible = String(xml.infotip[0]) == "0"?false:true;
         }
         catch(e:Error)
         {
            _infotipVisible = true;
         }
         try
         {
            this._definitionVisible = String(xml.definition[0]) == "0"?false:true;
         }
         catch(e:Error)
         {
            _definitionVisible = true;
         }
         try
         {
            this._nextBtnStatus = String(xml.nextBtnStatus[0]);
         }
         catch(e:Error)
         {
            _nextBtnStatus = "auto";
         }
         try
         {
            if(xml.hasOwnProperty("logo"))
            {
               this._logoVisible = true;
               this._logoURL = String(xml.logo.@logourl) == ""?null:String(xml.logo.@logourl);
               this._logoClkURL = String(xml.logo.@clickurl) == ""?null:String(xml.logo.@clickurl);
            }
            else
            {
               this._logoVisible = false;
               this._logoURL = null;
               this._logoClkURL = null;
            }
         }
         catch(e:Error)
         {
            _logoVisible = false;
            _logoURL = null;
            _logoClkURL = null;
         }
         try
         {
            if((flashvars.hasOwnProperty("nextBtn")) && !(flashvars["nextBtn"] == ""))
            {
               this._nextBtnVisible = String(flashvars["nextBtn"]) == "0"?false:true;
            }
            if((flashvars.hasOwnProperty("definition")) && !(flashvars["definition"] == ""))
            {
               this._definitionVisible = String(flashvars["definition"]) == "0"?false:true;
            }
            if(flashvars.hasOwnProperty("nextBtnStatus"))
            {
               this._nextBtnStatus = String(flashvars["nextBtnStatus"]);
            }
            if((flashvars.hasOwnProperty("simple")) && !(flashvars["simple"] == ""))
            {
               this._nextBtnVisible = false;
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public function get nextBtnVisible() : Boolean
      {
         return this._nextBtnVisible;
      }
      
      public function get infotipVisible() : Boolean
      {
         return this._infotipVisible;
      }
      
      public function get logoURL() : String
      {
         return this._logoURL;
      }
      
      public function get logoClkURL() : String
      {
         return this._logoClkURL;
      }
      
      public function get logoVisible() : Boolean
      {
         return this._logoVisible;
      }
      
      public function get definitionVisible() : Boolean
      {
         return this._definitionVisible;
      }
      
      public function set nextBtnStatus(param1:String) : void
      {
         this._nextBtnStatus = param1;
      }
      
      public function get nextBtnStatus() : String
      {
         return this._nextBtnStatus;
      }
   }
}
