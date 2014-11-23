#!/usr/bin/env ruby
require 'stringio'
require 'sinatra'
require 'mios'
require 'rest_client'
require 'uri'

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
    devices = mios.devices.sort { |a,b| a.name.downcase <=> b.name.downcase }
    erb :lights, :locals => { :lights => devices }
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

  get '/sounds' do
    erb :sounds
  end

  get '/sounds/favorite/:sound' do
    sound = URI.escape(params[:sound])
    RestClient.get "http://localhost:5005/kitchen/favorite/#{sound}"
  end

  get '/sounds/say/:sound' do
    sound = URI.escape(params[:sound])
    RestClient.get "http://localhost:5005/kitchen/say/#{sound}"
  end
end
