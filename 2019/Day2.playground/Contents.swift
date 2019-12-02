import Cocoa

func execute(_ ints: inout [Int]) {
	var pc = 0

	while ints[pc] != 99 {
		switch ints[pc] {
		case 1:
			let lhsPtr = ints[pc + 1]
			let rhsPtr = ints[pc + 2]
			let resultPtr = ints[pc + 3]
			pc += 4
			ints[resultPtr] = ints[lhsPtr] + ints[rhsPtr]
			break;

		case 2:
			let lhsPtr = ints[pc + 1]
			let rhsPtr = ints[pc + 2]
			let resultPtr = ints[pc + 3]
			pc += 4
			ints[resultPtr] = ints[lhsPtr] * ints[rhsPtr]
			break;

		default:
			assert(false, "Invalid opcode \(ints[pc])")
		}
	}
}

do {
	//var ints = [1,1,1,4,99,5,6,0,99]
	var ints = [1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,10,1,19,1,19,5,23,1,23,9,27,2,27,6,31,1,31,6,35,2,35,9,39,1,6,39,43,2,10,43,47,1,47,9,51,1,51,6,55,1,55,6,59,2,59,10,63,1,6,63,67,2,6,67,71,1,71,5,75,2,13,75,79,1,10,79,83,1,5,83,87,2,87,10,91,1,5,91,95,2,95,6,99,1,99,6,103,2,103,6,107,2,107,9,111,1,111,5,115,1,115,6,119,2,6,119,123,1,5,123,127,1,127,13,131,1,2,131,135,1,135,10,0,99,2,14,0,0]
	ints[1] = 12
	ints[2] = 2
	execute(&ints)
	print("Result (part 1): \(ints[0])")
}

do {
	for noun in 0...99 {
		for verb in 0...99 {
			var ints = [1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,10,1,19,1,19,5,23,1,23,9,27,2,27,6,31,1,31,6,35,2,35,9,39,1,6,39,43,2,10,43,47,1,47,9,51,1,51,6,55,1,55,6,59,2,59,10,63,1,6,63,67,2,6,67,71,1,71,5,75,2,13,75,79,1,10,79,83,1,5,83,87,2,87,10,91,1,5,91,95,2,95,6,99,1,99,6,103,2,103,6,107,2,107,9,111,1,111,5,115,1,115,6,119,2,6,119,123,1,5,123,127,1,127,13,131,1,2,131,135,1,135,10,0,99,2,14,0,0]
			ints[1] = noun
			ints[2] = verb
			execute(&ints)
			if ints[0] == 19690720 {
				print("Result (part 2): noun = \(noun), verb = \(verb), result = \(100 * noun + verb)")
			}
		}
	}
}
