class RecordsController < ApplicationController
  # nethttp.rb
  require 'uri'
  require 'net/http'

  def new
    @record = Record.new
  end

  # https://firebasestorage.googleapis.com/v0/b/hear4me-e0481.appspot.com/o/audio%2FY2022_M3_D19_H14_M9_rand80940.ogg?alt=media&token=cc8bda74-fc45-4a9a-b1c4-800714a4f8ba
  # https://firebasestorage.googleapis.com/v0/b/hear4me-e0481.appspot.com/o/audio%2FY2022_M3_D19_H22_M8_rand80940.ogg?alt=media&token=d859ffdf-4742-4e83-b82d-ba1c3a3fc957
  # Y2022_M3_D19_H22_M8_rand80940.ogg

  def transcription
    audio = params['audio']
    uri = URI('https://api.nasa.gov/planetary/apod')
    params = { :api_key => 'your_api_key' }
    uri.query = URI.encode_www_form(params)

    res = Net::HTTP.get_response(uri)
    puts res.body if res.is_a?(Net::HTTPSuccess)
  end
end
