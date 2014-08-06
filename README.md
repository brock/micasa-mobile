# MiCasa Mobile

A Bootstrap replacement for the MiCasaVerde interface called MIOS. Supports basic on/off functionality. To get this working, you'll need to modify just the index.rb file. The line that creates a new mios interface will need your local IP address (find this by going to the MIOS interface from your LAN).

The best way to start this app is using Rack:
```
rackup config.ru
```
That should start the web interface at http://0.0.0.0:9292 and immediately redirect you to http://0.0.0.0:9292/lights

Any kind of feedback is welcome. Just open an issue and start a discussion at https://github.com/brock/micasa-mobile/issues

---

![screenshot](http://f.cl.ly/items/251b1D2C3f2Q1J3A0x3i/Screen%20Shot%202014-08-03%20at%207.59.18%20PM.png)

This would be completely impossible without the [ruby-mios](https://github.com/kreynolds/ruby-mios) gem by @kreynolds.
