package org.puremvc.as3.multicore.utilities.fabrication.plumbing
{
   import org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IDisposable;
   import org.puremvc.as3.multicore.utilities.fabrication.utils.HashMap;
   import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.IRouterMessage;
   import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
   import org.puremvc.as3.multicore.utilities.fabrication.interfaces.INamedPipeFitting;
   import org.puremvc.as3.multicore.utilities.fabrication.vo.ModuleAddress;
   
   public class DynamicJunction extends Junction implements IDisposable
   {
      
      public static const MODULE_GROUP_REGEXP:RegExp = new RegExp("^[^\\*/]*$","");
      
      protected var moduleGroups:HashMap;
      
      public function DynamicJunction()
      {
         super();
         this.moduleGroups = new HashMap();
      }
      
      override public function sendMessage(param1:String, param2:IPipeMessage) : Boolean
      {
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:* = 0;
         var _loc8_:* = 0;
         var _loc3_:PipeDescriptor = this.describePipeName(param1);
         var _loc4_:IRouterMessage = param2 as IRouterMessage;
         if(param1 == "*")
         {
            for(_loc5_ in pipesMap)
            {
               if(!this.isLoopback(_loc5_,_loc4_.getFrom()))
               {
                  super.sendMessage(_loc5_,param2);
               }
            }
            return true;
         }
         if(this.isModuleGroup(param1))
         {
            _loc6_ = this.retrieveOutputPipesByModuleGroup(param1);
            if(_loc6_ == null)
            {
               return false;
            }
            _loc7_ = _loc6_.length;
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc5_ = _loc6_[_loc8_];
               if(!this.isLoopback(_loc5_,_loc4_.getFrom()))
               {
                  super.sendMessage(_loc5_,param2);
               }
               _loc8_++;
            }
            return _loc7_ > 0;
         }
         if(_loc3_.groupName != null)
         {
            _loc6_ = this.retrieveOutputPipesInModuleGroupByModuleName(_loc3_.groupName,_loc3_.className);
            _loc7_ = _loc6_.length;
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc5_ = _loc6_[_loc8_];
               if(!this.isLoopback(_loc5_,_loc4_.getFrom()))
               {
                  super.sendMessage(_loc5_,param2);
               }
               _loc8_++;
            }
            return _loc7_ > 0;
         }
         if(_loc3_.instanceName == "*")
         {
            _loc6_ = this.retrieveOutputPipesByClassName(_loc3_.className);
            _loc7_ = _loc6_.length;
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc5_ = _loc6_[_loc8_];
               if(!this.isLoopback(_loc5_,_loc4_.getFrom()))
               {
                  super.sendMessage(_loc5_,param2);
               }
               _loc8_++;
            }
            return _loc7_ > 0;
         }
         if(!this.isLoopback(param1,_loc4_.getFrom()))
         {
            return super.sendMessage(param1,param2);
         }
         return false;
      }
      
      public function dispose() : void
      {
         pipesMap = null;
         outputPipes = null;
         pipeTypesMap = null;
         inputPipes = null;
         this.moduleGroups.dispose();
         this.moduleGroups = null;
      }
      
      override public function registerPipe(param1:String, param2:String, param3:IPipeFitting) : Boolean
      {
         var _loc4_:INamedPipeFitting = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         if(param2 == Junction.OUTPUT && param3 is INamedPipeFitting)
         {
            _loc4_ = param3 as INamedPipeFitting;
            _loc5_ = _loc4_.moduleGroup;
            if(!(_loc5_ == null) && _loc5_.length > 0)
            {
               _loc6_ = this.moduleGroups.find(_loc5_) as Array;
               if(_loc6_ == null)
               {
                  _loc6_ = this.moduleGroups.put(_loc5_,new Array()) as Array;
               }
               _loc6_.push(param1);
            }
         }
         return super.registerPipe(param1,param2,param3);
      }
      
      override public function removePipe(param1:String) : void
      {
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:* = 0;
         var _loc2_:INamedPipeFitting = pipesMap[param1] as INamedPipeFitting;
         var _loc3_:String = pipeTypesMap[param1];
         if(!(_loc2_ == null) && _loc3_ == Junction.OUTPUT)
         {
            _loc4_ = _loc2_.moduleGroup;
            if(_loc4_ != null)
            {
               _loc5_ = this.moduleGroups.find(_loc4_) as Array;
               if(_loc5_ != null)
               {
                  _loc6_ = this.findPipeIndex(_loc5_,param1);
                  if(_loc6_ >= 0)
                  {
                     _loc5_.splice(_loc6_,1);
                  }
               }
            }
         }
         super.removePipe(param1);
      }
      
      protected function retrieveOutputPipesByClassName(param1:String) : Array
      {
         var _loc3_:PipeDescriptor = null;
         var _loc4_:String = null;
         var _loc2_:Array = new Array();
         for(_loc4_ in pipesMap)
         {
            _loc3_ = this.describePipeName(_loc4_);
            if(_loc3_.className == param1)
            {
               _loc2_.push(_loc4_);
            }
         }
         return _loc2_;
      }
      
      protected function retrieveOutputPipesByModuleGroup(param1:String) : Array
      {
         return this.moduleGroups.find(param1) as Array;
      }
      
      protected function retrieveOutputPipesInModuleGroupByModuleName(param1:String, param2:String) : Array
      {
         var _loc5_:* = 0;
         var _loc6_:String = null;
         var _loc7_:PipeDescriptor = null;
         var _loc3_:Array = this.retrieveOutputPipesByModuleGroup(param1);
         var _loc4_:int = _loc3_.length;
         var _loc8_:Array = new Array();
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc3_[_loc5_];
            _loc7_ = this.describePipeName(_loc6_);
            if(_loc7_.className == param2)
            {
               _loc8_.push(_loc6_);
            }
            _loc5_++;
         }
         return _loc8_;
      }
      
      protected function describePipeName(param1:String) : PipeDescriptor
      {
         var _loc2_:Array = param1.split("/");
         var _loc3_:PipeDescriptor = new PipeDescriptor();
         _loc3_.className = _loc2_[0];
         _loc3_.instanceName = _loc2_[1];
         var _loc4_:Object = ModuleAddress.groupNameRegExp.exec(_loc3_.instanceName);
         if(!(_loc4_ == null) && _loc4_.length == 2)
         {
            _loc3_.groupName = _loc4_[1];
         }
         _loc3_.type = _loc2_[1];
         return _loc3_;
      }
      
      protected function calcPipeClassName(param1:String) : String
      {
         return this.describePipeName(param1).className;
      }
      
      protected function calcModuleAddress(param1:String) : ModuleAddress
      {
         var _loc2_:ModuleAddress = new ModuleAddress();
         _loc2_.parse(param1);
         return _loc2_;
      }
      
      protected function isLoopback(param1:String, param2:String) : Boolean
      {
         var _loc3_:ModuleAddress = this.calcModuleAddress(param1);
         var _loc4_:ModuleAddress = this.calcModuleAddress(param2);
         return _loc3_.equals(_loc4_);
      }
      
      protected function findPipeIndex(param1:Array, param2:String) : int
      {
         var _loc4_:String = null;
         var _loc3_:int = param1.length;
         var _loc5_:* = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = param1[_loc5_];
            if(_loc4_ == param2)
            {
               return _loc5_;
            }
            _loc5_++;
         }
         return -1;
      }
      
      public function isModuleGroup(param1:String) : Boolean
      {
         return !(param1 == null) && !(param1 == "") && (MODULE_GROUP_REGEXP.test(param1));
      }
   }
}

class PipeDescriptor extends Object
{
   
   public var className:String;
   
   public var instanceName:String;
   
   public var groupName:String;
   
   public var type:String;
   
   function PipeDescriptor()
   {
      super();
   }
}
