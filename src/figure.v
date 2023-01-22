module vplotlib

// import gg
import gx
import ui

pub interface Plot {
	x_lim []f32
	y_lim []f32
	draw(ui.DrawDevice, &ui.CanvasLayout, &SubFigure)
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
struct SubFigure {
mut:
	plots []Plot

	title      string
	x_lim      []f32
	y_lim      []f32
	pad_x      f32
	pad_y      f32
	axis_pad_x f32
	axis_pad_y f32
}

[heap]
struct Figure {
mut:
	window  &ui.Window
	subfigs []SubFigure

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
	mut children := []ui.Widget{}
	if params.rows == 1 && params.cols == 1 {
		children << ui.canvas_layout(
			id: 'canvas_0_0'
			width: params.width / params.cols
			height: params.height / params.rows
			on_draw: fig.draw
		)
	} else {
		for i := 0; i < fig.rows; i++ {
			mut row_children := []ui.Widget{}
			for j := 0; j < fig.cols; j++ {
				row_children << ui.canvas_layout(
					id: 'canvas_${i}_${j}'
					width: params.width / params.cols
					height: params.height / params.rows
					on_draw: fig.draw
				)
			}
			children << ui.row(
				id: 'row_${i}'
				widths: get_fraction(fig.cols)
				children: row_children
			)
		}
	}
	fig.window = ui.window(
		width: params.width
		height: params.height
		title: params.title
		mode: .resizable
		children: [
			ui.column(
				id: 'main_col'
				heights: get_fraction(fig.rows)
				children: children
			),
		]
	)
	t_subfig := SubFigure{
		pad_x: params.pad_x
		pad_y: params.pad_y
		axis_pad_x: params.axis_pad_x
		axis_pad_y: params.axis_pad_y
	}
	fig.subfigs = []SubFigure{len: fig.rows * fig.cols, init: t_subfig}
	return fig
}

pub struct AddParams {
	i     int
	j     int
	plots []Plot
}

pub fn (mut fig Figure) add(params AddParams) {
	// clean/update global plotoptions here
	idx := params.i * fig.rows + params.j
	for plot in params.plots {
		fig.subfigs[idx].plots << plot
		fig.subfigs[idx].update_lims(plot.x_lim, plot.y_lim)
	}
}

pub fn (fig &Figure) show() {
	ui.run(fig.window)
}

fn (fig &Figure) draw(d ui.DrawDevice, c &ui.CanvasLayout) {
	x_c := c.width * fig.axis_pad_x
	y_c := c.height * fig.axis_pad_y
	w := c.width * (1 - 2 * fig.axis_pad_x)
	h := c.height * (1 - 2 * fig.axis_pad_y)
	c.draw_device_rect_empty(d, x_c, y_c, w, h, gx.black)

	// ctx.draw_text_def(int(x_c + w / 2), int(y_c/2), fig.title)
	s_id := c.id.split('_')
	idx := s_id[1].int() * fig.rows + s_id[2].int()
	s_fig := fig.subfigs[idx]
	for plot in s_fig.plots {
		plot.draw(d, c, s_fig)
	}
}

fn (mut fig SubFigure) update_lims(x_lim []f32, y_lim []f32) {
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

fn (fig SubFigure) norm_xy(x f32, y f32, w f32, h f32) (f32, f32) {
	mut n_x := (x - fig.x_lim[0]) / (fig.x_lim[1] - fig.x_lim[0])
	mut n_y := (y - fig.y_lim[0]) / (fig.y_lim[1] - fig.y_lim[0])
	n_x = fig.pad_x * w + (w - 2 * fig.pad_x * w) * n_x
	n_y = h - fig.pad_y * h + (2 * fig.pad_y * h - h) * n_y
	return n_x, n_y
}
