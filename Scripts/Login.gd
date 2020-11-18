extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var email : LineEdit = $VBoxContainer/HBoxContainer/LineEdit
onready var password : LineEdit = $VBoxContainer/HBoxContainer2/LineEdit
onready var notification : Label = $notification

func _on_Login_pressed():
	if email.text.empty() or password.text.empty():
		notification.text = "Please, enter your username and password"
		return
	Firebase.login(email.text, password.text, http)
	

func _on_Back_pressed():
	get_tree().change_scene("res://Level/Firebase/AuthStart.tscn")


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var response_body = JSON.parse(body.get_string_from_ascii())
	if response_code != 200:
		notification.text = response_body.result.error.message.capitalize()
	else:
		notification.text = "Sign in successful"
	yield(get_tree().create_timer(2.0), "timeout")
	get_tree().change_scene("res://Level/Main Menu.tscn")
