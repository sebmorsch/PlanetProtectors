extends KinematicBody2D

var movespeed = 100
var velocity = Vector2()

puppet var puppet_position = Vector2()
puppet var puppet_velosity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	
	if is_network_master():
		
		var move_dir = Vector2()	
		if Input.is_action_pressed("player_up"):
			move_dir.y -= 1
		if Input.is_action_pressed("player_down"):
			move_dir.y += 1
		if Input.is_action_pressed("player_left"):
			move_dir.x -= 1
		if Input.is_action_pressed("player_right"):
			move_dir.x += 1
		
		velocity = move_dir.normalized() * movespeed
	
		rset("puppet_position", position)
		rset("puppet_velosity", velocity)
	else:
		position = puppet_position
		velocity = puppet_velosity
	
	position += velocity * delta
	
	move_and_slide(velocity)
	if not is_network_master():
		puppet_position = position 

		
func init(name, position, is_slave):
	position = position
	if is_slave:
		$Sprite.texture = load('res://Resources/Player.png')

func set_player_name(new_name):
	get_node("label").set_text(new_name)
	print(new_name)
