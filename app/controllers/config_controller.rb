class ConfigController < Sinatra::Base
  @config = {}
  def self.set(key, value=false); @config[key] = value; end
  def self.get(key); @config[key] ||= false; end

  def self.base_url=(url); @base_url = url; end
  def self.base_url; @base_url; end

  def self.hero_base_url=(url); @hero_base_url = url; end
  def self.hero_base_url; @hero_base_url; end

  def self.local_file=(fileName); @local_file = fileName; end
  def self.local_file; @local_file; end

  def self.local_detail_file=(fileName); @local_detail_file = fileName; end
  def self.local_detail_file; @local_detail_file; end

  def self.hero_local_file=(fileName); @hero_local_file = fileName; end
  def self.hero_local_file; @hero_local_file; end

  def self.image_urls=(urls={}); @image_urls = urls; end
  def self.image_urls; @image_urls; end
end