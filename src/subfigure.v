module vplotlib

import gg
import gx

const (
	lim_frac = 0.02
)

pub interface Plot {
	x_lim []f32
	y_lim []f32
	draw(&gg.Context, &SubFigure)
}

// the struct names are subject to change
struct SubFigure {
	pos_i int
	pos_j int
mut:
	offset_x f32 // not a fraction
	offset_y f32
	height   int
	width    int

	plots       []Plot
	plot_labels []string
	title       string

	xaxis Axis = Axis{
		pos: .horizontal
	}
	yaxis Axis = Axis{
		pos: .vertical
	}
	xlabel  string
	ylabel  string
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

// Order of drawing:
// - grid lines if any
// - plots
// - rect box
// - axis ticks
// - labels and titles if any
// - legend if any
fn (sfig &SubFigure) draw(ctx &gg.Context) {
	// ctx.draw_text_def(int(x_c + w / 2), int(y_c/2), fig.title)
	for plot in sfig.plots {
		plot.draw(ctx, sfig)
	}

	x_c := sfig.width * sfig.pad_x
	y_c := sfig.height * sfig.pad_y
	w := sfig.width * (1 - 2 * sfig.pad_x)
	h := sfig.height * (1 - 2 * sfig.pad_y)
	ctx.draw_rect_empty(sfig.offset_x + x_c, sfig.offset_y + y_c, w, h, gx.black)

	sfig.xaxis.draw_ticks(ctx, sfig, sfig.offset_x + x_c, sfig.offset_y + y_c + h, w,
		0)
	sfig.yaxis.draw_ticks(ctx, sfig, sfig.offset_x + x_c, sfig.offset_y + y_c + h, 0,
		-h)

	if sfig.title.len != 0 {
		t_pad := sfig.title_pad * sfig.height
		ctx.draw_text(int(sfig.offset_x + x_c + w / 2), int(sfig.offset_y + y_c - t_pad),
			sfig.title, gx.TextCfg{
			size: 22
			align: .center
			vertical_align: .top
		})
	}
	if sfig.xlabel.len != 0 {
		xl_pad := sfig.xlabel_pad * sfig.height
		ctx.draw_text(int(sfig.offset_x + x_c + w / 2), int(sfig.offset_y + y_c + h + xl_pad),
			sfig.xlabel, gx.TextCfg{
			size: 18
			align: .center
			vertical_align: .top
		})
	}
	if sfig.ylabel.len != 0 {
		yl_pad := sfig.ylabel_pad * sfig.width
		ctx.draw_text(int(sfig.offset_x + x_c - yl_pad), int(sfig.offset_y + y_c + h / 2),
			sfig.ylabel, gx.TextCfg{
			size: 18
			align: .right
			vertical_align: .middle
		})
	}
}

fn (mut sfig SubFigure) update_lims(x_lim []f32, y_lim []f32) {
	if sfig.x_lim.len == 0 {
		sfig.x_lim = x_lim
		sfig.y_lim = y_lim

		// return
	}
	if x_lim[0] < sfig.x_lim[0] {
		sfig.x_lim[0] = x_lim[0]
	}
	if x_lim[1] > sfig.x_lim[1] {
		sfig.x_lim[1] = x_lim[1]
	}
	if y_lim[0] < sfig.y_lim[0] {
		sfig.y_lim[0] = y_lim[0]
	}
	if y_lim[1] > sfig.y_lim[1] {
		sfig.y_lim[1] = y_lim[1]
	}

	// TODO: temp fix for now
	sfig.x_lim_p = sfig.x_lim
	dx := sfig.x_lim[1] - sfig.x_lim[0]
	sfig.x_lim_p[0] = sfig.x_lim[0] - dx * vplotlib.lim_frac
	sfig.x_lim_p[1] = sfig.x_lim[1] + dx * vplotlib.lim_frac

	sfig.y_lim_p = sfig.y_lim
	dy := sfig.y_lim[1] - sfig.y_lim[0]
	sfig.y_lim_p[0] = sfig.y_lim[0] - dy * vplotlib.lim_frac
	sfig.y_lim_p[1] = sfig.y_lim[1] + dy * vplotlib.lim_frac
}

fn (sfig SubFigure) norm_xy(x f32, y f32, w f32, h f32) (f32, f32) {
	mut n_x := (x - sfig.x_lim_p[0]) / (sfig.x_lim_p[1] - sfig.x_lim_p[0])
	mut n_y := (y - sfig.y_lim_p[0]) / (sfig.y_lim_p[1] - sfig.y_lim_p[0])
	n_x = sfig.pad_x * w + (w - 2 * sfig.pad_x * w) * n_x
	n_y = h - sfig.pad_y * h + (2 * sfig.pad_y * h - h) * n_y
	return n_x, n_y
}
