package org.as3commons.reflect
{
   public class Accessor extends Field
   {
      
      private var _access:AccessorAccess;
      
      public function Accessor(param1:String, param2:AccessorAccess, param3:String, param4:String, param5:Boolean, param6:Array = null)
      {
         super(param1,param3,param4,param5,param6);
         _access = param2;
      }
      
      public function get readable() : Boolean
      {
         return isReadable();
      }
      
      public function isReadable() : Boolean
      {
         return _access == AccessorAccess.READ_ONLY || _access == AccessorAccess.READ_WRITE;
      }
      
      public function get access() : AccessorAccess
      {
         return _access;
      }
      
      public function get writeable() : Boolean
      {
         return isWriteable();
      }
      
      public function isWriteable() : Boolean
      {
         return _access == AccessorAccess.WRITE_ONLY || _access == AccessorAccess.READ_WRITE;
      }
   }
}
