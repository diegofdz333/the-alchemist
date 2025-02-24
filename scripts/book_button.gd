extends Control

func _ready():
	change_selected(false)
	

func change_selected(is_selected):
	if is_selected:
		show();
	else:
		hide();
