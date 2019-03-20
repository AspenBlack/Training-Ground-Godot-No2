extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var countdown = 0.0 
var Bullet_Scene = load("res://Subscene/Bullet_I_.tscn")
var Bullet_Script = load("res://Subscene/Bullet_I_.gd")
var thenodes

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	add_to_group("BlueBots")
	pass

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	countdown = countdown-delta
	if (countdown < 0):
		countdown = 1
		var bullet = Bullet_Scene.instance()
		bullet.set_name("bullet_A")
		bullet.set_script(Bullet_Script)
		bullet.position.x += -40
		bullet.rotation_degrees = 270
		#bullet.position.y += 10
		add_child(bullet)
		
		print("***Top***")
		#print_tree_pretty()
		var index = get_child_count()
		var TheNode = get_child(index-1)
		
		print(get_parent())
		get_parent().print_tree_pretty()
		print(get_groups())
		var thenodes = get_tree().get_nodes_in_group("BlueBots")
		for i in thenodes:
			print(i.name)
		thenodes = get_tree().get_nodes_in_group("FreeFire")
		for i in thenodes:
			print(i.name)
		print("end")
	pass
