# epicpydevicelib

A Python library providing base classes and utilities for writing devices and encoders for [EPICpy](https://github.com/travisseymour/EPICpy), a Python-based cognitive modeling environment built on the EPIC (Executive Process Interactive Control) architecture (Meyer & Kieras 1997).

## Overview

epicpydevicelib provides the foundational components needed to create simulated task environments (devices) that interact with EPIC's simulated human. It wraps the C++ EPIClib bindings and offers a Pythonic interface for:

- **Device development** - Create task environments that present stimuli and respond to simulated human actions
- **Visual/Auditory encoders** - Customize how sensory information is encoded before reaching the cognitive model
- **Data collection** - Built-in CSV output for recording experimental data
- **Statistical analysis** - Accumulators for means, proportions, distributions, correlations, and goodness-of-fit metrics

## Installation

```bash
pip install epicpydevicelib
```

Or with [uv](https://github.com/astral-sh/uv):

```bash
uv add epicpydevicelib
```

### Requirements

- Python 3.11 - 3.14
- [epiclibcpp](https://github.com/travisseymour/epiclibcpp) - Python bindings for EPIClib

## Quick Start

### Creating a Device

Subclass `EpicPyDevice` to create a task environment:

```python
from pathlib import Path
from epicpydevicelib.epicpy_device_base import EpicPyDevice
from epiclibcpp.epiclib import Output_tee, Symbol

class MyDevice(EpicPyDevice):
    def __init__(self, ot: Output_tee, device_name: str, device_folder: Path):
        super().__init__(ot, device_name, device_folder)

        # Define data output columns
        self.data_header = ("trial", "response", "rt", "correct")

    def handle_Start_event(self):
        """Called when simulation starts"""
        self.init_data_output()
        # Present initial stimulus
        self.make_visual_object_appear(Symbol("Stimulus1"))

    def handle_Keystroke_event(self, key_name: Symbol):
        """Called when simulated human presses a key"""
        # Record response and provide feedback
        self.data_writer.writerow((self.trial, str(key_name), self.rt, self.correct))
```

### Creating a Visual Encoder

Customize visual encoding by subclassing `EPICPyVisualEncoder`:

```python
from epicpydevicelib.epicpy_visual_encoder_base import EPICPyVisualEncoder
from epiclibcpp.epiclib import Symbol

class MyVisualEncoder(EPICPyVisualEncoder):
    def __init__(self):
        super().__init__("MyVisualEncoder")

    def set_object_property(self, object_name, property_name, property_value, encoding_time):
        # Custom encoding logic here
        encoded_value = self.encode(property_value)
        self.schedule_change_property_event(encoding_time, object_name, property_name, encoded_value)
        return True
```

## Key Components

### Device Base Class

`EpicPyDevice` provides:

- **Event handlers** - Override methods like `handle_Keystroke_event()`, `handle_Click_event()`, `handle_Vocal_event()` to respond to simulated human actions
- **Stimulus presentation** - Methods like `make_visual_object_appear()`, `set_visual_object_property()`, `make_auditory_speech_event()`
- **Data output** - Automatic CSV file management with `init_data_output()`, `finalize_data_output()`
- **Stats output** - `stats_write()` accepts strings, matplotlib figures, or pandas DataFrames
- **Condition strings** - Parse experimental conditions with `get_param_list()`

### Encoder Base Classes

- `EPICPyVisualEncoder` - Base for custom visual encoders
- `EPICPyAuditoryEncoder` - Base for custom auditory encoders

### Utilities

- **Symbols** - `Symbol` class and utilities for EPIC's symbolic representation
- **Geometry** - `Point`, `Size`, `Polar_vector` for spatial computations
- **Statistics** - `Mean_accumulator`, `Proportion_accumulator`, `Distribution_accumulator`, `Correl_accumulator`, `PredObs_accumulator`
- **Speech** - `Speech_word` for auditory speech events

## Related Projects

- [EPICpy](https://github.com/travisseymour/EPICpy) - The main EPICpy simulation environment
- [EPICpyDevices](https://github.com/travisseymour/EPICpyDevices) - Example devices built with this library
- [epiclibcpp](https://github.com/travisseymour/epiclibcpp) - Python bindings for the EPIC C++ library

## License

GNU General Public License v3 (GPLv3)

## Author

Travis Seymour (nogard@ucsc.edu)
