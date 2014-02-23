# Represents an IP address

include "ptlib.pxi"

from c_Address cimport c_Address

from c_PString cimport c_PString

cdef class Address:
    def __init__(self, dotNotation=None):
        cdef const c_PString *c_dotNotation
        
        if dotNotation is None:
            self.thisptr = new c_Address()
        else:
            c_dotNotation = new c_PString(<const char *>dotNotation)
            self.thisptr = new c_Address(c_dotNotation[0])

    def __dealloc__(self):
       if self.thisptr:
           del self.thisptr
            
    def __str__(self):
        return <const unsigned char *>self.thisptr.operator_pstring()