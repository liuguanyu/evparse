package com.alex.utils
{
   import flash.display.DisplayObject;
   
   public class ObjectUtil extends Object
   {
      
      public function ObjectUtil()
      {
         super();
      }
      
      public static function objectParseToString(param1:Object) : String
      {
         var _loc3_:* = 0;
         var _loc4_:String = null;
         if(param1 == null)
         {
            return "";
         }
         var _loc2_:* = "";
         for(_loc4_ in param1)
         {
            if(_loc3_ > 0)
            {
               _loc2_ = _loc2_ + ("&" + _loc4_ + "=" + param1[_loc4_]);
            }
            else
            {
               _loc2_ = _loc2_ + (_loc4_ + "=" + param1[_loc4_]);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public static function parserToXML(param1:Object) : XMLList
      {
         var _loc2_:XML = <node></node>;
         toXML(param1,_loc2_);
         return _loc2_.node;
      }
      
      private static function toXML(param1:Object, param2:XML, param3:Object = null) : void
      {
         var _loc4_:XML = null;
         var _loc5_:* = 0;
         var _loc6_:String = null;
         if(param1 != null)
         {
            if(param1 is Boolean)
            {
               param2.appendChild(XML("<node label=\'" + (param3?param3:param1) + " (Boolean)\' value=\'" + param1 + "\'/>"));
            }
            else if(param1 is Number)
            {
               param2.appendChild(XML("<node label=\'" + (param3 != null?param3:param1) + " (Number)\' value=\'" + param1 + "\'/>"));
            }
            else if(param1 is String)
            {
               param2.appendChild(XML("<node label=\'" + (param3 != null?param3:param1) + " (String)\' value=\'" + param1 + "\'/>"));
            }
            else if(param1 is DisplayObject)
            {
               param2.appendChild(XML("<node label=\'" + (param3 != null?param3:param1["name"]) + " (DisplayObject)\' value=\'" + param1["name"] + "\'/>"));
            }
            else if(param1 is Array)
            {
               param2.appendChild(XML("<node label=\'" + (param3 != null?param3 + " (Array)":"(Array)") + "\' value=\'Array\' collection=\'1\'/>"));
               _loc4_ = param2.node[param2.node.length() - 1];
               _loc5_ = 0;
               while(_loc5_ < param1.length)
               {
                  toXML(param1[_loc5_],_loc4_,_loc5_);
                  _loc5_++;
               }
            }
            else
            {
               param2.appendChild(XML("<node label=\'" + (param3 != null?param3:"Object") + " (Object)\' value=\'Object\' collection=\'1\'/>"));
               _loc4_ = param2.node[param2.node.length() - 1];
               for(_loc6_ in param1)
               {
                  toXML(param1[_loc6_],_loc4_,_loc6_);
               }
            }
            
            
            
            
         }
      }
   }
}
