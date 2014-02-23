from c_H323EndPoint cimport c_H323EndPoint
from c_PString cimport c_PString

cdef extern from "h323con.h":
    cdef enum c_CallEndReason "H323Connection::CallEndReason":
        c_EndedByLocalUser "H323Connection::EndedByLocalUser" = 0

    cdef cppclass c_H323Connection "H323Connection":
        c_H323Connection(c_H323EndPoint &endpoint, unsigned callReference, unsigned options)

        const c_PString & GetRemotePartyName() const