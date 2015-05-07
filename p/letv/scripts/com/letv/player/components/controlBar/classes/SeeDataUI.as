package com.letv.player.components.controlBar.classes
{
   import com.letv.player.components.BaseConfigComponent;
   import com.letv.player.components.controlBar.classes.seeDataPreview.SeePoint;
   import com.letv.player.components.controlBar.classes.seeDataPreview.ISeePoint;
   import com.letv.player.components.controlBar.classes.seeDataPreview.SeePointFactory;
   
   public class SeeDataUI extends BaseConfigComponent
   {
      
      private var pointClass:Class;
      
      private var duration:Number = 0;
      
      private var seeData:Array;
      
      private var stack:Array;
      
      public function SeeDataUI(param1:Object)
      {
         super();
         this.x = param1.x;
      }
      
      public function resize(param1:Number, param2:Number) : void
      {
         var _loc3_:* = 0;
         if(!(this.stack == null) && this.stack.length > 0 && this.duration > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < this.stack.length)
            {
               if(this.stack[_loc3_] != null)
               {
                  this.stack[_loc3_].x = param1 * this.stack[_loc3_].time / this.duration;
                  this.stack[_loc3_].y = param2 * 0.5;
               }
               _loc3_++;
            }
         }
      }
      
      public function setData(param1:Object, param2:Number = 0) : void
      {
         this.removeAll();
         this.duration = param2;
         this.seeData = param1.seeData;
         if(this.seeData == null)
         {
            this.seeData = [];
         }
         if(param1.headTime > 0)
         {
            this.seeData.push({
               "step":param1.headTime,
               "type":SeePoint.POINT_HEAD
            });
         }
         if(param1.tailTime > 0)
         {
            this.seeData.push({
               "step":param1.tailTime,
               "type":SeePoint.POINT_TAIL
            });
         }
         var _loc3_:* = 0;
         while(_loc3_ < this.seeData.length)
         {
            if(!this.seeData[_loc3_].hasOwnProperty("type"))
            {
               this.seeData[_loc3_].type = SeePoint.POINT_NORMAL;
            }
            _loc3_++;
         }
         this.initAll();
         this.visible = true;
         this.lock();
      }
      
      public function resetDuration(param1:Number) : void
      {
         if(param1 > 0)
         {
            this.visible = true;
            this.duration = param1;
         }
      }
      
      public function lock() : void
      {
         if(this.stack == null)
         {
            return;
         }
         var _loc1_:* = 0;
         while(_loc1_ < this.stack.length)
         {
            if(this.stack[_loc1_] != null)
            {
               this.stack[_loc1_].mouseChildren = false;
               this.stack[_loc1_].mouseEnabled = false;
            }
            _loc1_++;
         }
      }
      
      public function unlock() : void
      {
         visible = true;
         if(this.stack == null)
         {
            return;
         }
         var _loc1_:* = 0;
         while(_loc1_ < this.stack.length)
         {
            if(this.stack[_loc1_] != null)
            {
               this.stack[_loc1_].mouseEnabled = true;
               this.stack[_loc1_].mouseChildren = true;
            }
            _loc1_++;
         }
      }
      
      public function hide() : void
      {
         visible = false;
      }
      
      private function initAll() : void
      {
         var _loc2_:ISeePoint = null;
         this.stack = [];
         var _loc1_:int = this.seeData.length;
         var _loc3_:* = 0;
         while(_loc3_ < _loc1_)
         {
            if(this.seeData[_loc3_].step <= this.duration)
            {
               _loc2_ = SeePointFactory.create(this.pointClass,this,this.seeData[_loc3_],this.duration);
               if(_loc2_ != null)
               {
                  this.stack[_loc3_] = _loc2_;
                  addElement(this.stack[_loc3_]);
                  this.stack[_loc3_].x = 100 * this.stack[_loc3_].time / this.duration;
               }
            }
            _loc3_++;
         }
      }
      
      private function removeAll() : void
      {
         var _loc1_:* = 0;
         var _loc2_:* = 0;
         if(this.stack != null)
         {
            _loc1_ = this.stack.length;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               if(this.stack[_loc2_] != null)
               {
                  this.stack[_loc2_].destroy();
               }
               _loc2_++;
            }
         }
         this.hide();
         this.stack = null;
         this.seeData = null;
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         try
         {
            mouseEnabled = false;
            this.pointClass = skinApplicationDomain.getDefinition("SeekPointClass") as Class;
            if(this.pointClass == null)
            {
               this.hellNo();
               return;
            }
         }
         catch(e:Error)
         {
            hellNo();
            return;
         }
      }
      
      private function hellNo() : void
      {
         super.destroy();
      }
   }
}
