#- start LVGL and init environment -#
lv.start()

hres = lv.get_hor_res()       # should be 480
vres = lv.get_ver_res()       # should be 320

scr = lv.scr_act()            # default screean object
f20 = lv.montserrat_font(20)  # load embedded Montserrat 20

btn_size_ver = 30
btn_size_hor = 80

#- Background with a gradient from black #000000 (bottom) to dark blue #0000A0 (top) -#
scr.set_style_bg_color(lv.color(0x0000A0), lv.PART_MAIN | lv.STATE_DEFAULT)
scr.set_style_bg_grad_color(lv.color(0x000000), lv.PART_MAIN | lv.STATE_DEFAULT)
scr.set_style_bg_grad_dir(lv.GRAD_DIR_VER, lv.PART_MAIN | lv.STATE_DEFAULT)

#- Upper state line -#
stat_line = lv.label(scr)
if f20 != nil stat_line.set_style_text_font(f20, lv.PART_MAIN | lv.STATE_DEFAULT) end
stat_line.set_long_mode(lv.LABEL_LONG_SCROLL)                                        # auto scrolling if text does not fit
stat_line.set_width(hres)
stat_line.set_align(lv.TEXT_ALIGN_LEFT)                                              # align text left
stat_line.set_style_bg_color(lv.color(0xD00000), lv.PART_MAIN | lv.STATE_DEFAULT)    # background #000088
stat_line.set_style_bg_opa(lv.OPA_COVER, lv.PART_MAIN | lv.STATE_DEFAULT)            # 100% background opacity
stat_line.set_style_text_color(lv.color(0xFFFFFF), lv.PART_MAIN | lv.STATE_DEFAULT)  # text color #FFFFFF
stat_line.set_text("Luchtkwaliteit")
stat_line.refr_size()                                                                # new in LVGL8
stat_line.refr_pos()                                                                 # new in LVGL8

#- display wifi strength indicator icon (for professionals ;) -#
wifi_icon = lv_wifi_arcs_icon(stat_line)    # the widget takes care of positioning and driver stuff
clock_icon = lv_clock_icon(stat_line)

#- create a style for the buttons -#
btn_style = lv.style()
btn_style.set_radius(10)                        # radius of rounded corners
btn_style.set_bg_opa(lv.OPA_COVER)              # 100% backgrond opacity
if f20 != nil btn_style.set_text_font(f20) end  # set font to Montserrat 20
btn_style.set_bg_color(lv.color(0x1fa3ec))      # background color #1FA3EC (Tasmota Blue)
btn_style.set_border_color(lv.color(0x0000FF))  # border color #0000FF
btn_style.set_text_color(lv.color(0xFFFFFF))    # text color white #FFFFFF

#- register buttons -#
var btns = []         # relay buttons are added to this list to match with Tasmota relays

#- simple function to find the index of an element in a list -#
def findinlist(l, x)
  for i:0..size(l)-1
    if l[i] == x
      return i
    end
  end
end

#- callback function when a button is pressed -#
#- checks if the button is in the list, and react to EVENT_VALUE_CHANGED event -#
def btn_event_cb(o, event)
  var btn_idx = findinlist(btns, o)
  if btn_idx != nil && event == lv.EVENT_VALUE_CHANGED
    var val = o.get_state() < lv.BTN_STATE_CHECKED_RELEASED   # true if checked, false if unchecked
    tasmota.set_power(btn_idx, !val)                          # toggle the value
  end
end

def create_btn(label)
  var btn, btn_label
  btn = lv.btn(scr)
  btn.set_size(80, 30)
  #btn2.set_checkable(True)                                  # enable toggle mode
  btn_label = lv.label(btn)
  btn_label.set_text(label)
  btn_label.center()
  #btn.add_flag(btn.FLAG.CHECKABLE)
  #btn_event(btn)       # set callback to update Tasmota relays
  btns.push(btn)                                            # append button to the list
  return btn
end

#- create 3 relay buttons -#
btn1 = create_btn("Rel 1")
btn1.set_pos(60, 150)
btn2 = create_btn("Rel 2")
btn2.set_pos(200, 150)
btn2.add_flag.FLAG_CHECKABLE
btn3 = create_btn("Rel 3")
btn3.set_pos(340, 150)

#- create 3 screen buttons -#
btn4 = create_btn("Scr 1")
btn4.add_flag.FLAG_CHECKABLE
btn4.set_pos(((hres/2)-(2*btn_size_hor)),vres-40)
btn5 = create_btn("Scr 2")
btn5.set_pos(((hres/2)+(btn_size_hor)),vres-40)
btn6 = create_btn("Scr 3")
btn6.set_pos(((hres/2)-(btn_size_hor/2)),vres-40)


#- update the buttons values according to internal relays status -#
def btns_update()
  var power_list = tasmota.get_power()                                            # get a list of booleans with status of each relay
  for b:btns
    var state = b.get_state()
    var power_state = (size(power_list) > 0) ? power_list.pop(0) : false          # avoid exception if less relays than buttons
    if state != lv.EVENT_PRESSING     # update only if the button is not currently being pressed
      #b.set_state(power_state ? lv.STATE_CHECKED_RELEASED : lv.STATE_RELEASED)
    end
  end
end

#- update every 500ms -#
def btns_update_loop()
  btns_update()
  tasmota.set_timer(500, btns_update_loop)
end
btns_update_loop()  # start

# If you change the style after creating the button, you need to update objects:
def btns_refresh_style()
  for b:btns b.refresh_style(lv.PART_MAIN, lv.STYLE_PROP_ALL) end
end

#- callback function when a button is pressed, react to EVENT_CLICKED event -#

def btn_clicked_cb(obj, event)
        if obj == btn3
            print("btn3 pressed")
        elif obj == btn4
            print("btn4 pressed")
            btn4.set_state.CHECKED
        elif obj == btn5
            print("btn5 pressed")
        elif obj == btn6
            print("btn6 pressed")
        end
        print(obj, "button pressed")
end

btn1.add_event_cb(btn_clicked_cb, lv.EVENT_CLICKED, 0)
btn2.add_event_cb(btn_clicked_cb, lv.EVENT_CLICKED, 0)
btn3.add_event_cb(btn_clicked_cb, lv.EVENT_CLICKED, 0)
btn4.add_event_cb(btn_clicked_cb, lv.EVENT_CLICKED, 0)
btn5.add_event_cb(btn_clicked_cb, lv.EVENT_CLICKED, 0)
btn6.add_event_cb(btn_clicked_cb, lv.EVENT_CLICKED, 0)

#lv_obj_add_flag(btn2, LV_OBJ_FLAG_CHECKABLE);
#btn2.add_flag(lv.obj.FLAG.CHECKABLE)
