package com.qiyi.player.core.model.impls {
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
	
	public class AudioTrack extends Object implements IDestroy, IAudioTrackInfo {
		
		public function AudioTrack(param1:ICorePlayer, param2:IMovie) {
			super();
			this._holder = param1;
			this._movie = param2;
		}
		
		private var _movie:IMovie;
		
		private var _source:Object;
		
		private var _ID:int;
		
		private var _type:EnumItem;
		
		private var _isDefault:Boolean;
		
		private var _definitionVec:Vector.<Definition>;
		
		private var _holder:ICorePlayer;
		
		public function get isDefault() : Boolean {
			return this._isDefault;
		}
		
		public function get type() : EnumItem {
			return this._type;
		}
		
		public function get ID() : int {
			return this._ID;
		}
		
		public function get definitionCount() : int {
			if(this._definitionVec != null) {
				return this._definitionVec.length;
			}
			return 0;
		}
		
		public function initAudioTrack(param1:Object, param2:String, param3:String, param4:Boolean) : void {
			var _loc6_:* = 0;
			var _loc7_:Definition = null;
			var _loc8_:* = 0;
			var _loc9_:Array = null;
			if(this._source != null) {
				return;
			}
			this._source = param1;
			this._ID = param1.id.toString();
			this._type = Utility.getItemById(AudioTrackEnum.ITEMS,int(param1.lid));
			this._isDefault = int(param1.ispre) == 1;
			var _loc5_:Array = param1.vs as Array;
			if(_loc5_) {
				_loc6_ = _loc5_.length;
				_loc7_ = null;
				this._definitionVec = new Vector.<Definition>();
				_loc8_ = 0;
				while(_loc8_ < _loc6_) {
					_loc9_ = null;
					if(param4) {
						_loc9_ = _loc5_[_loc8_].flvs as Array;
					} else {
						_loc9_ = _loc5_[_loc8_].fs as Array;
					}
					if((_loc9_) && _loc9_.length > 0) {
						_loc7_ = new Definition(this._holder,this,this._movie);
						_loc7_.initDefinition(_loc5_[_loc8_],param2,param3,param4);
						this._definitionVec.push(_loc7_);
					}
					_loc8_++;
				}
			}
		}
		
		public function findDefinitionAt(param1:int) : Definition {
			var _loc2_:* = 0;
			if(this._definitionVec) {
				_loc2_ = this.definitionCount;
				if(param1 >= 0 && param1 < _loc2_) {
					return this._definitionVec[param1];
				}
			}
			return null;
		}
		
		public function findDefinitionInfoAt(param1:int) : IDefinitionInfo {
			return this.findDefinitionAt(param1);
		}
		
		public function findDefinitionByType(param1:EnumItem, param2:Boolean = false) : Definition {
			var _loc3_:* = 0;
			var _loc4_:* = false;
			var _loc5_:Definition = null;
			var _loc6_:* = 0;
			var _loc7_:Array = null;
			var _loc8_:* = 0;
			var _loc9_:EnumItem = null;
			var _loc10_:* = 0;
			if((this._definitionVec) && (param1)) {
				_loc3_ = this.definitionCount;
				_loc4_ = false;
				if((this._holder) && (this._holder.runtimeData.needFilterQualityDefinition)) {
					if(_loc3_ > 3) {
						_loc4_ = true;
					} else if(_loc3_ == 3) {
						if((DefinitionUtils.inFilterPPByDefinitionID(this._definitionVec[0].type.id)) && (DefinitionUtils.inFilterPPByDefinitionID(this._definitionVec[1].type.id)) && (DefinitionUtils.inFilterPPByDefinitionID(this._definitionVec[2].type.id))) {
							_loc4_ = false;
						} else {
							_loc4_ = true;
						}
					} else if(_loc3_ == 2) {
						if((DefinitionUtils.inFilterPPByDefinitionID(this._definitionVec[0].type.id)) && (DefinitionUtils.inFilterPPByDefinitionID(this._definitionVec[1].type.id))) {
							_loc4_ = false;
						} else {
							_loc4_ = true;
						}
					} else {
						_loc4_ = false;
					}
					
					
				}
				_loc5_ = null;
				_loc6_ = 0;
				if(param2) {
					_loc6_ = 0;
					while(_loc6_ < _loc3_) {
						_loc5_ = this._definitionVec[_loc6_];
						if(!((_loc4_) && (DefinitionUtils.inFilterPPByDefinitionID(_loc5_.type.id)))) {
							if((_loc5_) && _loc5_.type == param1) {
								return _loc5_;
							}
						}
						_loc6_++;
					}
				} else {
					if(_loc3_ == 1) {
						return this._definitionVec[0];
					}
					_loc7_ = DefinitionEnum.ITEMS;
					_loc8_ = 0;
					if(param1 == DefinitionEnum.LIMIT) {
						_loc8_ = 0;
					} else if(param1 == DefinitionEnum.NONE) {
						_loc8_ = _loc7_.indexOf(DefinitionEnum.HIGH);
					} else {
						_loc8_ = _loc7_.indexOf(param1);
					}
					
					_loc9_ = null;
					_loc10_ = _loc8_;
					while(_loc10_ >= 0) {
						if(_loc10_ == 0) {
							_loc9_ = DefinitionEnum.LIMIT;
						} else {
							_loc9_ = _loc7_[_loc10_];
						}
						_loc10_--;
						if(!((_loc4_) && (DefinitionUtils.inFilterPPByDefinitionID(_loc9_.id)))) {
							_loc6_ = 0;
							while(_loc6_ < _loc3_) {
								_loc5_ = this._definitionVec[_loc6_];
								if((_loc5_) && _loc5_.type == _loc9_) {
									return _loc5_;
								}
								_loc6_++;
							}
						}
					}
					_loc10_ = _loc8_;
					while(_loc10_ < _loc7_.length) {
						if(_loc10_ == 0) {
							_loc9_ = DefinitionEnum.LIMIT;
						} else {
							_loc9_ = _loc7_[_loc10_];
						}
						_loc10_++;
						if(!((_loc4_) && (DefinitionUtils.inFilterPPByDefinitionID(_loc9_.id)))) {
							_loc6_ = 0;
							while(_loc6_ < _loc3_) {
								_loc5_ = this._definitionVec[_loc6_];
								if((_loc5_) && _loc5_.type == _loc9_) {
									return _loc5_;
								}
								_loc6_++;
							}
						}
					}
				}
			}
			return null;
		}
		
		public function findDefinitionInfoByType(param1:EnumItem, param2:Boolean = false) : IDefinitionInfo {
			return this.findDefinitionByType(param1,param2);
		}
		
		public function findDefinitionByVid(param1:String) : Definition {
			var _loc2_:* = 0;
			var _loc3_:Definition = null;
			var _loc4_:* = 0;
			if(this._definitionVec) {
				_loc2_ = this.definitionCount;
				_loc3_ = null;
				_loc4_ = 0;
				while(_loc4_ < _loc2_) {
					_loc3_ = this._definitionVec[_loc4_];
					if((_loc3_) && _loc3_.vid == param1) {
						return _loc3_;
					}
					_loc4_++;
				}
			}
			return null;
		}
		
		public function destroy() : void {
			var _loc1_:* = 0;
			var _loc2_:Definition = null;
			var _loc3_:* = 0;
			this._movie = null;
			this._source = null;
			this._type = null;
			this._isDefault = false;
			if(this._definitionVec) {
				_loc1_ = this.definitionCount;
				_loc2_ = null;
				_loc3_ = 0;
				while(_loc3_ < _loc1_) {
					_loc2_ = this._definitionVec[_loc3_];
					if(_loc2_) {
						_loc2_.destroy();
					}
					_loc3_++;
				}
				this._definitionVec = null;
			}
		}
	}
}
