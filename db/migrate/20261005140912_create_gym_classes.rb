class CreateGymClasses < ActiveRecord::Migration[8.1]
  def change
    create_table :gym_classes do |t|
      t.string :name

      t.timestamps
    end
  end
end
