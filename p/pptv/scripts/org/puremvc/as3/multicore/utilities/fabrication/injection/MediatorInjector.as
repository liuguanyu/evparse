package org.puremvc.as3.multicore.utilities.fabrication.injection
{
   import org.puremvc.as3.multicore.interfaces.IMediator;
   import org.puremvc.as3.multicore.interfaces.IFacade;
   
   public class MediatorInjector extends Injector
   {
      
      public function MediatorInjector(param1:IFacade, param2:*)
      {
         super(param1,param2,INJECT_MEDIATOR);
      }
      
      override protected function elementExist(param1:String) : Boolean
      {
         return !(null == param1) && (facade.hasMediator(param1));
      }
      
      override protected function getPatternElementForInjection(param1:String, param2:Class) : Object
      {
         var _loc3_:IMediator = facade.retrieveMediator(param1) as IMediator;
         if((_loc3_) && _loc3_ is param2)
         {
            return _loc3_;
         }
         return null;
      }
   }
}
