package com.gridsum.Debug
{
   public class DefaultTextTracer extends Object implements ITextTracer
   {
      
      public function DefaultTextTracer()
      {
         super();
      }
      
      public function writeLine(param1:String) : void
      {
         trace(param1);
      }
      
      public function write(param1:String) : void
      {
         trace(param1);
      }
   }
}
