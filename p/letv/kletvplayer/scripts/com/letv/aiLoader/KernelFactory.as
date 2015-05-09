package com.letv.aiLoader
{
   import com.letv.aiLoader.kernel.IKernel;
   import com.letv.aiLoader.kernel.SingleKernel;
   import com.letv.aiLoader.kernel.MultiPleKernel;
   import com.letv.aiLoader.type.LoadOrderType;
   
   public class KernelFactory extends Object
   {
      
      public function KernelFactory()
      {
         super();
      }
      
      public static function create(param1:String) : IKernel
      {
         var _loc2_:IKernel = null;
         switch(param1)
         {
            case LoadOrderType.LOAD_SINGLE:
               _loc2_ = new SingleKernel();
               break;
            case LoadOrderType.LOAD_MULTIPLE:
               _loc2_ = new MultiPleKernel();
               break;
            default:
               _loc2_ = new SingleKernel();
         }
         return _loc2_;
      }
   }
}
