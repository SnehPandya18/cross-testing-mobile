# frozen_string_literal: true

require 'appium_lib'
require 'cucumber'
require 'selenium-webdriver'
require 'allure-cucumber'

$wait = Selenium::WebDriver::Wait.new(timeout: 60)

time  = Time.new
time = time.strftime('%d-%m-%Y')
$logger = Logger.new("./exec-logs/exec-log-#{time}.log")

AllureCucumber.configure do |c|
  c.output_dir = './allure-results/'
  c.clean_dir  = true
end

def load_appium_configuration(platform)
  dir = "#{Dir.pwd}/config/#{platform}/appium.txt"
  Appium.load_appium_txt file: File.expand_path(dir, __FILE__), verbose: true
end

env = ENV['PLATFORM_NAME'].downcase

case env
when 'android'
  caps = load_appium_configuration(env)
  caps[:appium_lib][:export_session] = true
when 'ios'
  caps = load_appium_configuration(env)
  caps[:appium_lib][:export_session] = true
else
  raise("Plataforma não suportada #{ENV['PLATFORM_NAME']}")
end

Appium::Driver.new(caps)
Appium.promote_appium_methods Object
