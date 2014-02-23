#include <Python.h>

#include "WrapperPIndirectChannel.h"
#include "../CPP/PIndirectChannel_api.h"

#include <ptlib.h>

WrapperPIndirectChannel::WrapperPIndirectChannel(PyObject *obj): m_obj(obj) {
	PyEval_InitThreads();

	if (import_PIndirectChannel()) {
    } else {
        Py_XINCREF(this->m_obj);
    }
}

WrapperPIndirectChannel::~WrapperPIndirectChannel() {
    Py_XDECREF(this->m_obj);
}

PBoolean WrapperPIndirectChannel::Close()
{
    if (!(this->m_obj)) {
        return false;
    }

    int error;

    PBoolean result = cy_call_Close(this->m_obj, &error);
    if (error) {
        result = PIndirectChannel::Close();
    }

    return result;
}

PBoolean WrapperPIndirectChannel::IsOpen() const
{
    if (!(this->m_obj)) {
        return false;
    }

    int error;

    PBoolean result = cy_call_IsOpen(this->m_obj, &error);
    if (error) {
        result = PIndirectChannel::IsOpen();
    }

    return result;
}

PBoolean WrapperPIndirectChannel::Read(void *buf, PINDEX len)
{
    if (!(this->m_obj)) {
        return false;
    }

    int error;

    PBoolean result = cy_call_Read(this->m_obj, &error, buf, len);
    if (error) {
        result = PIndirectChannel::Read(buf, len);
    }

    return result;
}

PINDEX WrapperPIndirectChannel::GetLastReadCount() const
{
    if (!(this->m_obj)) {
        return false;
    }

    int error;

    PINDEX result = cy_call_GetLastReadCount(this->m_obj, &error);
    if (error) {
        result = PIndirectChannel::GetLastReadCount();
    }

    return result;
}

PBoolean WrapperPIndirectChannel::Write(const void *buf, PINDEX len)
{
    if (!(this->m_obj)) {
        return false;
    }

    int error;

    PBoolean result = cy_call_Write(this->m_obj, &error, buf, len);
    if (error) {
        result = PIndirectChannel::Write(buf, len);
    }

    return result;
}