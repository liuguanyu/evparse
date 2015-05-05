package cn.pplive.player.dac
{
   import org.puremvc.as3.multicore.utilities.fabrication.patterns.mediator.FlashMediator;
   import cn.pplive.player.manager.*;
   import cn.pplive.player.common.*;
   import cn.pplive.player.utils.PrintDebug;
   import flash.events.Event;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class DACMediator extends FlashMediator
   {
      
      public static const NAME:String = "dac_mediator";
      
      private var _dac_report:DACReport;
      
      public function DACMediator(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      public function get dac_report() : DACReport
      {
         return this._dac_report;
      }
      
      override public function onRegister() : void
      {
         this._dac_report = new DACReport("_ikan_");
         this._dac_report.addEventListener(DACReport.INIT_VVID,this.onInitHandler);
         if(!this._dac_report.puid)
         {
            ViewManager.getInstance().getProxy("puid").initData();
         }
         else
         {
            VodCommon.puid = this._dac_report.puid;
            PrintDebug.Trace("本地 cookie 读取 guid : ",this._dac_report.puid);
         }
      }
      
      private function onInitHandler(param1:Event) : void
      {
         this._dac_report.isVip = VIPPrivilege.isVip;
      }
      
      public function setPuid() : void
      {
         this._dac_report.puid = VodCommon.mkey?VodCommon.mkey:this._dac_report.puid;
      }
      
      public function respondToVodPuidSuccess(param1:INotification) : void
      {
         PrintDebug.Trace("远端请求获取 guid : ",VodCommon.puid);
         this._dac_report.puid = VodCommon.mkey?VodCommon.mkey:VodCommon.puid;
         DACQueue.sendLogQueue(this._dac_report.puid);
      }
      
      public function respondToUpdateSession(param1:INotification) : void
      {
         this._dac_report.updateSession();
      }
      
      public function respondToDacMark(param1:INotification) : void
      {
         this._dac_report.setMark(param1.getType(),param1.getBody());
      }
      
      public function respondToAddValue(param1:INotification) : void
      {
         this._dac_report.addValue(param1.getType(),param1.getBody()?Number(param1.getBody()):1);
      }
      
      public function respondToAddObjectValue(param1:INotification) : void
      {
         this._dac_report.addObjectValue(param1.getType(),param1.getBody());
      }
      
      public function respondToSetValue(param1:INotification) : void
      {
         this._dac_report.setValue(param1.getType(),param1.getBody());
      }
      
      public function respondToStartRecord(param1:INotification) : void
      {
         this._dac_report.startRecord(param1.getType());
      }
      
      public function respondToStopRecord(param1:INotification) : void
      {
         this._dac_report.stopRecord(param1.getType(),param1.getBody());
      }
      
      public function respondToAction(param1:INotification) : void
      {
         this._dac_report.sendAction(param1.getType(),param1.getBody());
      }
      
      public function respondToError(param1:INotification) : void
      {
         this._dac_report.sendError(param1.getType(),(param1.getBody()?param1.getBody() + "&":"") + this._dac_report.tdsMark);
      }
      
      public function respondToP2pLog(param1:INotification) : void
      {
         this._dac_report.sendP2PLog(param1.getBody());
      }
   }
}
