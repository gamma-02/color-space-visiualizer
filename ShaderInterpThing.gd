extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.get_active_material(0).set_shader_parameter("rgb_lab_interp", 0.0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_h_slider_value_changed(value: float) -> void:
	#print_debug(value)
	var material : ShaderMaterial = self.get_active_material(0)
	
	#print_debug(material.get_shader_parameter("rgb_lab_interp"))
	material.set_shader_parameter("rgb_lab_interp", value)
	
	pass # Replace with function body.


var m1Held : bool = false;

var sensitivity : float = .005;
var scrollSensitivity : float = 0.01;

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mButtonEvent = event as InputEventMouseButton;
		
		if (mButtonEvent.button_index == 1) :
			m1Held = mButtonEvent.pressed;
		elif(mButtonEvent.button_index == MOUSE_BUTTON_WHEEL_UP):
			self.rotate_x(PI * scrollSensitivity);
		elif(mButtonEvent.button_index == MOUSE_BUTTON_WHEEL_DOWN):
			self.rotate_x(-PI * scrollSensitivity);
		
		
	elif event is InputEventMouseMotion && m1Held && (event as InputEventMouse).position:
		var mmoveEvent = event as InputEventMouseMotion;
		self.rotate_object_local(Vector3.UP, mmoveEvent.relative.x * sensitivity);
		self.rotate_x( mmoveEvent.relative.y * sensitivity )
	
	pass
	
	
	
	
	
	
	
	
	
	
	
