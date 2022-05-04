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

  def show
    @record = Record.find(params[:id])
  end

  def index
    @records = Record.where(user: current_user)
  end

  def create
    audio_file = params['record']['audio']
    uploaded_file = Cloudinary::Uploader.upload(audio_file, resource_type: 'video')
    filename = "#{uploaded_file['public_id']}.ogg"
    download_url = uploaded_file['secure_url']
    # download_url = "https://res.cloudinary.com/alecastello/video/upload/fl_attachment/v#{uploaded_file['version']}/#{filename}" # If it breaks, check Cloudinary username in the url 
    start = Time.now
    response = JSON.parse(api_request({ audio_file: download_url, filename: filename }, 'analyse_audio').force_encoding("UTF-8"))
    finish = Time.now
    diff = finish - start
    # => 2.333432
    if current_user
      @record = Record.create filename: filename,
                              analysis: response['textAnalysis'],
                              user: current_user,
                              nickname: filename,
                              transcription: response['transcribedText'],
                              analysis_time: diff #,
                              # audio_url: download_url
      redirect_to @record
    else
      redirect_to result(response)
    end
  end

  def analyse_text
    user_text = params['text_area']
    request_params = { user_text: user_text }
    method = 'analyse_text'
    start = Time.now
    response = api_request(request_params, method).force_encoding("UTF-8")
    finish = Time.now
    diff = finish - start
    if current_user
      @record = Record.create transcription: user_text,
                              analysis: response,
                              user: current_user,
                              nickname: DateTime.now.strftime("%Y%m%d%H%M%S"),
                              analysis_time: diff
      redirect_to @record
    else
      redirect_to result(response)
    end
  end

  def result(response)
    @response = response
  end

  private

  def api_request(request_params, method)
    uri = URI("https://api.hear4.me/#{method}")
    uri.query = URI.encode_www_form(request_params)
    res = Net::HTTP.get_response(uri)
    res.body if res.is_a?(Net::HTTPSuccess)
  end

  def record_params
  end
end
