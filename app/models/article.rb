require "net/http"
require "uri"
class Article < ActiveRecord::Base
  acts_as_paranoid
  has_many :comments
 
  after_save :after_save
  def after_save
    puts "Saved"
  end

  after_create :after_create
  def after_create
    if ENV["REST_SYNC_REALTIME"] === '' then 
      return
    end
    uri = URI.parse( ENV["REST_SYNC_ROOT"] )
    http = Net::HTTP.new( uri.host, uri.port)
    remoteNewUrl = "/rest-sync/articles"

    request = Net::HTTP::Post.new(remoteNewUrl)
    request.set_form_data( attributes )
    http.request(request)  
  end
 
  after_update :after_update
  after_destroy :after_update
  def after_update
    if ENV["REST_SYNC_REALTIME"] === '' then 
      return
    end
    uri = URI.parse( ENV["REST_SYNC_ROOT"] )
    http = Net::HTTP.new( uri.host, uri.port)
    remoteUpdateUrl = "/rest-sync/articles/" + attributes["id"].to_s

    request = Net::HTTP::Put.new(remoteUpdateUrl)
    request.set_form_data( attributes )
    http.request(request)  
  end
end
