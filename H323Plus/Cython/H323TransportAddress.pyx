from c_H323TransportAddress cimport c_H323TransportAddress

cdef class H323TransportAddress:
    """String representation of a transport address."""

    def __init__(self, address=None):
        """Create a new transport address.

        If "address" is None create a new empty address.
        If "address" is a string then create an address
        from the string.
        """

        if address is None:
            self.thisptr = new c_H323TransportAddress()
        elif isinstance(address, str):
            self.thisptr = new c_H323TransportAddress(<const char *>address)
        else:
            raise TypeError("Invalid initialization value for an H323TransportAddress")

    def __dealloc__(self):
        """Delete the address."""

        if self.thisptr:
            del self.thisptr