module ImageHelper
  def ImageHelper.get_images_from_hero(hero)
    hero = JSON.parse(hero)
    bustImage = hero['poster_image']
    abilityImages = [hero['trait']['image']]

    hero['abilities'].each do |ability|
      abilityImages << ability['image']
    end

    hero['heroics'].each do |heroic|
      abilityImages << heroic['image']
    end

    {
        :bust => bustImage,
        :abilities => abilityImages
    }
  end

  def ImageHelper.get_hero_image_url(hostname, hero, fallback_image)
    options = {:hero => hero['slug']}

    if fallback_image.contain?('/bust.')
      return ImageHelper.pull_image(hostname, fallback_image, options)
    end

    options[:type] = 'abilities'
    ImageHelper.pull_image(hostname, fallback_image, options)
  end

  def ImageHelper.pull_image(hostname, hero, fallback_image)
    local_image_path = ImageHelper.image_dir_path options
    if !File.exists?(local_image_path)
      create_hero_image_structure
    end
  end

  def ImageHelper.local_image_url(hostname, image, options={})
    url = hostname
    url += ImageHelper.image_dir_path(options)
    url += "#{image.split('/').last}"
    return url
  end

  def ImageHelper.image_dir_path(options={})
    url = "#{Config.get('image_path')}"
    url += "#{options[:hero] ? options[:hero] + '/': ''}"
    url += "#{options[:type] ? options[:type] + '/' : ''}"
    return url
  end

  def ImageHelper.create_hero_image_structure(hero_slug, options={})
    image_parts = [ConfigController.get('image_path'), hero_slug]
    if options[:type] == ''
    ImageHelper.create_directory image_parts.join('/')
  end


  def ImageHelper.create_directory(dir)
    return if File.directory?(dir)
    FileUtils.mkdir_p dir
  end
end