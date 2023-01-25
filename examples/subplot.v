module main

import vplotlib as vpl
import gx
import rand

fn main() {
	mut x := []int{}
	mut x1 := []int{}
	mut y := []int{}
	mut y1 := []int{}
	mut s := []f32{}
	for i in 0 .. 10 {
		x << i
		x1 << i + 5
		y << rand.intn(20) or { 0 }
		y1 << rand.intn(20) or { 0 }
		s << rand.f32() * 18 + 6
	}

	vpl.l_info('MAIN START')

	mut fig := vpl.figure(rows: 2, cols: 2, title: 'Subplot Example')
	fig.add(i: 0, j: 0, plots: [vpl.line(x: x1, y: y1)])
	fig.add(i: 0, j: 1, plots: [vpl.line(x: x, y: y, color: gx.green, line_type: .dashed)])
	fig.add(i: 1, j: 0, plots: [vpl.scatter(x: x, y: y, s: s, color: gx.red)])
	fig.add(
		i: 1
		j: 1
		plots: [
			vpl.scatter(x: x1, y: y1, s: s, color: gx.cyan, marker: .square),
		]
	)
	fig.show()

	vpl.l_info('MAIN END')
}
