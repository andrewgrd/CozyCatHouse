extends Node2D

const COLS = 9
const ROWS = 9
const GEM_SIZE = 64
const GEM_TYPES = 6

var grid = []
var selected = Vector2i(-1, -1)
var swipe_start = Vector2(-1, -1)

var gem_colors = [
	Color.RED,
	Color.BLUE,
	Color.GREEN,
	Color.YELLOW,
	Color.PURPLE,
	Color.ORANGE
]

func _ready():
	_create_grid()
	queue_redraw()

func _create_grid():
	for row in ROWS:
		grid.append([])
		for col in COLS:
			var gem_type = randi() % GEM_TYPES
			grid[row].append(gem_type)

func _draw():
	for row in ROWS:
		for col in COLS:
			if grid[row][col] == -1:
				continue  # пустая ячейка — не рисуем
			var color = gem_colors[grid[row][col]]
			var pos = Vector2(col * GEM_SIZE, row * GEM_SIZE)
			draw_rect(Rect2(pos + Vector2(4, 4), Vector2(GEM_SIZE - 8, GEM_SIZE - 8)), color)
			if selected == Vector2i(row, col):
				draw_rect(Rect2(pos + Vector2(2, 2), Vector2(GEM_SIZE - 4, GEM_SIZE - 4)), Color.WHITE, false, 3)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		swipe_start = event.position
		var col = int(event.position.x / GEM_SIZE)
		var row = int(event.position.y / GEM_SIZE)
		if _in_bounds(row, col):
			selected = Vector2i(row, col)
		queue_redraw()

	if event is InputEventMouseButton and not event.pressed:
		if selected == Vector2i(-1, -1):
			return
		var swipe = event.position - swipe_start
		var target = _get_swipe_target(selected, swipe)
		if target != Vector2i(-1, -1):
			_swap(selected, target)
			var matches = _find_matches()
			if matches.is_empty():
				_swap(selected, target)
			else:
				# Цепные реакции — повторяем пока есть матчи
				while not matches.is_empty():
					_remove_matches(matches)
					_apply_gravity()
					_fill_empty()
					matches = _find_matches()
		selected = Vector2i(-1, -1)
		swipe_start = Vector2(-1, -1)
		queue_redraw()

func _get_swipe_target(from: Vector2i, swipe: Vector2) -> Vector2i:
	if swipe.length() < 20:
		return Vector2i(-1, -1)
	var target: Vector2i
	if abs(swipe.x) > abs(swipe.y):
		target = Vector2i(from.x, from.y + 1) if swipe.x > 0 else Vector2i(from.x, from.y - 1)
	else:
		target = Vector2i(from.x + 1, from.y) if swipe.y > 0 else Vector2i(from.x - 1, from.y)
	if _in_bounds(target.x, target.y):
		return target
	return Vector2i(-1, -1)

func _in_bounds(row: int, col: int) -> bool:
	return row >= 0 and row < ROWS and col >= 0 and col < COLS

func _swap(a: Vector2i, b: Vector2i):
	var tmp = grid[a.x][a.y]
	grid[a.x][a.y] = grid[b.x][b.y]
	grid[b.x][b.y] = tmp

# Находим все совпадения на поле
func _find_matches() -> Array:
	var matched = {}  # словарь ячеек которые нужно убрать

	# Проверяем горизонталь
	for row in ROWS:
		for col in range(COLS - 2):
			var t = grid[row][col]
			if t == -1:
				continue
			if t == grid[row][col+1] and t == grid[row][col+2]:
				matched[Vector2i(row, col)] = true
				matched[Vector2i(row, col+1)] = true
				matched[Vector2i(row, col+2)] = true

	# Проверяем вертикаль
	for col in COLS:
		for row in range(ROWS - 2):
			var t = grid[row][col]
			if t == -1:
				continue
			if t == grid[row+1][col] and t == grid[row+2][col]:
				matched[Vector2i(row, col)] = true
				matched[Vector2i(row+1, col)] = true
				matched[Vector2i(row+2, col)] = true

	return matched.keys()

# Убираем найденные фишки (ставим -1)
func _remove_matches(matches: Array):
	for cell in matches:
		grid[cell.x][cell.y] = -1
	EventBus.gems_matched.emit(matches.size())

# Гравитация — фишки падают вниз
func _apply_gravity():
	for col in COLS:
		var empty_row = ROWS - 1
		for row in range(ROWS - 1, -1, -1):
			if grid[row][col] != -1:
				grid[empty_row][col] = grid[row][col]
				if empty_row != row:
					grid[row][col] = -1
				empty_row -= 1

# Заполняем пустые ячейки сверху новыми фишками
func _fill_empty():
	for row in ROWS:
		for col in COLS:
			if grid[row][col] == -1:
				grid[row][col] = randi() % GEM_TYPES
