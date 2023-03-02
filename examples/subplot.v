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
	for i in 0 .. 50 {
		x << i
		x1 << i + 5
		y << rand.intn(20) or { 0 }
		y1 << rand.intn(20) or { 0 }
		s << rand.f32() * 18 + 6
	}

	mut fig := vpl.new_figure(rows: 2, cols: 2)!
	fig.subplot(0, 0, [vpl.line(x: x1, y: y1)])!
	fig.subplot(0, 1, [vpl.line(x: x, y: y, color: gx.green, line_type: .dashed)])!
	fig.subplot(1, 0, [vpl.scatter(x: x, y: y, s: s, color: gx.red)])!
	fig.subplot(1, 1, [vpl.scatter(x: x1, y: y1, s: s, color: gx.cyan, marker: .square)])!

	fig.set_attributes(0, 0, title: 'SubPlot00', xlabel: 'x-axis', ylabel: 'y-axis')!
	fig.set_attributes(0, 1, title: 'SubPlot01', xlabel: 'x-axis', ylabel: 'y-axis')!
	fig.set_attributes(1, 0, title: 'SubPlot10', xlabel: 'x-axis', ylabel: 'y-axis')!
	fig.set_attributes(1, 1, title: 'SubPlot11', xlabel: 'x-axis', ylabel: 'y-axis')!

	fig.show()
}
