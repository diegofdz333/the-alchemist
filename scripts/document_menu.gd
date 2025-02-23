extends Area2D

signal expand_button_pressed()

## number of rows for placing docs
@export var rows: int = 5 
## number of columns for placing docs
@export var cols: int = 2 
## proportion of height and width of a grid cell that should be empty (so there's spacing between docs).
## smaller = bigger images in the menu
@export var margin: float = 0.3
## proportion of the screen occupied by retracted menu
@export var peek: float = 0.07 
## proportion of the screen occupied by expanded menu
@export var full: float = 0.3

const DOCUMENT_MENU_Z: int = 50
var retracted_pos: Vector2 = Vector2.ZERO
var expanded_pos: Vector2 = Vector2.ZERO
var width: int = 0
var height: int = 0
var expanded: bool = false

var documents: Dictionary = {}
var occupied: Dictionary = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	position_menu()
	for r in range(rows):
		for c in range(cols):
			occupied[Vector2(r, c)] = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func position_menu():
	var viewport_width = get_viewport().size.x
	width = $Sprite2D.texture.get_width()
	height = $Sprite2D.texture.get_height()
	retracted_pos = Vector2(-viewport_width / 2 - width / 2 + peek * viewport_width, 0)
	expanded_pos = Vector2(-viewport_width / 2 - width / 2 + full * viewport_width, 0)
	position = retracted_pos
	z_index = DOCUMENT_MENU_Z


func pos_in_menu(pos):
	var right = expanded_pos.x + width / 2
	var top = expanded_pos.y - height / 2
	var bottom = expanded_pos.y + height / 2
	return pos.x < right and pos.y > top and pos.y < bottom


func update_documents():
	for doc in documents:
		if expanded:
			doc.show()
			doc.set_process_input(true)
		else:
			doc.hide()
			doc.set_process_input(false)


func _on_documents_dropped(doc):
	if expanded:
		doc.in_menu = pos_in_menu(doc.position) and doc.z_index > DOCUMENT_MENU_Z
		if doc in documents and not doc.in_menu:
			# doc moved out of menu
			doc.reload_texture();
			occupied[documents[doc]] = false
			documents.erase(doc)
		elif doc not in documents and doc.in_menu:
			# doc moved into menu
			doc.texture = doc.small_texture
			rescale(doc)
			reposition(doc)
			doc.is_selected = false;
		elif doc in documents and doc.in_menu:
			# doc already in menu but dragged somewhere else within
			occupied[documents[doc]] = false
			reposition(doc)


# Rescale doc to fit a grid cell in the menu
func rescale(doc):
	var col_width = (expanded_pos.x + width / 2 + get_viewport().size.x / 2) / cols
	var row_height = height / rows
	var rect = doc.get_rect()
	var sprite_width = rect.size.x
	var sprite_height = rect.size.y
	var x_scale = (1 - margin) * col_width / sprite_width
	var y_scale = (1 - margin) * row_height / sprite_height
	doc.scale = Vector2(min(x_scale, y_scale), min(x_scale, y_scale))


# Snap a doc to a grid cell in the menu
func reposition(doc):
	var col_width = (expanded_pos.x + width / 2 + get_viewport().size.x / 2) / cols
	var row_height = height / rows
	var top_left = Vector2(-get_viewport().size.x / 2, -height / 2)
	
	for r in range(rows):
		for c in range(cols):
			if not occupied[Vector2(r, c)]:
				var x_pos = col_width * (c + 0.5)
				var y_pos = row_height * (r + 0.5)
				doc.position = top_left + Vector2(x_pos, y_pos)
				documents[doc] = Vector2(r, c)
				occupied[documents[doc]] = true
				return


func _on_expand_button_pressed():
	expand_button_pressed.emit()
	expanded = not expanded
	update_documents()
