include "ptlib.pxi"

from c_PProcess cimport c_PProcess_GetOSName

def GetOSName():
    """Get the name of the operating system the process is running on."""

    return <const unsigned char *>c_PProcess_GetOSName()