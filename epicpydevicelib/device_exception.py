from epiclibcpp.epiclib import raise_device_exception

raise_on_device_error: bool = False

class Device_exception(Exception):
    def __init__(self, message):
        super(Device_exception, self).__init__(message)
        if raise_on_device_error:
            raise_device_exception(message)


if __name__ == "__main__":
    raise Device_exception("This is a problem")
