package org.puremvc.as3.multicore.utilities.fabrication.vo
{
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IModuleAddress;
   
   public class ModuleAddress extends Object implements IModuleAddress
   {
      
      public static const INPUT_SUFFIX:String = "/INPUT";
      
      public static const OUTPUT_SUFFIX:String = "/OUTPUT";
      
      public static const inputSuffixRegExp:RegExp = new RegExp("\\" + INPUT_SUFFIX + "$","");
      
      public static const outputSuffixRegExp:RegExp = new RegExp("\\" + OUTPUT_SUFFIX + "$","");
      
      public static const groupNameRegExp:RegExp = new RegExp("^#(.+)$","");
      
      private var className:String;
      
      private var instanceName:String;
      
      private var groupName:String;
      
      public function ModuleAddress(param1:String = null, param2:String = null, param3:String = null)
      {
         super();
         this.className = param1;
         this.instanceName = param2;
         this.groupName = param3;
      }
      
      public function getClassName() : String
      {
         return this.className;
      }
      
      public function getInstanceName() : String
      {
         return this.instanceName;
      }
      
      public function getGroupName() : String
      {
         return this.groupName;
      }
      
      public function getInputName() : String
      {
         return this.getClassName() + "/" + this.getInstanceName() + INPUT_SUFFIX;
      }
      
      public function getOutputName() : String
      {
         return this.getClassName() + "/" + this.getInstanceName() + OUTPUT_SUFFIX;
      }
      
      public function parse(param1:String) : void
      {
         var _loc4_:Object = null;
         var _loc2_:Array = param1.split("/");
         var _loc3_:int = _loc2_.length;
         if(_loc3_ >= 2)
         {
            this.className = _loc2_[0] as String;
            this.instanceName = _loc2_[1] as String;
            _loc4_ = groupNameRegExp.exec(this.instanceName);
            if(!(_loc4_ == null) && _loc4_.length == 2)
            {
               this.groupName = _loc4_[1];
            }
         }
         else if(_loc3_ == 1)
         {
            this.className = _loc2_[0] as String;
            this.instanceName = null;
         }
         
      }
      
      public function equals(param1:ModuleAddress) : Boolean
      {
         return param1.getClassName() == this.getClassName() && param1.getInstanceName() == this.getInstanceName();
      }
      
      public function dispose() : void
      {
         this.className = null;
         this.instanceName = null;
         this.groupName = null;
      }
   }
}
