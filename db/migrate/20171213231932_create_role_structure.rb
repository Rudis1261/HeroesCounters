class CreateRoleStructure < ActiveRecord::Migration[5.1]
  def change
    create_table :roles do |t|
        t.string :name
        t.string :slug
        t.string :description
    end
  end
end
