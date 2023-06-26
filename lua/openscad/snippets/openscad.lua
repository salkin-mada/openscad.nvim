-- -- Snippets for luasnip
local function prequire(...)
	local status, lib = pcall(require, ...)
	if (status) then return lib end
	return nil
end
local ls = prequire('luasnip')
local s = ls.snippet
local ps = ls.parser.parse_snippet
local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
-- local f = ls.function_node
local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node
-- local events = require("luasnip.util.events")
-- local ai = require("luasnip.nodes.absolute_indexer")
return {
	s("var",  {i(1,"var"), t("="), i(2,"value"), t(";")}),
	s("function", {t("function "), i(1,"name"), t("("), i(2,"x=1"), t(") = "), i(3,"x * 2"), t(";")}),
	s("module", {t("module "), i(1,"name"), t("("), i(2,"x=1"), t({") {", ""}), i(3,"x * 2"), t({"", "}"})}),
	s("circle",{ t("circle("), c(1,{t("radius"), t("d")}), t(","), t(")")}),
	s("square",{ t("square("), i(1,"size"), t(","),i(2,"center"), t(")")}),
	s("square_",{ t("square("), t("["),i(1,"width"), t(","),i(2,"height"), t("]"), t(","),i(3,"center"), t(")")}),
	s("polygon",{ t("polygon("), t("["),i(1,"points"),t("]"), t(")")}),
	s("polygon_",{ t("polygon("), t("["),i(1,"points"),t("]"), t(","),t("["),i(2,"paths"), t("]"), t(")")}),
	s("text",{ t("text("), i(1,"t"), t(","),i(2,"size"), t(","),i(3,"font"), t(","), i(4,"halign"), t(","),i(5,"valign"), t(","),i(6,"spacing"), t(","), i(7,"direction"), t(","),i(8,"language"), t(","),i(9,"script"), t(")")}),
	s("sphere",{ t("sphere("), c(1,{t("radius"), t("d")}), t(")")}),
	s("cube",{ t("cube("), i(1,"size"), t(","),i(2,"center"), t(")")}),
	s("cube",{ t("cube("), t("["),i(1,"width"), t(","),i(2,"depth"), t(","),i(3,"height"), t("]"),t(","),i(4,"center"), t(")")}),
	s("cylinder",{ t("cylinder("), i(1,"h"), t(","),c(2,{t("r"), t("d")}), t(","),i(3,"center"), t(")")}),
	s("cylinder_",{ t("cylinder("), i(1,"h"),c(2,{t("r1"), t("d1")}), t(","),c(3,{t("r1"), t("d2")}), t(","),i(4,"center"), t(")")}),
	s("polyhedron",{ t("polyhedron("), i(1,"points"), t(","),i(2,"triangles"), t(","),i(3,"convexity"), t(")")}),
	s("union",{ t("union("), t(")")}),
	s("difference",{ t("difference("), t(")")}),
	s("intersection",{ t("intersection("), t(")")}),
	s("assert",{ t("assert("), i(1,"condition"), i(2,"string"), t(")")}),
	s("translate",{ t("translate("), t("["),i(1,"x"), t(","),i(2,"y"), t(","),i(3,"z"), t("]"), t(")")}),
	s("rotate",{ t("rotate("), t("["),i(1,"x"), t(","),i(2,"y"), t(","),i(3,"z"), t("]"), t(")")}),
	s("scale",{ t("scale("), t("["),i(1,"x"), t(","),i(2,"y"), t(","),i(3,"z"), t("]"), t(")")}),
	s("resize",{ t("resize("), t("["),i(1,"x"), t(","),i(2,"y"), t(","),i(3,"z"), t("]"),t(","),i(4,"auto"), t(")")}),
	s("mirror",{ t("mirror("), t("["),i(1,"x"), t(","),i(2,"y"), t(","),i(3,"z"), t("]"),t(")")}),
	s("multmatrix",{ t("multmatrix("), i(1,"m"), t(")")}),
	s("color",{ t("color("), i(1,"colorname"), t(")")}),
	s("color_",{ t("color("), t("["),i(1,"r"),t(","), i(2,"g"), t(","),i(3,"b"),t(","),i(4,"a"), t("]"), t(")")}),
	s("offset",{ t("offset("), c(1,{t("r"), t("delta")}),t(","), i(2,"chamfer"), t(")")}),
	s("hull",{ t("hull("), t(")")}),
	s("minkowski",{ t("minkowski(1,"), t(")")}),
	s({trig="abs", dscr="\\*\\* Mathematical Operator \\*\\*"}, t("abs")),
	s({trig="sign", dscr="\\*\\* Mathematical Operator \\*\\*"}, t("sign")),
	s({trig="sin", dscr="\\*\\* Mathematical Operator \\*\\*"}, t("sin")),
	s({trig="cos", dscr="\\*\\* Mathematical Operator \\*\\*"}, t("cos")),
	s({trig="tan", dscr="\\*\\* Mathematical Operator \\*\\*"}, t("tan")),
	s({trig="acos", dscr="\\*\\* Mathematical Operator \\*\\*"}, t("acos")),
	s({trig="asin", dscr="\\*\\* Mathematical Operator \\*\\*"}, t("asin")),
	s({trig="atan", dscr="\\*\\* Mathematical Operator \\*\\*"}, t("atan")),
	s({trig="atan2", dscr="\\*\\* Mathematical Operator \\*\\*"}, t("atan2")),
	s({trig="floor", dscr="\\*\\* Mathematical Operator \\*\\*"}, t("floor")),
	s({trig="round", dscr="\\*\\* Mathematical Operator \\*\\*"}, t("round")),
	s({trig="ceil", dscr="\\*\\* Mathematical Operator \\*\\*"}, t("ceil")),
	s({trig="ln", dscr="\\*\\* Mathematical Operator \\*\\*"}, t("ln")),
	s({trig="len", dscr="\\*\\* Mathematical Operator \\*\\*"}, t("len")),
	s({trig="log", dscr="\\*\\* Mathematical Operator \\*\\*"}, t("log")),
	s({trig="pow", dscr="\\*\\* Mathematical Operator \\*\\*"}, t("pow")),
	s({trig="sqrt", dscr="\\*\\* Mathematical Operator \\*\\*"}, t("sqrt")),
	s({trig="exp", dscr="\\*\\* Mathematical Operator \\*\\*"}, t("exp")),
	s({trig="rands", dscr="\\*\\* Mathematical Operator \\*\\*"}, t("rands")),
	s({trig="min", dscr="\\*\\* Mathematical Operator \\*\\*"}, t("min")),
	s({trig="max", dscr="\\*\\* Mathematical Operator \\*\\*"}, t("max")),
	s({trig="concat", dscr={"Concatenate:", "Return a new vector that is the result of appending the elements of the supplied vectors."}}, t("concat")),
	s("lookup", t("lookup")),
	s("str", t("str")),
	s("chr", t("chr")),
	s("ord", t("ord")),
	s("search", t("search")),
	s("version", t("version")),
	s("version_num", t("version_num")),
	s("norm", t("norm")),
	s("cross", t("cross")),
	s("include", {t("include"), t("<"), i(1,"filename"), t(".scad"), t(">")}) ,
	s("use", {t("use"), t("<"), i(1,"filename"), t(".scad"), t(">")}),

	s("for", {
		t("for ("),
		i(1, "i"), t("="),
		t("["),
		i(2, "0"),
		t(":"),
		i(3, "10"),
		t({"]){", ""}),
		i(4, ""),
		t({"", "}"})
	}),

	s("intersection_for", {
		t("intersection_for ("),
		i(1, "i"), t("="),
		t("["),
		i(2, "0"),
		t(":"),
		i(3, "10"),
		t({"]){", ""}),
		i(4, ""),
		t({"", "}"})
	}),

	s({trig="linear_extrude", dscr={"Linear Extrude", "Linear Extrusion is a operation that takes a 2D object as input and generates a 3D object as a result."}}, {
		t("linear_extrude(height="),
		i(1, "10"), t(", "),
		t("center="),
		i(2, "true"), t(", "),
		t("convexity="),
		i(3, "10"), t(", "),
		t("twist="),
		i(4, "360"), t(", "),
        c(5, {
            sn("slices", {
                t("slices="),
                i(1, "100")
            }),
            sn("$fn", {
                t("$fn="),
                i(1, "100")
            })
        }),
        t(")")
	}),

	s({trig="rotate_extrude", dscr={"Rotate Extrude", "Rotational extrusion spins a 2D shape around the Z-axis to form a solid which has rotational symmetry."}}, {
		t("angle="),
		i(1, "360"), t(", "),
		t("convexity = "),
		i(2, "2"),
        t(")")
	}),

    ps({trig="$fa", dscr={"\\*\\* Special Variable \\*\\*", "minimum angle"}}, "$fa=$1"),
    ps({trig="$fs", dscr={"\\*\\* Special Variable \\*\\*", "minimum size"}}, "$fs=$1"),
    ps({trig="$fn", dscr={"\\*\\* Special Variable \\*\\*", "number of fragments"}}, "$fn=$1"),
    ps({trig="$t", dscr={"\\*\\* Special Variable \\*\\*", "animation step"}}, "$t=$1"),
    ps({trig="$vpr", dscr={"\\*\\* Special Variable \\*\\*", "viewport rotation angles in degrees"}}, "$vpr=$1"),
    ps({trig="$vpt", dscr={"\\*\\* Special Variable \\*\\*", "viewport translation"}}, "$vpt=$1"),
    ps({trig="$vpd", dscr={"\\*\\* Special Variable \\*\\*", "viewport camera distance"}}, "$vpd=$1"),
    ps({trig="$children", dscr={"\\*\\* Special Variable \\*\\*", "number of module children"}}, "$children=$1"),
    ps({trig="$parent_modules", dscr={"\\*\\* Special Variable \\*\\*", "number of modules in the instantiation stack"}}, "$parent_modules=$1"),

	s({trig="supershape", dscr={"\\*\\* Supershape \\*\\*", "The 2D supershape equation is an extension of the general ellipse equation. The equation uses polar coordinates, radius and theta in this script."}}, {
        t({"//a and b are real numbers but not 0",""}),
        t("a ="), i(1,"1"), t({";",""}),
        t("b ="), i(2,"1"), t({";",""}),
        t({"//m = 0 returns a circle.",""}),
        t("m ="), i(3,"5"), t({";",""}),
        t("n1 ="), i(4,"1.02"), t({";",""}),
        t("n2 ="), i(5,"1.6"), t({";",""}),
        t("n3 ="), i(6,"1.7"), t({";",""}),
        t("radius ="), i(7,"30"), t({";",""}),
        t({
            "//range_multiplier integer larger than 0 but mostly 1",
            "//larger that 1 extends angle theta",
            "//for some shapes theta needs to be extended to 12pi (ext = 6)",
            ""
        }),
        t("range_multiplier ="), i(8,"1"), t({";",""}),
        t({
            "//equation of the 2D supershape results in 1/r for a given theta",
            "//(polar coordinates)",
            "function superformula(theta) = pow(pow(abs(1 / a * cos(m/4*theta)),n2)+ pow(abs(1 / a * sin(m/4*theta)),n3), 1 / n1);",
            "//function calculates supershape function for a number of angles,",
            "//using x = r cos(theta) and y = r sin(theta),",
            "//and returns the x and y coordinates in a list",
            "function supershape(range_multiplier) = [for (theta = [0:1:360 * range_multiplier]) [radius/superformula(theta) * cos(theta), radius/superformula(theta) * sin(theta)] ];",
            "//draw the x,y coordinates calculates in the function super",
            "echo(supershape(range_multiplier));",
            "polygon(supershape(range_multiplier));"
        })
    })
}

-- TODO(salkin, anyone): finish adding dscr to all snippets
-- TODO(anyone): include the following in the snippets, s() or ps() style
--[[

/* Other */
let(…)
echo(…)

if (…) { … }
import("….stl")
surface(file = "….dat",center,convexit
projection(cut)
render(convexity)
children([idx])
assign() // deprecated

/* List Comprehensions */
Generate [ for (i = range|list) i ]
Conditions [ for (i = …) if (condition(i)) i ]
Assignments [ for (i = …) let (assignments) a ]

--]]
