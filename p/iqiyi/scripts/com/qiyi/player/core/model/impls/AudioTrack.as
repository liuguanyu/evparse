package com.qiyi.player.core.model.impls
{
	import com.qiyi.player.core.IDestroy;
	import com.qiyi.player.core.model.IAudioTrackInfo;
	import com.qiyi.player.core.model.IMovie;
	import com.qiyi.player.base.pub.EnumItem;
	import com.qiyi.player.core.player.coreplayer.ICorePlayer;
	import com.qiyi.player.base.utils.Utility;
	import com.qiyi.player.core.model.def.AudioTrackEnum;
	import com.qiyi.player.core.model.IDefinitionInfo;
	import com.qiyi.player.core.model.utils.DefinitionUtils;
	import com.qiyi.player.core.model.def.DefinitionEnum;
	
	public class AudioTrack extends Object implements IDestroy, IAudioTrackInfo
	{
		
		private var _movie:IMovie;
		
		private var _source:Object;
		
		private var _ID:int;
		
		private var _type:EnumItem;
		
		private var _isDefault:Boolean;
		
		private var _definitionVec:Vector.<Definition>;
		
		private var _holder:ICorePlayer;
		
		public function AudioTrack(param1:ICorePlayer, param2:IMovie)
		{
			super();
			this._holder = param1;
			this._movie = param2;
		}
		
		public function get isDefault() : Boolean
		{
			return this._isDefault;
		}
		
		public function get type() : EnumItem
		{
			return this._type;
		}
		
		public function get ID() : int
		{
			return this._ID;
		}
		
		public function get definitionCount() : int
		{
			if(this._definitionVec != null)
			{
				return this._definitionVec.length;
			}
			return 0;
		}
		
		public function initAudioTrack(param1:Object, param2:String, param3:String, param4:Boolean) : void
		{
			var _loc6:* = 0;
			var _loc7:Definition = null;
			var _loc8:* = 0;
			var _loc9:Array = null;
			if(this._source != null)
			{
				return;
			}
			this._source = param1;
			this._ID = param1.id.toString();
			this._type = Utility.getItemById(AudioTrackEnum.ITEMS,int(param1.lid));
			this._isDefault = int(param1.ispre) == 1;
			var _loc5:Array = param1.vs as Array;
			if(_loc5)
			{
				_loc6 = _loc5.length;
				_loc7 = null;
				this._definitionVec = new Vector.<Definition>();
				_loc8 = 0;
				while(_loc8 < _loc6)
				{
					_loc9 = null;
					if(param4)
					{
						_loc9 = _loc5[_loc8].flvs as Array;
					}
					else
					{
						_loc9 = _loc5[_loc8].fs as Array;
					}
					if((_loc9) && _loc9.length > 0)
					{
						_loc7 = new Definition(this._holder,this,this._movie);
						_loc7.initDefinition(_loc5[_loc8],param2,param3,param4);
						this._definitionVec.push(_loc7);
					}
					_loc8++;
				}
			}
		}
		
		public function findDefinitionAt(param1:int) : Definition
		{
			var _loc2:* = 0;
			if(this._definitionVec)
			{
				_loc2 = this.definitionCount;
				if(param1 >= 0 && param1 < _loc2)
				{
					return this._definitionVec[param1];
				}
			}
			return null;
		}
		
		public function findDefinitionInfoAt(param1:int) : IDefinitionInfo
		{
			return this.findDefinitionAt(param1);
		}
		
		public function findDefinitionByType(param1:EnumItem, param2:Boolean = false) : Definition
		{
			var _loc3:* = 0;
			var _loc4:* = false;
			var _loc5:Definition = null;
			var _loc6:* = 0;
			var _loc7:Array = null;
			var _loc8:* = 0;
			var _loc9:EnumItem = null;
			var _loc10:* = 0;
			if((this._definitionVec) && (param1))
			{
				_loc3 = this.definitionCount;
				_loc4 = false;
				if((this._holder) && (this._holder.runtimeData.needFilterQualityDefinition))
				{
					if(_loc3 > 3)
					{
						_loc4 = true;
					}
					else if(_loc3 == 3)
					{
						if((DefinitionUtils.inFilterPPByDefinitionID(this._definitionVec[0].type.id)) && (DefinitionUtils.inFilterPPByDefinitionID(this._definitionVec[1].type.id)) && (DefinitionUtils.inFilterPPByDefinitionID(this._definitionVec[2].type.id)))
						{
							_loc4 = false;
						}
						else
						{
							_loc4 = true;
						}
					}
					else if(_loc3 == 2)
					{
						if((DefinitionUtils.inFilterPPByDefinitionID(this._definitionVec[0].type.id)) && (DefinitionUtils.inFilterPPByDefinitionID(this._definitionVec[1].type.id)))
						{
							_loc4 = false;
						}
						else
						{
							_loc4 = true;
						}
					}
					else
					{
						_loc4 = false;
					}
					
					
				}
				_loc5 = null;
				_loc6 = 0;
				if(param2)
				{
					_loc6 = 0;
					while(_loc6 < _loc3)
					{
						_loc5 = this._definitionVec[_loc6];
						if(!((_loc4) && (DefinitionUtils.inFilterPPByDefinitionID(_loc5.type.id))))
						{
							if((_loc5) && _loc5.type == param1)
							{
								return _loc5;
							}
						}
						_loc6++;
					}
				}
				else
				{
					if(_loc3 == 1)
					{
						return this._definitionVec[0];
					}
					_loc7 = DefinitionEnum.ITEMS;
					_loc8 = 0;
					if(param1 == DefinitionEnum.LIMIT)
					{
						_loc8 = 0;
					}
					else if(param1 == DefinitionEnum.NONE)
					{
						_loc8 = _loc7.indexOf(DefinitionEnum.HIGH);
					}
					else
					{
						_loc8 = _loc7.indexOf(param1);
					}
					
					_loc9 = null;
					_loc10 = _loc8;
					while(_loc10 >= 0)
					{
						if(_loc10 == 0)
						{
							_loc9 = DefinitionEnum.LIMIT;
						}
						else
						{
							_loc9 = _loc7[_loc10];
						}
						_loc10--;
						if(!((_loc4) && (DefinitionUtils.inFilterPPByDefinitionID(_loc9.id))))
						{
							_loc6 = 0;
							while(_loc6 < _loc3)
							{
								_loc5 = this._definitionVec[_loc6];
								if((_loc5) && _loc5.type == _loc9)
								{
									return _loc5;
								}
								_loc6++;
							}
						}
					}
					_loc10 = _loc8;
					while(_loc10 < _loc7.length)
					{
						if(_loc10 == 0)
						{
							_loc9 = DefinitionEnum.LIMIT;
						}
						else
						{
							_loc9 = _loc7[_loc10];
						}
						_loc10++;
						if(!((_loc4) && (DefinitionUtils.inFilterPPByDefinitionID(_loc9.id))))
						{
							_loc6 = 0;
							while(_loc6 < _loc3)
							{
								_loc5 = this._definitionVec[_loc6];
								if((_loc5) && _loc5.type == _loc9)
								{
									return _loc5;
								}
								_loc6++;
							}
						}
					}
				}
			}
			return null;
		}
		
		public function findDefinitionInfoByType(param1:EnumItem, param2:Boolean = false) : IDefinitionInfo
		{
			return this.findDefinitionByType(param1,param2);
		}
		
		public function findDefinitionByVid(param1:String) : Definition
		{
			var _loc2:* = 0;
			var _loc3:Definition = null;
			var _loc4:* = 0;
			if(this._definitionVec)
			{
				_loc2 = this.definitionCount;
				_loc3 = null;
				_loc4 = 0;
				while(_loc4 < _loc2)
				{
					_loc3 = this._definitionVec[_loc4];
					if((_loc3) && _loc3.vid == param1)
					{
						return _loc3;
					}
					_loc4++;
				}
			}
			return null;
		}
		
		public function destroy() : void
		{
			var _loc1:* = 0;
			var _loc2:Definition = null;
			var _loc3:* = 0;
			this._movie = null;
			this._source = null;
			this._type = null;
			this._isDefault = false;
			if(this._definitionVec)
			{
				_loc1 = this.definitionCount;
				_loc2 = null;
				_loc3 = 0;
				while(_loc3 < _loc1)
				{
					_loc2 = this._definitionVec[_loc3];
					if(_loc2)
					{
						_loc2.destroy();
					}
					_loc3++;
				}
				this._definitionVec = null;
			}
		}
	}
}
