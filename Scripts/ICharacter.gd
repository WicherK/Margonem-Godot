extends Area2D
class_name ICharacter

enum CHARACTER_TYPE {PLAYER, NPC, ENEMY}

@export var character_type: CHARACTER_TYPE
@export var character_name: String
@export var boss_status: String
@export var level: String
@export var actual_exp: String
@export var max_exp: String

var above_tip = preload("res://Prefabs/hover_tip.tscn")
var hover_tip = preload("res://Prefabs/hover_tip.tscn")

var above_tip_instance
var hover_tip_instance

func _ready() -> void:
	if character_type == CHARACTER_TYPE.PLAYER:
		character_name = get_parent().name
		
	connect("mouse_entered", mouse_on_character)
	connect("mouse_exited", mouse_leave_character)
	
func mouse_on_character() -> void:
	# Spawn tip with short info about character
	hover_tip_instance = hover_tip.instantiate()
	# Fill info in tip
	hover_tip_instance.character_name = character_name
	hover_tip_instance.boss_status = boss_status
	hover_tip_instance.level = level
	# Add it to the scene
	get_parent().add_child(hover_tip_instance)
	
func mouse_leave_character() -> void:
	# Delete tip
	hover_tip_instance.queue_free()
	
func _process(delta: float) -> void:
	# Update position of the tip when mouse is on character
	if hover_tip_instance:
		hover_tip_instance.global_position = get_global_mouse_position() + Vector2(30, 0)
