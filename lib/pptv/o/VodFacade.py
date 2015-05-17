# -*- coding: utf-8 -*-
# VodFacade.py, part for evparse : EisF Video Parse, evdh Video Parse. 
# VodFacade: pptv, player4player2: VodFacade

# import

from .player.view import CTXQuery
from .player.common import VodCommon, VodParser

# global static data

page_url = ''	# NOTE should be set
referrer = ''	# NOTE can be ''

# function

def ergodic():
    # set CTXQuery
    CTXQuery.setAttr('o', VodParser.os)
    CTXQuery.setAttr('type', VodCommon.playType)
    CTXQuery.setAttr('pageUrl', page_url)
    CTXQuery.setAttr('referrer', referrer)
    # done

# end VodFacade.py


