class RecordsController < ApplicationController
  # nethttp.rb
  require 'uri'
  require 'net/http'
  require 'securerandom'

  before_action :record_params, only: [:analyse_audio, :analyse_text]
  # uuid = SecureRandom.uuid
  # puts 'Your UUID is: ' + uuid

  def new
    @record = Record.new
  end

  def create
    raise
  end

  # # TODO
  def analyse_audio
    audio_file = params['audio']
    uploaded_file = Cloudinary::Uploader.upload(audio_file, resource_type: 'video')
    filename = "#{uploaded_file['public_id']}.ogg"
    download_url = "https://res.cloudinary.com/alecastello/video/upload/fl_attachment/v#{uploaded_file['version']}/#{filename}" 
    # If it breaks, check Cloudinary username in the url
    request_params = { audio_file: download_url, filename: filename }
    method = 'analyse_audio'
    api_request(request_params, method)
  end

  def analyse_text
    # firebase_request
    user_text = params['user_text']
    request_params = { user_text: user_text }
    method = 'analyse_text'
    @response = api_request(request_params, method).force_encoding("UTF-8")
  end

  private

  def api_request(request_params, method)
    uri = URI("https://api.hear4.me/#{method}")
    uri.query = URI.encode_www_form(request_params)
    res = Net::HTTP.get_response(uri)
    res.body if res.is_a?(Net::HTTPSuccess)
  end

  def firebase_request
    # android_base_uri = 'https://hear4me-e0481.firebaseio.com/'
    base_uri = 'https://hear4me-6046a.firebaseio.com/'
    private_key_json_string = File.open('google-services.json').read
    firebase = Firebase::Client.new(base_uri, private_key_json_string)
    @response = firebase.push("todos", { :name => 'Pick the milk', :'.priority' => 1 })
    raise
    @response.success? # => true
    @response.code # => 200
    @response.body # => { 'name' => "-INOQPH-aV_psbk3ZXEX" }
    @response.raw_body # => '{"name":"-INOQPH-aV_psbk3ZXEX"}'
  end

  def record_params
    # params.permit(:audio, :text_area)
  end
end
