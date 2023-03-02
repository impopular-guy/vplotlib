module vplotlib

import gg
import gx

[heap]
struct Figure {
mut:
	ctx     &gg.Context = unsafe { nil }
	subfigs []SubFigure

	height     int
	width      int
	rows       int
	cols       int
	is_subplot bool
}

pub struct FigureParams {
mut:
	height int = 800
	width  int = 800
	rows   int = 1
	cols   int = 1
}

pub fn new_figure(params FigureParams) !&Figure {
	debug_info('NEW FIGURE')
	if params.rows < 1 || params.rows > 10 {
		return error('`rows` should be an int between 1 and 10 inclusive')
	}
	if params.cols < 1 || params.cols > 10 {
		return error('`cols` should be an int between 1 and 10 inclusive')
	}

	mut fig := &Figure{
		height: params.height
		width: params.width
		rows: params.rows
		cols: params.cols
	}
	mut subfigs := []SubFigure{}
	if params.rows == 1 && params.cols == 1 {
		subfigs << SubFigure{
			width: params.width
			height: params.height
		}
	} else {
		fig.is_subplot = true
		w := int(fig.width / fig.cols)
		h := int(fig.height / fig.rows)
		for i := 0; i < params.rows; i++ {
			for j := 0; j < params.cols; j++ {
				subfigs << SubFigure{
					pos_i: i
					pos_j: j
					offset_x: f32(w * j)
					offset_y: f32(h * i)
					width: w
					height: h
				}
			}
		}
	}
	fig.ctx = gg.new_context(
		bg_color: gx.white
		width: params.width
		height: params.height
		create_window: true
		resizable: true
		ui_mode: true
		window_title: 'vplotlib'
		frame_fn: draw
		resized_fn: on_resize
		user_data: fig
	)
	fig.subfigs = subfigs
	return fig
}

pub fn (mut fig Figure) plot(plots []Plot) ! {
	fig.check_for_subplot(false, 'subplot')!
	for plot in plots {
		fig.subfigs[0].plots << plot
		fig.subfigs[0].update_lims(plot.x_lim, plot.y_lim)
	}
}

fn (fig &Figure) check_for_subplot(subplot bool, fn_name string) ! {
	if subplot && !fig.is_subplot {
		return error('Use `fig.${fn_name}` method for figure with single plot.')
	} else if !subplot && fig.is_subplot {
		return error('Use `fig.${fn_name}` method for figure with subplots.')
	}
}

fn validate_rowcols(i int, j int, rows int, cols int) ! {
	if i < 0 || i >= rows {
		return error('`row` must be between 0 and ${rows - 1}, inclusive.')
	}
	if j < 0 || j >= cols {
		return error('`col` must be between 0 and ${cols - 1}, inclusive.')
	}
}

pub fn (mut fig Figure) subplot(i int, j int, plots []Plot) ! {
	fig.check_for_subplot(true, 'plot')!
	validate_rowcols(i, j, fig.rows, fig.cols)!
	idx := i * fig.rows + j
	for plot in plots {
		fig.subfigs[idx].plots << plot
		fig.subfigs[idx].update_lims(plot.x_lim, plot.y_lim)
	}
}

pub fn (mut fig Figure) set_xlabel(label string) {
	fig.subfigs[0].xlabel = label
}

pub fn (mut fig Figure) set_ylabel(label string) {
	fig.subfigs[0].ylabel = label
}

pub fn (mut fig Figure) set_title(title string) {
	fig.subfigs[0].title = title
}

// TODO
pub fn (mut fig Figure) legend(labels []string) {
	// if labels empty, then use plotlabels if they exist
	// if labels given, override plotlabels
	// this is for only single plot
}

pub struct Attribute {
	title  string
	xlabel string
	ylabel string
}

// TODO set attribute methods for subplots will be merged into one func
// legend labels are also passed
pub fn (mut fig Figure) set_attributes(i int, j int, param Attribute) ! {
	validate_rowcols(i, j, fig.rows, fig.cols)!
	idx := i * fig.rows + j
	fig.subfigs[idx].title = param.title
	fig.subfigs[idx].xlabel = param.xlabel
	fig.subfigs[idx].ylabel = param.ylabel
}

fn (mut fig Figure) update_axes() {
	for mut s_fig in fig.subfigs {
		s_fig.xaxis.update_lim_ticks(s_fig.x_lim_p)
		s_fig.yaxis.update_lim_ticks(s_fig.y_lim_p)
	}
}

pub fn (mut fig Figure) show() {
	debug_info('SHOW')
	fig.update_axes()
	fig.ctx.run()
}

fn draw(fig &Figure) {
	fig.ctx.begin()
	for subfig in fig.subfigs {
		subfig.draw(fig.ctx)
	}
	fig.ctx.end()
}

fn on_resize(e &gg.Event, mut fig Figure) {
	debug_info('RESIZE ${e.window_width} ${e.window_height}')
	fig.width = e.window_width
	fig.height = e.window_height
	if fig.rows == 1 && fig.cols == 1 {
		fig.subfigs[0].height = fig.height
		fig.subfigs[0].width = fig.width
	} else {
		w := int(fig.width / fig.cols)
		h := int(fig.height / fig.rows)
		for i := 0; i < fig.rows; i++ {
			for j := 0; j < fig.cols; j++ {
				idx := i * fig.rows + j
				fig.subfigs[idx].offset_x = f32(w * j)
				fig.subfigs[idx].offset_y = f32(h * i)
				fig.subfigs[idx].width = w
				fig.subfigs[idx].height = h
			}
		}
	}
}

// TODO
pub fn (fig &Figure) save(filename string) {
}
