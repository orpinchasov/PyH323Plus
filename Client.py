import sys
sys.path.append("PTLib/Build")
sys.path.append("H323Plus/Build")

from PLibraryProcess import PLibraryProcess
from Address import Address
from PIndirectChannel import PIndirectChannel

from H323ListenerTCP import H323ListenerTCP
from H323EndPoint import H323EndPoint

import wave
import time
import argparse

def parse_args():
    parser = argparse.ArgumentParser(description='H323 VoIP Client.')

    parser.add_argument('-o', '--output-file', type=str, default=None,
                        help='output file name')
    parser.add_argument('-f', '--input-file', type=str, default=None,
                        help='input file name')
    parser.add_argument('-i', '--interface', type=str, default='*',
                        help='interface name')

    group = parser.add_mutually_exclusive_group()
    group.add_argument('-l', '--listen', action='store_true',
                       help='listen for incoming calls')
    group.add_argument('-d', '--destination', type=str, default=None,
                       help='identifier of destination endpoint')

    args = parser.parse_args()
    return args

class WavChannel(PIndirectChannel):
    SAMPLES_PER_SECOND = 8000
    DEFAULT_WAVE_PARAMETERS = (1, 2, SAMPLES_PER_SECOND, 40000, 'NONE', 'not compressed')

    def __init__(self, input_filename=None, output_filename=None):
        super(WavChannel, self).__init__()

        if input_filename:
            self._input_wav = wave.open(input_filename, "rb")
        else:
            self._input_wav = None

        if output_filename:
            self._output_wav = wave.open(output_filename, "wb")
            self._output_wav.setparams(WavChannel.DEFAULT_WAVE_PARAMETERS)
        else:
            self._output_wav = None

        self._read_previous_time = time.time()
        self._write_previous_time = time.time()

    def IsOpen(self):
        return True

    def Close(self):
        if self._input_wav:
            self._input_wav.close()
            self._input_wav = None
        if self._output_wav:
            self._output_wav.close()
            self._output_wav = None

        return True

    def Read(self, buf, length):
        if self._input_wav is not None:
            b = self._input_wav.readframes(length / 2)
        else:
            b = "\x00" * length
        self._last_read_count = length

        while (time.time() < self._read_previous_time +
                (1.0 / (WavChannel.SAMPLES_PER_SECOND / (length / 2)))):
            time.sleep(0)
        self._read_previous_time = time.time()

        return (True, b)

    def GetLastReadCount(self):
        return self._last_read_count

    def Write(self, buf, length):
        if self._output_wav is not None:
            self._output_wav.writeframes(buf)

        while (time.time() < self._write_previous_time +
                (1.0 / (WavChannel.SAMPLES_PER_SECOND / (length / 2)))):
            time.sleep(0)
        self._write_previous_time = time.time()

        return True

class Client(H323EndPoint):
    DEFAULT_LISTENING_PORT = 1720

    def initialize(self, input_filename=None, output_filename=None):
        self._input_filename = input_filename
        self._output_filename = output_filename

        self.LoadBaseFeatureSet()
        self.AddAllCapabilities(0, 0x7fffffff, '*')
        self.AddAllUserInputCapabilities(0, 0x7fffffff)

    def listen(self, interface):
        address = Address(interface)
        listener = H323ListenerTCP(self, address, Client.DEFAULT_LISTENING_PORT)
        return self.StartListener(listener)

    def OnIncomingCall(self, connection, setupPDU, alertingPDU):
        print "Incoming call", connection
        return True

    def OnConnectionEstablished(self, connection, token):
        print "Connection established, token =", token

    def OnConnectionCleared(self, connection, token):
        print "Connection cleared, token =", token

    def OpenAudioChannel(self, connection, isEncoding, bufferSize, codec):
        print "Opening audio channel (%s, %s, %d, %s)" % (connection, isEncoding, bufferSize, codec)

        if isEncoding:
            # Send data
            wav_channel = WavChannel(input_filename = self._input_filename)
        else:
            # Receive data
            wav_channel = WavChannel(output_filename = self._output_filename)

        return codec.AttachChannel(wav_channel, autoDelete = False)

def listen(client, interface):
    if client.listen(interface):
        print "Listening for an incoming call"
        return True
    else:
        print "Listening failed"
        return False

def make_call(client, destination):
    print "Making call to", destination
    return client.MakeCall(destination, None)

def main():
    args = parse_args()

    client = Client()
    client.initialize(args.input_file,
                      args.output_file)

    print "Press any key to quit\n\n"

    if args.listen:
        if not listen(client, args.interface):
            exit(1)
    else:
        make_call(client, args.destination)

    raw_input()

    client.ClearAllCalls(wait = False)
    # Allow the connection to clear
    time.sleep(1)

if __name__ == '__main__':
    p = PLibraryProcess("", "", 1, 0, 0, 0)

    main()