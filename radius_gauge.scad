/*

Copyright 2022 Michael Pilat

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/

// use lots of facets when rendering for a quality gauge
$fn = $preview ? 30 : 120;

function label(radius, denominator, units) =
    str(radius, (denominator != 1 ? str("/", denominator) : ""), " ", units);

function toMM(v, units) =
    units == "mm" ? v : v * 25.4;

units = "mm"; // [mm, in]
radius = 5; //[::non-negative float] gauge radius
radiusDenominator = 1; // gauge radius denominator (intended for fractional inches)
width = 25; //[::non-negative float] width of the guage arms
length = 50; //[::non-negative float] length of the guage arms
thickness = 3; //[::non-negative float] thickness of the gauge
emboss = 1; //[::non-negative float] text embossing depth
fontSize = 8; // font size

module radiusGauge (
    radiusNumerator = 5, // gauge radius
    radiusDenominator = 1, // fractional denominator
    widthInUnit = 25, // width of the guage arms
    lengthInUnit = 50, // length of the guage arms
    thicknessInUnit = 3, // thickness of the gauge
    embossInUnit = 1, // text embossing depth
    fontSize = 8, // font size
    units = "mm"
) {
    assert(units=="mm" || units == "in", "units must be 'mm' or 'in'")

    let (
            radius = toMM(radiusNumerator / radiusDenominator, units),
            width = toMM(widthInUnit, units),
            length = toMM(lengthInUnit, units),
            thickness = toMM(thicknessInUnit, units),
            emboss = toMM(embossInUnit, units)
        ) {
        assert(2*radius < width, "Diameter of gauge size is bigger than the width of the gauge!");
        difference() {
            linear_extrude(thickness) {
                union() {
                    // inside corner
                    translate([radius, radius]) {
                        circle(r=radius);
                    }

                    // inside semicircle
                    translate([length, width/2]) {
                        circle(r=radius);
                    }

                    // one arm with outside semicircle on end
                    translate([0, radius]) {
                        difference() {
                          square([width, length-radius], false);
                          translate([width/2, length-radius]) {
                              circle(r=radius);
                          }
                      }
                    }

                    // other arm with inside semicircle on end
                    translate([radius, 0]) {
                        square([length-radius, width], false);
                    }

                    // outside corner between arms
                    translate([width, width]) {
                        difference() {
                            square([radius, radius], false);
                            translate([radius, radius]) {
                                circle(r=radius);
                            }
                        }
                    }
                }
            }

            translate([length/2, width/2, thickness-emboss]) {
                linear_extrude(emboss+.001) {
                    text(label(radiusNumerator, radiusDenominator, units),
                        font="Helvetica:style=Bold",
                        size=fontSize,
                        halign="center",
                        valign="center");
                }
            }
        }
    }
}

radiusGauge(radiusNumerator=5, radiusDenominator=1, lengthInUnit=50, widthInUnit=25, thicknessInUnit=2, embossInUnit=0.5, units="mm");
