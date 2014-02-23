include "ptlib.pxi"

from c_PString cimport c_PString

cdef extern from "ptlib/ipsock.h":
    cdef cppclass c_Address "PIPSocket::Address":
        c_Address()
        c_Address(const c_PString & dotNotation)
        
        c_PString operator_pstring "operator PString"() const
