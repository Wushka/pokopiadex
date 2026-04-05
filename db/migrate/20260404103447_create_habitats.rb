class CreateHabitats < ActiveRecord::Migration[8.1]
  def change
    create_table :habitats do |t|
      t.string :name

      t.timestamps
    end
  end
end
