package com.gridsum.Debug
{
   public class TextTracer extends Object
   {
      
      private static var _defaultInstance:ITextTracer = new DefaultTextTracer();
      
      public function TextTracer()
      {
         super();
      }
      
      public static function setTracer(param1:ITextTracer) : void
      {
         _defaultInstance = param1;
      }
      
      public static function writeLine(param1:String) : void
      {
         var _loc2_:String = null;
         if(_defaultInstance != null)
         {
            _loc2_ = new Date().toLocaleTimeString();
            _defaultInstance.writeLine("[" + _loc2_ + "] " + param1);
         }
      }
      
      public static function write(param1:String) : void
      {
         var _loc2_:String = null;
         if(_defaultInstance != null)
         {
            _loc2_ = new Date().toLocaleTimeString();
            _defaultInstance.write("[" + _loc2_ + "] " + param1);
         }
      }
   }
}
