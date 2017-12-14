module StorageHelper
  def StorageHelper.read_from_disk
    return if !File.exists?(ConfigController.local_file)
    puts "Reading feed from cache"
    File.read(ConfigController.local_file)
  end

  def StorageHelper.read_detail_from_disk
    return if !File.exists?(ConfigController.local_detail_file)
    puts "Reading detail from cache"
    File.read(ConfigController.local_detail_file)
  end

  def StorageHelper.read_hero_from_disk(name)
    return if name.nil?
    return if !File.exists?(ConfigController.hero_local_file % name)
    puts "Reading hero feed from cache"
    File.read(ConfigController.hero_local_file % name)
  end

  def StorageHelper.save_to_disk(data)
    File.open(ConfigController.local_file, 'w') { |file| file.write(data) }
  end

  def StorageHelper.save_hero_to_disk(name, data)
    return if name.nil?
    data = ScraperHelper.parse_hero_json_data(data)
    data = JSON.pretty_generate(data)
    File.open(ConfigController.hero_local_file % name, 'w') { |file| file.write(data) }
  end
end