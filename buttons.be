#- create a style for the buttons -#
btn_style = lv.style()
btn_style.set_radius(10)                        # radius of rounded corners
btn_style.set_bg_opa(lv.OPA_COVER)              # 100% backgrond opacity
if f20 != nil btn_style.set_text_font(f20) end  # set font to Montserrat 20
btn_style.set_bg_color(lv.color(0x1fa3ec))      # background color #1FA3EC (Tasmota Blue)
btn_style.set_border_color(lv.color(0x0000FF))  # border color #0000FF
btn_style.set_text_color(lv.color(0xFFFFFF))    # text color white #FFFFFF

btn_size_ver = 30
btn_size_hor = 80

#- create buttons -#
prev_btn = lv.btn(scr)                            # create button with main screen as parent
prev_btn.set_pos(((hres/2)-(2*btn_size_hor)),vres-40)                      # position of button
prev_btn.set_size(btn_size_hor, btn_size_ver)                         # size of button
prev_btn.add_style(btn_style, lv.PART_MAIN | lv.STATE_DEFAULT)   # style of button
prev_label = lv.label(prev_btn)                   # create a label as sub-object
prev_label.set_text("<")                          # set label text
prev_label.center()

next_btn = lv.btn(scr)                            # right button
next_btn.set_pos(((hres/2)+(btn_size_hor)),vres-40)			  # 40 from bottom
next_btn.set_size(btn_size_hor, btn_size_ver)
next_btn.add_style(btn_style, lv.PART_MAIN | lv.STATE_DEFAULT)
next_label = lv.label(next_btn)
next_label.set_text(">")
next_label.center()

home_btn = lv.btn(scr)                            # center button
home_btn.set_pos(((hres/2)-(btn_size_hor/2)),vres-40)
home_btn.set_size(btn_size_hor, btn_size_ver)
home_btn.add_style(btn_style, lv.PART_MAIN | lv.STATE_DEFAULT)
home_label = lv.label(home_btn)
home_label.set_text('Binnen')                 # set text as Home icon
home_label.center()

var presses=0   #nbr of presses for screens
var in = 1
def handle_screens(pres)
  print('pres',pres)
  if pres==0 && in==1 can3.add_flag(lv.OBJ_FLAG_HIDDEN) can4.add_flag(lv.OBJ_FLAG_HIDDEN) can5.add_flag(lv.OBJ_FLAG_HIDDEN) can20.add_flag(lv.OBJ_FLAG_HIDDEN) can2.clear_flag(lv.OBJ_FLAG_HIDDEN)
  elif pres==0 && in==0 can3.add_flag(lv.OBJ_FLAG_HIDDEN) can4.add_flag(lv.OBJ_FLAG_HIDDEN) can5.add_flag(lv.OBJ_FLAG_HIDDEN) can2.add_flag(lv.OBJ_FLAG_HIDDEN) can20.clear_flag(lv.OBJ_FLAG_HIDDEN)
  elif pres==1 can4.add_flag(lv.OBJ_FLAG_HIDDEN) can5.add_flag(lv.OBJ_FLAG_HIDDEN) can3.clear_flag(lv.OBJ_FLAG_HIDDEN)
  elif pres==2 can3.add_flag(lv.OBJ_FLAG_HIDDEN) can5.clear_flag(lv.OBJ_FLAG_HIDDEN) can4.clear_flag(lv.OBJ_FLAG_HIDDEN)
  elif pres==3 can3.add_flag(lv.OBJ_FLAG_HIDDEN) can4.add_flag(lv.OBJ_FLAG_HIDDEN) can5.clear_flag(lv.OBJ_FLAG_HIDDEN)
  elif pres<0 presses=0 print('This is the first screen')
  elif pres>3 presses=3 print('No more screens to show') end
end

#- callback function when a button is pressed, react to EVENT_CLICKED event -#
def btn_clicked_cb(obj, event)
    var btn = "Unknown"
    if   obj == prev_btn  btn = "Prev" presses-=1
    elif obj == next_btn  btn = "Next" presses+=1
    elif obj == home_btn && in==1 btn = "Binnen" presses=0 in=0 home_label.set_text('Buiten')
    elif obj == home_btn && in==0 btn = "Buiten" presses=0 in=1 home_label.set_text('Binnen')
    end
    print(btn, "button pressed")
    handle_screens(presses)
    print('presses',presses)
end


prev_btn.add_event_cb(btn_clicked_cb, lv.EVENT_CLICKED, 0)
next_btn.add_event_cb(btn_clicked_cb, lv.EVENT_CLICKED, 0)
home_btn.add_event_cb(btn_clicked_cb, lv.EVENT_CLICKED, 0)