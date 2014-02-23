from c_PString cimport c_PString

cdef class PString:
    def __init__(self, value=None):
        if value is None:
            self.thisptr = new c_PString()
        elif isinstance(value, str):
            self.thisptr = new c_PString(<const char *>value)
        elif isinstance(value, int):
            self.thisptr = new c_PString(<short>value)
        else:
            raise TypeError("Invalid initialization value for a PString")

        self._is_cast = False

    def __dealloc__(self):
       if self.thisptr and not self._is_cast:
           del self.thisptr

    def __repr__(self):
        return self.__str__()

    def __str__(self):
        return <const unsigned char *>self.thisptr.operator_const_unsigned_char_p()

    def GetLength(self):
        return self.thisptr.GetLength()

cdef class cast_PString(PString):
    def __init__(self):
        self.thisptr = NULL
        self._is_cast = True

cdef PString cast_to_PString(c_PString *c):
    result = cast_PString()
    result.thisptr = c
    return result
