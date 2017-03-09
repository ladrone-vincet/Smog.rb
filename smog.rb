require "net/http"
require "uri"
require 'rubygems'
require 'json'


def colorize(text, color_code)
  "\e[#{color_code}m#{text}\e[0m"
end

def formatMeasurments(data)
  data.each do |x|
    case x[0]
    when "airQualityIndex"
      color = case x[1]
      when 1...50
        106
      when 51...100
        43
      when 100...300
        41
      else
        31
      end
      puts colorize("\tAir Quality Index-- %.2f" % x[1], color)
    when "pm1"
      puts "\tPM 1\t\t -- %.2f" % x[1]
    when "pm25"
      puts "\tPM 25\t\t -- %.2f" % x[1]
    when "pm10"
        puts "\tPM 10\t\t -- %.2f" % x[1]
    when "pressure"
        puts "\tPressure\t -- %.2f" % (x[1] / 100)
    when "humidity"
        puts "\tHumidity\t -- %.2f" % x[1]
    when "temperature"
      puts "\tTemperature\t -- %.2f" % x[1]
    when "pollutionLevel"
      print "\tHow good is the air? \n\t\t"
      case x[1]
      when 0
        puts "Pretty GOOOOOD!"
      when 1
        puts "It's nice"
      when 2
        puts "Good enough"
      when 3
        puts "Just BAD"
      when 4
        puts "Don't leave you home"
      else
        puts colorize("FUCK CRACOW!!!", 101)
      end
    end
  end
  print "\n"
end


def getDataFromID(id, apiKey)
  newUri = URI.parse("https://airapi.airly.eu/v1/sensor/measurements?apikey=#{apiKey}&&sensorId=#{id}")
  newResponse = Net::HTTP.get_response(newUri)
  jsoned = JSON.parse(newResponse.body)
  puts "------------------!!!------------"
  case id
  when 178
    puts "Okolice Bobrzynskiego"
  when 228
    puts "Kobierzyn i okolice"
  when 204
    puts "Rynek"
  when 193
    puts "Kazimierz"
  when 213
    puts "AGH i okolice"
  end
  puts "------------------!!!------------"
  if jsoned["currentMeasurements"].empty?
    puts "\t???----No data at the moment\n\n"
  end
  formatMeasurments(jsoned["currentMeasurements"])
  #jsoned["currentMeasurements"].each { |e|
  #  print "\t***----#{e[0]} is \t"
  #  puts "%.2f" % e[1]
  #  }
end

apiKey = "!!YOUR API KEY!!"
getDataFromID(178, apiKey)
getDataFromID(228, apiKey)
getDataFromID(204, apiKey)
getDataFromID(193, apiKey)
getDataFromID(213, apiKey)
