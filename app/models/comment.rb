require "net/http"
require "uri"

class Comment < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :article
  
  after_create :after_create

  def after_create
    if ENV["REST_SYNC_REALTIME"] === '' then 
      return
    end
    uri = URI.parse( ENV["REST_SYNC_ROOT"] )
    http = Net::HTTP.new( uri.host, uri.port)
    remoteNewUrl = "/rest-sync/comments"

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
    puts "UPDATING"
    puts attributes
    remoteUpdateUrl = "/rest-sync/comments/" + attributes["id"].to_s

    request = Net::HTTP::Put.new(remoteUpdateUrl)
    request.set_form_data( attributes )
    http.request(request)  
  end
end
