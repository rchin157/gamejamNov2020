extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_start_pressed():
	get_tree().change_scene("res://Level/OpeningMenu.tscn")
	pass # Replace with function body.


func _on_info_pressed():
	get_tree().change_scene("res://Level/Info.tscn")
	pass # Replace with function body.


func _on_stats_pressed():
	get_tree().change_scene("res://Level/Stats.tscn")
	pass # Replace with function body.
