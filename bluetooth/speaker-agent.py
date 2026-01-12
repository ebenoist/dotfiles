#!/usr/bin/python3
"""
Bluetooth speaker agent - makes this computer act as a Bluetooth speaker.
Automatically accepts A2DP connections from paired devices.
"""

import dbus
import dbus.service
import dbus.mainloop.glib
from gi.repository import GLib

BUS_NAME = 'org.bluez'
AGENT_INTERFACE = 'org.bluez.Agent1'
AGENT_PATH = '/speaker/agent'
ADAPTER_PATH = '/org/bluez/hci0'

# Audio-related UUIDs to accept
ALLOWED_UUIDS = [
    '0000110a-0000-1000-8000-00805f9b34fb',  # A2DP Source
    '0000110b-0000-1000-8000-00805f9b34fb',  # A2DP Sink
    '0000110c-0000-1000-8000-00805f9b34fb',  # AVRCP Target
    '0000110e-0000-1000-8000-00805f9b34fb',  # AVRCP Controller
    '0000110f-0000-1000-8000-00805f9b34fb',  # AVRCP
    '0000111e-0000-1000-8000-00805f9b34fb',  # Handsfree
    '0000111f-0000-1000-8000-00805f9b34fb',  # Handsfree AG
    '00001108-0000-1000-8000-00805f9b34fb',  # Headset
    '00001131-0000-1000-8000-00805f9b34fb',  # Headset HS
    '00001203-0000-1000-8000-00805f9b34fb',  # Generic Audio
]

class Agent(dbus.service.Object):
    @dbus.service.method(AGENT_INTERFACE, in_signature='', out_signature='')
    def Release(self):
        print('Agent released')

    @dbus.service.method(AGENT_INTERFACE, in_signature='os', out_signature='')
    def AuthorizeService(self, device, uuid):
        print(f'AuthorizeService called: device={device} uuid={uuid}')
        # Accept all audio-related UUIDs
        if uuid.lower() in ALLOWED_UUIDS:
            print(f'  -> Authorized')
            return
        # Also accept if it looks like an audio profile
        if 'audio' in uuid.lower() or 'a2dp' in uuid.lower():
            print(f'  -> Authorized (audio keyword)')
            return
        print(f'  -> Authorized (permissive mode)')
        return  # Accept everything for now

    @dbus.service.method(AGENT_INTERFACE, in_signature='o', out_signature='s')
    def RequestPinCode(self, device):
        print(f'RequestPinCode: {device}')
        return '0000'

    @dbus.service.method(AGENT_INTERFACE, in_signature='o', out_signature='u')
    def RequestPasskey(self, device):
        print(f'RequestPasskey: {device}')
        return dbus.UInt32(0)

    @dbus.service.method(AGENT_INTERFACE, in_signature='ouq', out_signature='')
    def DisplayPasskey(self, device, passkey, entered):
        print(f'DisplayPasskey: {passkey:06d}')

    @dbus.service.method(AGENT_INTERFACE, in_signature='os', out_signature='')
    def DisplayPinCode(self, device, pincode):
        print(f'DisplayPinCode: {pincode}')

    @dbus.service.method(AGENT_INTERFACE, in_signature='ou', out_signature='')
    def RequestConfirmation(self, device, passkey):
        print(f'RequestConfirmation: {device} passkey={passkey:06d} -> auto-confirmed')
        return

    @dbus.service.method(AGENT_INTERFACE, in_signature='o', out_signature='')
    def RequestAuthorization(self, device):
        print(f'RequestAuthorization: {device} -> authorized')
        return

    @dbus.service.method(AGENT_INTERFACE, in_signature='', out_signature='')
    def Cancel(self):
        print('Cancel called')


def set_adapter_discoverable(bus):
    adapter = dbus.Interface(
        bus.get_object(BUS_NAME, ADAPTER_PATH),
        'org.freedesktop.DBus.Properties'
    )
    adapter.Set('org.bluez.Adapter1', 'Discoverable', dbus.Boolean(True))
    adapter.Set('org.bluez.Adapter1', 'DiscoverableTimeout', dbus.UInt32(0))
    adapter.Set('org.bluez.Adapter1', 'Pairable', dbus.Boolean(True))
    adapter.Set('org.bluez.Adapter1', 'PairableTimeout', dbus.UInt32(0))
    print('Adapter set to discoverable')


def main():
    dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
    bus = dbus.SystemBus()

    agent = Agent(bus, AGENT_PATH)

    manager = dbus.Interface(
        bus.get_object(BUS_NAME, '/org/bluez'),
        'org.bluez.AgentManager1'
    )
    manager.RegisterAgent(AGENT_PATH, 'NoInputNoOutput')
    manager.RequestDefaultAgent(AGENT_PATH)
    print('Agent registered as default')

    set_adapter_discoverable(bus)

    print('Bluetooth speaker agent running...')
    print('Visible as "framework-desktop"')
    print('Waiting for connections...')

    mainloop = GLib.MainLoop()
    mainloop.run()


if __name__ == '__main__':
    main()
