@tool
@icon("icon.svg")
class_name SignalForward extends Node
## The SignalForward node will connect all signals of the specified name and forward them through a single signal

## The name of the signal that needs to be forwarded
@export var forward_signal_name: String = ""
## Forwarded signal [br]
## args: The data that needs to be passed, is null by default. If multiple data needs to be passed, it is recommended to pass an array or dictionary
signal forward(args: Variant)

#region dynamic options
## Select monitor method
@export var monitor_method: MonitorMethod = MonitorMethod.Recursive:
	set(value):
		if value == MonitorMethod.Recursive:
			monitor_node_paths.clear()
		elif value == MonitorMethod.Specified:
			monitor_node_paths = ["."]
		monitor_method = value
		notify_property_list_changed()

enum MonitorMethod {
	## Recursive monitor all child nodes
	Recursive,
	## Monitor child nodes under specified nodes
	Specified
}
## Nodes that need to be monitored
var monitor_node_paths: Array[NodePath] = []


func _get_property_list():
	var property_usage = PROPERTY_USAGE_NO_EDITOR
	if monitor_method == MonitorMethod.Specified:
		property_usage = PROPERTY_USAGE_DEFAULT
	var properties = []
	(
		properties
		. append(
			{
				"name": "monitor_node_paths",
				"type": TYPE_ARRAY,
				"hint": PROPERTY_HINT_NODE_TYPE,
				"usage": property_usage,  # See above assignment.
			}
		)
	)
	return properties


#endregion


func _enter_tree() -> void:
	if monitor_method == MonitorMethod.Recursive:
		_on_register_signals(self)
	elif monitor_method == MonitorMethod.Specified:
		for path in monitor_node_paths:
			var node = get_node(path)
			if node:
				_on_register_signals(node)


func _on_child_entered_tree(node: Node):
	if not (node is SignalForward):
		if monitor_method == MonitorMethod.Recursive:
			_on_register_signals(node)
		if (
			node.has_signal(forward_signal_name)
			and not node.is_connected(forward_signal_name, _on_forward)
		):
			node.connect(forward_signal_name, _on_forward)


func _on_forward(args: Variant = null) -> void:
	forward.emit(args)


func _on_register_signals(node: Node):
	if not node.is_connected("child_entered_tree", _on_child_entered_tree):
		node.connect("child_entered_tree", _on_child_entered_tree)

	if not node.is_connected("child_exiting_tree", _on_unregister_signals):
		node.connect("child_exiting_tree", _on_unregister_signals)


func _on_unregister_signals(node: Node):
	if node.is_connected("child_entered_tree", _on_child_entered_tree):
		node.disconnect("child_entered_tree", _on_child_entered_tree)

	if node.is_connected("child_exiting_tree", _on_unregister_signals):
		node.disconnect("child_exiting_tree", _on_unregister_signals)

	if node.has_signal(forward_signal_name) and node.is_connected(forward_signal_name, _on_forward):
		node.disconnect(forward_signal_name, _on_forward)
