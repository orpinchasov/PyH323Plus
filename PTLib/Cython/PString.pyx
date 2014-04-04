from c_PString cimport c_PString

cdef class PString:
    """The character string class."""

    def __init__(self, value=None):
        """Create a string object.

        If value is "None" then construct an empty string.
        This will have one character in it which is the '\\0' character.

        If value is a string then create a string from the C string array.

        If value is an int then create a string from the integer type.
        """
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
        """Delete the string."""

        if self.thisptr and not self._is_cast:
            del self.thisptr

    def __repr__(self):
        return self.__str__()

    def __str__(self):
        return <const unsigned char *>self.thisptr.operator_const_unsigned_char_p()

    def GetLength(self):
        """Determine the length of the null terminated string."""

        return self.thisptr.GetLength()

cdef class cast_PString(PString):
    def __init__(self):
        self.thisptr = NULL
        self._is_cast = True

cdef PString cast_to_PString(c_PString *c):
    result = cast_PString()
    result.thisptr = c
    return result
