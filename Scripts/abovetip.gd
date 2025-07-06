extends Panel
class_name AboveTip

var name_text : String
var parent : Node2D

@onready var name_label = $NameLabel

func _ready() -> void:
	assert(parent != null, "AboveTip requires a parent Node2D to follow.")
	name_label.text = name_text
	
func _process(delta: float) -> void:
	var camera := get_viewport().get_camera_2d()
	var screen_pos := (parent.global_position - camera.global_position) * camera.zoom + get_viewport_rect().size / 2
	position = screen_pos + Vector2(-size.x / 2, -40)
