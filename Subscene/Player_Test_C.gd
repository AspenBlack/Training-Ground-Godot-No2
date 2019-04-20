extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var countdown = 0.0
var countdown2 = 0.0
var Bullet_Scene = load("res://Subscene/Bullet_I_.tscn")
var Bullet_Script = load("res://Subscene/Bullet_I_.gd")
#var thenodes
var ArrayOf2D_1 = PoolVector2Array([Vector2(0,0),Vector2(30,30)])
var ArrayOf2D_2 = PoolVector2Array([Vector2(0,0),Vector2(8,40)])


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	add_to_group("BlueBots")
	pass

func _draw():
	#print ("is called")
	#note is refrenced to where this node is no global
	draw_polyline(ArrayOf2D_1,Color(255,100,0),2)
	draw_polyline(ArrayOf2D_2,Color(255,100,0),1)


func _physics_process(delta):
	countdown2 = countdown2-delta
	if (countdown2 < 0):
		countdown2 = 1
		move()

func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	countdown = countdown-delta
	if (countdown < 0):
		countdown = 1


		shoot(get_closest_target().global_position)


	pass


func get_closest_target():
	var SomeNodes = get_tree().get_nodes_in_group("RedBots")
	var ANode = SomeNodes[0]
	for i in SomeNodes:
	#	print(i.name)
	#	print(i.global_position)
	#	print(position.distance_to(i.global_position))
		if position.distance_to(ANode.global_position) > position.distance_to(i.global_position):
			ANode = i
	return ANode
	pass



func shoot( Apoint ):
	#if (Apoint.get_class() != "Vector2") : #only works for objects vector2 is a built in type.
	if (typeof(Apoint) != TYPE_VECTOR2):  #can test any thing but then need to test what type of object
		print ("type Error")
		return null
	var AnAngle = position.angle_to_point(Apoint)
	var AColl : CollisionShape2D  = get_node("CollisionShape2D")
	var Coll_Shape = AColl.shape            # Collision shape 2D of current KinematicBody2D
	var Coll_Offset = AColl.position
	var NewPoint = Apoint - position        # Newpoint Moves Apoint Global value to Local
	NewPoint = NewPoint.normalized()
	var Avector = NewPoint.abs()
	var Bvector = Vector2()


	#print ("The Shape is  %s" % AColl)
	#print ("Shape size %s" % (Coll_Shape.extents))
	#print ("Shape Aspect %s" % (Coll_Shape.extents.aspect()))
	#print ("Shape Pos G%s" % (Coll_Offset))
	#print ("Current Point %s" % position)
	#print ("Vector from current to Target %s" % NewPoint)
	#print ("Vector from current to Target Normalised * X %s" % NewPoint)
	#print (" Avector aspect %s" % Avector.aspect())

	#Creates a vector that will extend out side the collion2D on the NewPoint heading
	# Note the +4 is the offset for the projectile collion2D
	if (Avector.aspect() > Coll_Shape.extents.aspect()):
		Bvector = Vector2( Coll_Shape.extents.x + 4 , (Coll_Shape.extents.x+4)/Avector.aspect() )
	else :
		Bvector = Vector2( (Coll_Shape.extents.y +4) * Avector.aspect() , Coll_Shape.extents.y +4 )


	#print (" Bvector  %s" % Bvector)
	#print ("Vector from current to Target Normalised * X %s" % ((NewPoint * Bvector.length())+Coll_Offset))
	var bullet = Bullet_Scene.instance()
	bullet.set_name("bullet_A")
	bullet.set_script(Bullet_Script)
	#Takes the origianl direction to target and places projectial outside the collion2D
	bullet.position += NewPoint * Bvector.length() + Coll_Offset
	AnAngle = 270 + (AnAngle * 57.29) #dont get the factor wrong :)
	bullet.rotation_degrees = AnAngle # rotates projictial to point in correct direction.
	add_child(bullet)				#Note is added to this node

	#print ("Angle loaded %s" % (AnAngle))
	pass


func move():
	var Amove = Vector2(10,0)
	var Collision = move_and_collide(Amove)
	if Collision :  #if statement is true is valid variable.
	#	print ("Position Colision %s" % (Collision.position))
		mark_point(to_local(Collision.position))
	#	print ("Local Pos Colision %s" % (to_local(Collision.position)))
		if Collision.collider.has_method("Hit"):
			Collision.collider.Hit(Amove)



	pass


func mark_point(apoint) :
	if (typeof(apoint) != TYPE_VECTOR2):  #if not vector do nothing
		print ("type Error")
		return null
	#print ("marking")
	ArrayOf2D_1 = PoolVector2Array([Vector2(-10,-10) + apoint,Vector2(10,10) + apoint])
	ArrayOf2D_2 = PoolVector2Array([Vector2(10,-10) + apoint,Vector2(-10,10) + apoint])
	update()
