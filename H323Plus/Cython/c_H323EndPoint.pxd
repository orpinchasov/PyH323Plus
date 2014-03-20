include "ptlib.pxi"

from cpython.ref cimport PyObject

from c_H323Connection cimport c_H323Connection, c_CallEndReason
from c_H323ListenerTCP cimport c_H323ListenerTCP

from c_PString cimport c_PString

cdef extern from "Wrappers/WrapperH323EndPoint.h":
    cdef cppclass c_H323EndPoint "WrapperH323EndPoint":
        c_H323EndPoint(PyObject * obj)

        void SetLocalUserName(const c_PString & name)
        const c_PString & GetLocalUserName() const
        PBoolean AddAliasName(const c_PString & name)

        void LoadBaseFeatureSet()

        PINDEX AddAllCapabilities(PINDEX descriptorNum, PINDEX simultaneous, const c_PString & name)
        void AddAllUserInputCapabilities(PINDEX descriptorNum, PINDEX simultaneous)

        PBoolean UseGatekeeper(const c_PString & address, const c_PString & identifier, const c_PString & localAddress)

        # Actual definition requires an H323Listener. Throughout
        # our code we use the H323ListenerTCP class
        PBoolean StartListener(c_H323ListenerTCP * listener)

        c_H323Connection * MakeCall(const c_PString & remoteParty, c_PString & token, void * userData, PBoolean supplimentary)
        void ClearAllCalls(c_CallEndReason reason, PBoolean wait)