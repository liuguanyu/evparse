package com.letv.player.model.config
{
   public class InfoCoopConfig extends Object
   {
      
      private var _zw:Boolean;
      
      private var _typeFrom:String = "letv";
      
      public function InfoCoopConfig(param1:Object, param2:XML)
      {
         var flashvars:Object = param1;
         var pccs:XML = param2;
         super();
         try
         {
            this._zw = String(pccs.zw[0]) == "1"?true:false;
         }
         catch(e:Error)
         {
            _zw = false;
         }
         try
         {
            this._typeFrom = String(pccs.init[0].typefrom[0]);
         }
         catch(e:Error)
         {
            _typeFrom = "letv";
         }
         try
         {
            if((flashvars.hasOwnProperty("tg")) && !(flashvars["tg"] == null) && !(flashvars["tg"] == "") && !(flashvars["tg"] == "null"))
            {
               this._typeFrom = "letv_" + flashvars["tg"];
            }
            else if((flashvars.hasOwnProperty("typeFrom")) && !(flashvars["typeFrom"] == null) && !(flashvars["typeFrom"] == "") && !(flashvars["typeFrom"] == "null"))
            {
               this._typeFrom = flashvars["typeFrom"];
            }
            else if((flashvars.hasOwnProperty("from")) && !(flashvars["from"] == null) && !(flashvars["from"] == "") && !(flashvars["from"] == "null"))
            {
               this._typeFrom = flashvars["from"];
            }
            
            
         }
         catch(e:Error)
         {
         }
         if(this._typeFrom.indexOf("#") != -1)
         {
            this._typeFrom = this._typeFrom.split("#")[0];
         }
      }
      
      public function get zw() : Boolean
      {
         return this._zw;
      }
      
      public function get typeFrom() : String
      {
         return this._typeFrom;
      }
   }
}
