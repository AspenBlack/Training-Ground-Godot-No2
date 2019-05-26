extends Node

var Parent
export var MoveSpeed = 10

func _ready():
	Parent = get_parent()
	
func move(Apoint : Vector2):  #Relitive to Parrent
	#var Amove = Vector2(10,0)
	Apoint = Apoint.clamped(MoveSpeed)
	var Collision = Parent.move_and_collide(Apoint)
	if Collision :  #if statement is true is valid variable.
	##	print ("Position Colision %s" % (Collision.position))
		#mark_point(to_local(Collision.position))
	#	print ("Local Pos Colision %s" % (to_local(Collision.position)))
		if Collision.collider.has_method("Hit"):
			Collision.collider.Hit(Apoint)