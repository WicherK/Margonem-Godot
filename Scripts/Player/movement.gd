extends CharacterBody2D

@onready var tilemap = $"../World/Ground" # Main tilemap with basic GROUND
var tilemap_solid_list = [] # Array for tilemaps that can have tiles marked as SOLID
@onready var animationControllerUp = $TorsoUp
@onready var animationControllerDown = $TorsoDown
@onready var camera = $Camera

@export var map_position = Vector2(0, 0)
@export var move_speed = 125

var moving = false

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _ready():			
	# Delete camera if you are not the owner of this player
	if not is_multiplayer_authority():
		camera.queue_free()
	
	# Load tilemap layers that can have SOLID tiles
	var solid_root = get_node("../World/SOLID")
	for child in solid_root.get_children():
		if child is TileMapLayer:
			tilemap_solid_list.append(child)
		
	if tilemap:
		position = tilemap.map_to_local(map_position)

func _process(delta):
	if not is_multiplayer_authority(): return
		
	if not moving:
		var input_vector = Vector2.ZERO
		if Input.is_action_pressed("right"):
			animationControllerUp.PlayAnim("WalkRight")
			animationControllerDown.PlayAnim("WalkRight")
			input_vector.x += 1
		elif Input.is_action_pressed("left"):
			animationControllerUp.PlayAnim("WalkLeft")
			animationControllerDown.PlayAnim("WalkLeft")
			input_vector.x -= 1
		elif Input.is_action_pressed("up"):
			animationControllerUp.PlayAnim("WalkUp")
			animationControllerDown.PlayAnim("WalkUp")
			input_vector.y -= 1
		elif Input.is_action_pressed("down"):
			animationControllerUp.PlayAnim("WalkDown")
			animationControllerDown.PlayAnim("WalkDown")
			input_vector.y += 1

		if input_vector != Vector2.ZERO:
			var next_tile = map_position + input_vector
			if not is_tile_solid(next_tile):
				map_position = next_tile
				moving = true

	# Keep moving this destination, till then dont allow any moves (drift solution)
	if moving:
		var target = tilemap.map_to_local(map_position)
		position = position.move_toward(target, move_speed * delta)
		if position.distance_to(target) < 1:
			position = target
			moving = false
	else:
		if not (Input.is_action_pressed("right") or Input.is_action_pressed("left") or Input.is_action_pressed("up") or Input.is_action_pressed("down")):
			animationControllerUp.PlayAnim("Stop")	
			animationControllerDown.PlayAnim("Stop")	
			
func is_tile_solid(tile_coords: Vector2i) -> bool:
	for tilemap_solid in tilemap_solid_list:
		var data = tilemap_solid.get_cell_tile_data(tile_coords)
		
		if data:
			if data.has_custom_data("solid"):
				print(data.get_custom_data("solid"))
				if data.get_custom_data("solid") == true:
					return true
			
	return false
