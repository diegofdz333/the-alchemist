extends "res://scripts/document.gd"

signal page_changed(doc)

const MIN_PAGE = 0;
const MAX_PAGE = 3;
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
		var buttons = get_children();
		for button in buttons:
			button.change_selected(is_selected);

func get_text():
	var full_text = text.split("@Page")[page]
	return full_text.lstrip(" \n").rstrip(" \n");

func reload_texture():
	change_page(page);
	scale = big_texture_scale;
	

func change_page(page_):
	if page_ <= MAX_PAGE and page_ >= MIN_PAGE:
		page = page_;
		page_changed.emit(self);
		if page == 0:
			texture = load("res://assets/documents/book-page-0.png");
		elif page == 1:
			texture = load("res://assets/documents/book-page-1.png");
		elif page == 2:
			texture = load("res://assets/documents/book-page-2.png");
		elif page == 3:
			texture = load("res://assets/documents/book-page-4.png");


func _on_right_button_button_down():
	change_page(page + 1)


func _on_left_button_button_down():
	change_page(page - 1)
