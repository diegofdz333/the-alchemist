extends Node

const DOCUMENT_Z = 0; # Lowest document z value

var document_ordering: Array = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	var documents = get_children();
	for i in range(0, documents.size()):
		var doc = documents[i];
		document_ordering.push_back(doc);
	refresh_z_indeces();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in range(0, document_ordering.size()):
		var doc = document_ordering[i];
		if doc.process_dragging(delta):
			# Document is being dragged
			document_ordering.pop_at(i);
			document_ordering.push_front(doc);
			refresh_z_indeces();
			break
	pass

# Set z index of all documents based on document ordering
func refresh_z_indeces():
	var max_z = document_ordering.size()
	for i in range(0, max_z):
		# Higher z index is closer to screen
		var doc: Sprite2D = document_ordering[i];
		doc.z_index = DOCUMENT_Z + max_z - i - 1;
