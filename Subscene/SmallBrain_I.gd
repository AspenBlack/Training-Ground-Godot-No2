extends Node


var Parent = null

var ClosestFriend
var ClosestFoe
var Enviroment
var NetWorkWeights = Array()

# Called when the node enters the scene tree for the first time.
func _ready():
	Parent = get_parent()
	setup_process()
	print(NetWorkWeights)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func think(  ):
	ClosestFriend = sort_distance(get_friends_information())
	#print("Friend")
	#print(ClosestFriend)
	ClosestFoe = sort_distance(get_foe_information())
	#print("Foe")
	#print(ClosestFoe)
	Enviroment = sort_distance(get_evironment_information())
	#print("Envronment")
	#print(Enviroment)
	
	#Parent.CurrentMove = Parent.to_local(get_closest_target().position)/20
	Parent.CurrentMove = get_move()
	#print ("Movevector %s" % (Parent.CurrentMove))
	Parent.CurrentTarget = get_closest_target().global_position
	#print ("Targetvector %s" % (Parent.CurrentTarget))
	process_inputs()
	
	pass


func get_move():
#	print (ClosestFoe[0][1])
	var move
	move  = Parent.to_local(ClosestFoe[-1][1].position)/20

	return move

func process_inputs():
	var inputarray = Array()
	inputarray.append(Parent.to_local(ClosestFoe[0][1].position).x)
	inputarray.append(Parent.to_local(ClosestFoe[0][1].position).y)
	inputarray.append(Parent.to_local(ClosestFoe[1][1].position).x)
	inputarray.append(Parent.to_local(ClosestFoe[1][1].position).y)
	inputarray.append(Parent.to_local(ClosestFoe[2][1].position).x)
	inputarray.append(Parent.to_local(ClosestFoe[2][1].position).y)
	inputarray.append(Parent.to_local(ClosestFriend[0][1].position).x)
	inputarray.append(Parent.to_local(ClosestFriend[0][1].position).y)
	inputarray.append(Parent.to_local(ClosestFriend[1][1].position).x)
	inputarray.append(Parent.to_local(ClosestFriend[1][1].position).y)
	inputarray.append(Parent.to_local(ClosestFriend[2][1].position).x)
	inputarray.append(Parent.to_local(ClosestFriend[2][1].position).y)
	inputarray.append(Parent.to_local(Enviroment[0][1].position).x)
	inputarray.append(Parent.to_local(Enviroment[0][1].position).y)
	inputarray.append(Parent.to_local(Enviroment[1][1].position).x)
	inputarray.append(Parent.to_local(Enviroment[1][1].position).y)
	inputarray.append(Parent.to_local(Enviroment[2][1].position).x)
	inputarray.append(Parent.to_local(Enviroment[2][1].position).y)

	print (inputarray)

func setup_process():
	var Neuron = Array([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18])
	NetWorkWeights = [Neuron,Neuron,Neuron,Neuron,Neuron,Neuron,Neuron,Neuron,Neuron,Neuron,Neuron,Neuron,Neuron,Neuron,Neuron,Neuron,Neuron,Neuron]
	
	pass
	



func get_closest_target():
	var SomeNodes = get_foe_information()
	SomeNodes.sort()
	var Sorted = sort_distance(SomeNodes)
	#print("SomeNodes")
	#print(SomeNodes)
	#print("Sorted")
	#print(Sorted)
	var ANode 
#	for i in SomeNodes:
#		if Parent.position.distance_to(ANode.global_position) > Parent.position.distance_to(i.global_position):
#			ANode = i
	ANode = Sorted[0][1]
	#print("Target")
	#print(ANode)


	return ANode

#Need 3 closest red,blue,envo
func get_foe_information():
	var SomeNodes = get_tree().get_nodes_in_group("RedBots")

	return SomeNodes
	
func get_friends_information():
	var SomeNodes = get_tree().get_nodes_in_group("BlueBots")

	return SomeNodes
	
func get_evironment_information():
	var SomeNodes = get_tree().get_nodes_in_group("Environment")

	return SomeNodes

func sort_distance(AnArry):
	var NewArray : Array = Array() #it not initialised use variable from last time.
	for i in AnArry:
		NewArray.append([Parent.position.distance_to(i.global_position),i])
	NewArray.sort_custom(MyCustomSorter,"sort")
	return NewArray
	

#MatrixA x MatrixB
func MyMatrixMult(MatrixA,MatrixB):
	

	pass
	
class MyCustomSorter:
	static func sort(a, b):  #needs to be static for sort_custom to call.
		if a[0] < b[0]:
			return true
		return false

