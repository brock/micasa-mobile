#!/usr/bin/env ruby
require 'stringio'
require 'sinatra'
require 'mios'
require 'rest_client'
require 'uri'
require 'json'

class Mios < Sinatra::Base
  def self.silence_warnings
    old_stderr = $stderr
    $stderr = StringIO.new
    yield
  ensure
    $stderr = old_stderr
  end

  mios = nil

  silence_warnings do
  	mios = MiOS::Interface.new('http://10.0.1.3:3480')
    @devices = mios.device_names
  end

  get '/' do
    redirect to('/lights')
  end

  get '/lights' do
    lights=[]
    # I'm downcasing all of my device names here
    devices = mios.devices.sort { |a,b| a.name.downcase <=> b.name.downcase }

    # this next line can be commented out if you want to see more than just lights
    lights = devices.select { |d| defined? d.kWh and defined? d.on? }

    # include sensors
    sensors = devices.select { |d| defined? d.armed? and not defined? d.kWh }

    erb :lights, :locals => {
      :lights => lights,
      :devices => devices,
      :sensors => sensors
    }
  end

  get '/lights/dim/:name/:value' do
    name = params[:name]
    value = URI.escape(params[:value])
    device = mios.devices.find {|d| d.name == name}
    puts device.name
    puts name
    puts value

    if defined? device.set_level
      device.set_level(value)
    elsif defined? device.set_level!
      device.set_level!(value)
    else
      puts 'device couldnt set level'
    end

  end

  get '/lights/:name/:mode' do
    name = params[:name]
    mode = params[:mode]

    # depending on how you name your devices in VeraLite, you may want to update the next line
    # Here I'm taking the passed name of "master bedroom" and changing it to "Master Bedroom Lights"
    # device = mios.devices.find {|d| d.name == name.split.map(&:capitalize).join(' ') + " Lights"}
    device = mios.devices.find {|d| d.name == name}

    # the mios gem offers two methods: on! and off!
    if ["on", "off"].include?(mode)
      device.send(mode + "!") { |obj|
        return erb :light, :locals => {:light => obj.name, :mode => "on"}
      }
    else
        return "Supported actions are on or off."
    end
  end

  get '/sensors/:name/:mode' do
    name = params[:name]
    mode = params[:mode]

    # depending on how you name your devices in VeraLite, you may want to update the next line
    # Here I'm taking the passed name of "master bedroom" and changing it to "Master Bedroom Lights"
    # device = mios.devices.find {|d| d.name == name.split.map(&:capitalize).join(' ') + " Lights"}
    device = mios.devices.find {|d| d.name == name}

    # the mios gem offers two methods: on! and off!
    if ["arm", "disarm"].include?(mode)
      device.send(mode + "!") { |obj|
        return erb :light, :locals => {:light => obj.name, :mode => mode}
      }
    else
        return "Supported actions are arm or disarm."
    end
  end

  get '/music' do
    current = RestClient.get "http://localhost:5005/kitchen/state"
    response = RestClient.get "http://localhost:5005/kitchen/favorites"
    erb :music, :locals => {:favorites => response[1..-2].split(','), :current => JSON.parse(current) }
  end

  get '/music/favorite/:sound' do
    sound = URI.escape(params[:sound])
    RestClient.get "http://localhost:5005/kitchen/favorite/#{sound}"
  end

  get '/music/say/:sound' do
    sound = URI.escape(params[:sound])
    RestClient.get "http://localhost:5005/kitchen/say/#{sound}"
  end

  get '/music/volume/:level' do
    level = URI.escape(params[:level])
    RestClient.get "http://localhost:5005/kitchen/volume/#{level}"
  end

  get '/music/play' do
    RestClient.get "http://localhost:5005/kitchen/play"
  end

  get '/music/pause' do
    RestClient.get "http://localhost:5005/kitchen/pause"
  end
end
