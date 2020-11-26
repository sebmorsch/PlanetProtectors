extends Node

const DEFAULT_IP = '127.0.0.1'
const MAX_PLAYERS = 5

var players = {}
var self_data = { name = '', position = Vector2(360, 180) }

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func create_server(player_nickname, port):
	self_data.name = player_nickname
	players[1] = self_data
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(int(port), MAX_PLAYERS)
	get_tree().set_network_peer(peer)

func connect_to_server(player_nickname, ip, port):
	self_data.name = player_nickname
	get_tree().connect('connected_to_server', self, '_connected_to_server')
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(ip, int(port))
	get_tree().set_network_peer(peer)

func _connected_to_server():
	players[get_tree().get_network_unique_id()] = self_data
	rpc_unreliable('_send_player_info', get_tree().get_network_unique_id(), self_data)

func _player_connected(id):
	print('Player connected: ' + str(id))
	
func _player_disconnected(id):
	print('Player disconnected: ' + str(id))
	players.erase(id)

remote func _send_player_info(id, info):
	if get_tree().is_network_server():
		for peer_id in players:
			rpc_id(id, '_send_player_info', peer_id, players[peer_id])
	players[id] = info
	
	var new_player = load('res://Player.tscn').instance()
	new_player.name = str(id)
	new_player.set_network_master(id)
	get_tree().get_root().add_child(new_player)
	new_player.init(info.name, info.position, true)

func update_position(id, position):
	players[id].position = position
