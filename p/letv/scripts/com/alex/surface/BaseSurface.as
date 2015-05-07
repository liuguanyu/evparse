package com.alex.surface
{
   import flash.display.MovieClip;
   import flash.utils.getDefinitionByName;
   import com.alex.error.SkinError;
   
   public class BaseSurface extends Object implements ISurface
   {
      
      private var _skinlist:Object;
      
      private var _skin:MovieClip;
      
      public function BaseSurface(param1:MovieClip = null)
      {
         super();
         this.setSkin(param1);
      }
      
      public function get skin() : MovieClip
      {
         return this._skin;
      }
      
      public function setSkin(param1:MovieClip) : void
      {
         this.extract(param1);
      }
      
      public function getSkinConfig() : XML
      {
         return <root></root>;
      }
      
      public function getStyleName(param1:String) : String
      {
         if(!(this._skinlist == null) && (this._skinlist.hasOwnProperty(param1)))
         {
            return this._skinlist[param1];
         }
         return null;
      }
      
      protected function extract(param1:MovieClip) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:Class = null;
         var _loc6_:* = 0;
         var _loc7_:* = 0;
         if(param1 != null)
         {
            this._skinlist = {};
            _loc2_ = this.getSkinConfig().node;
            _loc6_ = _loc2_.length();
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc3_ = _loc2_[_loc7_].@type;
               _loc4_ = _loc2_[_loc7_].@name;
               _loc5_ = getDefinitionByName(String(_loc2_[_loc7_].@flash)) as Class;
               if(_loc5_ == null)
               {
                  throw new SkinError("皮肤配置文件错误",SkinError.SKIN_EXTRACT_ERROR);
               }
               else
               {
                  if(String(_loc2_[_loc7_].@option) == "1")
                  {
                     if((param1.hasOwnProperty(_loc4_)) && param1[_loc4_] is _loc5_)
                     {
                        this._skinlist[_loc3_] = _loc4_;
                     }
                     else if((param1.hasOwnProperty(_loc3_)) && param1[_loc3_] is _loc5_)
                     {
                        this._skinlist[_loc3_] = _loc3_;
                     }
                     
                  }
                  else if((param1.hasOwnProperty(_loc4_)) && param1[_loc4_] is _loc5_)
                  {
                     this._skinlist[_loc3_] = _loc4_;
                  }
                  else if((param1.hasOwnProperty(_loc3_)) && param1[_loc3_] is _loc5_)
                  {
                     this._skinlist[_loc3_] = _loc3_;
                  }
                  else
                  {
                     throw new SkinError("皮肤抽取错误",SkinError.SKIN_EXTRACT_ERROR);
                  }
                  
                  
                  _loc7_++;
                  continue;
               }
            }
            this._skin = param1;
            return;
         }
         throw new SkinError("皮肤抽取错误",SkinError.SKIN_EXTRACT_ERROR);
      }
   }
}
