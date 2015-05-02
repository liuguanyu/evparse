# -*- coding: utf-8 -*-
# netstream.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# netstream: sohu, com.sohu.tv.mediaplayer.netstream

# import

import random
from urllib.parse import quote

# class

class TvSohuNetStream(object):
    
    def update_info(self, info):	# info is got by Main.fetchVideoInfo()
        # this function is from Main.parseVInfo()
        self.synUrl = info['data']
        self.backupGSLBIP = info['reserveIp'].split(';')
        self.key = info['data']['ck']
        self.gslbIp = info['allot']
        self.currentVid = str(info['id'])
        self.tvid = info['tvid']	# reserved
        
        self.bfd = info['data']['bfd']
        
        self.cdnMd = 	# TODO
        
        self.clipsURL = info['data']['clipsURL']
        # self._gslbUrl = 
        pass
    
    def __init__(self):
        
        self.clipsURL = []
        # self._gslbUrl = ''
        
        self.synUrl = None		# self.synUrl = []
        self.backupGSLBIP = None	# []
        self.key = None			# []
        self.cdnMd = ''
        self.gslbIp = ''
        
        self.currentVid = ''
        self.tvid = ''
        
        self._ipTime = 0	# TODO
        self._changeGSLBIP = False
        
        self.userId = ''	# TODO reserved, may be null
        
        self.clientWidth = 1920
        self.clientHeight = 1080
        # reserved
        # self._errCdnIds = []
        # self.ta_jm = ''
        # self.lqd = ''
        # self.lcode = ''
        # self.ugu = ''
        # self.ugcode = ''
        self.bfd = []
        # done
    
    def loadLocationAndPlay(self, _clipNo):
        # re = RegExp('\\?start=')
        # reData = RegExp('http\\:\\/\\/(.+?)\\/\\|([0-9]{1,4})\\|(.+?)\\|([^|]*)\\|?([01]?)\\|?([01]?)\\|([0-9]{1,6})\\|([0-9]{1,6})\\|([0-9]{1,6})')
        # boo = re.test(_gslbUrl)
        # ips = ''	# null
        # if len(self._errCdnIds)  > 0:	# null
        #     ips = '&idc=' + this._errCdnIds.join(',')
        
        _gslbUrl = self.clipsURL[_clipNo]
        
        synUrl = ''
        if (self.synUrl != None) and (len(self.synUrl) > _clipNo):
            synUrl = '&new=' + self.synUrl[_clipNo]
        backupIP = ''
        if self._changeGSLBIP and (self.backupGSLBIP != None) and (self._ipTime < len(self.backupGSLBIP)):
            backupIP = self.backupGSLBIP[self._ipTime]
            self._ipTime += 1
            if self._ipTime == len(self.backupGSLBIP):
                self._ipTime = 0
            self._changeGSLBIP = False
        url = ''
        key = ''
        if (self.key != None) and (self.key[_clipNo] != None) and (self.key[_clipNo] != ''):
            key = '&key=' + self.key[_clipNo]
        vid = ''
        if self.currentVid != '':
            vid = '&vid=' + self.currentVid
        uid = ''
        if self.userId != '':
            uid = '&uid=' + self.userId
        # ta = ''	# null
        # if self.ta_jm != '':
        #     ta = '&ta=' + quote(self.ta_jm)
        _ap = ''
        # if self.lqd != '':	# null
        #     _ap += '&oth=' + self.lqd
        # if self.lcode != '':	# null
        #     _ap += '&cd=' + self.lcode
        _ap += '&sz=' + str(self.clientWidth) + '_' + str(self.clientHeight)
        _ap += '&md=' + str(self.cdnMd)
        # if self.ugu != '':	# null
        #     _ap += '&ugu=' + self.ugu
        # if self..ugcode != '':	# null
        #     _ap += '&ugcode=' + self.ugcode
        newInfoStr = _ap
        
        _ap = ''
        _ap += 'http://'
        
        if backupIP != '':
            _ap += backupIP
        else:
            _ap += self.gslbIp
        _ap += '/yp2p?prot=9&prod=flash&pt=1&file=' + self.getUrlPath(_gslbUrl)
        _ap += synUrl
        # _ap += ips
        _ap += key
        _ap += vid
        _ap += '&tvid=' + self.tvid
        _ap += uid
        # _ap += ta
        _ap += newInfoStr
        # if (self.bfd != None) and (self.bfd[_clipNo] != ''):
        #     _ap += '&bfd=' + self.bfd[_clipNo]
        # if (not PlayerConfig.isWebP2p) and boo:
        #     _ap += '&' + _gslbUrl.split("?")[1]
        _ap += '&t=' + str(random.random())
        url = _ap
        # done
        return url
    
    def getUrlPath(self, text):
        param1 = param1.replace('http://data.vod.itc.cn', '')
        return param1.split('?')[0]
    # done

# end netstream.py


