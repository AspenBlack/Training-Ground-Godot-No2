extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var themove = null

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	add_to_group("RedBots")
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _physics_process(delta):
	if themove :
		Bumped(themove)
		themove = null
		
		

func Hit(Info = null):
	if (typeof(Info) == TYPE_VECTOR2):  #can test any thing but then need to test what type of object
		print ("Bump")
		Info = Info.normalized()
		print (Info)
		print (Info.tangent())
		var NewVector = Info.tangent() * rand_range(-1,1)
		print ("Vector 1 %s" % (NewVector))
		NewVector = NewVector + Info
		print ("Vector 2 %s" % (NewVector))
		themove = NewVector * 10
		return null
	

	

	
	if ($Sprite.frame == $Sprite.vframes*$Sprite.hframes-1):
		$Sprite.frame = 0
	else:
		$Sprite.frame = $Sprite.frame + 1

	pass




	

func Bumped(Info):
	if (typeof(Info) != TYPE_VECTOR2): # Trap passing of non vectors to move
		return null
		
	var Amove = Info
	#print ("Vector 3 %s" % (Amove))
	#print ("Vector 4 %s" % (Amove))
	#global_translate(Amove) works but ignores other objects
	

#	var Collision = move_and_slide(Amove) # if using this need diffrent test for collision.
	var Collision = move_and_collide(Amove)  #Now working as all calls are in _physics_process()
	if Collision :  #if statement is true is valid variable.
		if Collision.collider.has_method("Hit"):
			Collision.collider.Hit(Amove)
		
	pass