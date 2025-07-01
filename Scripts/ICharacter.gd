extends Area2D
class_name ICharacter

enum CHARACTER_TYPE { NPC, PLAYER, ENEMY }

@export var character_name: String

@export var character_type: CHARACTER_TYPE
@export var boss_status: String
@export var level: int
@export var exp_min: int
@export var exp_max: int
@export var health: int
@export var mana: int

@export var skills: Array[ISkill] = []

@export var stats = {
	"attack_speed": 0,
	"base_attack": 0,
	"magic_attack": 0,
	"armor": 0,
	"magic_armor": 0,
}

# Cursors
var normal_cursor := preload("res://Assets/ReadyGUIResources/cursor.png")
var attack_cursor := preload("res://Assets/ReadyGUIResources/attack_cursor.png")
var use_cursor := preload("res://Assets/ReadyGUIResources/cursor.png")
var dialog_cursor := preload("res://Assets/ReadyGUIResources/dialog_cursor.png")

# Tooltip prefab
var tooltip_prefab := preload("res://Prefabs/tip_prefab.tscn")
var tooltip_instance: Tip = null

signal hovered(character: ICharacter)
signal unhovered()

func _ready():
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)

func apply_damage(damage_value: int, damage_type: ISkill.DAMAGE_TYPE) -> void:
	pass
	
func _on_mouse_entered():
	if tooltip_instance == null:
		tooltip_instance = tooltip_prefab.instantiate()
		
		if character_type == CHARACTER_TYPE.ENEMY:
			tooltip_instance.name_text = character_name
			tooltip_instance.boss_status_text = boss_status
			tooltip_instance.level_text = str(level) + " lvl"
			Input.set_custom_mouse_cursor(attack_cursor)	
		elif character_type == CHARACTER_TYPE.NPC:
			tooltip_instance.name_text = character_name
			tooltip_instance.level_text = ""
			Input.set_custom_mouse_cursor(dialog_cursor)
		elif character_type == CHARACTER_TYPE.PLAYER:
			tooltip_instance.name_text = character_name
			tooltip_instance.level_text = ""
			Input.set_custom_mouse_cursor(use_cursor)
			
		var ui_layer = get_tree().get_current_scene().get_node("CanvasLayer")
		ui_layer.add_child(tooltip_instance)
	tooltip_instance.show()
	set_process(true)

func _on_mouse_exited():
	if tooltip_instance:
		tooltip_instance.queue_free()
		tooltip_instance = null
	set_process(false)
	
	Input.set_custom_mouse_cursor(normal_cursor)

func _process(delta):
	if tooltip_instance:
		tooltip_instance.position = get_viewport().get_mouse_position() + Vector2(30, 0)
