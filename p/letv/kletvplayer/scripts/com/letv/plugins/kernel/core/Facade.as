package com.letv.plugins.kernel.core
{
   import com.letv.plugins.kernel.Kernel;
   import com.letv.plugins.kernel.model.Model;
   import com.letv.plugins.kernel.view.View;
   import com.letv.plugins.kernel.controller.Controller;
   import com.letv.plugins.kernel.statistics.LetvStatistics;
   
   public class Facade extends Object
   {
      
      private var main:Kernel;
      
      private var _model:Model;
      
      private var _view:View;
      
      private var _controller:Controller;
      
      public function Facade(param1:Kernel)
      {
         super();
         this.main = param1;
         this.init();
      }
      
      public function get controller() : Controller
      {
         return this._controller;
      }
      
      public function get view() : View
      {
         return this._view;
      }
      
      public function get model() : Model
      {
         return this._model;
      }
      
      public function destroy() : void
      {
         this._model = null;
         this._controller.closeVideo();
         this._controller = null;
         this._view.destroy();
         this._view = null;
         this.main = null;
      }
      
      protected function init() : void
      {
         this._model = new Model();
         this._controller = new Controller(this.model);
         LetvStatistics.getInstance().init(this.model,this.controller);
         this._view = new View(this.main,this.model,this.controller);
      }
   }
}
