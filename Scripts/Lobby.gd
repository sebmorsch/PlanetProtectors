extends Control

var _player_name = ""
var _ip = ""
var _port = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_CREATE_pressed():
	if _player_name == "":
		return
	if _ip == "":
		return
	if _port == "":
		return
	Network.create_server(_player_name, _port)
	_load_game()

func _on_JOIN_pressed():
	if _player_name == "":
		return
	if _ip == "":
		return
	if _port == "":
		return
	Network.connect_to_server(_player_name, _ip, _port)
	_load_game()


func _on_IP_INPUT_text_changed(new_text):
	_ip = new_text

func _on_PORT_INPUT_text_changed(new_text):
	_port = new_text

func _on_NAME_INPUT_text_changed(new_text):
	_player_name = new_text

func _load_game():
	get_tree().change_scene("res://Game.tscn")
