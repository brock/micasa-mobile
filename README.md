# MiCasa Mobile

A Bootstrap replacement for the MiCasaVerde interface called MIOS. Supports basic on/off functionality. To get this working, you'll need to modify just the index.rb file. The line that creates a new mios interface will need your local IP address (find this by going to the MIOS interface from your LAN).

## Notes
I'm only using this application to turn on and off lights, so in the index.rb, I'm filtering the devices by those that have the `on?` method and have a `kWh` method. All of my lights have that, but if you aren't seeing any devices, update the `/lights` endpoint in `index.rb` and remove the line that uses `select` and you should start seeing devices.

## Installation
This application uses Bundler. To setup the project run
```
bundle install
```

## Starting the Web Application
We'll use Bundler to start the application:
```
bundle exec rackup
```
Or you can start it just using Rack manually:
```
rackup config.ru
```
That should start the web interface at http://localhost:9292 and immediately redirect you to http://localhost:9292/lights

Any kind of feedback is welcome. Just open an issue and start a discussion at https://github.com/brock/micasa-mobile/issues

---

![screenshot](http://f.cl.ly/items/251b1D2C3f2Q1J3A0x3i/Screen%20Shot%202014-08-03%20at%207.59.18%20PM.png)

This would be completely impossible without the [ruby-mios](https://github.com/kreynolds/ruby-mios) gem by @kreynolds.


