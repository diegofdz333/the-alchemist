extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_document_menu_expand_button_pressed():
	if $DocumentMenu.expanded:
		print("debug")
		$DocumentMenu.position = $DocumentMenu.retracted_pos;
	else:
		$DocumentMenu.position = $DocumentMenu.expanded_pos;
