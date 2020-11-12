extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Hunger;
var Warmth
var Progress

# Called when the node enters the scene tree for the first time.
func _ready():
	Hunger = get_node("Hunger");
	Warmth = get_node("Warmth");
	Progress = get_node("Progress");
	pass # Replace with function body.

func updateHunger(state: int):
	Hunger.set_frame(state)
	pass

func updateWarmth(state: int):
	Warmth.set_frame(state)
	pass

func createProgress(position: Vector2):
	Progress.set_position(position+Vector2(-320,-50))
	Progress.show()
	#updateProgress(0)
	pass
	
func updateProgress(state: int):
	Progress.set_frame(state)
	pass
	
func removeProgress():
	Progress.hide();
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
