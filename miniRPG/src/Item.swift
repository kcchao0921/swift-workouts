//protocol is like interface
protocol Item {
	var name: String {get}
}

class Weapon: Item {
	let name: String
	let strength: Int

	init(name: String, strength: Int) {
		self.strength = strength
		self.name = name
	}
}
