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

  def ImageHelper.local_image_url(hostname, image, options={})
    url = "#{hostname}/public/images/#{options[:hero] ? options[:hero] + '/': ''}"
    url += "#{options[:type] ? options[:type] + '/' : ''}#{image.split('/').last}"
    return url
  end
end