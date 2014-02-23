from c_H323TransportAddress cimport c_H323TransportAddress

cdef class H323TransportAddress:
    def __init__(self, address=None):
        if address is None:
            self.thisptr = new c_H323TransportAddress()
        elif isinstance(address, str):
            self.thisptr = new c_H323TransportAddress(<const char *>address)
        else:
            raise TypeError("Invalid initialization value for an H323TransportAddress")

    def __dealloc__(self):
       if self.thisptr:
           del self.thisptr