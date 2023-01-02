# frozen_string_literal: true
require "browser"
class UrlsController < ApplicationController
  # urls_path
  def index
    # recent 10 short urls
    @url = Url.new
    @urls = Url.latest.limit(10)
  end
  # urls_path
  def create
    original_url = params['url']['original_url']
    @url = Url.new(original_url: original_url)
    if @url.save
      flash[:notice] = "Url was successfully created"
    else
      @urls = Url.latest.limit(10)
      render 'index'
      flash[:notice] = @url.errors.full_messages.join(", ")
    end
    # create a new URL record
  end
  # url_path(:id)
  def show
    @url = Url.find_by(short_url: params[:url])
    if @url.nil?
      render file: "public/404.html"
    else
      @daily_clicks = []
      clicks = @url.clicks
      clicks_hash = clicks.group('date(created_at)').count
      clicks_hash.each_pair do |k,v|
        @daily_clicks << [k.to_s, v]
      end

      @browsers_clicks = clicks.group('browser').count.to_a

      @platform_clicks = clicks.group('platform').count.to_a
    end
  end

  def visit
    url =  Url.find_by(short_url: params[:short_url])
    if url.nil?
      render file: "public/404.html"
    else
      clicks = url.clicks_count + 1
      url.update(clicks_count: clicks)
      browser = Browser.new(request.env['HTTP_USER_AGENT'], accept_language: "en-us")
      url.clicks.create(browser: browser.name, platform: browser.platform.name)
      # params[:short_url]
      redirect_to url.original_url
    end
  end
end
