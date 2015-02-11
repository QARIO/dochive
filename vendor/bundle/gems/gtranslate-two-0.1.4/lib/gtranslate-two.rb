require File.join(File.dirname(__FILE__), 'gtranslatorresult')
require File.join(File.dirname(__FILE__), 'glanguage')
require 'json'
require 'net/https'
require 'uri'

class GTranslator
  
  @@key = nil
  
  def self.key
    @@key
  end
  
  def self.key=(key)
    @@key = key
  end
  
  def self.detect_language(query)
    translate(query, 'en').source
  end
  
  def self.translate(query, target, source=nil)
    
    # Step 1a: make an array of required parameters to send to the Google Translate server
    options = { :q => query, :target => target, :key => @@key } 
    
    # Step 1b: Add the optional source parameter if it has been explicitly specified
    options[:source] = source if source
    
    # Step 1c: Serialize the hash for the POST request
    params = URI.escape(options.collect{|k,v| "#{k}=#{v}"}.join('&'))
    
    # Step 2a: Get the Google Translate host address
    uri = URI.parse('https://www.googleapis.com/language/translate/v2')
    
    # Step 2b: Create a new HTTP client from the provided host address
    http = Net::HTTP.new(uri.host, uri.port)
    
    # Step 2c: Force the HTTP client to use SSL and assign a proper certificate
    http.use_ssl = true
    http.ssl_timeout = 2
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    store = OpenSSL::X509::Store.new
    store.set_default_paths
    http.cert_store = store
    
    # Step 2d: Make an actual POST request and grab the response and it's body
    response, body = http.post(uri.path, params, { 'X-HTTP-Method-Override' => 'GET' })
    
    # Step 3a: If the response indicates an HTTP OK code (200), parse the body as JSON
    if response.is_a?(Net::HTTPOK)
      # Step 3b: The JSON response has 1 or more 'translations' - out of each one...
      result = JSON.parse(body)['data']['translations'].collect do |params|
        #... create a new GTranslatorResult object
        GTranslatorResult.new(query, target, params, source)
      end
      # Step 4a: If all went well, return the resulting GTranslatorResult or an array of those 
      #          if more than one translation has been returned
      return result.size == 1 ? result.first : result
    else
      # Step 4b: Otherwise, return the error response (generally, a Net::HTTPBadRequest)
      response
    end
  end
  
end