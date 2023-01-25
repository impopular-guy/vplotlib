module vplotlib

// import gg
import gx
import ui

const (
	lim_frac = 0.02
)

pub interface Plot {
	x_lim []f32
	y_lim []f32
	draw(ui.DrawDevice, &ui.CanvasLayout, &SubFigure)
}

pub struct FigureParams {
mut:
	height int = 600
	width  int = 600
	title  string
	// padding for graph from window border. Should be a value between 0 and 1
	pad_x f32 = 0.1
	pad_y f32 = 0.1
	// for subplot
	rows int = 1
	cols int = 1
}

// the struct names are subject to change
struct SubFigure {
mut:
	plots []Plot
	xaxis Axis = Axis{
		pos: .horizontal
	}
	yaxis Axis = Axis{
		pos: .vertical
	}

	title  string
	xlabel string
	ylabel string

	x_lim   []f32
	y_lim   []f32
	x_lim_p []f32
	y_lim_p []f32

	pad_x      f32 = 0.1
	pad_y      f32 = 0.1
	title_pad  f32 = 0.05
	xlabel_pad f32 = 0.05
	ylabel_pad f32 = 0.05
}

[heap]
struct Figure {
mut:
	window  &ui.Window
	subfigs []SubFigure

	height int
	width  int
	title  string
	pad_x  f32
	pad_y  f32
	rows   int
	cols   int
}

fn validate_figure_params(p FigureParams) {
	if p.pad_x < 0 || p.pad_x > 1 {
		panic('`pad_x` should be a f32 between 0 and 1')
	}
	if p.pad_y < 0 || p.pad_y > 1 {
		panic('`pad_y` should be a f32 between 0 and 1')
	}
	if p.rows < 1 || p.rows > 10 {
		panic('`rows` should be an int between 1 and 10 inclusive')
	}
	if p.cols < 1 || p.cols > 10 {
		panic('`cols` should be an int between 1 and 10 inclusive')
	}
}

pub fn figure(params FigureParams) &Figure {
	validate_figure_params(params)
	mut fig := &Figure{
		window: 0
		height: params.height
		width: params.width
		title: params.title
		pad_x: params.pad_x
		pad_y: params.pad_y
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
		title: 'vplotlib'
		mode: .resizable
		children: [
			ui.column(
				id: 'main_col'
				heights: get_fraction(fig.rows)
				children: children
			),
		]
	)
	fig.subfigs = []SubFigure{len: fig.rows * fig.cols}
	return fig
}

pub struct AddParams {
	i     int
	j     int
	plots []Plot

	title  string
	xlabel string
	ylabel string
}

fn validate_add_params(p AddParams, rows int, cols int) {
	if p.i < 0 || p.i >= rows {
		panic('`i` must be between 0 and fig.rows-1')
	}
	if p.j < 0 || p.j >= cols {
		panic('`j` must be between 0 and fig.cols-1')
	}
}

pub fn (mut fig Figure) add(params AddParams) {
	validate_add_params(params, fig.rows, fig.cols)
	// clean/update global plotoptions here
	idx := params.i * fig.rows + params.j
	for plot in params.plots {
		fig.subfigs[idx].plots << plot
		fig.subfigs[idx].update_lims(plot.x_lim, plot.y_lim)
	}
	fig.subfigs[idx].title = params.title
	fig.subfigs[idx].xlabel = params.xlabel
	fig.subfigs[idx].ylabel = params.ylabel
}

// Order of drawing:
// - grid lines if any
// - plots
// - rect box
// - axis ticks
// - labels and titles if any
// - legend if any
fn (fig &Figure) draw(d ui.DrawDevice, c &ui.CanvasLayout) {
	// ctx.draw_text_def(int(x_c + w / 2), int(y_c/2), fig.title)
	s_id := c.id.split('_')
	idx := s_id[1].int() * fig.rows + s_id[2].int()
	s_fig := fig.subfigs[idx]
	for plot in s_fig.plots {
		plot.draw(d, c, s_fig)
	}

	x_c := c.width * fig.pad_x
	y_c := c.height * fig.pad_y
	w := c.width * (1 - 2 * fig.pad_x)
	h := c.height * (1 - 2 * fig.pad_y)
	c.draw_device_rect_empty(d, x_c, y_c, w, h, gx.black)

	s_fig.xaxis.draw_ticks(d, c, x_c, y_c + h, w, 0)
	s_fig.yaxis.draw_ticks(d, c, x_c, y_c + h, 0, -h)

	if s_fig.title.len != 0 {
		t_pad := s_fig.title_pad * c.height
		c.draw_device_styled_text(d, int(x_c + w / 2), int(y_c - t_pad), s_fig.title,
			ui.TextStyleParams{
			size: 22
			align: .center
			vertical_align: .top
		})
	}
	if s_fig.xlabel.len != 0 {
		xl_pad := s_fig.xlabel_pad * c.height
		c.draw_device_styled_text(d, int(x_c + w / 2), int(y_c + h + xl_pad), s_fig.xlabel,
			ui.TextStyleParams{
			size: 18
			align: .center
			vertical_align: .top
		})
	}
	if s_fig.ylabel.len != 0 {
		yl_pad := s_fig.ylabel_pad * c.width
		c.draw_device_styled_text(d, int(x_c - yl_pad), int(y_c + h / 2), s_fig.ylabel,
			ui.TextStyleParams{
			size: 18
			align: .right
			vertical_align: .middle
		})
	}
}

fn (mut fig SubFigure) update_lims(x_lim []f32, y_lim []f32) {
	if fig.x_lim.len == 0 {
		fig.x_lim = x_lim
		fig.y_lim = y_lim
		// return
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
	// TODO: temp fix for now
	fig.x_lim_p = fig.x_lim
	dx := fig.x_lim[1] - fig.x_lim[0]
	fig.x_lim_p[0] = fig.x_lim[0] - dx * vplotlib.lim_frac
	fig.x_lim_p[1] = fig.x_lim[1] + dx * vplotlib.lim_frac

	fig.y_lim_p = fig.y_lim
	dy := fig.y_lim[1] - fig.y_lim[0]
	fig.y_lim_p[0] = fig.y_lim[0] - dy * vplotlib.lim_frac
	fig.y_lim_p[1] = fig.y_lim[1] + dy * vplotlib.lim_frac
}

fn (fig SubFigure) norm_xy(x f32, y f32, w f32, h f32) (f32, f32) {
	mut n_x := (x - fig.x_lim_p[0]) / (fig.x_lim_p[1] - fig.x_lim_p[0])
	mut n_y := (y - fig.y_lim_p[0]) / (fig.y_lim_p[1] - fig.y_lim_p[0])
	n_x = fig.pad_x * w + (w - 2 * fig.pad_x * w) * n_x
	n_y = h - fig.pad_y * h + (2 * fig.pad_y * h - h) * n_y
	return n_x, n_y
}

fn (mut fig Figure) update_axes() {
	for mut s_fig in fig.subfigs {
		s_fig.xaxis.update_lim_ticks(s_fig.x_lim_p)
		s_fig.yaxis.update_lim_ticks(s_fig.y_lim_p)
	}
}

pub fn (mut fig Figure) show() {
	fig.update_axes()
	ui.run(fig.window)
}

pub fn (mut fig Figure) save_figure(filename string) {
	f_type := filename.split('.').last()
	match f_type {
		// png feature is very bad as of now
		// 'png' { fig.window.png_screenshot(filename) }
		'svg' { fig.window.svg_screenshot(filename) }
		else { panic("Save file type can be only 'png' or 'svg'. png is disabled as it is very bad as of now.") }
	}
}
