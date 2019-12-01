import Cocoa

// Part 1

let path = Bundle.main.url(forResource: "Day1", withExtension: "txt")!
let data = (try! String(contentsOf: path)).split(separator: "\n").map({ Int($0)! })

func fuelRequired(_ mass: Int) -> Int {
	mass / 3 - 2
}

let sumPart1 = data.map(fuelRequired).reduce(0, { $0 + $1 })
print("Sum: \(sumPart1)")


// Part 2

func allFuelRequired(_ mass: Int) -> Int {
	let massFuel = fuelRequired(mass)

	if massFuel <= 0 {
		return 0
	}

	let fuelFuel = allFuelRequired(massFuel)
	return fuelFuel + massFuel
}

let sumPart2 = data.map(allFuelRequired).reduce(0, { $0 + $1 })
print("Sum (part2): \(sumPart2)")
