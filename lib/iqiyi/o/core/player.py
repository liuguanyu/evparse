# -*- coding: utf-8 -*-
# player.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# player: iqiyi, com.qiyi.player.core.player

# import

# class
class RuntimeData(object):
    def __init__(self):
        # important data
        self.key = ''
        self.currentUserIP = ''
        self.preDispatchArea = ''
        self.movieInfo = ''
        self.preDefinition = ''
        self.currentDefinition = ''
        self.preErrorCode = ''
        
        # may be important data
        self.tvid = ''
        self.vid = ''
        self.originalVid = ''
        self.albumId = ''
        self.movieIsMember = False
        self.currentUserArea = ''
        self.CDNStatus = -1
        self.dispatcherServerTime = 0
        self.dispatchFlashRunTime = 0
        self.QY00001 = ''
        self.cacheServerIP = ''
        self.vrsDomain = ''
        self.communicationlId = 'afbe8fd3d73448c9'
        self.ugcAuthKey = ''
        self.serverTime = 0
        self.serverTimeGetTimer = 0
        self.thdKey = ''
        self.thdToken = ''
        
        # other data
        self.VInfoDisIP = ''
        self.playerType = None
        self.platform = None
        self.station = None
        self.playerUseType = None
        self.prepareToPlayEnd = -1
        self.prepareToSkipPoint = -1
        self.prepareLeaveSkipPoint = -1
        self.preAverageSpeed = 0
        self.bufferEmpty = 0
        self.oversea = -1
        self.stratusIP = ''
        self.userDisInfo = None
        self.userArea = ''
        self.smallOperators = False
        self.startPlayTime = -1
        self.isTryWatch = False
        self.tryWatchType = None
        self.tryWatchTime = 0
        self.skipTrailer = False
        self.authentication = None
        self.authenticationError = False
        self.authenticationTipType = -1
        self.startFromHistory = False
        self.currentSpeed = 0
        self.currentAverageSpeed = 0
        self.retryCount = 0
        self.originalStartTime = -1
        self.originalEndTime = -1
        self.endTime = 0
        self.errorCode = 0
        self.errorCodeValue = None
        self.supportGPU = True
        self.isPreload = False
        self.autoDefinitionlimit = None
        self.tg = ''
        self.recordHistory = True
        self.useHistory = True
        self.needFilterQualityDefinition = False
        self.openSelectPlay = False
        self.collectionID = ''
        self.userEnjoyableSubType = None
        self.userEnjoyableDurationIndex = -1
        self.openFlashP2P = True
        self.flashP2PCoreURL = ''
        self.smallWindowMode = False
        # NOTE reserved
        # VInfoDisIP:String
        # playerType:EnumItem
        # platform:EnumItem
        # station:EnumItem
        # playerUseType:EnumItem
        # tvid:String
        # vid:String
        # originalVid:String
        # albumId:String
        # movieIsMember:Boolean
        # prepareToPlayEnd:int
        # prepareToSkipPoint:int
        # prepareLeaveSkipPoint:int
        # currentDefinition:String
        # preDispatchArea:String
        # preAverageSpeed:int
        # preDefinition:String
        # preErrorCode:String
        # currentUserIP:String
        # currentUserArea:String
        # bufferEmpty:int
        # movieInfo:String
        # key:String
        # CDNStatus:int
        # oversea:int
        # stratusIP:String
        # userDisInfo:Object
        # userArea:String
        # smallOperators:Boolean
        # startPlayTime:int
        # dispatcherServerTime:Number
        # dispatchFlashRunTime:Number
        # isTryWatch:Boolean
        # tryWatchType:EnumItem
        # tryWatchTime:int
        # QY00001:String
        # skipTrailer:Boolean
        # authentication:Object
        # authenticationError:Boolean
        # authenticationTipType:int
        # startFromHistory:Boolean
        # currentSpeed:int
        # currentAverageSpeed:int
        # retryCount:int
        # originalStartTime:int
        # originalEndTime:int
        # endTime:int
        # errorCode:int
        # errorCodeValue:Object
        # supportGPU:Boolean
        # isPreload:Boolean
        # autoDefinitionlimit:EnumItem
        # cacheServerIP:String
        # vrsDomain:String
        # communicationlId:String = 'afbe8fd3d73448c9'
        # tg:String
        # recordHistory:Boolean
        # useHistory:Boolean
        # needFilterQualityDefinition:Boolean
        # openSelectPlay:Boolean
        # collectionID:String
        # userEnjoyableSubType:EnumItem
        # userEnjoyableDurationIndex:int
        # openFlashP2P:Boolean
        # flashP2PCoreURL:String
        # smallWindowMode:Boolean
        # ugcAuthKey:String
        # serverTime:uint
        # serverTimeGetTimer:uint
        # thdKey:String
        # thdToken:String
    # end RuntimeData class

# end player.py


