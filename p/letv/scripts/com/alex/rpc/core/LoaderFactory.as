package com.alex.rpc.core
{
   import com.alex.rpc.interfaces.ILoader;
   import com.alex.rpc.type.LoadOrderType;
   
   public class LoaderFactory extends Object
   {
      
      public function LoaderFactory()
      {
         super();
      }
      
      public static function create(param1:String) : ILoader
      {
         var _loc2_:ILoader = null;
         switch(param1)
         {
            case LoadOrderType.LOAD_SINGLE:
               _loc2_ = new SingleLoader();
               break;
            case LoadOrderType.LOAD_MULTIPLE:
               _loc2_ = new MultiLoader();
               break;
            default:
               _loc2_ = new SingleLoader();
         }
         return _loc2_;
      }
   }
}
