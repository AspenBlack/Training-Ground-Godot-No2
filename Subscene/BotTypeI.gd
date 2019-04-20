extends KinematicBody2D

export(String,"NeutralBots","BlueBots","RedBots","NotaBot","Environment","FreeFire") var Side = "NotaBot"
var Actions : float = 1
var CounterA : float = 0
var CurrentMove = Vector2(10,10)
var CurrentTarget = Vector2(1000,0)
var ShootMethod = null
var ThinkMethod = null


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group(Side)
	#var children = get_children()
	for child in get_children():
		if child.has_method("shoot"):
			ShootMethod = child
			print ("ShootMethod %s" % (child.name))
		if child.has_method("think"):
			ThinkMethod = child
			print ("ThinkMethod %s" % (child.name))

func _physics_process(delta):
	
	CounterA  = CounterA +delta
	if (CounterA  > (1/Actions)):
		CounterA  = 0
		think()
		move(CurrentMove)
		shoot(CurrentTarget)

#move apoint is local
func move(Apoint):
	#var Amove = Vector2(10,0)
	var Collision = move_and_collide(Apoint)
	if Collision :  #if statement is true is valid variable.
	##	print ("Position Colision %s" % (Collision.position))
		#mark_point(to_local(Collision.position))
	#	print ("Local Pos Colision %s" % (to_local(Collision.position)))
		if Collision.collider.has_method("Hit"):
			Collision.collider.Hit(Apoint)


#shoot apoint is globle
func shoot( Apoint ):
	if ShootMethod != null :
		ShootMethod.shoot(Apoint)
	# Defult shoot is none
	

func think(  ):
	if ThinkMethod != null :
		ThinkMethod.think()
	
	
	# Defult shoot is none
	pass
	