extends Area2D
class_name ICharacter

enum CHARACTER_TYPE {PLAYER, NPC, ENEMY}
enum PVP_STATUS {NO, YES}

@export var character_type: CHARACTER_TYPE
@export var character_name: String
@export var boss_status: String
@export var level: String
@export var actual_exp: String
@export var max_exp: String
@export var pvp_status: PVP_STATUS

var normal_cursor = preload("res://Assets/ReadyGUIResources/cursor.png")
var use_cursor = preload("res://Assets/ReadyGUIResources/use_cursor.png")
var dialog_cursor = preload("res://Assets/ReadyGUIResources/dialog_cursor.png")
var attack_cursor = preload("res://Assets/ReadyGUIResources/attack_cursor.png")

var above_tip = preload("res://Prefabs/hover_tip.tscn")
var hover_tip = preload("res://Prefabs/hover_tip.tscn")

var above_tip_instance
var hover_tip_instance

func _ready() -> void:
	if character_type == CHARACTER_TYPE.PLAYER:
		set_multiplayer_authority(get_parent().name.to_int())
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
	
	# Manage style of cursor depending on what are we hovering mouse on
	if character_type == CHARACTER_TYPE.NPC:
		Input.set_custom_mouse_cursor(dialog_cursor)
		
	if character_type == CHARACTER_TYPE.PLAYER:
		Input.set_custom_mouse_cursor(use_cursor)
		
	if character_type == CHARACTER_TYPE.ENEMY:
		Input.set_custom_mouse_cursor(attack_cursor)
	
func mouse_leave_character() -> void:
	# Delete tip
	hover_tip_instance.queue_free()
	
	Input.set_custom_mouse_cursor(normal_cursor)
	
func _process(delta: float) -> void:
	# Update position of the tip when mouse is on character
	if hover_tip_instance:
		hover_tip_instance.global_position = get_global_mouse_position() + Vector2(30, 0)
		
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		shoot_ray()

var ray_length = 10000

func shoot_ray() -> void:
	if is_multiplayer_authority():
		# Settings position and direction of shot
		var start_pos = global_position
		var mouse_pos = get_global_mouse_position()
		var direction = (mouse_pos - start_pos).normalized()
		var end_pos = start_pos + direction * ray_length

		# Cast the ray in 2D space
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(start_pos, end_pos)
		query.collide_with_areas = true
		query.collide_with_bodies = false
		query.collision_mask = 2
		query.exclude = [self]
		
		# Result of our shot
		var result = space_state.intersect_ray(query)

		if result:
			if result.collider.name == "Character":
				# Start battle
				pass
		else:
			print("Ray missed.")
