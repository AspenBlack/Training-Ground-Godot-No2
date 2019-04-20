extends Node


var Parent = null

# Called when the node enters the scene tree for the first time.
func _ready():
	Parent = get_parent()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func think(  ):
	Parent.CurrentMove = Vector2(-10,-10)
	pass
	