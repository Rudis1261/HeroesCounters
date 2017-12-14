class UpdateHeroStructure < ActiveRecord::Migration[5.1]
  def change
    change_table :heroes do |t|
        t.remove :type
        t.string :type_of_hero
    end
  end
end
