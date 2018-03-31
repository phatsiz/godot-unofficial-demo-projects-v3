extends Node

const NumSprites = 6
const NumRows = 9
const NumColumns = 9

enum State { Idle, Empty, Filling, Dropping, Deleting }

class Cell:
	var row
	var column
	var index
	var state
	
	func _init(r, c, i):
		row = r
		column = c
		index = i
		state = State.Idle
		
class Level:
	var cells = []
	
	func _init():
		for row in range(NumRows):
			var rowData = []
			for column in range(NumColumns):
				rowData.append(null)
			cells.append(rowData)
			
		for row in range(NumRows):
			for column in range(NumColumns):
				var pos = getCellPosition(row, column)
				var cell = Cell.new(row, column, -1)
				setCellAtRowColumn(row, column, cell)
	
	static func getCellPosition(r, c):
		return Vector2(c * 32 + 32, r * 36 + 130)
			
	func getCellAtRowColumn(r, c):
		return cells[c][r]
	
	func setCellAtRowColumn(r, c, cell):
		cells[c][r] = cell
		cell.row = r
		cell.column = c
		cell.index = -1
		cell.state = State.Empty
		
	func fillLevel():
		for row in range(NumRows):
			for column in range(NumColumns):
				var cell = getCellAtRowColumn(row, column)
				if cell.state == State.Empty:
					var index = randi() % NumSprites
					cell.index = index
					cell.state = State.Filling
				
	func scanForHorizontalMatch(cell):
		var row = cell.row
		var column = cell.column + 1
		var index = cell.index
		var count = 1
		while(column < NumColumns):
			var c = cells[row][column]
			if c.index != index:
				return count
			count = count + 1
			column = column + 1
		return count
		
	func scanForVerticalMatch(cell):
		return 0
		
	func markForDeleteHorizontal(r, c, count):
		for index in range(count):
			var cell = cells[r][c + index]
			cell.index = -1
			cell.state = State.Deleting
			
	func markForDeleteVertical(r, c, count):
		for index in range(count):
			var cell = cells[r + index][c]
			cell.index = -1
			cell.state = State.Deleting
							
	func scanForMatch():
		for row in range(NumRows):
			for column in range(NumColumns - 3):
				var cell = cells[row][column]
				var count = scanForHorizontalMatch(cell)
				if count >= 3:
					markForDeleteHorizontal(row, column, count)
		
		for row in range(NumRows - 3):
			for column in range(NumColumns):
				var cell = cells[row][column]
				var count = scanForVerticalMatch(cell)
				if count >= 3:
					markForDeleteVertical(row, column, count)
