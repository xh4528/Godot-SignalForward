# <img src="https://raw.githubusercontent.com/xh4528/Godot-SignalForward/main/images/logo.png" width=30px height=auto> SignalForward - Godot 4 Plugin
The SignalForward node will connect all signals of the specified name and forward them through a single signal

## Signal

**forward(args: Variant)**
Forwarded signal
- args: The data that needs to be passed, is null by default. If multiple data needs to be passed, it is recommended to pass an array or dictionary



## Options
**forward_signal_name:**
 The name of the signal that needs to be forwarded


**monitor_method:**
 Select monitor method
- **Recursive**: Recursive monitor all child nodes
<img src="https://raw.githubusercontent.com/xh4528/Godot-SignalForward/main/images/recursive.png" width=800px height=auto>

- **Specified**: Monitor child nodes under specified nodes
<img src="https://raw.githubusercontent.com/xh4528/Godot-SignalForward/main/images/specified.png" width=800px height=auto>

**monitor_node_paths:**
 Nodes that need to be monitored