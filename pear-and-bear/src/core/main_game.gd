extends Node

@onready var h_box_container: SplitContainer = $SplitPlayerCamera/CanvasLayer/HBoxContainer

func splitworld(final:int):
	var t = create_tween()
	t.tween_property(h_box_container, "split_offset", final, 1.0)
