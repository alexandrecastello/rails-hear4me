class RecordsController < ApplicationController
  # nethttp.rb
  require 'uri'
  require 'net/http'

  def new
    @record = Record.new
  end

  # # TODO
  # def analyse_audio_request
  #   audio_file = params['audio']
  #   request_params = { audio_file: audio_file, filename: 'TODO' }
  #   method = 'analyze_audio'
  #   api_request(request_params, method)
  # end

  def analyse_text_request
    user_text = params['user_text']
    request_params = { user_text: user_text }
    method = 'analyze_audio'
    api_request(request_params, method)
  end

  private

  def api_request(request_params, method)
    uri = URI("https://api.hear4.me/#{method}")
    uri.query = URI.encode_www_form(request_params)
    res = Net::HTTP.get_response(uri)
    @response = res.body if res.is_a?(Net::HTTPSuccess)
  end
end
