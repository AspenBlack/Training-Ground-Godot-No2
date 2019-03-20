extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	add_to_group("RedBots")
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func Hit():
	
	
	
	print(get_node("Sprite").name)
	print(self.name)
	print($Sprite.frame)
	if ($Sprite.frame == $Sprite.vframes*$Sprite.hframes-1):
		$Sprite.frame = 0
	else:
		$Sprite.frame = $Sprite.frame + 1
	
	pass
	