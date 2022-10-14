#basic table
can1=lv.canvas(scr)
can1.set_pos(0,35)
can1.set_size(320,400)

can2=lv.canvas(scr)
can2.set_pos(180,35)
can2.set_size(70,400)

table2=lv.table(can2)
table2.set_col_width(0, 70)
table2.add_style(canvas_style, lv.PART_MAIN | lv.STATE_DEFAULT)
table2.set_style_border_color(lv.color(0x0000FF), lv.PART_ITEMS | lv.STATE_DEFAULT)
table2.add_style(canvas_style, lv.PART_ITEMS | lv.STATE_DEFAULT)
table2.set_style_pad_hor(3, lv.PART_ITEMS)
table2.set_style_text_align(lv.TEXT_ALIGN_RIGHT, lv.PART_ITEMS)
table2.set_style_border_opa(0,0)

can20=lv.canvas(scr)
can20.set_pos(180,35)
can20.set_size(70,400)

table20=lv.table(can20)
table20.set_col_width(0, 70)
table20.add_style(canvas_style, lv.PART_MAIN | lv.STATE_DEFAULT)
table20.set_style_border_color(lv.color(0x0000FF), lv.PART_ITEMS | lv.STATE_DEFAULT)
table20.add_style(canvas_style, lv.PART_ITEMS | lv.STATE_DEFAULT)
table20.set_style_pad_hor(3, lv.PART_ITEMS)
table20.set_style_text_align(lv.TEXT_ALIGN_RIGHT, lv.PART_ITEMS)
table20.set_style_border_opa(0,0)

table1=lv.table(can1)
table1.set_col_width(0, 246)
table1.set_col_width(1, 70)

table1.add_style(canvas_style, lv.PART_MAIN | lv.STATE_DEFAULT)
table1.set_style_border_color(lv.color(0x0000FF), lv.PART_ITEMS | lv.STATE_DEFAULT)
table1.add_style(canvas_style, lv.PART_ITEMS | lv.STATE_DEFAULT)
table1.set_style_pad_hor(5, lv.PART_ITEMS)
table1.set_style_text_align(lv.TEXT_ALIGN_LEFT, lv.PART_ITEMS)
table1.set_style_border_opa(0,0)

#start met indoor
can20.add_flag(lv.OBJ_FLAG_HIDDEN) 

# DS18b20_temperatuur, bme_temperatuur, bme_hum, bme_press, bme_IAQ_acc, bme_IAQ, bme_CO2, bme_TVOC, winssen_CO2, NOVA_part2.5, NOVA_part10
def create_items()
    import string
  var items= [' Temperatuur:', ' Hygro:', ' Luchtdruk:', ' IAQ:', ' CO2:', ' TVOC:', ' Fijnstof 2.5:', ' Fijnstof 10:']
  var val2=['°C', '%', 'hPa', '', 'ppm', 'ppm', 'ug/m', 'ug/m']
  var j=0
  for i: 0..7
    table1.set_cell_value(i, 0, items[i])
    table1.set_cell_value(i, 1, val2[i])
    j=1
    if i < 2 || i == 5 || i > 5
      if i==0 j=0 end
      if i == 5 j=2 end
      if i>5 j=3 end
      table2.set_cell_value(i, 0, string.format("% .1f",number(sens_val_in[i+j])))
      table20.set_cell_value(i, 0, string.format("% .1f",number(sens_val_out[i+j])))
    else
      if i>2 j=2 end
      table2.set_cell_value(i, 0, string.format("% .0f",number(sens_val_in[i+j])))
      table20.set_cell_value(i, 0, string.format("%d",number(sens_val_out[i+j])))
    end
  end
end

create_items()
#timer
def set_timer_every(delay,f)
  var now=tasmota.millis()
  tasmota.set_timer((now+delay/4+delay)/delay*delay-now, def() set_timer_every(delay,f) f() end)
end
set_timer_every(3000,create_items)