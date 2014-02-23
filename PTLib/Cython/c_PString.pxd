include "ptlib.pxi"

cdef extern from "ptlib/pstring.h":
    cdef cppclass c_PString "PString":
        c_PString()
        c_PString(const char * cstr)
        c_PString(short n)
        
        const unsigned char * operator_const_unsigned_char_p "operator const unsigned char *"() const
        
        PINDEX GetLength()