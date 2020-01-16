extends MeshInstance

class_name DisplayedItem

var _spin_speed_x: float
var _spin_speed_y: float

func _ready():
	_spin_speed_x = 0.0
	_spin_speed_y = 0.0

func _process(delta):
	if _spin_speed_x != 0.0:
		rotate_x(_spin_speed_x * delta)
	
	if _spin_speed_y != 0.0:
		rotate_y(_spin_speed_y * delta)

func add_spin_speed_x(delta_x: float) -> void:
	_spin_speed_x += delta_x

func add_spin_speed_y(delta_y: float) -> void:
	_spin_speed_y += delta_y

func is_spinning() -> bool:
	return (_spin_speed_x != 0.0 or _spin_speed_y != 0.0)

func stop_spinning() -> void:
	_spin_speed_x = 0.0
	_spin_speed_y = 0.0
