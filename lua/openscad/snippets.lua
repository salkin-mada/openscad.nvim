-- Snippets for luasnip
local function prequire(...)
	local status, lib = pcall(require, ...)
	if (status) then return lib end
	return nil
end

local ls = prequire('luasnip')
-- local cmp = prequire("cmp")
local s = ls.snippet
-- local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
-- local f = ls.function_node
local c = ls.choice_node
-- local d = ls.dynamic_node
-- local l = require("luasnip.extras").lambda
-- local r = require("luasnip.extras").rep
-- local p = require("luasnip.extras").partial
-- local m = require("luasnip.extras").match
-- local n = require("luasnip.extras").nonempty
-- local dl = require("luasnip.extras").dynamic_lambda
-- local fmt = require("luasnip.extras.fmt").fmt
-- local fmta = require("luasnip.extras.fmt").fmta
-- local types = require("luasnip.util.types")
-- local conds = require("luasnip.extras.expand_conditions")

local scad_snippets = {

	s("var",  {i(1,"var"), t("="), i(2,"value"), t(";")}),
	s("function", {t("function "), i(1,"name"), t("("), i(2,"x=1"), t(") = "), i(3,"x * 2"), t(";")}),
	s("module", {t("module "), i(1,"name"), t("("), i(2,"x=1"), t({") {", ""}), i(3,"x * 2"), t({"", "}"})}),
	s("circle",{ t("circle("), c(1,{t("radius"), t("d")}), t(","), t(")")}),
	s("square",{ t("square("), i(1,"size"), t(","),i(2,"center"), t(")")}),
	s("square",{ t("square("), t("["),i(1,"width"), t(","),i(2,"height"), t("]"), t(","),i(3,"center"), t(")")}),
	s("polygon",{ t("polygon("), t("["),i(1,"points"),t("]"), t(")")}),
	s("polygon",{ t("polygon("), t("["),i(1,"points"),t("]"), t(","),t("["),i(2,"paths"), t("]"), t(")")}),
	s("text",{ t("text("), i(1,"t"), t(","),i(2,"size"), t(","),i(3,"font"), t(","), i(4,"halign"), t(","),i(5,"valign"), t(","),i(6,"spacing"), t(","), i(7,"direction"), t(","),i(8,"language"), t(","),i(9,"script"), t(")")}),
	s("sphere",{ t("sphere("), c(1,{t("radius"), t("d")}), t(")")}),
	s("cube",{ t("cube("), i(1,"size"), t(","),i(2,"center"), t(")")}),
	s("cube",{ t("cube("), t("["),i(1,"width"), t(","),i(2,"depth"), t(","),i(3,"height"), t("]"),t(","),i(4,"center"), t(")")}),
	s("cylinder",{ t("cylinder("), i(1,"h"), t(","),c(2,{t("r"), t("d")}), t(","),i(3,"center"), t(")")}),
	s("cylinder",{ t("cylinder("), i(1,"h"),c(2,{t("r1"), t("d1")}), t(","),c(3,{t("r1"), t("d2")}), t(","),i(4,"center"), t(")")}),
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
	s("color",{ t("color("), t("["),i(1,"r"),t(","), i(2,"g"), t(","),i(3,"b"),t(","),i(4,"a"), t("]"), t(")")}),
	s("offset",{ t("offset("), c(1,{t("r"), t("delta")}),t(","), i(2,"chamfer"), t(")")}),
	s("hull",{ t("hull("), t(")")}),
	s("minkowski",{ t("minkowski(1,"), t(")")}),
	s("abs", t("abs")),
	s("sign", t("sign")),
	s("sin", t("sin")),
	s("cos", t("cos")),
	s("tan", t("tan")),
	s("acos", t("acos")),
	s("asin", t("asin")),
	s("atan", t("atan")),
	s("atan2", t("atan2")),
	s("floor", t("floor")),
	s("round", t("round")),
	s("ceil", t("ceil")),
	s("ln", t("ln")),
	s("len", t("len")),
	s("log", t("log")),
	s("pow", t("pow")),
	s("sqrt", t("sqrt")),
	s("exp", t("exp")),
	s("rands", t("rands")),
	s("min", t("min")),
	s("max", t("max")),
	s("concat", t("concat")),
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
}

--[[
--
TODO:

/* Other */
let(…)
echo(…)

if (…) { … }
import("….stl")
linear_extrude(height,center,convexity,twist,slices)
rotate_extrude(angle,convexity)
surface(file = "….dat",center,convexit
projection(cut)
render(convexity)
children([idx])
assign() // deprecated

/* List Comprehensions */
Generate [ for (i = range|list) i ]
Conditions [ for (i = …) if (condition(i)) i ]
Assignments [ for (i = …) let (assignments) a ]

/* Special variables */
$fa 		// minimum angle
$fs 		// minimum size
$fn 		// number of fragments
$t 			// animation step
$vpr 		// viewport rotation angles in degrees
$vpt 		// viewport translation
$vpd 		// viewport camera distance
$children 	// number of module children
$parent_modules // number of modules in the instantiation stack

--]]
--

return scad_snippets
