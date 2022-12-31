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
		y << rand.int()
		y1 << rand.int()
		s << rand.f32() * 18 + 6
	}

	vpl.l_info('MAIN START')

	mut fig := vpl.new_figure(title: 'Multiple Plots')
	fig.line(vpl.LineParams[int]{ x: x1, y: y1 })
	fig.line(vpl.LineParams[int]{ x: x, y: y, color: gx.green, line_type: .dashed })
	fig.scatter(vpl.ScatterParams[int]{ x: x, y: y, s: s, color: gx.red })
	fig.scatter(vpl.ScatterParams[int]{ x: x1, y: y1, s: s, color: gx.cyan, marker: .square })
	fig.show()

	vpl.l_info('MAIN END')
}
