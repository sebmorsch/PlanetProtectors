extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var new_player = preload("res://Scenes/Player.tscn").instance()
	print("test name  " , new_player.name)
	new_player.name = str(get_tree().get_network_unique_id())
	print("test name  " , new_player.name)
	new_player.set_network_master(get_tree().get_network_unique_id())
	get_tree().get_root().add_child(new_player)
	var info = Network.self_data
	print(info)
	new_player.init(info.name, info.position, false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
