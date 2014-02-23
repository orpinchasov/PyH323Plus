#include <Python.h>

#include "WrapperH323EndPoint.h"
#include "../CPP/H323EndPoint_api.h"

#include <ptlib.h>
#include <h323.h>

WrapperH323EndPoint::WrapperH323EndPoint(PyObject *obj): m_obj(obj) {
	PyEval_InitThreads();

	if (import_H323EndPoint()) {
    } else {
        Py_XINCREF(this->m_obj);
    }
}

WrapperH323EndPoint::~WrapperH323EndPoint() {
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