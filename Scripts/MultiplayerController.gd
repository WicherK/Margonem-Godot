extends Node2D

var peer = ENetMultiplayerPeer.new()

var world = preload("res://Scenes/world.tscn")
var player_prefab = preload("res://Prefabs/player_prefab.tscn")

func create_server() -> void:
	print("Creating server...")
	peer.create_server(25565)
	multiplayer.multiplayer_peer = peer
	
	# Set signal for spawning player for clients
	multiplayer.peer_connected.connect(spawn_player)
	
	# Load world for host
	var world_instance = world.instantiate()
	add_child(world_instance)
	
	# Spawn player for host
	spawn_player(multiplayer.get_unique_id())
	
	$Menu.hide()
	
func join_server() -> void:
	peer.create_client("localhost", 25565)
	multiplayer.multiplayer_peer = peer
	
	# Load world for client
	var world_instance = world.instantiate()
	add_child(world_instance)
	
	$Menu.hide()
	
func spawn_player(id) -> void:
	var player_instance = player_prefab.instantiate()
	player_instance.name = str(id)
	add_child(player_instance)
