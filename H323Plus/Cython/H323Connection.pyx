from c_H323Connection cimport c_H323Connection
from H323EndPoint cimport H323EndPoint

from c_PString cimport c_PString

cdef class H323Connection:
    def __init__(self, endpoint, callReference, options=0):
        self.thisptr = new c_H323Connection(((<H323EndPoint>endpoint).thisptr)[0], callReference, options)
        self._is_cast = False

    def __dealloc__(self):
       if self.thisptr and not self._is_cast:
           del self.thisptr

    def GetRemotePartyName(self):
        cdef const c_PString *c_name= &self.thisptr.GetRemotePartyName()
        return <const unsigned char *>c_name.operator_const_unsigned_char_p()

cdef class cast_H323Connection(H323Connection):
    def __init__(self):
        self.thisptr = NULL
        self._is_cast = True

cdef H323Connection cast_to_H323Connection(c_H323Connection *c):
    result = cast_H323Connection()
    result.thisptr = c
    return result
