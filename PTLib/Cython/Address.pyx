include "ptlib.pxi"

from c_Address cimport c_Address

from c_PString cimport c_PString

cdef class Address:
    """A class describing an IP address."""

    def __init__(self, dotNotation=None):
        """Create a new IP address.

        If "dotNotation" is None create an IPv4 address with
        the default address: 127.0.0.1 (loopback). Else, create an
        IP address from string notation, eg dot notation x.x.x.x
        """

        cdef const c_PString *c_dotNotation
        
        if dotNotation is None:
            self.thisptr = new c_Address()
        else:
            c_dotNotation = new c_PString(<const char *>dotNotation)
            self.thisptr = new c_Address(c_dotNotation[0])

    def __dealloc__(self):
        """Delete the address."""

        if self.thisptr:
            del self.thisptr
            
    def __str__(self):
        return <const unsigned char *>self.thisptr.operator_pstring()