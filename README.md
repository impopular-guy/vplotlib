# VPlotLib

2D Plotting library for V, inspired by Python's `matplotlib`

### Quick example:

```v
import vplotlib as vpl
import gx

fn main() {
	x, x1, y, y1, s := ... // inputs

	mut fig := vpl.new_figure(rows: 1)!
	fig.plot([
		vpl.line(x: x1, y: y1),
		vpl.line(x: x, y: y, color: gx.green, line_type: .dashed),
		vpl.scatter(x: x, y: y, s: s, color: gx.red),
		vpl.scatter(x: x1, y: y1, s: s, color: gx.cyan, marker: .square),
	])!
	fig.set_title('Hello Plot')
	fig.set_xlabel('x-axis')
	fig.set_ylabel('y-axis')
	fig.show()
}
```
![Screenshot](docs/assets/hello_plot.png)


#### Sub Plots Example

```v
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
```
![Screenshot_20230125_221604](docs/assets/subplot.png)


### How It Works ?
![flowchart](docs/flowchart.svg)

### CONTRIBUTING

#### To Add a new plot

Suppose anybody wants to add a new type of plot i.e. `violin` plot, then do the following:
- Add a new file `src/violin.v`. Ideally this is the only file that needs to be added/edited.
- This file must contain the following:
  1. A struct that implements `interface Plot`. The struct need not be public. The name of struct should be like `ViolinPlot`
  2. A public function with same name as the plot and returns `ViolinPlot`, i.e. `pub fn violin(ViolinParams) ViolinPlot`. This function will be used by end-user. This function should contain any preprecessing logic that is required.
  3. A pub struct like `ViolinParams` that helps taking inputs and setting default values required by the plot.
  4. Finally a private function that contains actual logic to draw the plot. i.e. `fn (plot &ViolinPlot) draw(ctx &gg.Context, sfig &SubFigure)`
- Add an example for the new plot in `examples/` and test it.
- Ideally this should be enough and no other files needs to be touched.

### Plots TODO

|        |             |            |
|--------|-------------|------------|
| line ✅ | scatter ✅   | histogram  |
| bar    | starckedbar | groupedbar |
| box    | stem        | heatmap    |
| pie    | polar       | logaxis    |
