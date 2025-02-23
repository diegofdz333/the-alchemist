extends Node

signal dropped(doc)
signal selected_document_changed(new_doc)

const DOCUMENT_Z = 0; # Lowest document z value

var document_ordering: Array = [];
var selected_document = null;
var plants_dragging: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	var documents = get_children();
	for i in range(0, documents.size()):
		var doc = documents[i];
		doc.release.connect(_on_document_release)
		document_ordering.push_back(doc);
	refresh_z_indeces();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Process document selection
	var selected_doc_exists = false;
	for i in range(0, document_ordering.size()):
		var doc = document_ordering[i];
		if doc.is_selected:
			# Document was clicked
			selected_doc_exists = true;
			if selected_document != doc:
				selected_document = doc;
				selected_document_changed.emit(doc)
				document_ordering.pop_at(i);
				document_ordering.push_front(doc);
				refresh_z_indeces();
			break
	if !selected_doc_exists and selected_document != null:
		selected_document = null;
		selected_document_changed.emit(null)
	
	# Process document dragging
	if plants_dragging:
		return
		
	for i in range(0, document_ordering.size()):
		var doc = document_ordering[i];
		if doc.process_dragging(delta):
			# Document is being dragged
			document_ordering.pop_at(i);
			document_ordering.push_front(doc);
			refresh_z_indeces();
			break
	refresh_z_indeces();


# Set z index of all documents based on document ordering
func refresh_z_indeces():
	var max_z = document_ordering.size()
	for i in range(0, max_z):
		# Higher z index is closer to screen
		var doc: Sprite2D = document_ordering[i];
		doc.z_index = DOCUMENT_Z + max_z - i - 1;
		if doc.in_menu or (i == 0 and doc.is_dragging):
			doc.z_index += ($"../DocumentMenu".DOCUMENT_MENU_Z + 1)


func _on_document_release(doc):
	dropped.emit(doc)


func _on_book_page_changed(doc):
	if doc.is_selected:
		selected_document_changed.emit(doc);


func _on_plants_dragging():
	plants_dragging = true


func _on_cauldron_dropped(cauldron):
	plants_dragging = false


func _on_plant_dropped(plant):
	plants_dragging = false
