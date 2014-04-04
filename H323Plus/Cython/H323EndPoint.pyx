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
    """This class manages the H323 endpoint.
    An endpoint may have zero or more listeners to create incoming connections
    or zero or more outgoing conenctions initiated via the MakeCall() function.
    Once a conection exists it is managed by this class instance.

    The main thing this class embodies is the capabilities of the application,
    that is the codecs and protocols it is capable of.
    """

    def __init__(self):
        """Create a new endpoint."""

        self.thisptr = new c_H323EndPoint(<cpy_ref.PyObject *>self)
       
    def __dealloc__(self):
        """Destroy endpoint."""

        if self.thisptr:
            del self.thisptr

    def SetLocalUserName(self, name):
        """Set the user name to be used for the local end of any connections. This
        defaults to the logged in user.
        Note that this name is technically the first alias for the endpoint
        """

        cdef const c_PString * c_name = new c_PString(<const char *>name)
        self.thisptr.SetLocalUserName(c_name[0])

    def GetLocalUserName(self):
        """Get the user name to be used for the local end of any connections. This
        defaults to the logged in user
        """

        cdef const c_PString * c_name = &self.thisptr.GetLocalUserName()

        return <const unsigned char *>c_name.operator_const_unsigned_char_p()

    def AddAliasName(self, name):
        """Add an alias name to be used for the local end of any connections. If
        the alias name already exists in the list then is is not added again.
        The list defaults to the value set in the SetLocalUserName() function.
        Note that calling SetLocalUserName() will clear the alias list.
        """

        cdef const c_PString * c_name = new c_PString(<const char *>name)

        return self.thisptr.AddAliasName(c_name[0])

    def LoadBaseFeatureSet(self):
        """Load the Base FeatureSet usually called when you initialise the endpoint prior to
        registering with a gatekeeper.
        """

        self.thisptr.LoadBaseFeatureSet()

    def AddAllCapabilities(self, descriptorNum, simultaneous, name):
        """Add all matching capabilities in list.
        All capabilities that match the specified name are added.
        """

        cdef const c_PString * c_name = new c_PString(<const char *>name)

        return self.thisptr.AddAllCapabilities(descriptorNum, simultaneous, c_name[0])

    def AddAllUserInputCapabilities(self, descriptorNum, simultaneous):
        """Add all user input capabilities to this endpoints capability table."""

        self.thisptr.AddAllUserInputCapabilities(descriptorNum, simultaneous)

    def UseGatekeeper(self, address=None, identifier=None, localAddress=None):
        """Use and register with an explicit gatekeeper.
        This will call other functions according to the following table:

            address    identifier   function
            empty      empty        DiscoverGatekeeper()
            non-empty  empty        SetGatekeeper()
            empty      non-empty    LocateGatekeeper()
            non-empty  non-empty    SetGatekeeperZone()

        The localAddress field, if non-empty, indicates the interface on which
        to look for the gatekeeper. An empty string is equivalent to "ip$*:*"
        which is any interface or port.

        If the endpoint is already registered with a gatekeeper that meets
        the same criteria then the gatekeeper is not changed, otherwise it is
        deleted (with unregistration) and new one created and registered to.
        """

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
        """Add a listener to the endpoint.
        This allows for the automatic creating of incoming call connections. An
        application should use OnConnectionEstablished() to monitor when calls
        have arrived and been successfully negotiated.

        If a listener already exists on the same transport address then it is
        ignored, but TRUE is still returned.
        """

        return self.thisptr.StartListener((<H323ListenerTCP>listener).thisptr)

    def MakeCall(self, remoteParty, token, userData=None, supplimentary=False):
        """Make a call to a remote party. An appropriate transport is determined
        from the remoteParty parameter. The general form for this parameter is
        [alias@][transport$]host[:port] where the default alias is the same as
        the host, the default transport is "ip" and the default port is 1720.
        """

        cdef const c_PString * c_remote_party = new c_PString(<const char *>remoteParty)
        cdef c_PString * c_token = new c_PString()
        cdef c_H323Connection * c_h323connection = NULL

        c_h323connection = self.thisptr.MakeCall(c_remote_party[0], c_token[0], <void *>userData, supplimentary)

        return (cast_to_H323Connection(c_h323connection), cast_to_PString(c_token))

    def ClearAllCalls(self, reason=c_EndedByLocalUser, wait=True):
        """Clear all current connections.
        This hangs up all the connections to remote endpoints.
        """

        self.thisptr.ClearAllCalls(reason, wait)

cdef public api PBoolean cy_call_OnIncomingCall(object self,
                                                bint *error,
                                                c_H323Connection & connection,
                                                const c_H323SignalPDU & setupPDU,
                                                c_H323SignalPDU & alertingPDU) with gil:
    """Call back for incoming call.
    This function is called from the OnReceivedSignalSetup() function
    before it sends the Alerting PDU. It gives an opportunity for an
    application to alter the reply before transmission to the other
    endpoint.

    If FALSE is returned the connection is aborted and a Release Complete
    PDU is sent.
    """

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
    """A call back function whenever a connection is established.
    This indicates that a connection to a remote endpoint was established
    with a control channel and zero or more logical channels.
    """

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
    """A call back function whenever a connection is broken.
    This indicates that a connection to a remote endpoint is no longer
    available.
    """

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
    """Open a channel for use by an audio codec."""

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
    """Call back for opening a logical channel."""

    try:
        func = getattr(self, "OnStartLogicalChannel")
    except AttributeError:
        error[0] = 1
    else:
        error[0] = 0

        return func(cast_to_H323Connection(<c_H323Connection *>&connection),
                    cast_to_H323Channel(<c_H323Channel *>&channel))