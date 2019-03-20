extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"


const ACCEL = 200
const MAX_SPEED = 10000
const FRICTION = -100
const GRAVITY = 2000

var acc = Vector2()
var vel = Vector2()


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	add_to_group("FreeFire")
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass



func _physics_process(delta):
	var MyDeg = self.rotation
	#print(MyDeg/(2*PI)*360)
	
	# Converts Rotation to vector
	vel = Vector2(sin(MyDeg),-cos(MyDeg))
	
	#print(vel)
	#print(vel.y)
	
	vel = vel*ACCEL
	#print(vel)
	vel.x = clamp(vel.x, -MAX_SPEED, MAX_SPEED)
	vel.y = clamp(vel.y, -MAX_SPEED, MAX_SPEED)
	var Collision = move_and_collide(vel * delta) #moves 100 times faster that 
	#var motion = move_and_slide(vel * delta) #moves very slow because already has delta mutiplyer.
	
	if Collision :  #if statement is true is valid variable.
		
		
		#print ("Yes")
		#print (Collision.collider.has_method("Hit"))
		if Collision.collider.has_method("Hit"):
			Collision.collider.Hit()
		queue_free()
	
	
	pass
	