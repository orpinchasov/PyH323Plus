// Defines a wrapper class for an H323 end point

#include <Python.h>

#include "WrapperH323EndPoint.h"
#include "../CPP/H323EndPoint_api.h"

#include <ptlib.h>
#include <h323.h>

WrapperH323EndPoint::WrapperH323EndPoint(PyObject *obj): m_obj(obj) {
    // Call the following to allow Python interaction with
    // PTLib threads created outside the Python interpreter
	PyEval_InitThreads();

    // Attempt to create the Pythonic object. Manually
    // increase its reference counter if successful
	if (0 == import_H323EndPoint()) {
        Py_XINCREF(this->m_obj);
    }
}

WrapperH323EndPoint::~WrapperH323EndPoint() {
    // Decrease the Pythonic object reference counter manually
    Py_XDECREF(this->m_obj);
}

PBoolean WrapperH323EndPoint::OnIncomingCall(H323Connection &connection,
                                             const H323SignalPDU &setupPDU,
                                             H323SignalPDU &alertingPDU)
{
    if (!(this->m_obj)) {
        return false;
    }

    int error;

    // Try to call the overriding Pythonic method.
    // If it doesn't exist just call the original method
    PBoolean result = cy_call_OnIncomingCall(this->m_obj, &error, connection, setupPDU, alertingPDU);
    if (error) {
        result = H323EndPoint::OnIncomingCall(connection, setupPDU, alertingPDU);
    }

    return result;
}

void WrapperH323EndPoint::OnConnectionEstablished(H323Connection &connection,
                                                  const PString &token)
{
    if (!(this->m_obj)) {
        return;
    }

    int error;

    cy_call_OnConnectionEstablished(this->m_obj, &error, connection, token);
    if (error) {
        H323EndPoint::OnConnectionEstablished(connection, token);
    }
}

void WrapperH323EndPoint::OnConnectionCleared(H323Connection &connection,
                                              const PString &token)
{
    if (!(this->m_obj)) {
        return;
    }

    int error;

    cy_call_OnConnectionCleared(this->m_obj, &error, connection, token);
    if (error) {
        H323EndPoint::OnConnectionCleared(connection, token);
    }
}

PBoolean WrapperH323EndPoint::OpenAudioChannel(H323Connection &connection,
                                               PBoolean isEncoding,
                                               unsigned bufferSize,
                                               H323AudioCodec &codec)
{
    if (!(this->m_obj)) {
        return false;
    }

    int error;

    PBoolean result = cy_call_OpenAudioChannel(this->m_obj, &error, connection, isEncoding, bufferSize, codec);
    if (error) {
        result = H323EndPoint::OpenAudioChannel(connection, isEncoding, bufferSize, codec);
    }

    return result;
}

PBoolean WrapperH323EndPoint::OnStartLogicalChannel(H323Connection &connection,
                                                    H323Channel &channel)
{
    if (!(this->m_obj)) {
        return false;
    }

    int error;

    PBoolean result = cy_call_OnStartLogicalChannel(this->m_obj, &error, connection, channel);
    if (error) {
        result = H323EndPoint::OnStartLogicalChannel(connection, channel);
    }

    return result;
}