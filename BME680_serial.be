ser = serial(21, 22, 115200, serial.SERIAL_8N1)   #RX=21, TX=22
def read_bme680()
    if ser.available() == 45
        var msg=ser.read()
        var outp=msg.asstring()
        print(outp)
    end
end