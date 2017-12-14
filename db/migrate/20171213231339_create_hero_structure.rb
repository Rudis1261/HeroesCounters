class CreateHeroStructure < ActiveRecord::Migration[5.1]
  def change
    create_table :heroes do |t|
        t.string :name
        t.string :slug
        t.string :title
        t.string :description
        t.string :type
        t.string :franchise
        t.string :difficulty
        t.string :live
        t.string :poster_image
        t.integer :role_id
    end
  end
end