module ImageHelper
  def ImageHelper.get_images_from_hero(hero)
    return if hero.nil?
    hero = JSON.parse(hero)
    images = [hero['poster_image']]
    images << hero['trait']['image']

    hero['abilities'].each do |ability|
      images << ability['image']
    end

    hero['heroics'].each do |heroic|
      images << heroic['image']
    end

    return images
  end

  def ImageHelper.image_name(image)
    "#{image.split('/').last}"
  end

  def ImageHelper.local_image_url(hero, image)
    url = ApplicationController.get_hostname
    url += "#{Config.get('image_path')}"
    url += "#{hero ? hero + '/': ''}"
    url += self.image_name image
    return url
  end

  def ImageHelper.image_dir_path(hero)
    url = "/public#{Config.get('image_path')}"
    url += "#{hero ? hero + '/': ''}"
    return url
  end

  def ImageHelper.pull_image(hero, image)

    self.create_hero_image_directories hero
    local_image = self.local_image_url(hero, image)
    image_file = self.path(
        [
           self.image_dir_path(hero),
           self.image_name(image)
        ])

    if File.exists?(image_file) && File.size?(image_file) > 1024
      return local_image
    end

    return local_image if local_image == image

    # Failure to get image, thread it out and save it
    Thread.new do
      puts "SCRAPING IMAGE: #{image}"
      image_data = HTTParty.get(image)
      puts "RESP #{image_data.code}"
      if !image_data || image_data.code != 200 || !image_data.body
        return image
      end

      # Great success
      StorageHelper.save_image_to_disk(image_file, image_data.body)
    end

    return image
  end

  def ImageHelper.path(parts=[])
    after_parts = []
    parts.each do |part|
      after_parts << part.split('/').reject { |p| p.empty? }.join('/')
    end
    after_parts.join('/')
  end

  def ImageHelper.create_hero_image_directories(hero_slug)
    hero_image_path = ImageHelper.path([self.image_dir_path(hero_slug)])
    ImageHelper.create_directory hero_image_path
  end

  def ImageHelper.create_directory(dir)
    return if File.directory?(dir)
    FileUtils.mkdir_p dir
  end

  def ImageHelper.purge
     FileUtils.rm_rf("./public#{Config.get('image_path')}") rescue 'Failed to delete images'
  end
end