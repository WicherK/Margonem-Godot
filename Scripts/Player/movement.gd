extends CharacterBody2D

@onready var tilemap = $"../Ground"
@onready var animationController = $BodySkin

@export var map_position = Vector2(0, 0)
@export var move_speed = 125

var moving = false

func _ready():
	position = tilemap.map_to_local(map_position)

func _process(delta):
	if not moving:
		var input_vector = Vector2.ZERO
		if Input.is_action_pressed("ui_right"):
			animationController.PlayAnim("WalkRight")
			input_vector.x += 1
		elif Input.is_action_pressed("ui_left"):
			animationController.PlayAnim("WalkLeft")
			input_vector.x -= 1
		elif Input.is_action_pressed("ui_up"):
			animationController.PlayAnim("WalkUp")
			input_vector.y -= 1
		elif Input.is_action_pressed("ui_down"):
			animationController.PlayAnim("WalkDown")
			input_vector.y += 1

		if input_vector != Vector2.ZERO:
			map_position += input_vector
			moving = true

	# Keep moving this destination, till then dont allow any moves (drift solution)
	if moving:
		var target = tilemap.map_to_local(map_position)
		position = position.move_toward(target, move_speed * delta)
		if position.distance_to(target) < 1:
			position = target
			moving = false
	else:
		if not Input.is_anything_pressed():
			animationController.PlayAnim("Stop")		
