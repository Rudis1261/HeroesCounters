module ScraperHelper

  def error(message = false)
    JSON.pretty_generate({
      :error => true,
      :message => message ||= 'Unable to process your request'
    })
  end


  def scrape_heroes
    puts "Scraping heroes from site"

    doc = HTTParty.get(ConfigController.base_url)
    data = doc.body.scan(/window\.heroes.+= (.+);/)

    # Fall back should a request fail, try and force read locally
    if (data.nil? || data[0].nil? || data[0].first.nil?)
      puts "Failed to scrape, falling back to local cached file"
      return self.read_from_disk
    end

    heroes = JSON.pretty_generate(JSON.parse(data[0].first))
    if !heroes.nil?
      self.save_to_disk(heroes)
      self.parse_hero_details_and_save_to_disk
      return self.parse_json_data(heroes)
    else
      return self.error 'Unable to scrape'
    end
  end


  def scrape_hero(name)
    return if name.nil?

    doc = HTTParty.get(ConfigController.hero_base_url % name)
    data = doc.body.scan(/window\.hero.+= (.+);/)

    #Fall back should a request fail, try and force read locally
    if (data.nil? || data[0].nil? || data[0].first.nil?)
      puts "Failed to scrape, falling back to local cached file"
      return self.read_hero_from_disk
    end

    hero = JSON.parse(data[0].first)
    if !hero.nil?
      self.save_hero_to_disk(name, hero)
      self.parse_hero_details_and_save_to_disk
      return JSON.pretty_generate(self.parse_hero_json_data(hero))
    else
      return self.error 'Unable to scrape hero data'
    end
  end


  def scrape_hero_details
    puts "Scraping all the hero details"
    heroes = JSON.parse(read_from_disk)
    return false if heroes.nil?

    heroes.each_with_index do |hero, index|
      self.scrape_hero(heroes[index]['slug']) or return false
    end

    return true
  end


  def parse_hero_details_and_save_to_disk
    puts "Reading all the hero details"
    heroes = JSON.parse(read_from_disk)
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
      hero_detail_from_disk = self.read_hero_from_disk(slug)
      if hero_detail_from_disk
        detail << JSON.parse(hero_detail_from_disk)
      else
        detail << simpleHeroDetails[slug]
      end
    end

    detail = JSON.pretty_generate(detail)
    File.open(ConfigController.local_detail_file, 'w') { |file| file.write(detail) }
    return true
  end


  def hero_slugs
    heroes = JSON.parse(read_from_disk)
    return [] if heroes.nil?

    # Default set of data based on landing page
    heroSlugs = []
    heroes.each_with_index do |hero, index|
      heroSlugs << heroes[index]['slug']
    end
    return heroSlugs.sort
  end


  def read_from_disk
    return if !File.exists?(ConfigController.local_file)
    puts "Reading feed from cache"
    File.read(ConfigController.local_file)
  end


  def read_detail_from_disk
    return if !File.exists?(ConfigController.local_detail_file)
    puts "Reading detail from cache"
    File.read(ConfigController.local_detail_file)
  end


  def read_hero_from_disk(name)
    return if name.nil?
    return if !File.exists?(ConfigController.hero_local_file % name)
    puts "Reading hero feed from cache"
    File.read(ConfigController.hero_local_file % name)
  end


  def parse_json_data(data)
    data = JSON.parse(data).map do |hero|
      parse_hero_json_data hero
    end
    JSON.pretty_generate(data)
  end


  def parse_hero_json_data(hero)
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
                'image' => ConfigController.image_urls['trait'] % [hero['slug'], item['slug']]
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
          'image' => ConfigController.image_urls['trait'] % [hero['slug'], hero['trait']['slug']]
      }
    end

    {
      'name' => hero['name'],
      'slug' => hero['slug'],
      'title' => hero['title'],
      'description' => hero['role']['description'],
      'role' => hero['role']['name'],
      'type' => hero['type']['name'],
      'franchise' => hero['franchise'],
      'difficulty' => hero['difficulty'],
      'live' => hero['revealed'],
      'poster_image' => ConfigController.image_urls['bust'] % hero['slug'],
      'stats' => @stats,
      'trait' => @data['trait'],
      'abilities' => @data['abilities'],
      'heroics' => @data['heroics'],
      #'original' => hero
    }
  end


  def save_to_disk(data)
    File.open(ConfigController.local_file, 'w') { |file| file.write(data) }
  end


  def save_hero_to_disk(name, data)
    return if name.nil?
    data = self.parse_hero_json_data(data)
    data = JSON.pretty_generate(data)
    File.open(ConfigController.hero_local_file % name, 'w') { |file| file.write(data) }
  end


  def find_hero_by_name(name)
    name = name.to_s.downcase
    heroes = self.read_detail_from_disk
    return self.error if heroes.nil?

    find = JSON.parse(heroes).select do |h|
      h['name'].downcase.include?(name)
    end

    return self.error if find.nil? || find.first.nil?
    return JSON.pretty_generate(find.first)
  end


  def search_for_hero_by_term(term)
    term = term.to_s.downcase
    heroes = self.read_detail_from_disk
    return self.error if heroes.nil?

    find = JSON.parse(heroes).select do |h|
      h['name'].downcase.include?(term) ||
      h['title'].downcase.include?(term) ||
      h['franchise'].downcase.include?(term) ||
      h['role']['name'].downcase.include?(term) ||
      h['role']['description'].downcase.include?(term)
    end

    return self.error if find.nil?
    JSON.pretty_generate(find)
  end
end