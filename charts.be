#can3 => graph temperatuur & HYGRO
can3_style=canvas_style

can3=lv.canvas(scr)
can3.set_pos(0,35)
can3.set_size(320,400)
can3.add_flag(lv.OBJ_FLAG_HIDDEN)
can3.add_style(can3_style, lv.PART_MAIN | lv.STATE_DEFAULT)

temp_chart=lv.chart(can3)
temp_chart.set_size(250, 400)
temp_chart.set_type(lv.CHART_TYPE_LINE)
temp_chart.set_point_count(96)
temp_chart.set_range(lv.CHART_AXIS_PRIMARY_Y,-20,40)
temp_chart.set_range(lv.CHART_AXIS_SECONDARY_Y,20,80)
temp_chart.set_div_line_count(7, 24)    #7= 20% - 80%; -20 - 40C; 16 - 28; 15 - 33
temp_chart.set_axis_tick(lv.CHART_AXIS_PRIMARY_Y, 1, 0, 7, 3, true, 40)
temp_chart.set_axis_tick(lv.CHART_AXIS_SECONDARY_Y, 2, 0, 7, 3, true, 40)
temp_chart.set_style_bg_color(lv.color(0x000000), lv.PART_MAIN | lv.STATE_DEFAULT)
temp_chart.center()
var Tin = temp_chart.add_series(lv.color(lv.COLOR_RED), lv.CHART_AXIS_PRIMARY_Y) #temp indoor
var Hin = temp_chart.add_series(lv.color(lv.COLOR_GREEN), lv.CHART_AXIS_SECONDARY_Y) #hygro indoor
var Tout = temp_chart.add_series(lv.color(lv.COLOR_MAROON), lv.CHART_AXIS_PRIMARY_Y) #temp indoor
var Hout = temp_chart.add_series(lv.color(lv.COLOR_LIME), lv.CHART_AXIS_SECONDARY_Y) #hygro indoor

#can3 => graph temperatuur & HYGRO
can4=lv.canvas(scr)
can4.set_pos(0,35)
can4.set_size(320,400)
can4.add_flag(lv.OBJ_FLAG_HIDDEN)
can4.add_style(can3_style, lv.PART_MAIN | lv.STATE_DEFAULT)

gas_chart=lv.chart(can4)
gas_chart.set_size(320, 400)
gas_chart.set_type(lv.CHART_TYPE_LINE)
var CO2in = temp_chart.add_series(lv.color(lv.COLOR_RED), lv.CHART_AXIS_PRIMARY_Y) #CO2 indoor
var TGin = temp_chart.add_series(lv.color(lv.COLOR_GREEN), lv.CHART_AXIS_SECONDARY_Y) #Total gas indoor

#can3 => graph temperatuur & HYGRO
can5=lv.canvas(scr)
can5.set_pos(0,35)
can5.set_size(320,400)
can5.add_flag(lv.OBJ_FLAG_HIDDEN)
can5.add_style(can3_style, lv.PART_MAIN | lv.STATE_DEFAULT)

part_chart=lv.chart(can5)
part_chart.set_size(320, 400)
part_chart.set_type(lv.CHART_TYPE_LINE)
var P1in = temp_chart.add_series(lv.color(lv.COLOR_RED), lv.CHART_AXIS_PRIMARY_Y) #fijnstof 1.0 indoor
var P25in = temp_chart.add_series(lv.color(lv.COLOR_GREEN), lv.CHART_AXIS_SECONDARY_Y) #fijnstof 2.5 indoor
var P10in = temp_chart.add_series(lv.color(lv.COLOR_YELLOW), lv.CHART_AXIS_PRIMARY_Y) #fijnstof 10 indoor