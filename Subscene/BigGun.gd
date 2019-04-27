extends Node

var Parent = null
var Bullet_Scene = load("res://Subscene/Bullet_I_.tscn")
var Bullet_Script = load("res://Subscene/Bullet_I_.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	Parent = get_parent()
	#print (Parent)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func shoot( Apoint ):
	#print("shooting")
	
	if (typeof(Apoint) != TYPE_VECTOR2):  #can test any thing but then need to test what type of object
		print ("type Error")
		return null
	var AnAngle = Parent.position.angle_to_point(Apoint)
	var AColl : CollisionShape2D  = Parent.get_node("CollisionShape2D")
	var Coll_Shape = AColl.shape            # Collision shape 2D of current KinematicBody2D
	var Coll_Offset = AColl.position
	var NewPoint = Apoint - Parent.position        # Newpoint Moves Apoint Global value to Local
	NewPoint = NewPoint.normalized()
	var Avector = NewPoint.abs()
	var Bvector = Vector2()
	
	#Creates a vector that will extend out side the collion2D on the NewPoint heading
	# Note the +4 is the offset for the projectile collion2D 
	if (Avector.aspect() > Coll_Shape.extents.aspect()):  
		Bvector = Vector2( Coll_Shape.extents.x + 4 , (Coll_Shape.extents.x+4)/Avector.aspect() )
	else :
		Bvector = Vector2( (Coll_Shape.extents.y +4) * Avector.aspect() , Coll_Shape.extents.y +4 )
	
	Bvector = Bvector*1
	#print ("Bvector %s" % (Bvector))
	
	var bullet = Bullet_Scene.instance()
	bullet.set_name("bullet_B")
	bullet.set_script(Bullet_Script)
	#Takes the origianl direction to target and places projectial outside the collion2D
	bullet.position += NewPoint * Bvector.length() + Coll_Offset  
	AnAngle = 270 + (AnAngle * 57.29) #dont get the factor wrong :)
	bullet.rotation_degrees = AnAngle # rotates projictial to point in correct direction.
	#print(bullet.rotation_degrees)
	#print(bullet.position)
	Parent.add_child(bullet)				#Note is added to this node
	