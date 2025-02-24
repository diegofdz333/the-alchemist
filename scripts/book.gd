extends "res://scripts/document.gd"

@export var pages: Array[String] = []

signal page_changed(doc)

var page = 0
var prev_is_selected = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	page = 0
	super()


func _process(delta):
	super(delta)
	if is_selected != prev_is_selected:
		prev_is_selected = is_selected;
		var children = get_children();
		for child in children:
			if child is Button:
				child.change_selected(is_selected);
			else:
				if not is_selected:
					child.release_focus();
				child.change_selected(page > 0);


func get_text():
	var full_text = text.split("@Page")[page]
	return full_text.lstrip(" \n").rstrip(" \n");


func reload_texture():
	change_page(page);
	scale = big_texture_scale;



func change_page(page_):
	if page_ < pages.size() and page_ >= 0:
		page = page_;
		page_changed.emit(self);
		texture = load(pages[page])
		var children = get_children();
		for child in children:
			if child is Button:
				child.change_selected(is_selected);
			else:
				child.change_selected(page > 0);


func _on_right_button_button_down():
	change_page(page + 1)


func _on_left_button_button_down():
	change_page(page - 1)
