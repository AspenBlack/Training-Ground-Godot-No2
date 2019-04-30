extends KinematicBody2D

export(String,"NeutralBots","BlueBots","RedBots","NotaBot","Environment","FreeFire") var Side = "NotaBot"
var Actions : float = 1
var CounterA : float = 0
var CurrentMove = Vector2(100,100)
var CurrentTarget = Vector2(1000,0)
var ShootMethod = null
var ThinkMethod = null
var MoveMethod = null
var SaveDataMethod = null
var SaveNetworkMethod = null


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
		if child.has_method("move"):
			MoveMethod = child
			print ("MoveMethod %s" % (child.name))
		if child.has_method("savedata"):
			SaveDataMethod = child
			print ("SaveDataMethod %s" % (child.name))
		if child.has_method("savenetwork"):
			SaveNetworkMethod = child
			print ("SaveNetworkMethod %s" % (child.name))
		

func _physics_process(delta):
	
	CounterA  = CounterA +delta
	if (CounterA  > (1/Actions)):
		CounterA  = 0
		think()
		move(CurrentMove)
		shoot(CurrentTarget)

#move apoint is local
func move(Apoint):
	if MoveMethod != null :
		MoveMethod.move(Apoint)
	# Defult shoot is none


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
	

func _on_SaveData_pressed():
	print("Button Pressed")
	if SaveDataMethod != null :
		SaveDataMethod.savedata()

