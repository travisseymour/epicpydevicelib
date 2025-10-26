from pyee import EventEmitter

bus = EventEmitter()

"""
# in your pyside6 gui app, use something like this:

from PySide6.QtCore import QObject, Signal
from library.events import bus

class QtEvents(QObject):
    info = Signal(str)
    progress = Signal(int)

qt_events = QtEvents()

# Bridge from Pyee to Qt signals
bus.on("info", lambda s: qt_events.info.emit(s))
bus.on("progress", lambda v: qt_events.progress.emit(v))
"""

if __name__ == "__main__":
    bus.emit("info", "starting")
    bus.emit("progress", 50)
    bus.emit("info", "done")
