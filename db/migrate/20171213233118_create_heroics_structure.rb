class CreateHeroicsStructure < ActiveRecord::Migration[5.1]
  def change
    create_table :heroics do |t|
        t.string :name
        t.string :slug
        t.string :description
        t.string :image
        t.integer :hero_id
    end
  end
end
