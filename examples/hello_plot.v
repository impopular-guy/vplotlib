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
		s << rand.f32() * 10 + 5
	}

	vpl.l_info('MAIN START')

	mut fig := vpl.new_figure(title: 'Multiple Plots')
	fig.scatter(vpl.ScatterParams[int]{ x: x, y: y, s: s, color: gx.red })
	// fig.line(x1, y1, mut vpl.PlotOptions{})
	// fig.line(x, y, mut vpl.PlotOptions{ line_color: gx.red, line_type: .dashed })
	fig.show()

	vpl.l_info('MAIN END')
}
