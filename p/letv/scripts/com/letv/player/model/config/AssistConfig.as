package com.letv.player.model.config
{
   public class AssistConfig extends Object
   {
      
      private var _docStat:Boolean;
      
      private var _runDebug:Boolean;
      
      public function AssistConfig(param1:Object, param2:XML)
      {
         var flashvars:Object = param1;
         var pccs:XML = param2;
         super();
         try
         {
            this._docStat = String(pccs.init[0].dockstat[0]) == "0"?false:true;
         }
         catch(e:Error)
         {
            _docStat = true;
         }
         try
         {
            if(flashvars.hasOwnProperty("docstat"))
            {
               this._docStat = String(flashvars["docstat"]) == "1";
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public function get docStat() : Boolean
      {
         return this._docStat;
      }
   }
}
