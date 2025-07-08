extends Camera2D

var is_dragging := false
var drag_start_mouse_pos := Vector2()
var drag_start_camera_pos := Vector2()
var move_speed := 1.25
var zoom_speed := 0.1
var min_zoom := 0.5
var max_zoom := 5.0

func _ready() -> void:
	visible = true

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			if event.pressed:
				is_dragging = true
				drag_start_mouse_pos = get_viewport().get_mouse_position()
				drag_start_camera_pos = global_position
			else:
				is_dragging = false

		# Scroll to zoom
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			adjust_zoom(zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			adjust_zoom(-zoom_speed)

	elif event is InputEventMouseMotion and is_dragging:
		var mouse_delta = get_viewport().get_mouse_position() - drag_start_mouse_pos
		global_position = drag_start_camera_pos - mouse_delta * move_speed
		
func adjust_zoom(amount: float) -> void:
	var new_zoom = zoom + Vector2(amount, amount)
	new_zoom.x = clamp(new_zoom.x, min_zoom, max_zoom)
	new_zoom.y = clamp(new_zoom.y, min_zoom, max_zoom)
	zoom = new_zoom
