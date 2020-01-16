extends Spatial

const CAMERA_OFFSET = Vector3(0.0, 0.5, 1.5)
const SPIN_ACCELERATION = 2.0
const TIME_TO_MOVE = 0.5

enum DisplayStatus {
	DISPLAYING,
	MOVING
}

var _camera: Camera
var _displayed_items: Spatial
var _item_info_label: Label

var _status: int
var _item_index: int
var _time_to_move: float
var _move_time_count: float
var _move_start_pos: Vector3
var _move_end_pos: Vector3
var _do_update_text: bool

func _ready():
	_camera = get_node("camera")
	_displayed_items = get_node("displayed_items")
	_item_info_label = get_node("item_info_label")
	
	_start_moving(0, 0.0)
	_process_moving(0.0)

func _process(delta):
	match _status:
		DisplayStatus.DISPLAYING:
			_process_displaying(delta)
		
		DisplayStatus.MOVING:
			_process_moving(delta)

func _process_displaying(delta: float) -> void:
	var items_count: int = _displayed_items.get_child_count()
	var current_item: DisplayedItem = _displayed_items.get_child(_item_index)
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	elif Input.is_action_just_pressed("ui_page_down"):
		_start_moving((_item_index + 1) % items_count, TIME_TO_MOVE)
	
	elif Input.is_action_just_pressed("ui_page_up"):
		_start_moving((_item_index + items_count - 1) % items_count, TIME_TO_MOVE)
	
	elif Input.is_action_just_pressed("ui_home"):
		_start_moving(0, TIME_TO_MOVE)
	
	elif Input.is_action_just_pressed("ui_end"):
		_start_moving(items_count - 1, TIME_TO_MOVE)
	
	elif Input.is_action_just_pressed("ui_accept"):
		if current_item.is_spinning():
			current_item.stop_spinning()
		else:
			current_item.rotation_degrees = Vector3.ZERO
	else:
		if Input.is_action_pressed("ui_right"):
			current_item.add_spin_speed_y(SPIN_ACCELERATION * delta)
		
		if Input.is_action_pressed("ui_left"):
			current_item.add_spin_speed_y(-SPIN_ACCELERATION * delta)
		
		if Input.is_action_pressed("ui_up"):
			current_item.add_spin_speed_x(-SPIN_ACCELERATION * delta)
		
		if Input.is_action_pressed("ui_down"):
			current_item.add_spin_speed_x(SPIN_ACCELERATION * delta)

func _process_moving(delta: float) -> void:
	_move_time_count += delta
	var move_rate: float
	var label_alpha: float
	
	var rate: float = (_move_time_count / _time_to_move) if (_time_to_move > 0.0) else 1.0
	if rate >= 1.0:
		move_rate = 1.0
		label_alpha = 1.0
		_status = DisplayStatus.DISPLAYING
	else:
		# Bicubic interpolation
		move_rate = 3 * rate * rate - 2 * rate * rate * rate
		label_alpha = (1.0 - 2 * rate) if (rate < 0.5) else (2 * (rate - 0.5))
	
	_camera.translation = _move_start_pos * (1.0 - move_rate) + _move_end_pos * move_rate
	_camera.look_at(_camera.translation - CAMERA_OFFSET, Vector3.UP)
	
	if _do_update_text and rate >= 0.5:
		var item: DisplayedItem = _displayed_items.get_child(_item_index)
		var script_name: String = item.get_script().resource_path
		script_name = script_name.right(script_name.find_last("/") + 1)
		
		_item_info_label.set_text(script_name)
		_do_update_text = false
	_item_info_label.modulate = Color(1.0, 1.0, 1.0, label_alpha)

func _start_moving(target_item_index: int, time_to_move: float) -> void:
	_time_to_move = time_to_move
	_move_time_count = 0.0
	_move_start_pos = _camera.translation
	_move_end_pos = _displayed_items.get_child(target_item_index).translation + CAMERA_OFFSET
	_do_update_text = true
	
	_status = DisplayStatus.MOVING
	_item_index = target_item_index
