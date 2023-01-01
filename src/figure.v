module vplotlib

import gg
import gx
import ui

interface Plot {
	x_lim []f32
	y_lim []f32
	draw(&gg.Context, &Figure)
}

pub struct FigureParams {
mut:
	height int    = 600
	width  int    = 600
	title  string = 'Plot'
	// axes limits
	x_lim []f32
	y_lim []f32
	// padding for graph from window border. Should be a value between 0 and 1
	pad_x f32 = 0.12
	pad_y f32 = 0.12
	// padding for axis from win border. [0,1]
	axis_pad_x f32 = 0.1
	axis_pad_y f32 = 0.1
	// for subplot
	rows int = 1
	cols int = 1
}

// the struct names are subject to change
[heap]
struct Figure {
mut:
	window &ui.Window
	plots  []Plot

	height     int
	width      int
	title      string
	x_lim      []f32
	y_lim      []f32
	pad_x      f32
	pad_y      f32
	axis_pad_x f32
	axis_pad_y f32
	rows       int
	cols       int
}

pub fn figure(params FigureParams) &Figure {
	mut fig := &Figure{
		window: 0
		height: params.height
		width: params.width
		title: params.title
		x_lim: params.x_lim
		y_lim: params.y_lim
		pad_x: params.pad_x
		pad_y: params.pad_y
		axis_pad_x: params.axis_pad_x
		axis_pad_y: params.axis_pad_y
		rows: params.rows
		cols: params.cols
	}
	fig.window = ui.window(
		width: params.width
		height: params.height
		title: params.title
		mode: .resizable
		children: [
			ui.canvas(
				id: 'canvas1'
				width: params.width
				height: params.height
				draw_fn: fig.draw
			),
		]
	)
	return fig
}

pub struct AddParams {
	i     int
	j     int
	plots []Plot
}

pub fn (mut fig Figure) add(params AddParams) {
	// clean/update global plotoptions here
	for plot in params.plots {
		fig.plots << plot
		fig.update_lims(plot.x_lim, plot.y_lim)
	}
}

pub fn (fig &Figure) show() {
	ui.run(fig.window)
}

fn (fig &Figure) draw(ctx &gg.Context, c &ui.Canvas) {
	x_c := fig.width * fig.axis_pad_x
	y_c := fig.height * fig.axis_pad_y
	w := fig.width * (1 - 2 * fig.axis_pad_x)
	h := fig.height * (1 - 2 * fig.axis_pad_y)
	ctx.draw_rect_empty(x_c, y_c, w, h, gx.black)

	// ctx.draw_text_def(int(x_c + w / 2), int(y_c/2), fig.title)
	for plot in fig.plots {
		plot.draw(ctx, fig)
	}
}

// fn on_resize(window &Window, w int, h int) {
// 	fig.width = w
// 	fig.height = h
// }

fn (mut fig Figure) update_lims(x_lim []f32, y_lim []f32) {
	if fig.x_lim.len == 0 {
		fig.x_lim = x_lim
		fig.y_lim = y_lim
		return
	}
	if x_lim[0] < fig.x_lim[0] {
		fig.x_lim[0] = x_lim[0]
	}
	if x_lim[1] > fig.x_lim[1] {
		fig.x_lim[1] = x_lim[1]
	}
	if y_lim[0] < fig.y_lim[0] {
		fig.y_lim[0] = y_lim[0]
	}
	if y_lim[1] > fig.y_lim[1] {
		fig.y_lim[1] = y_lim[1]
	}
}

fn (fig Figure) norm_x(x f32) f32 {
	n_x := (x - fig.x_lim[0]) / (fig.x_lim[1] - fig.x_lim[0])
	return fig.pad_x * fig.width + (fig.width - 2 * fig.pad_x * fig.width) * n_x
}

fn (fig Figure) norm_y(y f32) f32 {
	n_y := (y - fig.y_lim[0]) / (fig.y_lim[1] - fig.y_lim[0])
	return fig.height - fig.pad_y * fig.height + (2 * fig.pad_y * fig.height - fig.height) * n_y
}