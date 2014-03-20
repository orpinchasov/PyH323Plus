include "ptlib.pxi"

cimport cpython.ref as cpy_ref

from c_H323EndPoint cimport c_H323EndPoint
from c_H323SignalPDU cimport c_H323SignalPDU
from H323SignalPDU cimport cast_to_H323SignalPDU
from c_H323Connection cimport c_H323Connection, c_EndedByLocalUser
from H323Connection cimport cast_to_H323Connection
from c_H323AudioCodec cimport c_H323AudioCodec
from H323AudioCodec cimport cast_to_H323AudioCodec
from c_H323Channel cimport c_H323Channel
from H323Channel cimport cast_to_H323Channel
from H323ListenerTCP cimport H323ListenerTCP

from c_PString cimport c_PString
from PString cimport cast_to_PString

cdef class H323EndPoint:
    def __init__(self):
       self.thisptr = new c_H323EndPoint(<cpy_ref.PyObject *>self)
       
    def __dealloc__(self):
       if self.thisptr:
           del self.thisptr

    def SetLocalUserName(self, name):
        cdef const c_PString * c_name = new c_PString(<const char *>name)
        self.thisptr.SetLocalUserName(c_name[0])

    def GetLocalUserName(self):
        cdef const c_PString * c_name = &self.thisptr.GetLocalUserName()

        return <const unsigned char *>c_name.operator_const_unsigned_char_p()

    def AddAliasName(self, name)
       cdef const c_PString * c_name = new c_PString(<const char *>name)

       return self.thisptr.AddAliasName(c_name[0])

    def LoadBaseFeatureSet(self):
        self.thisptr.LoadBaseFeatureSet()

    def AddAllCapabilities(self, descriptorNum, simultaneous, name):
        cdef const c_PString * c_name = new c_PString(<const char *>name)

        return self.thisptr.AddAllCapabilities(descriptorNum, simultaneous, c_name[0])

    def AddAllUserInputCapabilities(self, descriptorNum, simultaneous):
        self.thisptr.AddAllUserInputCapabilities(descriptorNum, simultaneous)

    def UseGatekeeper(self, address=None, identifier=None, localAddress=None):
        if address is None:
            address = ""
        if identifier is None:
            identifier = ""
        if localAddress is None:
            localAddress = ""

        cdef const c_PString * c_address = new c_PString(<const char *>address)
        cdef const c_PString * c_identifier = new c_PString(<const char *>identifier)
        cdef const c_PString * c_localAddress = new c_PString(<const char *>localAddress)

        return self.thisptr.UseGatekeeper(c_address[0], c_identifier[0], c_localAddress[0])

    def StartListener(self, listener):
        return self.thisptr.StartListener((<H323ListenerTCP>listener).thisptr)

    def MakeCall(self, remoteParty, token, userData=None, supplimentary=False):
        cdef const c_PString * c_remote_party = new c_PString(<const char *>remoteParty)
        cdef c_PString * c_token = new c_PString()
        cdef c_H323Connection * c_h323connection = NULL

        c_h323connection = self.thisptr.MakeCall(c_remote_party[0], c_token[0], <void *>userData, supplimentary)

        return (cast_to_H323Connection(c_h323connection), cast_to_PString(c_token))

    def ClearAllCalls(self, reason=c_EndedByLocalUser, wait=True):
        self.thisptr.ClearAllCalls(reason, wait)

cdef public api PBoolean cy_call_OnIncomingCall(object self,
                                                bint *error,
                                                c_H323Connection & connection,
                                                const c_H323SignalPDU & setupPDU,
                                                c_H323SignalPDU & alertingPDU) with gil:
    try:
        func = getattr(self, "OnIncomingCall")
    except AttributeError:
        error[0] = 1
    else:
        error[0] = 0

        return func(cast_to_H323Connection(<c_H323Connection *>&connection),
                    cast_to_H323SignalPDU(<c_H323SignalPDU *>&setupPDU),
                    cast_to_H323SignalPDU(<c_H323SignalPDU *>&alertingPDU))

cdef public api void cy_call_OnConnectionEstablished(object self,
                                                     bint *error,
                                                     c_H323Connection & connection,
                                                     const c_PString & token) with gil:
    try:
        func = getattr(self, "OnConnectionEstablished")
    except AttributeError:
        error[0] = 1
    else:
        error[0] = 0

        func(cast_to_H323Connection(<c_H323Connection *>&connection),
             cast_to_PString(<c_PString *>&token))

cdef public api void cy_call_OnConnectionCleared(object self,
                                                 bint *error,
                                                 c_H323Connection & connection,
                                                 const c_PString & token) with gil:
    try:
        func = getattr(self, "OnConnectionCleared")
    except AttributeError:
        error[0] = 1
    else:
        error[0] = 0

        func(cast_to_H323Connection(<c_H323Connection *>&connection),
             cast_to_PString(<c_PString *>&token))

cdef public api PBoolean cy_call_OpenAudioChannel(object self,
                                                  bint *error,
                                                  c_H323Connection & connection,
                                                  PBoolean isEncoding,
                                                  unsigned bufferSize,
                                                  c_H323AudioCodec & codec) with gil:
    try:
        func = getattr(self, "OpenAudioChannel")
    except AttributeError:
        error[0] = 1
    else:
        error[0] = 0

        return func(cast_to_H323Connection(<c_H323Connection *>&connection),
                    isEncoding,
                    bufferSize,
                    cast_to_H323AudioCodec(<c_H323AudioCodec *>&codec))

cdef public api PBoolean cy_call_OnStartLogicalChannel(object self,
                                                       bint *error,
                                                       c_H323Connection & connection,
                                                       c_H323Channel & channel) with gil:
    try:
        func = getattr(self, "OnStartLogicalChannel")
    except AttributeError:
        error[0] = 1
    else:
        error[0] = 0

        return func(cast_to_H323Connection(<c_H323Connection *>&connection),
                    cast_to_H323Channel(<c_H323Channel *>&channel))