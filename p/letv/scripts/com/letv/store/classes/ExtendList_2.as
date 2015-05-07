package com.letv.store.classes
{
   import com.letv.player.components.ExtendListUI_2;
   import com.letv.player.components.dragBar.Dragbar;
   import com.greensock.TweenLite;
   import com.letv.store.events.ExtendListEvent;
   import com.greensock.easing.Back;
   import flash.events.MouseEvent;
   import com.letv.player.components.dragBar.DragbarDirection;
   import com.letv.player.components.dragBar.DragbarEvent;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   
   public class ExtendList_2 extends ExtendListUI_2
   {
      
      private var _opening:Boolean;
      
      private var _allData:Array;
      
      private var _list:Vector.<ExtendListItem_2>;
      
      private var dragbarUI:Dragbar;
      
      public function ExtendList_2(param1:Array)
      {
         super();
         var _loc2_:ContextMenu = new ContextMenu();
         _loc2_.hideBuiltInItems();
         _loc2_.customItems.push(new ContextMenuItem("components_extendstore_2",true));
         this.contextMenu = _loc2_;
         this._allData = param1;
         this.init();
      }
      
      public function destroy() : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
         TweenLite.killTweensOf(this);
         this.removeListener();
         this._allData = null;
         if(this._list == null || this._list.length == 0)
         {
            return;
         }
         var _loc1_:int = this._list.length;
         var _loc2_:* = 0;
         while(_loc2_ < _loc1_)
         {
            TweenLite.killTweensOf(this._list[_loc2_]);
            this._list[_loc2_].destroy();
            this._list[_loc2_].removeEventListener(ExtendListEvent.CHANGE,this.onItemChange);
            this._list[_loc2_].removeEventListener(ExtendListEvent.CLOSE_PLUGIN,this.onItemClose);
            this._list[_loc2_] = null;
            _loc2_++;
         }
         this._list = null;
      }
      
      public function toggle() : void
      {
         if(this._opening)
         {
            this.hide();
         }
         else
         {
            this.show();
         }
      }
      
      public function shutdown() : void
      {
         this.hide(false);
      }
      
      public function hide(param1:Boolean = true) : void
      {
         this._opening = false;
         this.removeListener();
         if(param1)
         {
            TweenLite.to(this,0.6,{
               "alpha":0,
               "y":-height,
               "ease":Back.easeInOut,
               "onComplete":this.onHideComplete
            });
         }
         else
         {
            visible = false;
         }
      }
      
      private function onHideComplete() : void
      {
         visible = false;
      }
      
      public function show() : void
      {
         if(stage)
         {
            this._opening = true;
            this.hideAll();
            this.addListener();
            visible = true;
            alpha = 0;
            y = -height;
            container.visible = false;
            TweenLite.to(this,0.6,{
               "alpha":1,
               "y":10,
               "ease":Back.easeInOut,
               "onComplete":this.onShowComplete
            });
         }
      }
      
      private function onShowComplete() : void
      {
         var _loc3_:* = NaN;
         if(this._list == null || this._list.length == 0)
         {
            return;
         }
         container.visible = true;
         var _loc1_:int = this._list.length;
         var _loc2_:* = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = (this._list[_loc2_].width + ExtendListItem_2.GAP) * _loc2_;
            this._list[_loc2_].x = _loc3_;
            this._list[_loc2_].x = _loc3_ - 40;
            this._list[_loc2_].alpha = 0;
            TweenLite.to(this._list[_loc2_],0.2,{
               "alpha":1,
               "x":_loc3_,
               "delay":0.06 * _loc2_
            });
            _loc2_++;
         }
      }
      
      public function update(param1:String, param2:Boolean) : void
      {
         var _loc4_:* = 0;
         var _loc3_:int = this._list.length;
         if(param2)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               if(this._list[_loc4_].eventid == param1)
               {
                  this._list[_loc4_].selected = true;
               }
               else
               {
                  this._list[_loc4_].selected = false;
               }
               _loc4_++;
            }
         }
         else
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               if(this._list[_loc4_].eventid == param1)
               {
                  this._list[_loc4_].selected = false;
                  break;
               }
               _loc4_++;
            }
         }
      }
      
      private function hideAll() : void
      {
         if(this._list == null || this._list.length == 0)
         {
            return;
         }
         var _loc1_:int = this._list.length;
         var _loc2_:* = 0;
         while(_loc2_ < _loc1_)
         {
            this._list[_loc2_].alpha = 0;
            _loc2_++;
         }
      }
      
      private function addListener() : void
      {
         closeBtn.addEventListener(MouseEvent.CLICK,this.onClose);
      }
      
      private function removeListener() : void
      {
         closeBtn.removeEventListener(MouseEvent.CLICK,this.onClose);
      }
      
      private function init() : void
      {
         x = 20;
         visible = false;
         container.mask = masker;
         this._list = new Vector.<ExtendListItem_2>();
         var _loc1_:int = this._allData.length;
         var _loc2_:* = 0;
         while(_loc2_ < _loc1_)
         {
            this._list[_loc2_] = new ExtendListItem_2(this._allData[_loc2_]);
            this._list[_loc2_].addEventListener(ExtendListEvent.CHANGE,this.onItemChange);
            this._list[_loc2_].addEventListener(ExtendListEvent.CLOSE_PLUGIN,this.onItemClose);
            this._list[_loc2_].alpha = 0;
            this._list[_loc2_].x = (this._list[_loc2_].width + ExtendListItem_2.GAP) * _loc2_;
            container.addChild(this._list[_loc2_]);
            _loc2_++;
         }
         if(container.width > dragbar.width)
         {
            this.dragbarUI = new Dragbar(dragbar,DragbarDirection.HORIZONTAL,true);
            this.dragbarUI.addEventListener(DragbarEvent.CHANGE,this.onChange);
         }
         else
         {
            dragbar.visible = false;
         }
      }
      
      private function onItemChange(param1:ExtendListEvent) : void
      {
         var _loc2_:ExtendListEvent = new ExtendListEvent(ExtendListEvent.CHANGE);
         _loc2_.eventid = param1.eventid;
         _loc2_.id = param1.id;
         dispatchEvent(_loc2_);
      }
      
      private function onItemClose(param1:ExtendListEvent) : void
      {
         var _loc2_:ExtendListEvent = new ExtendListEvent(ExtendListEvent.CLOSE_PLUGIN);
         _loc2_.eventid = param1.eventid;
         _loc2_.id = param1.id;
         dispatchEvent(_loc2_);
      }
      
      private function onChange(param1:DragbarEvent) : void
      {
         container.x = dragbar.x - this.dragbarUI.percent * (container.width - dragbar.width);
      }
      
      private function onClose(param1:MouseEvent) : void
      {
         this.hide();
      }
   }
}
