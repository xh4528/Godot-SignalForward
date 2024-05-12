@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type("SignalForward", "Node", preload("signal_forward_node.gd"), preload("icon.svg"))


func _exit_tree():
	remove_custom_type("SignalForward")
