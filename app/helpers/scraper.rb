module ScraperHelper

  def error(message = false)
    JSON.pretty_generate({
      :error => true,
      :message => message ||= 'Unable to process your request'
    })
  end


  def scrape_heroes
    puts "Scraping heroes from site"

    doc = HTTParty.get(Config.base_url)
    data = doc.body.scan(/window\.heroes.+= (.+);/)

    # Fall back should a request fail, try and force read locally
    if (data.nil? || data[0].nil? || data[0].first.nil?)
      puts "Failed to scrape, falling back to local cached file"
      return StorageHelper.read_from_disk
    end

    heroes = JSON.pretty_generate(JSON.parse(data[0].first))
    if !heroes.nil?
      StorageHelper.save_to_disk(heroes)
      ScraperHelper.parse_hero_details_and_save_to_disk
      ScraperHelper.parse_json_data(heroes)
    else
      ScraperHelper.error 'Unable to scrape'
    end
  end


  def scrape_hero(name)
    return if name.nil?

    Thread.new do
      ImageHelper.create_hero_image_directories name

      doc = HTTParty.get(Config.hero_base_url % name)
      puts "SCRAPING: #{Config.hero_base_url % name}"
      data = doc.body.scan(/window\.hero.+= (.+);/)

      # Fall back should a request fail, try and force read locally
      if (data.nil? || data[0].nil? || data[0].first.nil?)
        puts "Failed to scrape, falling back to local cached file"
        return StorageHelper.read_hero_from_disk
      end

      hero = JSON.parse(data[0].first)
      if !hero.nil?
        StorageHelper.save_hero_to_disk(name, hero)
        ScraperHelper.parse_hero_details_and_save_to_disk
        JSON.pretty_generate(ScraperHelper.parse_hero_json_data(hero))
      else
        ScraperHelper.error 'Unable to scrape hero data'
      end
    end
  end


  def scrape_heroes_detail
    puts "Scraping all the hero details"
    heroes = JSON.parse(StorageHelper.read_from_disk)
    return false if heroes.nil?

    heroes.each_with_index do |hero, index|
       scrape_hero(heroes[index]['slug'])
    end
  end


  def ScraperHelper.parse_hero_details_and_save_to_disk
    #puts "Reading all the hero details"
    heroes = JSON.parse(StorageHelper.read_from_disk)
    return [] if heroes.nil?

    # Default set of data based on landing page
    heroSlugs = []
    simpleHeroDetails = {}
    heroes.each_with_index do |hero, index|
      heroSlugs << heroes[index]['slug']
      simpleHeroDetails[heroes[index]['slug']] = hero
    end

    # Get the contents from the hero files for the details
    detail = []
    heroSlugs.sort.each do |slug|
      hero_detail_from_disk = StorageHelper.read_hero_from_disk(slug)
      if hero_detail_from_disk
        detail << JSON.parse(hero_detail_from_disk)
      else
        detail << simpleHeroDetails[slug]
      end
    end

    detail = JSON.pretty_generate(detail)
    File.open(Config.local_detail_file, 'w') { |file| file.write(detail) }
    true
  end


  def hero_slugs
    heroes = JSON.parse(StorageHelper.read_from_disk)
    return [] if heroes.nil?

    # Default set of data based on landing page
    heroSlugs = []
    heroes.each_with_index do |hero, index|
      heroSlugs << heroes[index]['slug']
    end
    heroSlugs.sort
  end


  def write_hero_to_db(name)
    return if name.nil?
    hero_data = StorageHelper.read_hero_from_disk(name)
    return if !hero_data
    hero_data = JSON.parse(hero_data)

    puts "INSERTING HERO: #{hero_data}"
    abilities = [];
    hero = Hero.new
    puts "hero ID: #{hero.id}"
    hero_data['abilities'].each do |ability|
      ability['hero_id'] = 1
      abilities << Ability.new(ability)
    end
    # hero = Hero.new(JSON.parse(hero_data))

    puts "RESULT: #{abilities}"
  end


  def ScraperHelper.parse_json_data(data)
    data = JSON.parse(data).map do |hero|
      ScraperHelper.parse_hero_json_data hero
    end
    JSON.pretty_generate(data)
  end


  def ScraperHelper.parse_hero_json_data(hero)
    @data = {}
    @keys = {
        'heroics' => 'heroicAbilities',
        'abilities' => 'abilities'
    }

    @data['trait'] = @values = {
        'name' => '',
        'description' => '',
        'slug' => '',
        'image' => ''
    }

    @stats = {
        'damage' => hero['stats']['damage'] ||= 0,
        'utility' => hero['stats']['utility'] ||= 0,
        'survivability' => hero['stats']['survivability'] ||= 0,
        'complexity' => hero['stats']['complexity'] ||= 0
    }

    @keys.each_key  do |key|
      needle = @keys[key]
      if !hero[needle].nil?
        @data[key] = hero[needle].map do |item|
            {
                'name' => item['name'],
                'description' => item['description'],
                'slug' => item['slug'],
                'image' => ImageHelper.pull_image(hero['slug'], Config.image_urls['trait'] % [hero['slug'], item['slug']])
            }
          end
      else
        @data[key] = @values
      end
    end

    if !hero['trait'].nil?
      @data['trait'] = {
          'name' => hero['trait']['name'],
          'description' => hero['trait']['name'],
          'slug' => hero['trait']['slug'],
          'image' => ImageHelper.pull_image(hero['slug'], Config.image_urls['trait'] % [hero['slug'], hero['trait']['slug']])
      }
    end
    {
      'name' => hero['name'],
      'slug' => hero['slug'],
      'title' => hero['title'],
      'description' => hero['baseHeroInfo']['role']['description'] ||= hero['role']['description'],
      'role' => {
        'name' => hero['baseHeroInfo']['role']['name'] ||= hero['role']['name'],
        'slug' => hero['baseHeroInfo']['role']['slug'] ||= hero['role']['slug'],
        'description' => hero['baseHeroInfo']['role']['description'] ||= hero['role']['description'],
      },
      'type_of_hero' => hero['baseHeroInfo']['type']['name'] ||= hero['type']['name'],
      'franchise' => hero['franchise'],
      'difficulty' => hero['difficulty'],
      'live' => hero['revealed'],
      'poster_image' => ImageHelper.pull_image(hero['slug'], Config.image_urls['bust'] % hero['slug']),
      'stats' => @stats,
      'trait' => @data['trait'],
      'abilities' => @data['abilities'],
      'heroics' => @data['heroics'],
      #'original' => hero
    }
  end


  def find_hero_by_name(name)
    name = name.to_s.downcase
    heroes = StorageHelper.read_detail_from_disk
    return ScraperHelper.error if heroes.nil?

    find = JSON.parse(heroes).select do |h|
      h['name'].downcase.include?(name)
    end

    return ScraperHelper.error if find.nil? || find.first.nil?
    JSON.pretty_generate(find.first)
  end


  def search_for_hero_by_term(term)
    term = term.to_s.downcase
    heroes = StorageHelper.read_detail_from_disk
    return ScraperHelper.error if heroes.nil?

    find = JSON.parse(heroes).select do |h|
      h['name'].downcase.include?(term) ||
      h['title'].downcase.include?(term) ||
      h['franchise'].downcase.include?(term) ||
      h['role']['name'].downcase.include?(term) ||
      h['role']['description'].downcase.include?(term)
    end

    return ScraperHelper.error if find.nil?
    JSON.pretty_generate(find)
  end
end