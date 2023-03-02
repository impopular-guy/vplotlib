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

	mut fig := vpl.new_figure(rows: 1)!
	fig.plot([
		vpl.line(x: x1, y: y1),
		vpl.line(x: x, y: y, color: gx.green, line_type: .dashed),
		vpl.scatter(x: x, y: y, s: s, color: gx.red),
		vpl.scatter(x: x1, y: y1, s: s, color: gx.cyan, marker: .square),
	])!
	fig.title('Hello Plot')
	fig.xlabel('x-axis')
	fig.ylabel('y-axis')
	fig.show()
}
