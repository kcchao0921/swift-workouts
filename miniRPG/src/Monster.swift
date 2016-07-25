class Monster: Character {
	override init(_ name: String, hp: Int, strength: Int, _ weapon: Weapon! = nil) {
		super.init(name, hp: hp, strength: strength, weapon)
		print("\(name) showed up.")
	}

	deinit {
		print("\(name) is dead.")
	}

	override func attackedBy(_ attacker: Character) -> Int {
		let lostHp = super.attackedBy(attacker)
		if lostHp > 0 {
			print("\(name) is bleeding and lost \(lostHp) hp.")
		}

		return lostHp
	}
}
